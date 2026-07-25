import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/models/entity_kind.dart';

import '../helpers.dart';

void main() {
  late TestHarness h;

  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  test('usage counts reflect live assignments', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'A'))
        .value;
    final b = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'B'))
        .value;

    await h.entityService.addTag(a.id, world.id, 'hero');
    await h.entityService.addTag(b.id, world.id, 'hero');
    await h.entityService.addTag(b.id, world.id, 'villain');

    final tags = await h.tags.watchTags(world.id).first;
    final hero = tags.firstWhere((t) => t.name == 'hero');
    final villain = tags.firstWhere((t) => t.name == 'villain');
    expect(hero.createdAt, greaterThan(0));

    final counts = await h.tags.usageCounts(world.id);
    expect(counts[hero.id], 2);
    expect(counts[villain.id], 1);
  });

  test('merge moves assignments, collapses duplicates, deletes source',
      () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'A'))
        .value;
    final b = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'B'))
        .value;

    // "hero" and its duplicate "heroes"; A has both, B only the duplicate.
    await h.entityService.addTag(a.id, world.id, 'hero');
    await h.entityService.addTag(a.id, world.id, 'heroes');
    await h.entityService.addTag(b.id, world.id, 'heroes');

    final tags = await h.tags.watchTags(world.id).first;
    final hero = tags.firstWhere((t) => t.name == 'hero');
    final heroes = tags.firstWhere((t) => t.name == 'heroes');

    await h.tags.merge(fromTagId: heroes.id, intoTagId: hero.id);

    final remaining = await h.tags.watchTags(world.id).first;
    expect(remaining.map((t) => t.name), ['hero']);
    expect((await h.tags.entityTags(a.id)).map((t) => t.name), ['hero']);
    expect((await h.tags.entityTags(b.id)).map((t) => t.name), ['hero']);
    expect((await h.tags.usageCounts(world.id))[hero.id], 2);
  });

  test('deleting a tag detaches it everywhere but keeps the entries',
      () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'A'))
        .value;
    await h.entityService.addTag(a.id, world.id, 'doomed');

    final tag =
        (await h.tags.watchTags(world.id).first).single;
    await h.tags.delete(tag.id);

    expect(await h.tags.watchTags(world.id).first, isEmpty);
    expect(await h.tags.entityTags(a.id), isEmpty);
    expect(await h.entities.getEntity(a.id), isNotNull,
        reason: 'the entry itself must survive tag deletion');
  });

  test('rename, merge and delete keep the search index in sync', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.character, name: 'A'))
        .value;
    await h.entityService.addTag(a.id, world.id, 'npc');

    final tag = (await h.tags.watchTags(world.id).first).single;
    await h.tags.rename(tag.id, 'villager');

    expect(
        (await h.search.search(world.id, 'villager')).map((r) => r.entityId),
        contains(a.id),
        reason: 'search must find the renamed tag');
    expect(await h.search.search(world.id, 'npc'), isEmpty,
        reason: 'search must stop matching the old tag name');

    // Merging re-points assignments; the index must follow.
    await h.entityService.addTag(a.id, world.id, 'boss');
    final tags = await h.tags.watchTags(world.id).first;
    final villager = tags.firstWhere((t) => t.name == 'villager');
    final boss = tags.firstWhere((t) => t.name == 'boss');
    await h.tags.merge(fromTagId: villager.id, intoTagId: boss.id);
    expect(await h.search.search(world.id, 'villager'), isEmpty);
    expect((await h.search.search(world.id, 'boss')).map((r) => r.entityId),
        contains(a.id));

    await h.tags.delete(boss.id);
    expect(await h.search.search(world.id, 'boss'), isEmpty,
        reason: 'search must stop matching a deleted tag');
  });
}
