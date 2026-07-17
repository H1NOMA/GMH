import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/data/backup/project_archive_service.dart';
import 'package:gmh/data/repositories/category_repository_impl.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

void main() {
  late TestHarness h;
  late CategoryRepositoryImpl categories;

  setUp(() async {
    h = await TestHarness.create();
    categories = CategoryRepositoryImpl(h.db);
  });
  tearDown(() => h.dispose());

  test('create, rename, reorder and list categories', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final guilds =
        await categories.create(worldId: world.id, name: 'Guilds');
    final kingdoms = await categories.create(
        worldId: world.id, name: 'Kingdoms', icon: 'castle');
    final rituals =
        await categories.create(worldId: world.id, name: 'Rituals');

    var list = await categories.categories(world.id);
    expect(list.map((c) => c.name).toList(), ['Guilds', 'Kingdoms', 'Rituals']);
    expect(list[1].icon, 'castle');

    // Rename + change icon.
    await categories
        .update(guilds.copyWith(name: 'Merchant Guilds', icon: 'gem'));
    expect((await categories.get(guilds.id))!.name, 'Merchant Guilds');

    // Reorder: rituals first.
    await categories
        .reorder(world.id, [rituals.id, guilds.id, kingdoms.id]);
    list = await categories.categories(world.id);
    expect(list.map((c) => c.name).toList(),
        ['Rituals', 'Merchant Guilds', 'Kingdoms']);
  });

  test('entities live in categories and are counted', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final guilds =
        await categories.create(worldId: world.id, name: 'Guilds');

    final entity = (await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.custom,
      customCategoryId: guilds.id,
      name: 'Ironmongers Guild',
    ))
        .value;
    expect(entity.kind, EntityKind.custom);
    expect(entity.customCategoryId, guilds.id);

    // Listed via the category filter.
    final inCategory = await h.entities
        .watchEntities(world.id,
            kind: EntityKind.custom, customCategoryId: guilds.id)
        .first;
    expect(inCategory.single.name, 'Ironmongers Guild');

    final counts = await categories.countsByCategory(world.id);
    expect(counts[guilds.id], 1);

    // Full shared machinery: document, tags, search.
    await h.documentService.save(
      entityId: entity.id,
      contentJson:
          '[{"insert":"The guild controls the mithril trade.\\n"}]',
    );
    final results = await h.search.search(world.id, 'mithril');
    expect(results.single.entityId, entity.id);

    // Category-scoped search filter.
    final scoped = await h.search
        .search(world.id, 'mithril', customCategoryId: guilds.id);
    expect(scoped, hasLength(1));
    final wrongScope = await h.search
        .search(world.id, 'mithril', customCategoryId: 'other-cat');
    expect(wrongScope, isEmpty);
  });

  test('deleting a category preserves its entries as concepts', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final rituals =
        await categories.create(worldId: world.id, name: 'Rituals');
    final entity = (await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.custom,
      customCategoryId: rituals.id,
      name: 'Rite of Ash',
    ))
        .value;

    await categories.delete(rituals.id);

    expect(await categories.get(rituals.id), isNull);
    final preserved = await h.entities.getEntity(entity.id);
    expect(preserved, isNotNull);
    expect(preserved!.kind, EntityKind.concept,
        reason: 'entries move to the Concept Archive, nothing is lost');
    expect(preserved.customCategoryId, isNull);
  });

  test('categories survive export → import round-trip', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final guilds = await categories.create(
        worldId: world.id, name: 'Guilds', icon: 'shield');
    final entity = (await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.custom,
      customCategoryId: guilds.id,
      name: 'Shadow Guild',
    ))
        .value;

    final target = await TestHarness.create();
    addTearDown(target.dispose);
    final targetCategories = CategoryRepositoryImpl(target.db);

    final archivePath = p.join(h.tempDir.path, 'w.gmhw');
    final exported = await ProjectArchiveService(h.db, h.vault)
        .exportArchive(world.id, archivePath);
    expect(exported.isOk, isTrue);
    final imported0 = await ProjectArchiveService(target.db, target.vault)
        .importArchive(archivePath);
    expect(imported0.isOk, isTrue);

    final imported = await targetCategories.categories(world.id);
    expect(imported.single.name, 'Guilds');
    expect(imported.single.icon, 'shield');
    final importedEntity = await target.entities.getEntity(entity.id);
    expect(importedEntity!.customCategoryId, guilds.id);
    expect(importedEntity.kind, EntityKind.custom);
  });
}
