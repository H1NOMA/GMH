import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/custom_category.dart';
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
                          const TextStyle(color: GmhColors.parchmentDim)),
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
                            const Icon(Icons.drag_indicator,
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
                            onPressed: () => showCategoryEditorDialog(
                                context, ref,
                                worldId: worldId, existing: category),
                          ),
                          IconButton(
                            tooltip: context.l10n.deleteCategory,
                            icon: const Icon(Icons.delete_outline,
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
                showCategoryEditorDialog(context, ref, worldId: worldId),
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
      await ref.read(categoryRepositoryProvider).delete(category.id);
    }
  }
}

/// Create/edit dialog: name + icon picker. Returns the category id.
Future<String?> showCategoryEditorDialog(
  BuildContext context,
  WidgetRef ref, {
  required String worldId,
  CustomCategory? existing,
}) async {
  final nameController = TextEditingController(text: existing?.name ?? '');
  var icon = existing?.icon ?? 'folder';

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null
            ? context.l10n.newCategory
            : context.l10n.renameCategory),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: context.l10n.categoryNameLabel,
                    hintText: context.l10n.categoryNameHint),
                onSubmitted: (_) => Navigator.pop(context, true),
              ),
              const SizedBox(height: 14),
              Text(context.l10n.chooseIcon,
                  style: const TextStyle(
                      fontSize: 11.5, color: GmhColors.parchmentDim)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final entry in categoryIcons.entries)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => setState(() => icon = entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: icon == entry.key
                                  ? GmhColors.ember
                                  : GmhColors.border,
                              width: icon == entry.key ? 1.6 : 1),
                          color: icon == entry.key
                              ? GmhColors.ember.withValues(alpha: 0.12)
                              : null,
                        ),
                        child: Icon(entry.value,
                            size: 20,
                            color: icon == entry.key
                                ? GmhColors.emberBright
                                : GmhColors.parchmentDim),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(existing == null
                  ? context.l10n.create
                  : context.l10n.save)),
        ],
      ),
    ),
  );

  final name = nameController.text.trim();
  if (saved != true || name.isEmpty) return existing?.id;

  final repository = ref.read(categoryRepositoryProvider);
  if (existing == null) {
    final category =
        await repository.create(worldId: worldId, name: name, icon: icon);
    return category.id;
  }
  await repository.update(existing.copyWith(name: name, icon: icon));
  return existing.id;
}
