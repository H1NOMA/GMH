import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/custom_category.dart';
import '../../domain/models/entity_kind.dart';
import 'category_constructor.dart';
import 'category_ui.dart';

/// Category manager: create, rename, change icon, reorder (drag) and delete
/// custom archive categories.
Future<void> showManageCategoriesSheet(
    BuildContext context, String worldId) async {
  await showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: _ManageCategories(worldId: worldId),
      ),
    ),
  );
}

class _ManageCategories extends ConsumerWidget {
  final String worldId;
  const _ManageCategories({required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(worldCategoriesProvider(worldId)).valueOrNull ?? [];
    final counts =
        ref.watch(categoryCountsProvider(worldId)).valueOrNull ?? const {};

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(context.l10n.manageCategories,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 19),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(),
        Flexible(
          child: categories.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(context.l10n.noCategoriesYet,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: GmhColors.parchmentDim)),
                )
              : ReorderableListView.builder(
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  itemCount: categories.length,
                  onReorder: (oldIndex, newIndex) {
                    final ids = categories.map((c) => c.id).toList();
                    if (newIndex > oldIndex) newIndex--;
                    final moved = ids.removeAt(oldIndex);
                    ids.insert(newIndex, moved);
                    ref
                        .read(categoryRepositoryProvider)
                        .reorder(worldId, ids);
                  },
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      key: ValueKey(category.id),
                      leading: ReorderableDragStartListener(
                        index: index,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.drag_indicator,
                                size: 18, color: GmhColors.parchmentFaint),
                            const SizedBox(width: 8),
                            Icon(categoryIconFor(category.icon),
                                size: 20, color: Color(category.color)),
                          ],
                        ),
                      ),
                      title: Text(category.name),
                      subtitle: Text(
                          context.l10n
                              .entriesCount(counts[category.id] ?? 0),
                          style: const TextStyle(fontSize: 11)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: context.l10n.rename,
                            icon: const Icon(Icons.edit_outlined, size: 17),
                            onPressed: () => showCategoryConstructor(
                                context, ref,
                                worldId: worldId, existing: category),
                          ),
                          IconButton(
                            tooltip: context.l10n.deleteCategory,
                            icon: Icon(Icons.delete_outline,
                                size: 17, color: GmhColors.danger),
                            onPressed: () => _confirmDelete(
                                context, ref, category,
                                count: counts[category.id] ?? 0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.newCategory),
            onPressed: () =>
                showCategoryConstructor(context, ref, worldId: worldId),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, CustomCategory category,
      {required int count}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteCategoryTitle(category.name)),
        content: Text(count == 0
            ? context.l10n.deleteCategoryBodyEmpty
            : context.l10n.deleteCategoryBody(count)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: GmhColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final movedIds =
          await ref.read(categoryRepositoryProvider).delete(category.id);
      // The converted entries changed kind — without a reindex the search
      // keeps returning them under the deleted category's filter.
      final search = ref.read(searchRepositoryProvider);
      for (final id in movedIds) {
        await search.reindexEntity(id);
      }
      // If the user is currently browsing the deleted category, its route
      // would become a dead page (empty list, FAB writing into a ghost
      // category). Move them to the Concept Archive where the entries went.
      if (context.mounted) {
        final router = GoRouter.of(context);
        final location =
            router.routerDelegate.currentConfiguration.uri.path;
        if (location ==
            Routes.browseCategory(category.worldId, category.id)) {
          router.go(
              Routes.browse(category.worldId, EntityKind.concept));
        }
      }
    }
  }
}
