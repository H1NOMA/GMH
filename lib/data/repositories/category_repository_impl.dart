import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/category_blueprint.dart';
import '../../domain/models/custom_category.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

/// Palette cycled through as categories are created.
const _categoryPalette = [
  0xFFB98BC9, 0xFF6FA8DC, 0xFF93C47D, 0xFFE0A458,
  0xFFC27BA0, 0xFF76A5AF, 0xFFCC7A5A, 0xFF8E7CC3,
  0xFFAF8C5E, 0xFF7D9B6A, 0xFF9FC5E8, 0xFFD9A441,
];

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _db;

  CategoryRepositoryImpl(this._db);

  CustomCategory _map(CustomCategoryRow row) => CustomCategory(
        id: row.id,
        worldId: row.worldId,
        name: row.name,
        icon: row.icon,
        color: row.color,
        sortOrder: row.sortOrder,
        blueprint: CategoryBlueprint.parse(row.blueprintJson),
        createdAt: row.createdAt,
      );

  @override
  Stream<List<CustomCategory>> watchCategories(String worldId) {
    return (_db.select(_db.customCategories)
          ..where((c) => c.worldId.equals(worldId))
          ..orderBy([
            (c) => OrderingTerm.asc(c.sortOrder),
            (c) => OrderingTerm.asc(c.createdAt),
          ]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  @override
  Future<List<CustomCategory>> categories(String worldId) async {
    final rows = await (_db.select(_db.customCategories)
          ..where((c) => c.worldId.equals(worldId))
          ..orderBy([
            (c) => OrderingTerm.asc(c.sortOrder),
            (c) => OrderingTerm.asc(c.createdAt),
          ]))
        .get();
    return rows.map(_map).toList();
  }

  @override
  Future<CustomCategory?> get(String id) async {
    final row = await (_db.select(_db.customCategories)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<CustomCategory> create({
    required String worldId,
    required String name,
    String icon = 'folder',
    int? color,
    CategoryBlueprint blueprint = CategoryBlueprint.standard,
  }) async {
    final count = await (_db.selectOnly(_db.customCategories)
          ..addColumns([_db.customCategories.id.count()])
          ..where(_db.customCategories.worldId.equals(worldId)))
        .map((r) => r.read(_db.customCategories.id.count())!)
        .getSingle();
    // max(sortOrder) + 1, not the row count: after a deletion the count
    // collides with an existing order and the new category lands mid-list.
    final maxOrder = await (_db.selectOnly(_db.customCategories)
          ..addColumns([_db.customCategories.sortOrder.max()])
          ..where(_db.customCategories.worldId.equals(worldId)))
        .map((r) => r.read(_db.customCategories.sortOrder.max()))
        .getSingle();

    final category = CustomCategory(
      id: newId(),
      worldId: worldId,
      name: name.trim(),
      icon: icon,
      color: color ?? _categoryPalette[count % _categoryPalette.length],
      sortOrder: (maxOrder ?? -1) + 1,
      blueprint: blueprint,
      createdAt: nowMs(),
    );
    await _db.into(_db.customCategories).insert(
          CustomCategoriesCompanion.insert(
            id: category.id,
            worldId: worldId,
            name: category.name,
            icon: Value(category.icon),
            color: category.color,
            sortOrder: Value(category.sortOrder),
            blueprintJson: Value(category.blueprint.toJson()),
            createdAt: category.createdAt,
          ),
        );
    return category;
  }

  @override
  Future<void> update(CustomCategory category) async {
    await (_db.update(_db.customCategories)
          ..where((c) => c.id.equals(category.id)))
        .write(CustomCategoriesCompanion(
      name: Value(category.name.trim()),
      icon: Value(category.icon),
      color: Value(category.color),
      blueprintJson: Value(category.blueprint.toJson()),
    ));
  }

  @override
  Future<void> reorder(String worldId, List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.customCategories)
              ..where((c) =>
                  c.id.equals(orderedIds[i]) & c.worldId.equals(worldId)))
            .write(CustomCategoriesCompanion(sortOrder: Value(i)));
      }
    });
  }

  @override
  Future<void> delete(String categoryId) async {
    await _db.transaction(() async {
      // Preserve the category's entries by converting them to the Concept
      // Archive — no data is ever lost by deleting a category.
      await (_db.update(_db.entities)
            ..where((e) => e.customCategoryId.equals(categoryId)))
          .write(EntitiesCompanion(
        kind: Value(EntityKind.concept.name),
        customCategoryId: const Value(null),
        updatedAt: Value(nowMs()),
      ));
      await (_db.delete(_db.customCategories)
            ..where((c) => c.id.equals(categoryId)))
          .go();
    });
  }

  @override
  Future<Map<String, int>> countsByCategory(String worldId) async {
    final rows = await _db.customSelect(
      'SELECT custom_category_id AS cid, COUNT(*) AS n FROM entities '
      'WHERE world_id = ? AND deleted_at IS NULL '
      'AND custom_category_id IS NOT NULL GROUP BY custom_category_id',
      variables: [Variable.withString(worldId)],
      readsFrom: {_db.entities},
    ).get();
    return {
      for (final row in rows) row.read<String>('cid'): row.read<int>('n')
    };
  }
}
