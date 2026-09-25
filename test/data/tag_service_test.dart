import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/services/tag_service.dart';

import '../helpers.dart';

void main() {
  late TestHarness h;
  late TagService tags;
  setUp(() async {
    h = await TestHarness.create();
    tags = TagService(h.tags, h.search);
  });
  tearDown(() async => h.dispose());

  Future<List<String>> find(String worldId, String q) async =>
      [for (final r in await h.search.search(worldId, q)) r.name];

  test('rename, merge and delete keep the search index current', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final mira = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'Mira'))
        .value;
    await h.entityService.addTag(mira.id, world.id, 'smuggler');
    expect(await find(world.id, 'smuggler'), ['Mira']);

    final tag = (await h.tags.tags(world.id)).single;
    expect((await tags.rename(world.id, tag.id, 'corsair')).isOk, isTrue);
    expect(await find(world.id, 'smuggler'), isEmpty);
    expect(await find(world.id, 'corsair'), ['Mira']);

    await h.entityService.addTag(mira.id, world.id, 'captain');
    final captain =
        (await h.tags.tags(world.id)).firstWhere((t) => t.name == 'captain');
    final corsair =
        (await h.tags.tags(world.id)).firstWhere((t) => t.name == 'corsair');
    await tags.merge(fromTagId: corsair.id, intoTagId: captain.id);
    expect(await find(world.id, 'corsair'), isEmpty);

    await tags.delete(captain.id);
    expect(await find(world.id, 'captain'), isEmpty);
    expect(await find(world.id, 'Mira'), ['Mira']);
  });

  test('tag names are unique per world regardless of case', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'A'))
        .value;
    await h.entityService.addTag(a.id, world.id, 'Злодей');
    await h.entityService.addTag(a.id, world.id, 'злодей');
    expect(await h.tags.tags(world.id), hasLength(1));

    await h.entityService.addTag(a.id, world.id, 'Hero');
    final hero =
        (await h.tags.tags(world.id)).firstWhere((t) => t.name == 'Hero');
    final clash = await tags.rename(world.id, hero.id, 'ЗЛОДЕЙ');
    expect(clash.isErr, isTrue);
    expect((await tags.rename(world.id, hero.id, 'HERO')).isOk, isTrue);
  });

  test('usage counts are live', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'A'))
        .value;
    final counts = h.tags.watchUsageCounts(world.id);
    final seen = <int>[];
    final sub = counts.listen((m) => seen.add(m.values.fold(0, (x, y) => x + y)));
    await h.entityService.addTag(a.id, world.id, 'x');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await sub.cancel();
    expect(seen.last, 1);
  });
}
