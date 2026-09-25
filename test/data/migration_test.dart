import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/repositories/world_object_repository_impl.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:path/path.dart' as p;

/// The database exactly as GMH 1.x (schema v5) created it: every table
/// except the v6 world-object store.
class _V5Database extends AppDatabase {
  _V5Database(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        for (final table in allTables) {
          if (table.actualTableName == 'world_objects') continue;
          await m.createTable(table);
        }
      });
}

void main() {
  test('a v5 database upgrades to v6 and keeps its data', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final dir = await Directory.systemTemp.createTemp('gmh_migration_');
    addTearDown(() => dir.delete(recursive: true));
    final file = File(p.join(dir.path, 'gmh.db'));

    final old = _V5Database(NativeDatabase(file));
    await old.into(old.worlds).insert(WorldsCompanion.insert(
        id: 'w1', name: 'Legacy', createdAt: 1, updatedAt: 1));
    final oldTables = await old
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get();
    expect(oldTables.map((r) => r.read<String>('name')),
        isNot(contains('world_objects')));
    await old.close();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    final worlds = await db.select(db.worlds).get();
    expect(worlds.single.name, 'Legacy');

    final repo = WorldObjectRepositoryImpl(db);
    final o = await repo.create(
        worldId: 'w1', type: WorldObjectTypes.map, name: 'Upgraded');
    expect((await repo.get(o.id))!.name, 'Upgraded');

    final indexes = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='index'")
        .get();
    expect(indexes.map((r) => r.read<String>('name')),
        containsAll(['idx_world_objects_type', 'idx_world_objects_parent']));
  });
}
