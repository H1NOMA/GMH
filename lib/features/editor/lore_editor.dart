import 'dart:async';
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/save_flush.dart';
import '../../domain/services/document_service.dart';
import '../attachments/attachment_utils.dart';
import '../entities/widgets/entity_picker_dialog.dart';
import 'entity_link_embed.dart';
import 'file_attachment_embed.dart';
import 'image_embed.dart';
import 'unknown_embed.dart';
import '../../domain/services/linking/mention_parser.dart';
import 'version_history_sheet.dart';

/// The rich-text lore editor: Quill with entity-link, vault-image and
/// file-attachment embeds; image paste from the clipboard; drag & drop of
/// files straight into the text; debounced autosave (mention links and the
/// search index update on every save); version checkpoints on close.
class LoreEditor extends ConsumerStatefulWidget {
  final String worldId;
  final String entityId;

  /// Initial Delta JSON (the caller loads the document).
  final String initialContentJson;

  const LoreEditor({
    super.key,
    required this.worldId,
    required this.entityId,
    required this.initialContentJson,
  });

  @override
  ConsumerState<LoreEditor> createState() => _LoreEditorState();
}

class _LoreEditorState extends ConsumerState<LoreEditor> {
  late QuillController _controller;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final _autosave = Debouncer(GmhConstants.autosaveDebounce);
  String _lastSavedJson = '';
  StreamSubscription? _changes;
  bool _dragging = false;

  /// Captured in initState: dispose() may run during final tree teardown
  /// (app shutdown), when `ref` is already unusable — reading it there
  /// throws "Cannot use ref after the widget was disposed" and skips the
  /// flush-save and checkpoint.
  late final DocumentService _documents;

  /// Save chain: every save is appended to the previous one, so writes
  /// never interleave and a flush can await whatever is still in flight
  /// (an armed timer alone is not the only pending state — exit must not
  /// kill the process mid-write).
  Future<void> _saveChain = Future.value();

  /// Flushes the debounced autosave immediately; registered globally so
  /// the pause menu can persist pending edits before backup or exit.
  Future<void> _flushNow() async {
    var pending = false;
    _autosave.flush(() => pending = true);
    if (pending) {
      await _save();
    } else {
      await _saveChain;
    }
  }

