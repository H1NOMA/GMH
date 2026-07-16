import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  await service.checkpoint(entityId, note: 'Before restore');
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
              child: Text('Version History',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            if (versions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No snapshots yet. Versions are saved when you '
                    'leave the editor or restore.'),
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
                            ? '(empty)'
                            : preview.length > 120
                                ? '${preview.substring(0, 120)}…'
                                : preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                      trailing: TextButton(
                        child: const Text('Restore'),
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
