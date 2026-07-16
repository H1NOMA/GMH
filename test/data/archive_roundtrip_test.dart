import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/data/backup/project_archive_service.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/link.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

void main() {
  late TestHarness source;
  late TestHarness target;

  setUp(() async {
    source = await TestHarness.create();
    target = await TestHarness.create();
  });

  tearDown(() async {
    await source.dispose();
    await target.dispose();
  });

  test('full export → import round-trip preserves everything', () async {
    // Build a small but complete world.
    final world = await source.worlds
        .createWorld(name: 'Aurion', description: 'Realm of ash');
    final arden = (await source.entityService.create(
      worldId: world.id,
      kind: EntityKind.character,
      name: 'King Arden',
      summary: 'The Ashen King',
    ))
        .value;
    final sword = (await source.entityService.create(
      worldId: world.id,
      kind: EntityKind.item,
      name: "Ashen King's Sword",
      attributes: {'currentOwner': entityRefValue(arden.id)},
    ))
        .value;
    await source.documentService.save(
      entityId: sword.id,
      contentJson: jsonEncode([
        {'insert': 'Created during the War of Mages by '},
        {
          'insert': {
            'entityLink': jsonEncode({'id': arden.id, 'label': 'King Arden'})
          }
        },
        {'insert': '\n'},
      ]),
    );
    await source.entityService.addTag(sword.id, world.id, 'legendary');
    final media = await source.media.import(
        worldId: world.id,
        fileName: 'sword.png',
        bytes: utf8.encode('image-bytes'));
    await source.media.addToGallery(sword.id, media.id, caption: 'The blade');
    await source.entityService
        .update(sword.copyWith(coverMediaId: () => media.id));

    // Export from the source harness.
    final archiveService = ProjectArchiveService(source.db, source.vault);
    final archivePath = p.join(source.tempDir.path, 'aurion.gmhw');
    final exported =
        await archiveService.exportArchive(world.id, archivePath);
    expect(exported.isOk, isTrue, reason: exported.isErr ? '${exported.error}' : null);
    expect(await File(archivePath).exists(), isTrue);

    // Import into a completely fresh harness (fresh DB + vault).
    final importer = ProjectArchiveService(target.db, target.vault);
    final imported = await importer.importArchive(archivePath);
    expect(imported.isOk, isTrue, reason: imported.isErr ? '${imported.error}' : null);
    expect(imported.value, world.id);

    // World and entities arrived with stable ids.
    final importedWorld = await target.worlds.getWorld(world.id);
    expect(importedWorld!.name, 'Aurion');
    final importedSword = await target.entities.getEntity(sword.id);
    expect(importedSword!.name, "Ashen King's Sword");
    expect(parseEntityRef(importedSword.attributes['currentOwner']),
        arden.id);
    expect(importedSword.coverMediaId, media.id);

    // Links (attribute mirror + document mention) preserved.
    final outgoing = await target.links.outgoing(sword.id);
    expect(outgoing.map((l) => l.origin).toSet(),
        {LinkOrigin.attribute, LinkOrigin.document});

    // Document body preserved.
    final doc = await target.documents.getOrCreate(sword.id);
    expect(doc.plainText, contains('War of Mages'));

    // Tags preserved.
    final tags = await target.tags.entityTags(sword.id);
    expect(tags.single.name, 'legendary');

    // Media file physically restored into the target vault.
    final importedMedia = await target.media.get(media.id);
    expect(importedMedia, isNotNull);
    expect(
        await target.vault.exists(world.id, importedMedia!.relativePath),
        isTrue);

    // Search works after reindex (import path calls rebuildIndex in UI).
    await target.search.rebuildIndex(world.id);
    final results = await target.search.search(world.id, 'mages');
    expect(results.map((r) => r.entityId), contains(sword.id));
  });

  test('import replaces an existing copy of the same world atomically',
      () async {
    final world = await source.worlds.createWorld(name: 'V1');
    await source.entityService.create(
        worldId: world.id, kind: EntityKind.character, name: 'Old Hero');

    final archiveService = ProjectArchiveService(source.db, source.vault);
    final archivePath = p.join(source.tempDir.path, 'v1.gmhw');
    await archiveService.exportArchive(world.id, archivePath);

    // Mutate after export.
    await source.worlds.updateWorld(world.copyWith(name: 'V2'));
    await source.entityService.create(
        worldId: world.id, kind: EntityKind.character, name: 'New Hero');

    // Re-import the old archive into the SAME database → back to V1.
    final restored = await archiveService.importArchive(archivePath);
    expect(restored.isOk, isTrue);
    final restoredWorld = await source.worlds.getWorld(world.id);
    expect(restoredWorld!.name, 'V1');
    final entities = await source.entities.getAllEntities(world.id);
    expect(entities.map((e) => e.name).toList(), ['Old Hero']);
  });

  test('import rejects garbage and missing files with typed errors',
      () async {
    final archiveService = ProjectArchiveService(target.db, target.vault);

    final missing = await archiveService
        .importArchive(p.join(target.tempDir.path, 'nope.gmhw'));
    expect(missing.isErr, isTrue);

    final garbagePath = p.join(target.tempDir.path, 'garbage.gmhw');
    await File(garbagePath).writeAsString('this is not a zip');
    final garbage = await archiveService.importArchive(garbagePath);
    expect(garbage.isErr, isTrue);
  });
}
