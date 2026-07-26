// Generates the real-app PNG screenshots embedded in the built-in User
// Guide (assets/help/*.png).
//
// Not part of the normal suite: every test below is skipped unless the
// GMH_SCREENSHOTS environment variable is set, so CI never depends on
// pixel-perfect rendering of a particular host. To regenerate the images:
//
//   GMH_SCREENSHOTS=1 flutter test --update-goldens test/help_screenshots_test.dart
//   cp test/goldens/help/*.png assets/help/
//
// Screenshots are captured with the ENGLISH interface on purpose — one
// set of images serves every app language, while captions and schematic
// figures in the guide stay localized.

import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show FlutterQuillLocalizations;
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme/gmh_theme.dart';
import 'package:gmh/l10n/app_localizations.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/repositories/repositories.dart';
import 'package:path/path.dart' as p;

final _enabled = Platform.environment['GMH_SCREENSHOTS'] == '1';

/// Loads the real Roboto + MaterialIcons fonts from the Flutter SDK cache so
/// screenshots render actual text instead of the Ahem placeholder blocks.
Future<void> _loadRealFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) fail('FLUTTER_ROOT is not set');
  final fontsDir = p.join(
      flutterRoot, 'bin', 'cache', 'artifacts', 'material_fonts');

  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      final bytes = await File(p.join(fontsDir, file)).readAsBytes();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }

  await load('Roboto', [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
    'Roboto-Italic.ttf',
  ]);
  await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
}

class _Demo {
  final AppDatabase db;
  final MediaVault vault;
  final Directory dir;
  late final String worldId;
  final byName = <String, Entity>{};

  _Demo(this.db, this.vault, this.dir);
}

/// Builds a small but lively demo world so every captured screen has
/// realistic content: linked characters, locations, a campaign with
/// quests and sessions, tags and documents.
Future<_Demo> _seedDemoWorld() async {
  final dir = await Directory.systemTemp.createTemp('gmh_screens_');
  final db = AppDatabase(NativeDatabase.memory());
  final demo = _Demo(db, MediaVault(dir.path), dir);

  final container = ProviderContainer(overrides: [
    appRootDirProvider.overrideWithValue(dir.path),
    databaseProvider.overrideWithValue(db),
    mediaVaultProvider.overrideWithValue(demo.vault),
  ]);
  addTearDown(container.dispose);

  final worlds = container.read(worldRepositoryProvider);
  final world = await worlds.createWorld(
      name: 'The Aurion Realms',
      description: 'Realm of ash, salt and amber');
  demo.worldId = world.id;

  final entities = container.read(entityServiceProvider);
  Future<Entity> create(EntityKind kind, String name, String summary,
      [Map<String, Object?> attributes = const {}]) async {
    final result = await entities.create(
        worldId: world.id,
        kind: kind,
        name: name,
        summary: summary,
        attributes: attributes);
    final entity = result.value;
    demo.byName[name] = entity;
    return entity;
  }

  final ravenport = await create(EntityKind.location, 'Ravenport',
      'A grim harbor city under perpetual drizzle', {
    'locationType': 'City',
    'population': '12,400',
    'government': 'Harbor Council',
  });
  final tavern = await create(EntityKind.location, 'The Sunken Bell',
      'Dockside tavern where every rumor is half true', {
    'locationType': 'Landmark',
  });

  final circle = await create(EntityKind.faction, 'The Silver Circle',
      'Secretive order of tide-mages', {'factionType': 'Order'});

  final mira = await create(EntityKind.character, 'Captain Mira Voss',
      'Harbor master of Ravenport, keeps the docks honest', {
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
    'homeLocation': entityRefValue(ravenport.id),
    'factions': [entityRefValue(circle.id)],
  });
  await create(EntityKind.character, 'Old Tom',
      'A fisherman who saw the wyrm and lived', {
    'race': 'Human',
    'characterClass': 'Commoner',
    'status': 'Missing',
    'allies': [entityRefValue(mira.id)],
    'homeLocation': entityRefValue(ravenport.id),
  });
  await create(EntityKind.character, 'Seraphine the Ashen',
      'Exiled pyromancer with a debt to the Circle', {
    'race': 'Tiefling',
    'characterClass': 'Sorcerer',
    'status': 'Alive',
    'rivals': [entityRefValue(mira.id)],
    'factions': [entityRefValue(circle.id)],
  });

  await create(EntityKind.item, 'Tidecaller Trident',
      'Commands the waves; hums near deep water', {
    'itemType': 'Weapon',
    'rarity': 'Legendary',
    'currentOwner': entityRefValue(mira.id),
  });
  await create(EntityKind.creature, 'Harbor Wyrm',
      'Lurks beneath the docks of Ravenport', {
    'creatureType': 'Dragon',
    'challenge': '7',
    'size': 'Huge',
    'habitat': [entityRefValue(ravenport.id)],
  });

  final campaign = await create(EntityKind.campaign,
      'Curse of the Amber Throne', 'The long campaign, season two', {
    'status': 'Active',
  });
  await create(EntityKind.quest, 'The Sunken Bell',
      'Recover the drowned bell before the next storm', {
    'status': 'Active',
    'campaign': entityRefValue(campaign.id),
    'questGiver': entityRefValue(mira.id),
  });
  await create(EntityKind.quest, 'The Missing Fisherman',
      'Find Old Tom — or what is left of him', {
    'status': 'Available',
    'campaign': entityRefValue(campaign.id),
  });
  await create(EntityKind.session, 'Session 12 — The Storm',
      'The party finally met the wyrm', {
    'campaign': entityRefValue(campaign.id),
    'date': '2026-07-12',
  });

  for (final tag in ['harbor', 'ally', 'season-2']) {
    await entities.addTag(mira.id, world.id, tag);
  }
  await entities.addTag(tavern.id, world.id, 'harbor');

  // A short lore document so the entry screen shows real text.
  final documents = container.read(documentServiceProvider);
  final delta = [
    {'insert': 'Ravenport\n', 'attributes': {'header': 2}},
    {
      'insert': 'A grim harbor city where the fog never fully lifts. '
          'The docks belong to '
    },
    {'insert': 'Captain Mira Voss', 'attributes': {'bold': true}},
    {
      'insert': ', the market belongs to the gulls, and the deep water '
          'belongs to something older.\n'
    },
    {'insert': 'Docks quarter — smugglers, rope, salt\n',
        'attributes': {'list': 'bullet'}},
    {'insert': 'Amber market — relics of the old kingdom\n',
        'attributes': {'list': 'bullet'}},
    {'insert': 'The Sunken Bell — where rumors surface first\n',
        'attributes': {'list': 'bullet'}},
  ];
  await documents.save(
      entityId: ravenport.id, contentJson: jsonEncode(delta));

  // The campaigns screen opens on the persisted selection.
  await container
      .read(settingsRepositoryProvider)
      .set('${SettingsKeys.selectedCampaign}.${world.id}', campaign.id);

  return demo;
}

