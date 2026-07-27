import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../domain/models/entity_kind.dart';
import '../../categories/category_ui.dart';

/// What the "Type" dropdown selects: a built-in kind or a custom category.
sealed class _TypeChoice {
  const _TypeChoice();
}

class _KindChoice extends _TypeChoice {
  final EntityKind kind;
  const _KindChoice(this.kind);

  @override
  bool operator ==(Object other) =>
      other is _KindChoice && other.kind == kind;

  @override
  int get hashCode => kind.hashCode;
}

class _CategoryChoice extends _TypeChoice {
  final String categoryId;
  const _CategoryChoice(this.categoryId);

  @override
  bool operator ==(Object other) =>
      other is _CategoryChoice && other.categoryId == categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}

/// Creation dialog used from the dashboard FAB, list screens and the
/// command palette. Custom categories appear alongside built-in kinds and
/// behave exactly the same. Returns the new entity's id (and navigates).
Future<String?> showNewEntityDialog(
  BuildContext context,
  WidgetRef ref,
  String worldId, {
  EntityKind? initialKind,
  String? initialCategoryId,
}) async {
  final nameController = TextEditingController();
  final categories =
      ref.read(worldCategoriesProvider(worldId)).valueOrNull ?? [];

  // Only preselect a category the dropdown will actually contain: if the
  // categories stream hasn't emitted yet (cold start straight onto a
  // category route), a value without a matching item would assert.
  _TypeChoice choice = initialCategoryId != null &&
          categories.any((c) => c.id == initialCategoryId)
      ? _CategoryChoice(initialCategoryId)
      : _KindChoice(initialKind ?? EntityKind.character);

  ModalRoute<Object?>? dialogRoute;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(context.l10n.newEntryTitle),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<_TypeChoice>(
                value: choice,
                decoration:
                    InputDecoration(labelText: context.l10n.typeLabel),
                items: [
                  for (final k in EntityKind.values)
                    if (k != EntityKind.custom)
                      DropdownMenuItem<_TypeChoice>(
                        value: _KindChoice(k),
                        child: Row(
                          children: [
                            Icon(k.icon, size: 17, color: k.color),
                            const SizedBox(width: 8),
                            Text(k.localizedLabel(context)),
                          ],
                        ),
                      ),
                  for (final category in categories)
                    DropdownMenuItem<_TypeChoice>(
                      value: _CategoryChoice(category.id),
                      child: Row(
                        children: [
                          Icon(categoryIconFor(category.icon),
                              size: 17, color: Color(category.color)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(category.name,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) => setState(
                    () => choice = value ?? _KindChoice(EntityKind.character)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration:
                    InputDecoration(labelText: context.l10n.nameLabel),
                onSubmitted: (_) => Navigator.pop(context, true),
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
              child: Text(context.l10n.create)),
        ],
      ),
    );
    },
  );

  final name = nameController.text.trim();
  // The dialog can still rebuild during its exit transition — release the
  // controller only once the route is fully gone.
  dialogRoute?.completed.whenComplete(nameController.dispose);
  if (confirmed != true || name.isEmpty) return null;

  final selected = choice;
  final result = await ref.read(entityServiceProvider).create(
        worldId: worldId,
        kind: selected is _KindChoice ? selected.kind : EntityKind.custom,
        customCategoryId:
            selected is _CategoryChoice ? selected.categoryId : null,
        name: name,
      );

  return result.fold(
    (entity) {
      if (context.mounted) {
        context.go(Routes.entity(worldId, entity.id));
      }
      return entity.id;
    },
    (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizedError(context, error))));
      }
      return null;
    },
  );
}
