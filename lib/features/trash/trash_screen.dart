import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity.dart';
import '../../app/router.dart';
import '../categories/category_ui.dart';
import '../shell/history_buttons.dart';
import '../shell/ui_providers.dart';
import '../shell/workspace_tabs.dart';

/// Trashed entries of the open world: restore them or delete them for
/// good, one by one or all at once.
class TrashScreen extends ConsumerWidget {
  final String worldId;
  const TrashScreen({super.key, required this.worldId});

  Future<bool> _confirm(BuildContext context,
      {required String title, required String body}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: GmhColors.danger,
                foregroundColor: readableOn(GmhColors.danger)),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.trashDeleteForever),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _restore(
      BuildContext context, WidgetRef ref, Entity entity) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    ref
        .read(workspaceTabsProvider.notifier)
        .revive(Routes.entity(worldId, entity.id));
    final result = await ref.read(entityServiceProvider).restore(entity.id);
    messenger.showSnackBar(SnackBar(
        content: Text(result.isOk
            ? l10n.trashRestoredSnack(entity.name)
            : l10n.errorUnexpected)));
  }

  Future<void> _purge(
      BuildContext context, WidgetRef ref, Entity entity) async {
    final service = ref.read(entityServiceProvider);
    if (!await _confirm(context,
        title: context.l10n.trashDeleteForeverTitle(entity.name),
        body: context.l10n.trashDeleteForeverBody)) {
      return;
    }
    await service.purge(entity.id);
  }

  Future<void> _emptyTrash(
      BuildContext context, WidgetRef ref, int count) async {
    final service = ref.read(entityServiceProvider);
    if (!await _confirm(context,
        title: context.l10n.trashEmptyConfirmTitle,
        body: context.l10n.trashEmptyConfirmBody(count))) {
      return;
    }
    await service.emptyTrash(worldId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashed = ref.watch(trashProvider(worldId)).valueOrNull ?? const [];
    final categories = ref.watch(categoryMapProvider(worldId));

    return Scaffold(
      appBar: AppBar(
        leading: historyLeading(),
        leadingWidth: kHistoryLeadingWidth,
        title: Text(context.l10n.trashTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              icon: const Icon(Icons.delete_sweep_outlined, size: 18),
              label: Text(context.l10n.trashEmptyAction),
              style: TextButton.styleFrom(foregroundColor: GmhColors.danger),
              onPressed: trashed.isEmpty
                  ? null
                  : () => _emptyTrash(context, ref, trashed.length),
            ),
          ),
        ],
      ),
      body: trashed.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline,
                        size: 48,
                        color: GmhColors.ember.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Text(context.l10n.trashEmptyState,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: GmhColors.parchmentDim)),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              itemCount: trashed.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entity = trashed[index];
                return Card(
                  child: ListTile(
                    leading: Icon(entityIcon(entity, categories),
                        color: entityColor(entity, categories)),
                    title: Text(entity.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      [
                        typeLabel(context, entity.kind,
                            entity.customCategoryId, categories),
                        if (entity.deletedAt != null)
                          context.l10n.trashDeletedOn(
                              localizedDate(context, entity.deletedAt!)),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: context.l10n.restore,
                          icon: const Icon(Icons.restore_from_trash_outlined),
                          onPressed: () => _restore(context, ref, entity),
                        ),
                        IconButton(
                          tooltip: context.l10n.trashDeleteForever,
                          icon: Icon(Icons.delete_forever_outlined,
                              color: GmhColors.danger),
                          onPressed: () => _purge(context, ref, entity),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
