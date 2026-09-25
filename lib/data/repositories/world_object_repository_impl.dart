import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/world_object.dart';
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

class WorldObjectRepositoryImpl implements WorldObjectRepository {
  final AppDatabase _db;

  WorldObjectRepositoryImpl(this._db);

  /// Updates must be distinguishable even within one millisecond (models
  /// compare by id + updatedAt).
  int _lastStamp = 0;
  int _stamp() {
    final now = nowMs();
    _lastStamp = now > _lastStamp ? now : _lastStamp + 1;
    return _lastStamp;
  }

  static WorldObject _map(WorldObjectRow row) {
    Map<String, Object?> data;
    try {
      final decoded = jsonDecode(row.dataJson);
      data = decoded is Map<String, Object?> ? decoded : const {};
    } catch (_) {
      data = const {};
    }
    return WorldObject(
      id: row.id,
      worldId: row.worldId,
      type: row.type,
      parentId: row.parentId,
      name: row.name,
      data: data,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  SimpleSelectStatement<$WorldObjectsTable, WorldObjectRow> _query(
      String worldId, String type, String? parentId) {
    final q = _db.select(_db.worldObjects)
      ..where((o) => o.worldId.equals(worldId) & o.type.equals(type));
    if (parentId != null) q.where((o) => o.parentId.equals(parentId));
    q.orderBy([
      (o) => OrderingTerm.asc(o.sortOrder),
      (o) => OrderingTerm.asc(o.createdAt),
    ]);
    return q;
  }

  @override
  Stream<List<WorldObject>> watch(String worldId, String type,
          {String? parentId}) =>
      _query(worldId, type, parentId)
          .watch()
          .map((rows) => rows.map(_map).toList());

  @override
  Future<List<WorldObject>> list(String worldId, String type,
          {String? parentId}) async =>
      (await _query(worldId, type, parentId).get()).map(_map).toList();

  @override
  Stream<WorldObject?> watchOne(String id) =>
      (_db.select(_db.worldObjects)..where((o) => o.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _map(row));

  @override
  Future<WorldObject?> get(String id) async {
    final row = await (_db.select(_db.worldObjects)
          ..where((o) => o.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<WorldObject> create({
    required String worldId,
    required String type,
    String? parentId,
    String name = '',
    Map<String, Object?> data = const {},
    int? sortOrder,
  }) async {
    final now = _stamp();
    var order = sortOrder;
    if (order == null) {
      // Append: one past the current maximum among siblings.
      final max = _db.worldObjects.sortOrder.max();
      final q = _db.selectOnly(_db.worldObjects)
        ..addColumns([max])
        ..where(_db.worldObjects.worldId.equals(worldId) &
            _db.worldObjects.type.equals(type));
      if (parentId != null) {
        q.where(_db.worldObjects.parentId.equals(parentId));
      }
      order = ((await q.getSingle()).read(max) ?? -1) + 1;
    }
    final object = WorldObject(
      id: newId(),
      worldId: worldId,
      type: type,
      parentId: parentId,
      name: name,
      data: data,
      sortOrder: order,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.worldObjects).insert(WorldObjectsCompanion.insert(
          id: object.id,
          worldId: worldId,
          type: type,
          parentId: Value(parentId),
          name: Value(name),
          dataJson: Value(jsonEncode(data)),
          sortOrder: Value(order),
          createdAt: now,
          updatedAt: now,
        ));
    return object;
  }

  @override
  Future<WorldObject> update(WorldObject object) async {
    final now = _stamp();
    await (_db.update(_db.worldObjects)
          ..where((o) => o.id.equals(object.id)))
        .write(WorldObjectsCompanion(
      parentId: Value(object.parentId),
      name: Value(object.name),
      dataJson: Value(jsonEncode(object.data)),
      sortOrder: Value(object.sortOrder),
      updatedAt: Value(now),
    ));
    return WorldObject(
      id: object.id,
      worldId: object.worldId,
      type: object.type,
      parentId: object.parentId,
      name: object.name,
      data: object.data,
      sortOrder: object.sortOrder,
      createdAt: object.createdAt,
      updatedAt: now,
    );
  }

  @override
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      // Breadth-first collection of the whole subtree, then one delete.
      final doomed = <String>{id};
      var frontier = [id];
      while (frontier.isNotEmpty) {
        final children = await (_db.select(_db.worldObjects)
              ..where((o) => o.parentId.isIn(frontier)))
            .get();
        frontier = [
          for (final c in children)
            if (doomed.add(c.id)) c.id,
        ];
      }
      await (_db.delete(_db.worldObjects)..where((o) => o.id.isIn(doomed)))
          .go();
    });
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.worldObjects)
              ..where((o) => o.id.equals(orderedIds[i])))
            .write(WorldObjectsCompanion(sortOrder: Value(i)));
      }
    });
  }

  @override
  Future<void> trim(String worldId, String type, {required int keep}) async {
    // customUpdate (not customStatement) so live watchers see the removal.
    await _db.customUpdate(
      'DELETE FROM world_objects WHERE world_id = ? AND type = ? AND id NOT IN '
      '(SELECT id FROM world_objects WHERE world_id = ? AND type = ? '
      'ORDER BY created_at DESC LIMIT ?)',
      variables: [
        Variable.withString(worldId),
        Variable.withString(type),
        Variable.withString(worldId),
        Variable.withString(type),
        Variable.withInt(keep),
      ],
      updates: {_db.worldObjects},
      updateKind: UpdateKind.delete,
    );
  }
}
