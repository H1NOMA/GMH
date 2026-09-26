import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/document_model.dart';
import '../../domain/services/linking/mention_parser.dart';

/// Stored as the note of the snapshot taken right before a restore;
/// shown in the UI language of whoever reads the history later (old
/// snapshots carry a note in the language they were saved in).
const versionNoteBeforeRestore = '@beforeRestore';

/// Bottom sheet listing document version snapshots; restoring replaces the
/// editor content (non-destructively — the current state is checkpointed
/// first).
Future<void> showVersionHistorySheet(
  BuildContext context,
  WidgetRef ref, {
  required String entityId,
  required void Function(String contentJson) onRestore,
}) async {
  final documents = ref.read(documentRepositoryProvider);
  final service = ref.read(documentServiceProvider);

  final doc = await documents.getOrCreate(entityId);
  final versions = await documents.versions(doc.id);

  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: GmhColors.surfaceRaised,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              // The list tiles' inset: title and rows share a left edge.
              padding: const EdgeInsets.fromLTRB(16, 16, 24, 8),
              child: Text(context.l10n.versionHistoryTitle,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            if (versions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(context.l10n.versionHistoryEmpty),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: versions.length,
                  itemBuilder: (context, index) {
                    final version = versions[index];
                    final preview = extractPlainText(version.contentJson)
                        .replaceAll('\n', ' ')
                        .trim();
                    final note = version.note == versionNoteBeforeRestore
                        ? context.l10n.versionBeforeRestore
                        : version.note;
                    return ListTile(
                      leading: const Icon(Icons.history, size: 20),
                      title: Text(
                        note.isEmpty
                            ? localizedDateTime(context, version.createdAt)
                            : '$note — ${localizedDateTime(context, version.createdAt)}',
                        style: const TextStyle(fontSize: 13.5),
                      ),
                      subtitle: Text(
                        preview.isEmpty
                            ? context.l10n.versionEmptyPreview
                            : preview.length > 120
                                ? '${preview.substring(0, 120)}…'
                                : preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                      trailing: TextButton(
                        child: Text(context.l10n.restore),
                        onPressed: () async {
                          Navigator.pop(context);
                          // Snapshot the current text only when a restore
                          // actually happens, so merely browsing the
                          // history never pushes older versions out.
                          await service.checkpoint(entityId,
                              note: versionNoteBeforeRestore);
                          onRestore(version.contentJson);
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

/// Convenience for widgets that only have the entity id.
Future<DocumentModel> loadDocument(WidgetRef ref, String entityId) =>
    ref.read(documentRepositoryProvider).getOrCreate(entityId);
