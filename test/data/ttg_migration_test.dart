import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/data/import/ttg/rich_text_converter.dart';
import 'package:gmh/data/import/ttg/ttg_migration_service.dart';
import 'package:gmh/data/import/ttg/ttg_source.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../helpers.dart';

/// Builds a realistic TTG-style SQLite database with media files on disk.
Future<String> buildTtgFixture(Directory dir) async {
  final dbPath = p.join(dir.path, 'ttg_world.db');
  final db = sqlite3.open(dbPath);
  db.execute('''
    CREATE TABLE campaigns (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT, created_at INTEGER);
    CREATE TABLE npcs (id INTEGER PRIMARY KEY, name TEXT, description TEXT,
      city_id INTEGER, faction_id INTEGER, religion_id INTEGER,
      portrait TEXT, tags TEXT, favorite INTEGER DEFAULT 0,
      FOREIGN KEY (city_id) REFERENCES cities(id));
    CREATE TABLE cities (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT, population INTEGER, kingdom_id INTEGER);
    CREATE TABLE kingdoms (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT);
    CREATE TABLE factions (id INTEGER PRIMARY KEY, name TEXT, notes TEXT);
    CREATE TABLE religions (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT);
    CREATE TABLE spells (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT, level INTEGER, school TEXT);
    CREATE TABLE classes (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT);
    CREATE TABLE spell_classes (spell_id INTEGER, class_id INTEGER,
      FOREIGN KEY (spell_id) REFERENCES spells(id),
      FOREIGN KEY (class_id) REFERENCES classes(id));
    CREATE TABLE quests (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT, campaign_id INTEGER);
    CREATE TABLE monsters (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT, cr TEXT);
    CREATE TABLE magic_items (id INTEGER PRIMARY KEY, name TEXT,
      description TEXT, owner_id INTEGER,
      FOREIGN KEY (owner_id) REFERENCES npcs(id));
    CREATE TABLE attachments (id INTEGER PRIMARY KEY, npc_id INTEGER,
      file_path TEXT, caption TEXT,
      FOREIGN KEY (npc_id) REFERENCES npcs(id));
    CREATE TABLE schema_migrations (version INTEGER);
  ''');

  db.execute("INSERT INTO campaigns VALUES "
      "(1, 'Curse of the Amber Throne', 'The long campaign.', 1700000000)");
  db.execute("INSERT INTO kingdoms VALUES (1, 'Aldenmark', 'Old kingdom.')");
  db.execute("INSERT INTO cities VALUES "
      "(1, 'Ravenport', '# Ravenport\\n\\nA **grim** harbor city.\\n\\n"
      "- Docks\\n- Market', 12000, 1)");
  db.execute("INSERT INTO factions VALUES "
      "(1, 'Silver Circle', 'Secretive mages.')");
  db.execute("INSERT INTO religions VALUES "
      "(1, 'Church of the Dawn', 'Sun worship.')");
  db.execute("INSERT INTO npcs VALUES "
      "(1, 'Captain Mira Voss', 'Harbor master of *Ravenport*.', 1, 1, 1, "
      "'mira.png', 'ally,harbor', 1)");
  db.execute("INSERT INTO npcs VALUES "
      "(2, 'Old Tom', 'A [fisherman](https://example.com/tom).', 1, "
      "NULL, NULL, NULL, NULL, 0)");
  // Broken reference on purpose: city 999 does not exist.
  db.execute("INSERT INTO npcs VALUES "
      "(3, 'Ghost of the Pier', 'Nobody knows.', 999, NULL, NULL, NULL, "
      "NULL, 0)");
  db.execute("INSERT INTO spells VALUES "
      "(1, 'Amber Bolt', 'A bolt of amber light.', 2, 'Evocation')");
  db.execute("INSERT INTO spells VALUES "
      "(2, 'Tidal Ward', 'Protects ships.', 3, 'Abjuration')");
  db.execute("INSERT INTO classes VALUES (1, 'Wizard', 'Book magic.')");
  db.execute("INSERT INTO classes VALUES (2, 'Cleric', 'Faith magic.')");
  db.execute('INSERT INTO spell_classes VALUES (1, 1)');
  db.execute('INSERT INTO spell_classes VALUES (2, 1)');
  db.execute('INSERT INTO spell_classes VALUES (2, 2)');
  db.execute("INSERT INTO quests VALUES "
      "(1, 'The Sunken Bell', 'Recover the bell.', 1)");
  db.execute("INSERT INTO monsters VALUES "
      "(1, 'Harbor Wyrm', 'Lurks beneath the docks.', '7')");
  db.execute("INSERT INTO magic_items VALUES "
      "(1, 'Tidecaller Trident', 'Commands the waves.', 1)");
  db.execute("INSERT INTO attachments VALUES "
      "(1, 1, 'notes/voss_contract.pdf', 'Signed contract')");
  db.execute('INSERT INTO schema_migrations VALUES (42)');
  db.dispose();

  // Media on disk, next to the database.
  final png = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 1, 2, 3, 4, 5,
  ];
  await File(p.join(dir.path, 'mira.png')).writeAsBytes(png);
  await Directory(p.join(dir.path, 'notes')).create(recursive: true);
  await File(p.join(dir.path, 'notes', 'voss_contract.pdf'))
      .writeAsBytes([0x25, 0x50, 0x44, 0x46, 9, 9, 9]);
  return dbPath;
}

