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
import '../attachments/attachment_utils.dart';
import '../entities/widgets/entity_picker_dialog.dart';
import 'entity_link_embed.dart';
import 'file_attachment_embed.dart';
import 'image_embed.dart';
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

  @override
  void initState() {
    super.initState();
    Document document;
    try {
      document =
          Document.fromJson(jsonDecode(widget.initialContentJson) as List);
    } catch (_) {
      document = Document();
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
    _listenToDocument();
  }

  /// (Re)binds autosave to the controller's current document. Must be called
  /// again whenever the document instance is swapped (e.g. version restore),
  /// because the change stream belongs to the Document, not the controller.
  void _listenToDocument() {
    _changes?.cancel();
    _changes = _controller.document.changes.listen((_) {
      _autosave(_save);
    });
  }

  @override
  void dispose() {
    _changes?.cancel();
    _autosave.flush(_saveAndCheckpointSync);
    // Checkpoint the version history when leaving the editor.
    final service = ref.read(documentServiceProvider);
    unawaited(service.checkpoint(widget.entityId));
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _autosave.dispose();
    super.dispose();
  }

  void _saveAndCheckpointSync() {
    unawaited(_save());
  }

  Future<void> _save() async {
    final json = jsonEncode(_controller.document.toDelta().toJson());
    if (json == _lastSavedJson) return;
    _lastSavedJson = json;
    final result = await ref
        .read(documentServiceProvider)
        .save(entityId: widget.entityId, contentJson: json);
    if (result.isErr && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizedError(context, result.error))));
    }
  }

  Future<String?> _importPastedImage(Uint8List bytes) async {
    if (bytes.isEmpty) return null;
    final media = await ref.read(mediaRepositoryProvider).import(
          worldId: widget.worldId,
          fileName: 'pasted-${DateTime.now().millisecondsSinceEpoch}.png',
          bytes: bytes,
        );
    return '$mediaImagePrefix${media.id}';
  }

  Future<void> _linkEntity() async {
    final entity = await showEntityPickerDialog(context,
        worldId: widget.worldId, title: context.l10n.insertLinkTitle);
    if (entity == null) return;
    insertEntityLink(_controller, entity);
    _focusNode.requestFocus();
  }

  Future<void> _insertImage() async {
    final files = await pickAnyFiles(dialogTitle: context.l10n.editorInsertImage);
    await _embedFiles(files, imagesOnly: true);
  }

  Future<void> _attachFile() async {
    final files = await pickAnyFiles(dialogTitle: context.l10n.editorAttachFile);
    await _embedFiles(files);
  }

  /// Imports files into the vault and embeds them at the cursor —
  /// images inline, everything else as attachment chips.
  Future<void> _embedFiles(List<XFile> files, {bool imagesOnly = false}) async {
    if (files.isEmpty) return;
    final imported = await importXFiles(ref,
        worldId: widget.worldId, files: files);
    // Large imports can outlive the editor; the controller is disposed then.
    if (!mounted) return;
    for (final item in imported) {
      if (isImageMime(item.mimeType)) {
        insertVaultImage(_controller, item.id);
      } else if (!imagesOnly) {
        insertFileAttachment(_controller, item);
      }
    }
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
                  onPressed: () => showVersionHistorySheet(
                    context,
                    ref,
                    entityId: widget.entityId,
                    onRestore: (contentJson) {
                      try {
                        final restored =
                            Document.fromJson(jsonDecode(contentJson) as List);
                        _controller.document = restored;
                        _listenToDocument();
                        _autosave(_save);
                      } catch (_) {}
                    },
                  ),
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
