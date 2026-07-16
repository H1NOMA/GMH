import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/world.dart';
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';
import '../storage/media_vault.dart';

class WorldRepositoryImpl implements WorldRepository {
  final AppDatabase _db;
  final MediaVault _vault;

  WorldRepositoryImpl(this._db, this._vault);

  World _map(WorldRow row) => World(
        id: row.id,
        name: row.name,
        description: row.description,
        coverMediaId: row.coverMediaId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  @override
  Stream<List<World>> watchWorlds() {
    final query = _db.select(_db.worlds)
      ..orderBy([(w) => OrderingTerm.desc(w.updatedAt)]);
    return query.watch().map((rows) => rows.map(_map).toList());
  }

  @override
  Future<World?> getWorld(String id) async {
    final row = await (_db.select(_db.worlds)..where((w) => w.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<World> createWorld(
      {required String name, String description = ''}) async {
    final now = nowMs();
    final world = World(
      id: newId(),
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.worlds).insert(WorldsCompanion.insert(
          id: world.id,
          name: world.name,
          description: Value(world.description),
          createdAt: now,
          updatedAt: now,
        ));
    return world;
  }

  @override
  Future<void> updateWorld(World world) async {
    await (_db.update(_db.worlds)..where((w) => w.id.equals(world.id))).write(
      WorldsCompanion(
        name: Value(world.name),
        description: Value(world.description),
        coverMediaId: Value(world.coverMediaId),
        updatedAt: Value(nowMs()),
      ),
    );
  }

  @override
  Future<void> deleteWorld(String id) async {
    await _db.transaction(() async {
      await _db.customStatement(
        'DELETE FROM entity_search WHERE entity_id IN '
        '(SELECT id FROM entities WHERE world_id = ?)',
        [id],
      );
      await (_db.delete(_db.worlds)..where((w) => w.id.equals(id))).go();
    });
    await _vault.deleteWorldDirectory(id);
  }
}