void main() {
  late TestHarness h;
  late Directory dir;
  late TtgMigrationService service;

  setUp(() async {
    h = await TestHarness.create();
    dir = await Directory.systemTemp.createTemp('ttg_fixture_');
    service = TtgMigrationService(h.db, h.vault, h.search, h.settings);
  });

  tearDown(() async {
    await h.dispose();
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  group('rich text conversion', () {
    test('markdown formatting maps to Quill attributes', () {
      final c = convertRichText(
          '# Title\n\nSome **bold** and *italic* and `code`.\n\n'
          '- one\n- two\n\n> quoted\n\n[link](https://x.y)');
      expect(
          c.ops.any((op) =>
              (op['attributes'] as Map?)?['header'] == 1), isTrue);
      expect(
          c.ops.any((op) =>
              op['insert'] == 'bold' &&
              (op['attributes'] as Map?)?['bold'] == true),
          isTrue);
      expect(
          c.ops.any((op) =>
              (op['attributes'] as Map?)?['list'] == 'bullet'), isTrue);
      expect(
          c.ops.any((op) =>
              (op['attributes'] as Map?)?['blockquote'] == true), isTrue);
      expect(
          c.ops.any((op) =>
              (op['attributes'] as Map?)?['link'] == 'https://x.y'), isTrue);
      expect(c.plainText, contains('bold'));
    });

    test('HTML is converted and images are collected', () {
      final c = convertRichText(
          '<h2>Head</h2><p>A <b>bold</b> and <i>soft</i> line.<br>'
          '<a href="https://a.b">go</a></p><img src="pic.png">');
      expect(
          c.ops.any((op) =>
              op['insert'] == 'bold' &&
              (op['attributes'] as Map?)?['bold'] == true),
          isTrue);
      expect(
          c.ops.any((op) =>
              (op['attributes'] as Map?)?['link'] == 'https://a.b'), isTrue);
      expect(c.imageRefs, ['pic.png']);
    });

    test('existing Quill deltas pass through losslessly', () {
      final delta = jsonEncode([
        {'insert': 'kept', 'attributes': {'bold': true}},
        {'insert': '\n'},
      ]);
      final c = convertRichText(delta);
      expect(c.ops.first['insert'], 'kept');
      expect((c.ops.first['attributes'] as Map)['bold'], true);
    });

    test('markdown tables become aligned code blocks', () {
      final c = convertRichText(
          '| A | B |\n|---|---|\n| 1 | 2 |');
      expect(
          c.ops.any((op) =>
              (op['attributes'] as Map?)?['code-block'] == true), isTrue);
      expect(c.plainText, contains('| A | B |'));
    });
  });

  group('SQLite source reader', () {
    test('discovers collections, relations, attachments and skips '
        'technical tables', () async {
      final path = await buildTtgFixture(dir);
      final source = await readTtgSource(path);

      expect(source.collections.keys, containsAll([
        'campaigns', 'npcs', 'cities', 'kingdoms', 'factions',
        'religions', 'spells', 'classes', 'quests', 'monsters',
        'magic_items',
      ]));
      // Join and technical tables are not record collections.
      expect(source.collections.keys, isNot(contains('spell_classes')));
      expect(source.collections.keys, isNot(contains('schema_migrations')));
      expect(source.collections.keys, isNot(contains('attachments')));

      final mira = source.collections['npcs']!
          .firstWhere((r) => r.name == 'Captain Mira Voss');
      expect(mira.favorite, isTrue);
      expect(mira.tags, containsAll(['ally', 'harbor']));
      // FK relations + attachment media + portrait media.
      expect(mira.relations.map((r) => r.targetKey),
          containsAll(['cities#1', 'factions#1', 'religions#1']));
      expect(mira.media.length, 2); // portrait + pdf attachment
      final spell = source.collections['spells']!
          .firstWhere((r) => r.name == 'Tidal Ward');
      expect(spell.relations.map((r) => r.targetKey),
          containsAll(['classes#1', 'classes#2']));
    });
  });

  group('full migration', () {
    test('imports every record, preserves relationships, media, tags and '
        'produces a report', () async {
      final path = await buildTtgFixture(dir);
      final progressPhases = <String>{};
      final result = await service.migrate(
        path,
        const TtgImportOptions(worldName: 'Amberlands'),
        onProgress: (pr) => progressPhases.add(pr.phase),
      );
      expect(result.isOk, isTrue, reason: result.isErr ? '${result.error}' : '');
      final report = result.value;

      expect(report.completed, isTrue);
      // 1 campaign + 3 npc + 1 city + 1 kingdom + 1 faction + 1 religion +
      // 2 spells + 2 classes + 1 quest + 1 monster + 1 magic item = 15
      expect(report.imported, 15);
      expect(report.sourceRecords, 15);
      expect(report.documentsCreated, greaterThanOrEqualTo(15));
      expect(progressPhases,
          containsAll(['entities', 'links', 'validating', 'indexing']));

      final worldId = report.worldId;
      final entities = await h.entities.getAllEntities(worldId);
      // 15 imported + the migration report lore document.
      expect(entities.length, 16);

      // Kinds and categories mapped correctly.
      Map<String, dynamic> byName(String name) =>
          {'e': entities.firstWhere((e) => e.name == name)};
      expect(byName('Captain Mira Voss')['e'].kind, EntityKind.character);
      expect(byName('Ravenport')['e'].kind, EntityKind.location);
      expect(byName('Harbor Wyrm')['e'].kind, EntityKind.creature);
      expect(byName('Silver Circle')['e'].kind, EntityKind.faction);
      expect(byName('The Sunken Bell')['e'].kind, EntityKind.quest);
      expect(byName('Curse of the Amber Throne')['e'].kind,
          EntityKind.campaign);
      final amberBolt = entities.firstWhere((e) => e.name == 'Amber Bolt');
      expect(amberBolt.kind, EntityKind.custom);
      expect(amberBolt.customCategoryId, isNotNull);
      final categories = await h.db.select(h.db.customCategories).get();
      final categoryNames = categories.map((c) => c.name).toSet();
      expect(categoryNames, containsAll(['Spells', 'Classes']));

      // Relationships preserved: NPC -> city/faction/religion,
      // spell -> classes, quest -> campaign, item -> owner.
      final links = await h.links.allForWorld(worldId);
      String idOf(String name) =>
          entities.firstWhere((e) => e.name == name).id;
      bool linked(String from, String to) => links.any((l) =>
          l.sourceId == idOf(from) && l.targetId == idOf(to));
      expect(linked('Captain Mira Voss', 'Ravenport'), isTrue);
      expect(linked('Captain Mira Voss', 'Silver Circle'), isTrue);
      expect(linked('Captain Mira Voss', 'Church of the Dawn'), isTrue);
      expect(linked('Ravenport', 'Aldenmark'), isTrue);
      expect(linked('Tidal Ward', 'Wizard'), isTrue);
      expect(linked('Tidal Ward', 'Cleric'), isTrue);
      expect(linked('The Sunken Bell', 'Curse of the Amber Throne'), isTrue);
      expect(linked('Tidecaller Trident', 'Captain Mira Voss'), isTrue);
      expect(report.linksCreated, greaterThanOrEqualTo(8));

      // The broken city reference (999) was repaired (dropped), and the
      // ghost NPC still imported fine.
      expect(report.repairedReferences, greaterThanOrEqualTo(1));
      expect(idOf('Ghost of the Pier'), isNotEmpty);

      // Media: portrait + pdf attachment imported into the vault.
      expect(report.mediaImported, 2);
      final media = await h.media.allForWorld(worldId);
      expect(media.length, 2);
      for (final m in media) {
        final abs = await h.media.absolutePath(m);
        expect(await File(abs).exists(), isTrue);
      }
      // Portrait becomes the cover image.
      expect(byName('Captain Mira Voss')['e'].coverMediaId, isNotNull);

      // Formatting: markdown became a Quill delta with a header + bold.
      final doc = await h.documents.getOrCreate(idOf('Ravenport'));
      final ops = jsonDecode(doc.contentJson) as List;
      expect(
          ops.any((op) =>
              (op['attributes'] as Map?)?['header'] == 1), isTrue);
      expect(doc.plainText, contains('grim'));

      // Tags: source tags plus mapping tags (npc, monster...).
      final tags = await h.tags.watchTags(worldId).first;
      final tagNames = tags.map((t) => t.name.toLowerCase()).toSet();
      expect(tagNames, containsAll(['ally', 'harbor', 'npc', 'magic item']));

      // Search index covers imported entities.
      final found = await h.search.search(worldId, 'Ravenport');
      expect(found, isNotEmpty);

      // Favorite preserved.
      expect(byName('Captain Mira Voss')['e'].isFavorite, isTrue);

      // The migration report document exists.
      expect(entities.any((e) => e.name.startsWith('TTG Migration Report')),
          isTrue);

      // Checkpoint cleared after a completed run.
      expect(await h.settings.get('ttgImportState'), isNull);
    });

    test('re-import with skip creates no duplicates; replace overwrites',
        () async {
      final path = await buildTtgFixture(dir);
      final first = await service.migrate(
          path, const TtgImportOptions(worldName: 'Amberlands'));
      final worldId = first.value.worldId;

      // Re-import into the SAME world: everything is a duplicate.
      final second = await service.migrate(
        path,
        TtgImportOptions(
          worldName: 'Amberlands',
          targetWorldId: worldId,
          duplicates: TtgDuplicateStrategy.skip,
        ),
      );
      expect(second.value.imported, 0);
      expect(second.value.skippedDuplicates, 15);
      final entities = await h.entities.getAllEntities(worldId);
      expect(entities.length, 17); // 15 + 2 report documents

      // User edits, then re-imports with replace: source wins again.
      final mira = entities.firstWhere(
          (e) => e.name == 'Captain Mira Voss');
      await h.entities
          .updateEntity(mira.copyWith(summary: 'user edited'));
      final third = await service.migrate(
        path,
        TtgImportOptions(
          worldName: 'Amberlands',
          targetWorldId: worldId,
          duplicates: TtgDuplicateStrategy.replace,
        ),
      );
      expect(third.value.replacedDuplicates, 15);
      final replaced = await h.entities.getEntity(mira.id);
      expect(replaced!.summary, isNot('user edited'));
    });

    test('never touches existing worlds by default and dedupes world names',
        () async {
      final existing = await h.worlds.createWorld(name: 'Amberlands');
      final path = await buildTtgFixture(dir);
      final result = await service.migrate(
          path, const TtgImportOptions(worldName: 'Amberlands'));
      expect(result.value.worldId, isNot(existing.id));
      final untouched = await h.entities.getAllEntities(existing.id);
      expect(untouched, isEmpty);
      final imported =
          await h.worlds.getWorld(result.value.worldId);
      expect(imported!.name, 'Amberlands (2)'); // no name collision
    });

    test('cancelled import keeps a checkpoint and resumes without '
        'duplicating', () async {
      final path = await buildTtgFixture(dir);
      var processed = 0;
      final first = await service.migrate(
        path,
        TtgImportOptions(
          worldName: 'Amberlands',
          isCancelled: () => processed >= 5,
        ),
        onProgress: (pr) {
          if (pr.phase == 'entities') processed = pr.processed;
        },
      );
      expect(first.value.completed, isFalse);
      expect(first.value.imported, lessThan(15));
      expect(await h.settings.get('ttgImportState'), isNotNull);

      // Resume: same file, no explicit target — continues the same world.
      final second = await service.migrate(
          path, const TtgImportOptions(worldName: 'Amberlands'));
      expect(second.value.completed, isTrue);
      expect(second.value.worldId, first.value.worldId);
      expect(
          second.value.imported + second.value.skippedDuplicates +
              first.value.imported,
          greaterThanOrEqualTo(15));
      final entities =
          await h.entities.getAllEntities(second.value.worldId);
      final names = entities.map((e) => e.name).toList();
      // No record imported twice.
      expect(names.toSet().length, names.length);
      expect(await h.settings.get('ttgImportState'), isNull);
    });
  });

  group('JSON migration', () {
    test('imports a JSON export with camelCase refs and ref lists',
        () async {
      final jsonPath = p.join(dir.path, 'export.json');
      await File(jsonPath).writeAsString(jsonEncode({
        'worldName': 'JSON Realm',
        'collections': {
          'cities': [
            {'id': 'c1', 'name': 'Goldfall', 'description': 'Rich.'},
          ],
          'npcs': [
            {
              'id': 'n1',
              'name': 'Serra',
              'description': 'Guide.',
              'cityId': 'c1',
              'tags': ['guide'],
            },
          ],
          'quests': [
            {
              'id': 'q1',
              'name': 'Golden Path',
              'description': 'Find it.',
              'npc_ids': ['n1'],
            },
          ],
        },
      }));

      final result = await service.migrate(
          jsonPath, const TtgImportOptions(worldName: 'JSON Realm'));
      expect(result.isOk, isTrue,
          reason: result.isErr ? '${result.error}' : '');
      final report = result.value;
      expect(report.imported, 3);

      final entities =
          await h.entities.getAllEntities(report.worldId);
      String idOf(String name) =>
          entities.firstWhere((e) => e.name == name).id;
      final links = await h.links.allForWorld(report.worldId);
      expect(
          links.any((l) =>
              l.sourceId == idOf('Serra') &&
              l.targetId == idOf('Goldfall')),
          isTrue);
      expect(
          links.any((l) =>
              l.sourceId == idOf('Golden Path') &&
              l.targetId == idOf('Serra')),
          isTrue);
    });

    test(
        'same-named records from different collections stay separate '
        'and keep their own links', () async {
      // A city and a tavern both named "New Liberty" map to the same GMH
      // kind (location) — they must not be collapsed into one entity, and
      // the NPC's tavern_id link must point at the tavern, not the city.
      final jsonPath = p.join(dir.path, 'liberty.json');
      await File(jsonPath).writeAsString(jsonEncode({
        'worldName': 'Liberty Realm',
        'collections': {
          'cities': [
            {'id': 1, 'name': 'New Liberty', 'description': 'The city.'},
          ],
          'taverns': [
            {'id': 1, 'name': 'New Liberty', 'description': 'The tavern.'},
          ],
          'npcs': [
            {
              'id': 1,
              'name': 'Mira Voss',
              'description': 'Regular.',
              'tavern_id': 1,
            },
          ],
        },
      }));

      final result = await service.migrate(
          jsonPath, const TtgImportOptions(worldName: 'Liberty Realm'));
      expect(result.isOk, isTrue,
          reason: result.isErr ? '${result.error}' : '');
      final report = result.value;
      expect(report.imported, 3);

      final entities = await h.entities.getAllEntities(report.worldId);
      final liberties =
          entities.where((e) => e.name == 'New Liberty').toList();
      expect(liberties, hasLength(2));

      Future<String> idWithTag(String tag) async {
        for (final e in liberties) {
          final tags = await h.tags.entityTags(e.id);
          if (tags.any((t) => t.name == tag)) return e.id;
        }
        fail('no New Liberty entity tagged "$tag"');
      }

      final tavernId = await idWithTag('tavern');
      final cityId = await idWithTag('city');
      expect(tavernId, isNot(cityId));

      final mira = entities.firstWhere((e) => e.name == 'Mira Voss');
      final links = await h.links.allForWorld(report.worldId);
      expect(
          links.any(
              (l) => l.sourceId == mira.id && l.targetId == tavernId),
          isTrue,
          reason: 'the NPC link must land on the tavern');
      expect(
          links.any((l) => l.sourceId == mira.id && l.targetId == cityId),
          isFalse,
          reason: 'the NPC link must not be re-routed to the city');
    });

    test('rejects garbage files with a typed error', () async {
      final bad = p.join(dir.path, 'bad.ttg');
      await File(bad).writeAsString('this is not a database');
      final result = await service.migrate(
          bad, const TtgImportOptions(worldName: 'X'));
      expect(result.isErr, isTrue);
    });
  });
}
