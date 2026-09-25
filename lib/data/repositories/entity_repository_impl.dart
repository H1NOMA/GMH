import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

class EntityRepositoryImpl implements EntityRepository {
  final AppDatabase _db;

  EntityRepositoryImpl(this._db);

  Entity _map(EntityRow row) {
    // A kind this build doesn't know (an archive from a newer version)
    // shows up in the Concept Archive instead of breaking every list that
    // contains it. updateEntity never writes the kind, so the original
    // value survives edits and a later upgrade.
    final kind = EntityKind.tryParse(row.kind) ?? EntityKind.concept;
    return Entity(
      id: row.id,
      worldId: row.worldId,
      kind: kind,
      customCategoryId: row.customCategoryId,
      name: row.name,
      summary: row.summary,
      attributes: Entity.decodeAttributes(row.attributesJson),
      coverMediaId: row.coverMediaId,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  OrderingTerm _ordering(EntitySort sort, $EntitiesTable e) => switch (sort) {
        EntitySort.nameAsc => OrderingTerm.asc(e.name),
        EntitySort.updatedDesc => OrderingTerm.desc(e.updatedAt),
        EntitySort.createdDesc => OrderingTerm.desc(e.createdAt),
      };

  @override
  Stream<List<Entity>> watchEntities(
    String worldId, {
    EntityKind? kind,
    String? customCategoryId,
    String? tagId,
    bool favoritesOnly = false,
    EntitySort sort = EntitySort.updatedDesc,
    int? limit,
  }) {
    if (tagId != null) {
      final join = _db.select(_db.entities).join([
        innerJoin(_db.entityTags,
            _db.entityTags.entityId.equalsExp(_db.entities.id)),
      ])
        ..where(_db.entities.worldId.equals(worldId) &
            _db.entities.deletedAt.isNull() &
            _db.entityTags.tagId.equals(tagId))
        ..orderBy([_ordering(sort, _db.entities)]);
      if (limit != null) join.limit(limit);
      if (kind != null) {
        join.where(_db.entities.kind.equals(kind.name));
      }
      if (customCategoryId != null) {
        join.where(_db.entities.customCategoryId.equals(customCategoryId));
      }
      if (favoritesOnly) {
        join.where(_db.entities.isFavorite.equals(true));
      }
      return join.watch().map((rows) => _sorted(
          [for (final r in rows) _map(r.readTable(_db.entities))], sort));
    }

    final query = _db.select(_db.entities)
      ..where((e) => e.worldId.equals(worldId) & e.deletedAt.isNull())
      ..orderBy([(e) => _ordering(sort, e)]);
    // Unlimited by default: the lists build lazily, and a silent cap hid
    // everything past the 500th entry of big archives.
    if (limit != null) query.limit(limit);
    if (kind != null) {
      query.where((e) => e.kind.equals(kind.name));
    }
    if (customCategoryId != null) {
      query.where((e) => e.customCategoryId.equals(customCategoryId));
    }
    if (favoritesOnly) {
      query.where((e) => e.isFavorite.equals(true));
    }
    return query.watch().map((rows) => _sorted(rows.map(_map).toList(), sort));
  }

  /// SQLite's default collation is binary: "zeta" after "Zulu", and
  /// lowercase Cyrillic after every capital. Name order is settled here.
  List<Entity> _sorted(List<Entity> list, EntitySort sort) {
    if (sort == EntitySort.nameAsc) {
      list.sort((a, b) {
        final byFolded = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        return byFolded != 0 ? byFolded : a.name.compareTo(b.name);
      });
    }
    return list;
  }

  @override
  Stream<Entity?> watchEntity(String id) {
    return (_db.select(_db.entities)..where((e) => e.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _map(row));
  }

  @override
  Future<Entity?> getEntity(String id) async {
    final row = await (_db.select(_db.entities)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<List<Entity>> getEntitiesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final rows =
        await (_db.select(_db.entities)..where((e) => e.id.isIn(ids))).get();
    return rows.map(_map).toList();
  }

  @override
  Future<List<Entity>> getAllEntities(String worldId) async {
    final rows = await (_db.select(_db.entities)
          ..where((e) => e.worldId.equals(worldId) & e.deletedAt.isNull())
          ..orderBy([(e) => OrderingTerm.asc(e.name)]))
        .get();
    return rows.map(_map).toList();
  }

  @override
  Future<Entity> createEntity({
    required String worldId,
    required EntityKind kind,
    String? customCategoryId,
    required String name,
    String summary = '',
    Map<String, Object?> attributes = const {},
  }) async {
    final now = nowMs();
    final entity = Entity(
      id: newId(),
      worldId: worldId,
      kind: kind,
      customCategoryId: customCategoryId,
      name: name,
      summary: summary,
      attributes: attributes,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.entities).insert(EntitiesCompanion.insert(
          id: entity.id,
          worldId: worldId,
          kind: kind.name,
          customCategoryId: Value(customCategoryId),
          name: name,
          summary: Value(summary),
          attributesJson: Value(entity.attributesJson),
          createdAt: now,
          updatedAt: now,
        ));
    return entity;
  }

  @override
  Future<void> updateEntity(Entity entity) async {
    await (_db.update(_db.entities)..where((e) => e.id.equals(entity.id)))
        .write(EntitiesCompanion(
      customCategoryId: Value(entity.customCategoryId),
      name: Value(entity.name),
      summary: Value(entity.summary),
      attributesJson: Value(entity.attributesJson),
      coverMediaId: Value(entity.coverMediaId),
      isFavorite: Value(entity.isFavorite),
      updatedAt: Value(nowMs()),
    ));
  }

  @override
  Future<void> setFavorite(String id, bool favorite) async {
    await (_db.update(_db.entities)..where((e) => e.id.equals(id)))
        .write(EntitiesCompanion(isFavorite: Value(favorite)));
  }

  @override
  Future<void> softDelete(String id) async {
    await (_db.update(_db.entities)..where((e) => e.id.equals(id)))
        .write(EntitiesCompanion(deletedAt: Value(nowMs())));
    await _db.customStatement(
        'DELETE FROM entity_search WHERE entity_id = ?', [id]);
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.entities)..where((e) => e.id.equals(id)))
        .write(const EntitiesCompanion(deletedAt: Value(null)));
  }

  @override
  Stream<List<Entity>> watchTrash(String worldId) {
    return (_db.select(_db.entities)
          ..where((e) => e.worldId.equals(worldId) & e.deletedAt.isNotNull())
          ..orderBy([(e) => OrderingTerm.desc(e.deletedAt)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  @override
  Future<void> purge(String id) async {
    await _db.transaction(() async {
      await _db.customStatement(
          'DELETE FROM entity_search WHERE entity_id = ?', [id]);
      await (_db.delete(_db.entities)..where((e) => e.id.equals(id))).go();
    });
  }

  Selectable<QueryRow> _countsQuery(String worldId) => _db.customSelect(
        'SELECT kind, COUNT(*) AS n FROM entities '
        'WHERE world_id = ? AND deleted_at IS NULL GROUP BY kind',
        variables: [Variable.withString(worldId)],
        readsFrom: {_db.entities},
      );

  static Map<EntityKind, int> _countsFrom(List<QueryRow> rows) {
    final result = <EntityKind, int>{};
    for (final row in rows) {
      final kind = EntityKind.tryParse(row.read<String>('kind'));
      if (kind != null) result[kind] = row.read<int>('n');
    }
    return result;
  }

  @override
  Future<Map<EntityKind, int>> countsByKind(String worldId) async =>
      _countsFrom(await _countsQuery(worldId).get());

  @override
  Stream<Map<EntityKind, int>> watchCountsByKind(String worldId) =>
      _countsQuery(worldId).watch().map(_countsFrom);

  @override
  Future<List<Entity>> lookupByName(String worldId, String query,
      {int limit = 12, List<EntityKind> kinds = const []}) async {
    // SQLite's LIKE folds case for ASCII only ("дракон" would miss
    // "Дракон") and treats '%'/'_' as wildcards, so match in Dart: a
    // world's names fit comfortably in memory.
    final needle = query.trim().toLowerCase();
    final kindNames = kinds.map((k) => k.name).toList();
    final candidates = await (_db.select(_db.entities)
          ..where((e) =>
              e.worldId.equals(worldId) &
              e.deletedAt.isNull() &
              (kindNames.isEmpty
                  ? const Constant(true)
                  : e.kind.isIn(kindNames))))
        .get();
    final rows = [
      for (final row in candidates)
        if (row.name.toLowerCase().contains(needle)) row
    ]..sort((a, b) {
        // Prefix hits first, then shorter (closer) names.
        final pa = a.name.toLowerCase().startsWith(needle) ? 0 : 1;
        final pb = b.name.toLowerCase().startsWith(needle) ? 0 : 1;
        if (pa != pb) return pa - pb;
        final byLength = a.name.length - b.name.length;
        return byLength != 0 ? byLength : a.name.compareTo(b.name);
      });
    return rows.take(limit).map(_map).toList();
  }
}
