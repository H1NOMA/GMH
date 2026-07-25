import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/document_model.dart';
import '../../domain/services/linking/mention_parser.dart';

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

  // Checkpoint current state so restoring can always be undone.
  if (!context.mounted) return;
  await service.checkpoint(entityId,
      note: context.l10n.versionBeforeRestore);
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
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
                    return ListTile(
                      leading: const Icon(Icons.history, size: 20),
                      title: Text(
                        version.note.isEmpty
                            ? formatDateTime(version.createdAt)
                            : '${version.note} — ${formatDateTime(version.createdAt)}',
                        style: const TextStyle(fontSize: 13.5),
                      ),
                      subtitle: Text(
                        preview.isEmpty
                            ? context.l10n.versionEmptyPreview
                            : preview.length > 120
                                // characters, not substring: a raw UTF-16
                                // cut can split an emoji surrogate pair.
                                ? '${preview.characters.take(120)}…'
                                : preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                      trailing: TextButton(
                        child: Text(context.l10n.restore),
                        onPressed: () {
                          Navigator.pop(context);
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
