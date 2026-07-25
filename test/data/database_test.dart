import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/link.dart';
import 'package:gmh/domain/repositories/repositories.dart';

import '../helpers.dart';

void main() {
  late TestHarness h;

  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  test('world and entity CRUD with counts', () async {
    final world = await h.worlds.createWorld(name: 'Aurion');
    final arden = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'King Arden');
    await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.location, name: 'Black Tower');

    final counts = await h.entities.countsByKind(world.id);
    expect(counts[EntityKind.character], 1);
    expect(counts[EntityKind.location], 1);

    final fetched = await h.entities.getEntity(arden.id);
    expect(fetched!.name, 'King Arden');

    await h.entities.softDelete(arden.id);
    expect((await h.entities.getEntity(arden.id))!.isDeleted, isTrue);
    expect((await h.entities.countsByKind(world.id))[EntityKind.character],
        isNull);

    await h.entities.restore(arden.id);
    expect((await h.entities.getEntity(arden.id))!.isDeleted, isFalse);
  });

  test('FTS search finds names, bodies and tags; soft delete removes',
      () async {
    final world = await h.worlds.createWorld(name: 'W');
    final sword = (await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.item,
      name: "Ashen King's Sword",
      summary: 'A legendary blade',
    ))
        .value;
    await h.documentService.save(
      entityId: sword.id,
      contentJson: jsonEncode([
        {'insert': 'Forged in the Dragon Forge during the War of Mages.\n'}
      ]),
    );

    // Name match (prefix, as-you-type).
    var results = await h.search.search(world.id, 'ashe');
    expect(results, hasLength(1));
    expect(results.single.name, "Ashen King's Sword");

    // Body match.
    results = await h.search.search(world.id, 'dragon forge');
    expect(results, hasLength(1));
    expect(results.single.snippet, contains('Dragon'));

    // Tag match after tagging.
    await h.entityService.addTag(sword.id, world.id, 'artifact');
    results = await h.search.search(world.id, 'artifact');
    expect(results, hasLength(1));

    // Kind filter.
    results = await h.search.search(world.id, 'ashen',
        kind: EntityKind.character);
    expect(results, isEmpty);

    // Soft delete drops it from the index.
    await h.entities.softDelete(sword.id);
    results = await h.search.search(world.id, 'ashen');
    expect(results, isEmpty);
  });

  test('document versions are pruned and deduplicated', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final entity = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.loreDocument, name: 'History');
    final doc = await h.documents.getOrCreate(entity.id);

    // Identical checkpoint is skipped.
    await h.documents.saveVersion(doc.id);
    await h.documents.saveVersion(doc.id);
    expect(await h.documents.versions(doc.id), hasLength(1));

    // Distinct saves create new versions, retention caps at 25.
    for (var i = 0; i < 30; i++) {
      await h.documents.save(
        entityId: entity.id,
        contentJson: jsonEncode([
          {'insert': 'revision $i\n'}
        ]),
        plainText: 'revision $i\n',
      );
      await h.documents.saveVersion(doc.id);
    }
    final versions = await h.documents.versions(doc.id, limit: 100);
    expect(versions.length, lessThanOrEqualTo(25));
  });

  test('recents record and cap; recently opened preserves order', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'A');
    final b = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'B');

    await h.search.recordOpened(a.id);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await h.search.recordOpened(b.id);

    final recents = await h.search.recentlyOpened(world.id);
    expect(recents.map((e) => e.name).toList(), ['B', 'A']);
  });

  test('media vault dedupes identical content', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final bytes = utf8.encode('fake image bytes');
    final first = await h.media
        .import(worldId: world.id, fileName: 'a.png', bytes: bytes);
    final second = await h.media
        .import(worldId: world.id, fileName: 'b.png', bytes: bytes);
    expect(second.id, first.id, reason: 'same content → same media row');
    expect(await h.vault.exists(world.id, first.relativePath), isTrue);
  });

  test('cascading delete: removing a world clears its data', () async {
    final world = await h.worlds.createWorld(name: 'Doomed');
    final entity = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'X');
    final other = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.location, name: 'Y');
    await h.links.create(
      worldId: world.id,
      sourceId: entity.id,
      targetId: other.id,
      role: LinkRoles.locatedAt,
      origin: LinkOrigin.manual,
    );

    await h.worlds.deleteWorld(world.id);
    expect(await h.entities.getEntity(entity.id), isNull);
    expect(await h.links.allForWorld(world.id), isEmpty);
  });

  test('lookupByName escapes wildcards and matches case-insensitively',
      () async {
    final world = await h.worlds.createWorld(name: 'W');
    await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'Lady Vex');
    await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.location, name: 'Vault_7');
    final hits = await h.entities.lookupByName(world.id, 'vex');
    expect(hits.map((e) => e.name), contains('Lady Vex'));
    // LIKE wildcards are treated as literal characters, so names containing
    // '_' stay findable and '%' cannot match everything.
    final vault = await h.entities.lookupByName(world.id, 'Vault_7');
    expect(vault.map((e) => e.name), contains('Vault_7'));
    expect(await h.entities.lookupByName(world.id, '%'), isEmpty);
    // A kind restriction applies before the LIMIT.
    final locationsOnly = await h.entities
        .lookupByName(world.id, 'v', kinds: [EntityKind.location]);
    expect(locationsOnly.map((e) => e.name), ['Vault_7']);
  });

  test('settings round-trip', () async {
    await h.settings.set(SettingsKeys.lastOpenedWorld, 'w1');
    expect(await h.settings.get(SettingsKeys.lastOpenedWorld), 'w1');
    await h.settings.remove(SettingsKeys.lastOpenedWorld);
    expect(await h.settings.get(SettingsKeys.lastOpenedWorld), isNull);
  });

  test('entity ref attribute values survive service sanitize', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final owner = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'Arden');
    final result = await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.item,
      name: 'Sword',
      attributes: {'currentOwner': entityRefValue(owner.id)},
    );
    expect(result.isOk, isTrue);
    final links = await h.links.outgoing(result.value.id);
    expect(links, hasLength(1));
    expect(links.single.targetId, owner.id);
    expect(links.single.role, LinkRoles.owner);
    expect(links.single.origin, LinkOrigin.attribute);
  });
}
