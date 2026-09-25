import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/data/backup/project_archive_service.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

void main() {
  late TestHarness h;

  setUp(() async => h = await TestHarness.create());
  tearDown(() async => h.dispose());

  test('create, list in order, update and watch', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = await h.objects.create(
        worldId: world.id, type: WorldObjectTypes.randomTable, name: 'A');
    final b = await h.objects.create(
        worldId: world.id,
        type: WorldObjectTypes.randomTable,
        name: 'B',
        data: {'die': 'd6'});
    // Other types and worlds never leak into a query.
    await h.objects.create(worldId: world.id, type: WorldObjectTypes.map);
    final other = await h.worlds.createWorld(name: 'Other');
    await h.objects
        .create(worldId: other.id, type: WorldObjectTypes.randomTable);

    var list = await h.objects.list(world.id, WorldObjectTypes.randomTable);
    expect(list.map((o) => o.name), ['A', 'B']);
    expect(list[1].data['die'], 'd6');
    expect(a.sortOrder, lessThan(b.sortOrder));

    final updated =
        await h.objects.update(a.copyWith(name: 'A2', data: {'x': 1}));
    expect(updated.updatedAt, greaterThan(a.updatedAt));
    final reread = await h.objects.get(a.id);
    expect(reread!.name, 'A2');
    expect(reread.data, {'x': 1});

    await h.objects.reorder([b.id, a.id]);
    list = await h.objects.list(world.id, WorldObjectTypes.randomTable);
    expect(list.map((o) => o.id), [b.id, a.id]);

    final stream = h.objects.watch(world.id, WorldObjectTypes.randomTable);
    expect((await stream.first).length, 2);
  });

  test('deleting a parent removes its whole subtree only', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final map = await h.objects
        .create(worldId: world.id, type: WorldObjectTypes.map, name: 'Map');
    final pin = await h.objects.create(
        worldId: world.id, type: WorldObjectTypes.mapPin, parentId: map.id);
    final nested = await h.objects.create(
        worldId: world.id, type: WorldObjectTypes.mapPin, parentId: pin.id);
    final keep = await h.objects
        .create(worldId: world.id, type: WorldObjectTypes.map, name: 'Keep');
    final keepPin = await h.objects.create(
        worldId: world.id, type: WorldObjectTypes.mapPin, parentId: keep.id);

    await h.objects.delete(map.id);
    expect(await h.objects.get(map.id), isNull);
    expect(await h.objects.get(pin.id), isNull);
    expect(await h.objects.get(nested.id), isNull);
    expect(await h.objects.get(keep.id), isNotNull);
    expect(await h.objects.get(keepPin.id), isNotNull);
    expect(
        await h.objects
            .list(world.id, WorldObjectTypes.mapPin, parentId: keep.id),
        hasLength(1));
  });

  test('trim keeps only the newest entries of a log', () async {
    final world = await h.worlds.createWorld(name: 'W');
    for (var i = 0; i < 12; i++) {
      await h.objects.create(
          worldId: world.id, type: WorldObjectTypes.diceRoll, name: 'r$i');
    }
    await h.objects.trim(world.id, WorldObjectTypes.diceRoll, keep: 5);
    final left = await h.objects.list(world.id, WorldObjectTypes.diceRoll);
    expect(left.map((o) => o.name), ['r7', 'r8', 'r9', 'r10', 'r11']);
  });

  test('deleting the world cascades its objects', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final o = await h.objects
        .create(worldId: world.id, type: WorldObjectTypes.encounter);
    await h.worlds.deleteWorld(world.id);
    expect(await h.objects.get(o.id), isNull);
  });

  test('media referenced only by a world object survives cleanup', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final media = await h.media
        .import(worldId: world.id, fileName: 'map.png', bytes: [1, 2, 3]);
    await h.objects.create(
        worldId: world.id,
        type: WorldObjectTypes.map,
        data: {'mediaId': media.id});
    await h.media.deleteIfUnreferenced(media.id);
    expect(await h.media.get(media.id), isNotNull);
  });

  test('world objects travel through a .gmhw archive', () async {
    final target = await TestHarness.create();
    addTearDown(target.dispose);
    final world = await h.worlds.createWorld(name: 'Aurion');
    final map = await h.objects.create(
        worldId: world.id,
        type: WorldObjectTypes.map,
        name: 'Realm',
        data: {'scale': 5, 'layers': ['a', 'b']});
    await h.objects.create(
        worldId: world.id,
        type: WorldObjectTypes.mapPin,
        parentId: map.id,
        data: {'x': 0.25, 'y': 0.75});

    final out = p.join(h.tempDir.path, 'w.gmhw');
    final exported =
        await ProjectArchiveService(h.db, h.vault).exportArchive(world.id, out);
    expect(exported.isOk, isTrue);
    expect(File(out).existsSync(), isTrue);
    final imported =
        await ProjectArchiveService(target.db, target.vault).importArchive(out);
    expect(imported.isOk, isTrue);

    final maps = await target.objects.list(world.id, WorldObjectTypes.map);
    expect(maps.single.name, 'Realm');
    expect(maps.single.data['layers'], ['a', 'b']);
    final pins = await target.objects
        .list(world.id, WorldObjectTypes.mapPin, parentId: maps.single.id);
    expect(pins.single.data['x'], 0.25);
  });
}
