// Shared demo-world fixture for widget tests that pump the whole app:
// the store screenshot generator and the visual smoke matrix.
//
// Seeds a rich fantasy world (cover art, stat blocks, linked lore, a
// campaign with quests/sessions, custom categories) plus a cyberpunk world.

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/domain/combat/combatant.dart';
import 'package:gmh/domain/combat/encounter.dart';
import 'package:gmh/domain/tables/content/table_library.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/maps/map_pin.dart';
import 'package:gmh/domain/maps/game_map.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/repositories/repositories.dart';
import 'package:path/path.dart' as p;

bool _fontsLoaded = false;

Future<void> loadRealFonts(WidgetTester tester) async {
  if (_fontsLoaded) return;
  await tester.runAsync(() async {
    final flutterRoot = Platform.environment['FLUTTER_ROOT'];
    if (flutterRoot == null) fail('FLUTTER_ROOT is not set');
    final fontsDir =
        p.join(flutterRoot, 'bin', 'cache', 'artifacts', 'material_fonts');
    Future<void> load(String family, List<String> files) async {
      for (final file in files) {
        await ui.loadFontFromList(
            await File(p.join(fontsDir, file)).readAsBytes(),
            fontFamily: family);
      }
    }

    await load('Roboto', [
      'Roboto-Regular.ttf',
      'Roboto-Medium.ttf',
      'Roboto-Bold.ttf',
      'Roboto-Italic.ttf',
    ]);
    await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
  });
  _fontsLoaded = true;
}

/// Procedural cover art: a seeded gradient with soft shapes — looks like
/// concept art thumbnails without shipping any binary fixtures.
Future<List<int>> demoCoverArt(int seed, {bool neon = false}) async {
  final rnd = Random(seed);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const w = 880.0, h = 560.0;

  Color hsl(double h0, double s, double l) =>
      HSLColor.fromAHSL(1, h0 % 360, s, l).toColor();
  final baseHue = rnd.nextDouble() * 360;
  final c1 = neon
      ? hsl(180 + rnd.nextDouble() * 120, 0.9, 0.45)
      : hsl(baseHue, 0.45, 0.32);
  final c2 = neon
      ? hsl(280 + rnd.nextDouble() * 60, 0.85, 0.18)
      : hsl(baseHue + 40, 0.5, 0.16);

  canvas.drawRect(
    const Rect.fromLTWH(0, 0, w, h),
    Paint()
      ..shader = ui.Gradient.linear(
          Offset.zero, const Offset(w, h), [c1, c2]),
  );
  for (var i = 0; i < 7; i++) {
    canvas.drawCircle(
      Offset(rnd.nextDouble() * w, rnd.nextDouble() * h),
      50 + rnd.nextDouble() * 180,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.04 + rnd.nextDouble() * 0.08),
    );
  }
  for (var i = 0; i < 3; i++) {
    final x = rnd.nextDouble() * w;
    canvas.drawRect(
      Rect.fromLTWH(x, 0, 30 + rnd.nextDouble() * 80, h),
      Paint()
        ..color = (neon ? c1 : Colors.black).withValues(alpha: 0.10),
    );
  }

  final image = await recorder.endRecording().toImage(w.toInt(), h.toInt());
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

class DemoWorld {
  final AppDatabase db;
  final MediaVault vault;
  final Directory dir;
  late final String worldId;
  late final String cyberWorldId;

  /// A user-defined section ("Guilds") with one entry, so screens that
  /// branch on custom categories are covered too.
  late final String guildCategoryId;

  /// A map of the harbor region with a few pins (one GM-only).
  late final String mapId;

  /// A fight in progress (round 2, three combatants, one condition) and
  /// a random table copied from the library.
  late final String encounterId;
  late final String tableId;

  /// One small world per additional setting pack (everything but fantasy
  /// and the cyberpunk demo): style -> world id, plus the ids of its
  /// headline character and creature for entity-page coverage.
  final packWorldIds = <WorldStyle, String>{};
  final packCharacterIds = <WorldStyle, String>{};
  final packCreatureIds = <WorldStyle, String>{};
  final byName = <String, Entity>{};
  DemoWorld(this.db, this.vault, this.dir);
}

