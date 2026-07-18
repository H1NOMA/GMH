import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/data/backup/project_archive_service.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

void main() {
  late TestHarness h;

  setUp(() async => h = await TestHarness.create());
  tearDown(() async => h.dispose());

  test('world style round-trips through the repository', () async {
    final cyber = await h.worlds.createWorld(
        name: 'Neon City', style: WorldStyle.cyberpunk);
    final fantasy = await h.worlds.createWorld(name: 'Old Realm');

    expect((await h.worlds.getWorld(cyber.id))!.style,
        WorldStyle.cyberpunk);
    expect((await h.worlds.getWorld(fantasy.id))!.style,
        WorldStyle.fantasy);

    // updateWorld keeps the style.
    await h.worlds
        .updateWorld(cyber.copyWith(name: 'Neon City 2077'));
    final updated = await h.worlds.getWorld(cyber.id);
    expect(updated!.name, 'Neon City 2077');
    expect(updated.style, WorldStyle.cyberpunk);
  });

  test('world style survives archive export -> import', () async {
    final world = await h.worlds.createWorld(
        name: 'Chrome District', style: WorldStyle.cyberpunk);
    final service = ProjectArchiveService(h.db, h.vault);
    final path = p.join(h.tempDir.path, 'world.gmhw');
    final exported = await service.exportArchive(world.id, path);
    expect(exported.isOk, isTrue);

    await h.worlds.deleteWorld(world.id);
    expect(await h.worlds.getWorld(world.id), isNull);

    final imported = await service.importArchive(path);
    expect(imported.isOk, isTrue);
    final restored = await h.worlds.getWorld(world.id);
    expect(restored!.style, WorldStyle.cyberpunk);
    expect(await File(path).exists(), isTrue);
  });

  test('unknown style strings fall back to fantasy', () {
    expect(WorldStyle.parse('cyberpunk'), WorldStyle.cyberpunk);
    expect(WorldStyle.parse('fantasy'), WorldStyle.fantasy);
    expect(WorldStyle.parse('steampunk'), WorldStyle.fantasy);
    expect(WorldStyle.parse(null), WorldStyle.fantasy);
  });
}
