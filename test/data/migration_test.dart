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

/// GMH 1.0's first schema: no custom categories, no category column on
/// entities, no tag timestamps, no world style, no world objects.
class _V1Database extends AppDatabase {
  _V1Database(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        for (final table in allTables) {
          if (table.actualTableName == 'world_objects' ||
              table.actualTableName == 'custom_categories') {
            continue;
          }
          await m.createTable(table);
        }
        await customStatement(
            'ALTER TABLE entities DROP COLUMN custom_category_id');
        await customStatement('ALTER TABLE tags DROP COLUMN created_at');
        await customStatement('ALTER TABLE worlds DROP COLUMN style');
      });
}

void main() {
  test('a v1 database upgrades through every step to the current schema',
      () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final dir = await Directory.systemTemp.createTemp('gmh_migration_v1_');
    addTearDown(() => dir.delete(recursive: true));
    final file = File(p.join(dir.path, 'gmh.db'));

    final old = _V1Database(NativeDatabase(file));
    await old.customStatement(
        "INSERT INTO worlds (id, name, description, created_at, updated_at) "
        "VALUES ('w1', 'Oldest', '', 1, 1)");
    await old.close();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    final world = (await db.select(db.worlds).get()).single;
    expect(world.name, 'Oldest');
    expect(world.style, 'fantasy');
    await db.into(db.customCategories).insert(
        CustomCategoriesCompanion.insert(
            id: 'c1', worldId: 'w1', name: 'Guilds', color: 1, createdAt: 1));
    final category = (await db.select(db.customCategories).get()).single;
    expect(category.blueprintJson, '{}');
    final repo = WorldObjectRepositoryImpl(db);
    await repo.create(worldId: 'w1', type: WorldObjectTypes.map);
  });

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