Future<DemoWorld> seedRichWorld() async {
  final dir = await Directory.systemTemp.createTemp('gmh_store_');
  final db = AppDatabase(NativeDatabase.memory());
  final demo = DemoWorld(db, MediaVault(dir.path), dir);

  final container = ProviderContainer(overrides: [
    appRootDirProvider.overrideWithValue(dir.path),
    databaseProvider.overrideWithValue(db),
    mediaVaultProvider.overrideWithValue(demo.vault),
  ]);
  addTearDown(container.dispose);

  final worlds = container.read(worldRepositoryProvider);
  final entities = container.read(entityServiceProvider);
  final entityRepo = container.read(entityRepositoryProvider);
  final media = container.read(mediaRepositoryProvider);
  final settings = container.read(settingsRepositoryProvider);

  final world = await worlds.createWorld(
      name: 'The Aurion Realms',
      description: 'Realm of ash, salt and amber');
  demo.worldId = world.id;

  var artSeed = 7;
  Future<Entity> create(
    String worldId,
    EntityKind kind,
    String name,
    String summary, {
    Map<String, Object?> attributes = const {},
    bool cover = false,
    bool neon = false,
    bool favorite = false,
    List<String> tags = const [],
  }) async {
    final entity = (await entities.create(
            worldId: worldId,
            kind: kind,
            name: name,
            summary: summary,
            attributes: attributes))
        .value;
    demo.byName[name] = entity;
    if (cover) {
      final item = await media.import(
          worldId: worldId,
          fileName: '${name.toLowerCase().replaceAll(' ', '_')}.png',
          bytes: await demoCoverArt(artSeed++, neon: neon));
      await media.addToGallery(entity.id, item.id);
      await entityRepo.updateEntity(
          entity.copyWith(coverMediaId: () => item.id));
    }
    if (favorite) await entities.setFavorite(entity.id, true);
    for (final tag in tags) {
      await entities.addTag(entity.id, worldId, tag);
    }
    return entity;
  }

  // ------------------------------------------------- fantasy world content
  final aldenmark = await create(world.id, EntityKind.location, 'Aldenmark',
      'Old kingdom of amber and oaths', attributes: {
    'locationType': 'Country',
    'government': 'Elective monarchy',
  });
  final ravenport = await create(world.id, EntityKind.location, 'Ravenport',
      'A grim harbor city under perpetual drizzle',
      cover: true,
      favorite: true,
      tags: ['harbor'],
      attributes: {
        'locationType': 'City',
        'population': '12,400',
        'government': 'Harbor Council',
        'climate': 'Cold coastal, fog nine months a year',
        'parentLocation': entityRefValue(aldenmark.id),
      });
  // Extra vistas so the location page's bottom image strip has cells.
  for (var i = 0; i < 2; i++) {
    final vista = await media.import(
        worldId: world.id,
        fileName: 'ravenport_vista_${i + 1}.png',
        bytes: await demoCoverArt(artSeed++));
    await media.addToGallery(ravenport.id, vista.id);
  }
  await create(world.id, EntityKind.location, 'The Sunken Bell',
      'Dockside tavern where every rumor is half true',
      cover: true,
      tags: ['harbor'],
      attributes: {'locationType': 'Landmark'});
  await create(world.id, EntityKind.location, 'Gloomwood',
      'The forest that swallows lantern light',
      cover: true, attributes: {'locationType': 'Region'});
  final circle = await create(world.id, EntityKind.faction,
      'The Silver Circle', 'Secretive order of tide-mages',
      attributes: {'factionType': 'Order'});
  await create(world.id, EntityKind.faction, 'Harbor Council',
      'Merchants who really run Ravenport',
      attributes: {'factionType': 'Guild'});

  final mira = await create(world.id, EntityKind.character,
      'Captain Mira Voss', 'Harbor master of Ravenport, keeps the docks honest',
      cover: true,
      favorite: true,
      tags: ['ally', 'harbor', 'season-2'],
      attributes: {
        'race': 'Human',
        'characterClass': 'Fighter',
        'status': 'Alive',
        'title': 'The Tidekeeper',
        'age': '41',
        'alignment': 'Lawful Neutral',
        'strength': 16,
        'dexterity': 12,
        'constitution': 14,
        'intelligence': 11,
        'wisdom': 13,
        'charisma': 15,
        'hp': '34 / 40',
        'ac': 16,
        'speed': '30 ft.',
        'initiative': 1,
        'passivePerception': 13,
        'homeLocation': entityRefValue(ravenport.id),
        'factions': [entityRefValue(circle.id)],
      });
  await create(world.id, EntityKind.character, 'Seraphine the Ashen',
      'Exiled pyromancer with a debt to the Circle',
      cover: true,
      tags: ['season-2'],
      attributes: {
        'race': 'Tiefling',
        'characterClass': 'Sorcerer',
        'status': 'Alive',
        'rivals': [entityRefValue(mira.id)],
        'factions': [entityRefValue(circle.id)],
      });
  await create(world.id, EntityKind.character, 'Old Tom',
      'A fisherman who saw the wyrm and lived', attributes: {
    'race': 'Human',
    'characterClass': 'Commoner',
    'status': 'Missing',
    'allies': [entityRefValue(mira.id)],
    'homeLocation': entityRefValue(ravenport.id),
  });
  await create(world.id, EntityKind.character, 'Brother Aldous',
      'Keeper of the drowned chapel', cover: true, attributes: {
    'race': 'Human',
    'characterClass': 'Cleric',
    'status': 'Alive',
    'religion': 'Church of the Dawn',
  });
  await create(world.id, EntityKind.character, 'Wren Six-Fingers',
      'Smuggler queen of the amber market',
      cover: true,
      favorite: true,
      tags: ['harbor'],
      attributes: {
        'race': 'Halfling',
        'characterClass': 'Rogue',
        'status': 'Alive',
        'enemies': [entityRefValue(mira.id)],
      });

  final trident = await create(world.id, EntityKind.item,
      'Tidecaller Trident', 'Commands the waves; hums near deep water',
      cover: true, favorite: true, attributes: {
    'itemType': 'Weapon',
    'rarity': 'Legendary',
    'currentOwner': entityRefValue(mira.id),
  });
  await create(world.id, EntityKind.item, 'Lantern of True Names',
      'Shows what a thing really is', attributes: {
    'itemType': 'Magical Item',
    'rarity': 'Very Rare',
  });

  await create(world.id, EntityKind.creature, 'Harbor Wyrm',
      'Lurks beneath the docks of Ravenport',
      cover: true, attributes: {
    'creatureType': 'Dragon',
    'challenge': '7',
    'size': 'Huge',
    'habitat': [entityRefValue(ravenport.id)],
    // Full stat block for the monster-card screenshot.
    'ac': 17,
    'hp': '142 (15d12 + 45)',
    'speed': '30 ft., swim 60 ft.',
    'strength': 21,
    'dexterity': 12,
    'constitution': 17,
    'intelligence': 8,
    'wisdom': 13,
    'charisma': 10,
    'savingThrows': 'CON +6, WIS +4',
    'skills': 'Perception +4, Stealth +4',
    'resistances': 'cold; bludgeoning from nonmagical attacks',
    'immunities': 'poison',
    'senses': 'darkvision 120 ft., passive Perception 14',
    'languages': 'understands Draconic, cannot speak',
    'traits': 'Amphibious. The wyrm can breathe air and water.\n'
        'Fog Shroud. While in fog, attack rolls against it have '
        'disadvantage.',
    'actions': 'Multiattack. Bite and tail.\n'
        'Bite. +8 to hit, 2d10+5 piercing plus 1d8 cold.\n'
        'Tail. +8 to hit, reach 15 ft., 2d8+5 bludgeoning.',
  });
  await create(world.id, EntityKind.creature, 'Fog Hounds',
      'They hunt by the sound of your heartbeat', attributes: {
    'creatureType': 'Monster',
    'challenge': '2',
    'size': 'Medium',
  });

  await create(world.id, EntityKind.event, 'The Night of Amber Rain',
      'When the sky wept the old kingdom back', attributes: {
    'date': '3rd Age, Year 409',
    'locations': [entityRefValue(ravenport.id)],
  });

  // A map of the harbor region: pins linked to entries, one GM-only.
  final objects = container.read(worldObjectRepositoryProvider);
  final mapArt = await media.import(
      worldId: world.id,
      fileName: 'harbor-region.png',
      bytes: await demoCoverArt(4242));
  final map = await objects.create(
    worldId: world.id,
    type: WorldObjectTypes.map,
    name: 'The Harbor Reach',
    data: GameMap(
      name: 'The Harbor Reach',
      mediaId: mapArt.id,
      width: 880,
      height: 560,
      description: 'Coast, docks and the drowned quarter',
      scale: const MapScale(unitsPerCell: 1, unitName: 'miles', cellPx: 40),
    ).toData(),
  );
  demo.mapId = map.id;
  for (final (x, y, label, entity, icon, gmOnly) in [
    (0.34, 0.42, '', ravenport, MapPinIcon.town, false),
    (0.52, 0.61, '', mira, MapPinIcon.npc, false),
    (0.71, 0.28, 'Wreck of the Tern', null, MapPinIcon.treasure, true),
  ]) {
    await objects.create(
      worldId: world.id,
      type: WorldObjectTypes.mapPin,
      parentId: map.id,
      data: MapPin(
        x: x,
        y: y,
        label: label,
        entityId: entity?.id,
        icon: icon,
        gmOnly: gmOnly,
      ).toData(),
    );
  }

  // A fight in progress for the combat tracker and the GM screen.
  final encounter = await objects.create(
    worldId: world.id,
    type: WorldObjectTypes.encounter,
    name: 'Ambush at the Sunken Bell',
    data: const Encounter(
      id: '',
      worldId: '',
      name: 'Ambush at the Sunken Bell',
      status: EncounterStatus.active,
      round: 2,
      partyLevels: [3, 3, 4],
    ).toData(),
  );
  demo.encounterId = encounter.id;
  for (final (i, c) in [
    Combatant(
        name: 'Captain Mira Voss',
        entityId: mira.id,
        isPlayer: true,
        initiative: 17,
        hpMax: 38,
        hpCurrent: 31,
        ac: 16),
    const Combatant(
        name: 'Fog Hound 1',
        initiative: 14,
        hpMax: 22,
        hpCurrent: 9,
        ac: 13,
        cr: '1',
        xp: 200,
        conditions: [CombatCondition('frightened', rounds: 2)]),
    const Combatant(
        name: 'Fog Hound 2',
        initiative: 9,
        hpMax: 22,
        hpCurrent: 22,
        ac: 13,
        cr: '1',
        xp: 200),
  ].indexed) {
    await objects.create(
      worldId: world.id,
      type: WorldObjectTypes.combatant,
      parentId: encounter.id,
      name: c.name,
      data: c.toData(),
      sortOrder: i,
    );
  }

  // Random tables from the library (one references the other).
  final tableIds = <String>[];
  for (final table in TableLibrary.forStyle(WorldStyle.fantasy).take(2)) {
    final draft = TableLibrary.materialize(table, 'en', worldId: world.id);
    final object = await objects.create(
      worldId: world.id,
      type: WorldObjectTypes.randomTable,
      name: draft.name,
      data: draft.toData(),
    );
    tableIds.add(object.id);
  }
  demo.tableId = tableIds.first;

  // A short history for the timeline: two eras, dated events, one
  // event waiting for a date.
  await create(world.id, EntityKind.era, 'The Amber Kingdom',
      'Crowned merchants and a sea of lamps',
      attributes: {'startDate': 'Year 120', 'endDate': 'Year 398'});
  await create(world.id, EntityKind.era, 'The Drowned Years',
      'Fog, debt and the long quiet', attributes: {'startDate': 'Year 399'});
  await create(world.id, EntityKind.event, 'The First Toll',
      'Harbor dues are paid in amber', attributes: {'date': 'Year 211'});
  await create(world.id, EntityKind.event, 'The Council Fire',
      'The old council burns its ledgers', attributes: {'date': '12 March 402'});
  await create(world.id, EntityKind.event, 'The Bell Falls Silent',
      'Nobody agrees when it stopped');

  // The city's ruler ref creates a visible relation + backlink pair.
  await entities.setAttribute(
      ravenport.id, 'ruler', entityRefValue(mira.id));

  // A full spell card for the stat-first page screenshot.
  await create(world.id, EntityKind.magicSystem, 'Tidebinding',
      'Chains of seawater hold what the deep has claimed', attributes: {
    'level': '3rd Level',
    'school': 'Conjuration',
    'castingTime': '1 action',
    'range': '60 ft.',
    'components': 'V, S, M (a link of rusted chain)',
    'duration': 'Concentration, up to 1 minute',
    'ritual': 'No',
    'saveAttack': 'STR save, restrained on failure',
    'damageEffect': '3d8 cold on entering the chains',
    'classes': ['Wizard', 'Sorcerer'],
    'higherLevels': 'One extra target per slot level above 3rd.',
    'source': 'The Silver Circle tide-lore',
  });

  final campaign = await create(world.id, EntityKind.campaign,
      'Curse of the Amber Throne', 'The long campaign, season two',
      attributes: {
        'status': 'Active',
        'players': ['Lena', 'Marcus', 'Petya', 'Sasha'],
        'currentChapter': 'Chapter 9 — The Drowned Court',
      });
  Future<void> quest(String name, String summary, String status,
      {String? giver}) async {
    await create(world.id, EntityKind.quest, name, summary, attributes: {
      'status': status,
      'campaign': entityRefValue(campaign.id),
      if (giver != null) 'questGiver': entityRefValue(giver),
    });
  }

  await quest('The Sunken Bell', 'Recover the drowned bell before the storm',
      'Active', giver: mira.id);
  await quest('The Missing Fisherman', 'Find Old Tom — or what is left',
      'Available');
  await quest('Crown in the Deep', 'The wyrm guards more than gold',
      'Active');
  await quest('The Amber Audit', 'Prove the Council cooks its books',
      'Completed');
  for (final (i, name) in [
    'Session 10 — The Broken Oath',
    'Session 11 — Amber and Ash',
    'Session 12 — The Storm',
  ].indexed) {
    await create(world.id, EntityKind.session, name,
        'The party edges closer to the throne', attributes: {
      'campaign': entityRefValue(campaign.id),
      'date': '2026-07-${5 + i * 7}',
    });
  }

  // Two entries in the trash, for the Trash page.
  for (final (kind, name) in [
    (EntityKind.character, 'Captain Vell (retconned)'),
    (EntityKind.item, 'Cracked Spyglass'),
  ]) {
    final trashed = await create(world.id, kind, name, 'Cut from the story.');
    await entities.moveToTrash(trashed.id);
    demo.byName.remove(name);
  }

  // A meaty lore document for the entry screenshot, with real @-mention
  // links to entries (they render as chips and create backlinks).
  Map<String, Object> mention(Entity e) => {
        'insert': {
          'entityLink': jsonEncode({'id': e.id, 'label': e.name}),
        },
      };
  final tavern = demo.byName['The Sunken Bell']!;
  final aldous = demo.byName['Brother Aldous']!;
  final delta = [
    {'insert': 'Ravenport\n', 'attributes': {'header': 2}},
    {
      'insert': 'A grim harbor city where the fog never fully lifts. '
          'The docks belong to '
    },
    mention(mira),
    {
      'insert': ', the market belongs to the gulls, and the deep water '
          'belongs to something older.\n'
    },
    {'insert': 'Quarters\n', 'attributes': {'header': 3}},
    {'insert': 'Docks quarter — smugglers, rope, salt\n',
        'attributes': {'list': 'bullet'}},
    {'insert': 'Amber market — relics of the old kingdom\n',
        'attributes': {'list': 'bullet'}},
    mention(tavern),
    {'insert': ' — where rumors surface first\n',
        'attributes': {'list': 'bullet'}},
    {'insert': 'Chapel row — '},
    mention(aldous),
    {'insert': ' rings for the drowned\n',
        'attributes': {'list': 'bullet'}},
    {
      'insert': 'Nothing leaves this harbor that the tide does not '
          'already know about.\n',
      'attributes': {'blockquote': true}
    },
  ];
  await container
      .read(documentServiceProvider)
      .save(entityId: ravenport.id, contentJson: jsonEncode(delta));

  await settings.set(
      '${SettingsKeys.selectedCampaign}.${world.id}', campaign.id);
  // The characters section opens as a gallery grid for the store shot.
  await settings.set('${SettingsKeys.listViewMode}.${world.id}|character',
      'grid');

  final guilds = await container.read(categoryRepositoryProvider).create(
      worldId: world.id, name: 'Guilds', icon: 'shield');
  demo.guildCategoryId = guilds.id;
  final guildEntry = (await entities.create(
          worldId: world.id,
          kind: EntityKind.custom,
          customCategoryId: guilds.id,
          name: 'The Lantern Wrights',
          summary: 'Lamp-makers who secretly map the fog'))
      .value;
  demo.byName[guildEntry.name] = guildEntry;

  // Keep the trident referenced so the analyzer sees it used.
  await entities.addTag(trident.id, world.id, 'artifact');

  // ------------------------------------------------------ cyberpunk world
  final cyber = await worlds.createWorld(
      name: 'Neon Ashfall',
      description: 'Chrome above, ash below',
      style: WorldStyle.cyberpunk);
  demo.cyberWorldId = cyber.id;

  final sprawl = await create(cyber.id, EntityKind.location, 'Sector 9',
      'Stacked housing blocks over the old refinery',
      cover: true, neon: true, attributes: {'locationType': 'Region'});
  await create(cyber.id, EntityKind.location, 'The Filament Bar',
      'Every fixer in Ashfall drinks here',
      cover: true, neon: true, attributes: {'locationType': 'Landmark'});
  final syndicate = await create(cyber.id, EntityKind.faction,
      'Kessler-Dyne', 'The corp that owns the weather',
      attributes: {'factionType': 'Company'});
  await create(cyber.id, EntityKind.character, 'Vex',
      'Netrunner with a stolen corporate face',
      cover: true, neon: true, favorite: true, attributes: {
    'race': 'Human',
    'characterClass': 'Netrunner',
    'status': 'Alive',
    'homeLocation': entityRefValue(sprawl.id),
    'factions': [entityRefValue(syndicate.id)],
  });
  await create(cyber.id, EntityKind.character, 'Juno Ashfall-9',
      'Chrome-armed courier who never drops a package',
      cover: true, neon: true, attributes: {
    'race': 'Android',
    'characterClass': 'Courier',
    'status': 'Alive',
  });
  await create(cyber.id, EntityKind.character, 'Mother Static',
      'Cult broadcaster of the dead frequencies',
      cover: true, neon: true, attributes: {
    'race': 'Human',
    'characterClass': 'Icon',
    'status': 'Unknown',
  });
  final op = await create(cyber.id, EntityKind.campaign, 'Operation Blackout',
      'Cut the corp\'s eyes for one night', attributes: {'status': 'Active'});
  await create(cyber.id, EntityKind.quest, 'The Filament Job',
      'Lift the prototype before dawn', attributes: {
    'status': 'Active',
    'campaign': entityRefValue(op.id),
  });
  await settings.set('${SettingsKeys.listViewMode}.${cyber.id}|character',
      'grid');

  // ------------------------------------------- one world per other pack
  for (final style in WorldStyle.values) {
    if (style == WorldStyle.fantasy || style == WorldStyle.cyberpunk) {
      continue;
    }
    final w = await worlds.createWorld(
        name: 'Demo ${style.name}',
        description: 'Setting-pack showcase',
        style: style);
    demo.packWorldIds[style] = w.id;
    final home = await create(w.id, EntityKind.location, 'Haven ${style.name}',
        'Where the story starts', cover: true, attributes: {
      'locationType': 'City',
      'population': '4,200',
    });
    final hero = await create(w.id, EntityKind.character,
        'Hero of ${style.name}', 'Reluctant protagonist',
        cover: true, favorite: true, attributes: {
      'race': 'Human',
      'characterClass': 'Wanderer',
      'status': 'Alive',
      'strength': 12,
      'dexterity': 15,
      'homeLocation': entityRefValue(home.id),
    });
    demo.packCharacterIds[style] = hero.id;
    final beast = await create(w.id, EntityKind.creature,
        'Menace of ${style.name}', 'Something hungry in the dark', attributes: {
      'size': 'Large',
      'creatureType': 'Monster',
      'ac': 14,
      'hp': '52 (8d10 + 8)',
      'challenge': '3 (700 XP)',
      'strength': 17,
      'actions': 'Bite. Melee Attack: +5, reach 5 ft. Hit: 2d6 + 3.',
    });
    demo.packCreatureIds[style] = beast.id;
    final arc = await create(w.id, EntityKind.campaign, 'First Arc',
        'Opening chapter', attributes: {'status': 'Active'});
    await create(w.id, EntityKind.quest, 'The First Job', 'Get paid, stay alive',
        attributes: {'status': 'Active', 'campaign': entityRefValue(arc.id)});
    await create(w.id, EntityKind.magicSystem, 'Signature Power',
        'The genre\'s answer to magic', attributes: {
      'level': '2nd Level',
      'school': 'Evocation',
      'castingTime': '1 action',
      'components': 'V, S',
      'duration': '1 minute',
    });
  }

  return demo;
}