  @override
  void initState() {
    super.initState();
    _documents = ref.read(documentServiceProvider);
    saveFlushHooks.add(_flushNow);
    Document document;
    try {
      document = Document.fromJson(
        jsonDecode(widget.initialContentJson) as List,
      );
    } catch (_) {
      // Unreadable content (corrupt, or from a newer/other editor). The
      // first keystroke would overwrite it for good, so snapshot the
      // stored original into version history before any save can run,
      // and salvage whatever plain text it holds.
      document = Document();
      final salvaged = extractPlainText(widget.initialContentJson).trim();
      if (salvaged.isNotEmpty) document.insert(0, salvaged);
      _saveChain = _documents
          .checkpoint(widget.entityId)
          .then((_) {}, onError: (_) {});
    }
    _lastSavedJson = widget.initialContentJson;
    _controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      config: QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          // Pasted/copied images land in the vault and embed as media: ids,
          // so documents stay portable across devices.
          onImagePaste: _importPastedImage,
        ),
      ),
    );
    _changes = _controller.document.changes.listen((_) {
      _autosave(_save);
    });
  }

  @override
  void dispose() {
    saveFlushHooks.remove(_flushNow);
    _changes?.cancel();
    _retry?.cancel();
    _autosave.flush(_saveAndCheckpointSync);
    // Checkpoint the version history when leaving the editor — after the
    // flush-save above has landed, or the snapshot misses the last edits.
    final documents = _documents;
    final entityId = widget.entityId;
    unawaited(_saveChain.then((_) => documents.checkpoint(entityId)));
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _autosave.dispose();
    super.dispose();
  }

  void _saveAndCheckpointSync() {
    unawaited(_save());
  }

  Future<void> _save() {
    // Serialized now, not when the chain gets to it: the dispose-time
    // flush queues a save right before the controller is disposed.
    final json = jsonEncode(_controller.document.toDelta().toJson());
    _saveChain = _saveChain.then((_) => _doSave(json));
    return _saveChain;
  }

  Future<void> _doSave(String json) async {
    if (json == _lastSavedJson) return;
    final result = await _documents.save(
      entityId: widget.entityId,
      contentJson: json,
    );
    if (result.isErr) {
      // Deliberately NOT marking the content as saved: the next change or
      // flush retries the write instead of silently losing it. One notice
      // per failure streak, retries backing off (2s, 4s … 60s) — a locked
      // or full disk must not bury the user in snackbars.
      _failedSaves++;
      if (mounted) {
        if (_failedSaves == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizedError(context, result.error))),
          );
        }
        _retry?.cancel();
        final seconds = 1 << _failedSaves.clamp(1, 6);
        _retry = Timer(Duration(seconds: seconds.clamp(2, 60)), () {
          if (mounted) _save();
        });
      }
      return;
    }
    _failedSaves = 0;
    _retry?.cancel();
    _lastSavedJson = json;
  }

  int _failedSaves = 0;
  Timer? _retry;

  Future<String?> _importPastedImage(Uint8List bytes) async {
    if (bytes.isEmpty) return null;
    final media = await ref
        .read(mediaRepositoryProvider)
        .import(
          worldId: widget.worldId,
          fileName: 'pasted-${DateTime.now().millisecondsSinceEpoch}.png',
          bytes: bytes,
        );
    return '$mediaImagePrefix${media.id}';
  }

  Future<void> _linkEntity() async {
    final entity = await showEntityPickerDialog(
      context,
      worldId: widget.worldId,
      title: context.l10n.insertLinkTitle,
    );
    if (entity == null || !mounted) return;
    insertEntityLink(_controller, entity);
    _focusNode.requestFocus();
  }

  Future<void> _insertImage() async {
    final files = await pickImageFiles(
      dialogTitle: context.l10n.editorInsertImage,
    );
    await _embedFiles(files, imagesOnly: true);
  }

  Future<void> _attachFile() async {
    final files = await pickAnyFiles(
      dialogTitle: context.l10n.editorAttachFile,
    );
    await _embedFiles(files);
  }

  /// Imports files into the vault and embeds them at the cursor —
  /// images inline, everything else as attachment chips.
  Future<void> _embedFiles(List<XFile> files, {bool imagesOnly = false}) async {
    if (files.isEmpty) return;
    final (:imported, :failed) = await importXFiles(
      ref.read(mediaRepositoryProvider),
      worldId: widget.worldId,
      files: files,
    );
    // A slow import can outlive this editor (user navigated away): the
    // controller is disposed then, and inserting would throw.
    if (!mounted) return;
    if (failed > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.importFilesFailed(failed))));
    }
    for (final item in imported) {
      if (isImageMime(item.mimeType)) {
        insertVaultImage(_controller, item.id);
      } else if (!imagesOnly) {
        insertFileAttachment(_controller, item);
      }
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: GmhColors.surface,
            border: Border(bottom: BorderSide(color: GmhColors.border)),
          ),
          child: QuillSimpleToolbar(
            controller: _controller,
            config: QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
              showFontFamily: false,
              showFontSize: false,
              showSubscript: false,
              showSuperscript: false,
              showInlineCode: true,
              showColorButton: false,
              showBackgroundColorButton: false,
              showSearchButton: false,
              showCodeBlock: true,
              showIndent: false,
              showDividers: false,
              // Paragraph alignment: left, center, right and justified.
              // The choice is stored as a Delta attribute, so it persists
              // with the document on every platform.
              showAlignmentButtons: true,
              showLeftAlignment: true,
              showCenterAlignment: true,
              showRightAlignment: true,
              showJustifyAlignment: true,
              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.alternate_email, size: 18),
                  tooltip: context.l10n.editorLinkEntity,
                  onPressed: _linkEntity,
                ),
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.image_outlined, size: 18),
                  tooltip: context.l10n.editorInsertImage,
                  onPressed: _insertImage,
                ),
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.attach_file, size: 18),
                  tooltip: context.l10n.editorAttachFile,
                  onPressed: _attachFile,
                ),
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.history, size: 18),
                  tooltip: context.l10n.editorVersionHistory,
                  onPressed: () async {
                    // Pending edits must reach the DB first: the sheet's
                    // "before restore" checkpoint reads the stored
                    // document, not the live controller — restoring while
                    // typing must not lose the unflushed tail.
                    await _flushNow();
                    if (!context.mounted) return;
                    await showVersionHistorySheet(
                      context,
                      ref,
                      entityId: widget.entityId,
                      onRestore: (contentJson) {
                        if (!mounted) return;
                        try {
                          final restored = Document.fromJson(
                            jsonDecode(contentJson) as List,
                          );
                          // The changes stream belongs to the Document
                          // instance: without re-subscribing, no edit made
                          // after a restore would ever reach autosave.
                          _changes?.cancel();
                          _controller.document = restored;
                          _changes = _controller.document.changes.listen((_) {
                            _autosave(_save);
                          });
                          _autosave(_save);
                        } catch (_) {}
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: DropTarget(
            onDragEntered: (_) => setState(() => _dragging = true),
            onDragExited: (_) => setState(() => _dragging = false),
            onDragDone: (details) {
              setState(() => _dragging = false);
              _embedFiles(details.files);
            },
            child: Container(
              decoration: _dragging
                  ? BoxDecoration(
                      border: Border.all(color: GmhColors.ember, width: 1.5),
                      color: GmhColors.ember.withValues(alpha: 0.05),
                    )
                  : null,
              child: QuillEditor.basic(
                controller: _controller,
                focusNode: _focusNode,
                scrollController: _scrollController,
                config: QuillEditorConfig(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
                  placeholder: context.l10n.editorPlaceholder,
                  embedBuilders: [
                    EntityLinkEmbedBuilder(worldId: widget.worldId),
                    VaultImageEmbedBuilder(),
                    FileAttachmentEmbedBuilder(),
                  ],
                  unknownEmbedBuilder: const UnknownEmbedBuilder(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
