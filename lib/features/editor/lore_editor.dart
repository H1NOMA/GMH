import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../core/utils/debouncer.dart';
import '../entities/widgets/entity_picker_dialog.dart';
import 'entity_link_embed.dart';
import 'image_embed.dart';
import 'version_history_sheet.dart';

/// The rich-text lore editor: Quill with entity-link and vault-image embeds,
/// debounced autosave (mention links and the search index update on every
/// save) and version checkpoints on close.
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

  @override
  void initState() {
    super.initState();
    Document document;
    try {
      document = Document.fromJson(
          jsonDecode(widget.initialContentJson) as List);
    } catch (_) {
      document = Document();
    }
    _lastSavedJson = widget.initialContentJson;
    _controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
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
          SnackBar(content: Text(result.error.userMessage)));
    }
  }

  Future<void> _linkEntity() async {
    final entity = await showEntityPickerDialog(context,
        worldId: widget.worldId, title: 'Insert link to entry');
    if (entity == null) return;
    insertEntityLink(_controller, entity);
    _focusNode.requestFocus();
  }

  Future<void> _insertImage() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final file = picked?.files.firstOrNull;
    final bytes = file?.bytes;
    if (file == null || bytes == null) return;

    final media = await ref.read(mediaRepositoryProvider).import(
          worldId: widget.worldId,
          fileName: file.name,
          bytes: bytes,
        );
    insertVaultImage(_controller, media.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
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
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showSearchButton: false,
              showCodeBlock: false,
              showIndent: false,
              showDividers: false,
              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.alternate_email, size: 18),
                  tooltip: 'Link an entry (mention)',
                  onPressed: _linkEntity,
                ),
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.image_outlined, size: 18),
                  tooltip: 'Insert image',
                  onPressed: _insertImage,
                ),
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.history, size: 18),
                  tooltip: 'Version history',
                  onPressed: () => showVersionHistorySheet(
                    context,
                    ref,
                    entityId: widget.entityId,
                    onRestore: (contentJson) {
                      try {
                        final restored =
                            Document.fromJson(jsonDecode(contentJson) as List);
                        _controller.document = restored;
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
          child: QuillEditor.basic(
            controller: _controller,
            focusNode: _focusNode,
            scrollController: _scrollController,
            config: QuillEditorConfig(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
              placeholder: 'Write the lore… Use @ button to link entries.',
              embedBuilders: [
                EntityLinkEmbedBuilder(worldId: widget.worldId),
                VaultImageEmbedBuilder(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