Future<void> _pumpApp(WidgetTester tester, _Demo demo,
    String initialLocation) async {
  // A trimmed GmhApp: the real router, theme and localization stack, but
  // without the nav-history wiring (its delegate listener fires during the
  // very first build under flutter_test and trips Riverpod's build guard).
  await tester.pumpWidget(ProviderScope(
    overrides: [
      appRootDirProvider.overrideWithValue(demo.dir.path),
      databaseProvider.overrideWithValue(demo.db),
      mediaVaultProvider.overrideWithValue(demo.vault),
    ],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: GmhTheme.light(),
      darkTheme: GmhTheme.dark(),
      themeMode: ThemeMode.dark,
      // Screenshots ship in English for every app language.
      locale: const Locale('en'),
      routerConfig: createRouter(initialLocation: initialLocation),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        ...FlutterQuillLocalizations.localizationsDelegates,
      ],
    ),
  ));
  await _settle(tester);
}

/// pumpAndSettle can never finish while tickers (graph simulation) or
/// repeating timers run; real async DB work needs runAsync slices instead.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)));
    await tester.pump(const Duration(milliseconds: 120));
  }
}

Future<void> _capture(WidgetTester tester, String name) async {
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/help/$name.png'),
  );
}

void main() {
  setUpAll(() async {
    if (!_enabled) return;
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadRealFonts();
  });

  Future<void> run(WidgetTester tester, String name,
      String Function(_Demo demo) location,
      {Future<void> Function(WidgetTester, _Demo)? act}) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final demo = await tester.runAsync(_seedDemoWorld) as _Demo;
    addTearDown(() async {
      await demo.db.close();
      if (await demo.dir.exists()) await demo.dir.delete(recursive: true);
    });

    await _pumpApp(tester, demo, location(demo));
    if (act != null) await act(tester, demo);
    await _capture(tester, name);
  }

  testWidgets('shell + characters list', skip: !_enabled, (tester) async {
    await run(tester, 'shell_list',
        (d) => Routes.browse(d.worldId, EntityKind.character));
  });

  testWidgets('entry page with document', skip: !_enabled, (tester) async {
    await run(tester, 'entry',
        (d) => Routes.entity(d.worldId, d.byName['Ravenport']!.id));
  });

  testWidgets('character profile', skip: !_enabled, (tester) async {
    await run(
        tester,
        'profile',
        (d) =>
            Routes.entity(d.worldId, d.byName['Captain Mira Voss']!.id));
  });

  testWidgets('campaign dashboard', skip: !_enabled, (tester) async {
    await run(tester, 'campaigns', (d) => Routes.campaigns(d.worldId));
  });

  testWidgets('search with results', skip: !_enabled, (tester) async {
    await run(tester, 'search', (d) => Routes.search(d.worldId),
        act: (tester, demo) async {
      await tester.enterText(find.byType(TextField).first, 'raven');
      await _settle(tester);
    });
  });

  testWidgets('relationship graph', skip: !_enabled, (tester) async {
    await run(tester, 'graph', (d) => Routes.graph(d.worldId));
  });
}
