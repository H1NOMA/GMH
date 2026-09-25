// Generates the 1920x1080 store-page screenshots (marketing/screenshots/)
// used on the itch.io page and in the README.
//
// Like test/help_screenshots_test.dart, this is not part of the normal
// suite — every test is skipped unless GMH_STORE_SHOTS is set:
//
//   GMH_STORE_SHOTS=1 flutter test test/store_screenshots_test.dart
//
// The captures use a richer demo world than the in-app guide: cover art
// on cards, a gallery grid, a full quest board, a bigger graph and a
// second cyberpunk-styled world. English interface (the store page can
// note that the app itself ships in EN/RU/DE/FR/ZH).

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show FlutterQuillLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme/gmh_theme.dart';
import 'package:gmh/features/shell/workspace_tabs.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/l10n/app_localizations.dart';
import 'package:path/path.dart' as p;

import 'support/demo_world.dart';

final _enabled = Platform.environment['GMH_STORE_SHOTS'] == '1';


late GlobalKey _shotKey;

Future<void> _pumpApp(WidgetTester tester, DemoWorld demo, String initialLocation,
    {ThemeMode themeMode = ThemeMode.dark}) async {
  _shotKey = GlobalKey();
  await tester.pumpWidget(ProviderScope(
    overrides: [
      appRootDirProvider.overrideWithValue(demo.dir.path),
      databaseProvider.overrideWithValue(demo.db),
      mediaVaultProvider.overrideWithValue(demo.vault),
    ],
    child: RepaintBoundary(
      key: _shotKey,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: GmhTheme.light(),
        darkTheme: GmhTheme.dark(),
        themeMode: themeMode,
        locale: const Locale('en'),
        routerConfig: createRouter(initialLocation: initialLocation),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          ...FlutterQuillLocalizations.localizationsDelegates,
        ],
      ),
    ),
  ));
  // Seed the workspace tab strip like the real router wiring does: a
  // dashboard tab in the background plus the captured page in front.
  final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)));
  final tabs = container.read(workspaceTabsProvider.notifier);
  final worldMatch = RegExp(r'^/w/([^/]+)/').firstMatch(initialLocation);
  if (worldMatch != null) {
    final home = '/w/${worldMatch.group(1)}/home';
    tabs.onLocationChanged(home);
    if (initialLocation != home) tabs.openInNewTab(initialLocation);
  } else {
    tabs.onLocationChanged(initialLocation);
  }
  await _settle(tester);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)));
    await tester.pump(const Duration(milliseconds: 120));
  }
}

Future<void> _capture(WidgetTester tester, String name) async {
  await tester.runAsync(() async {
    final boundary = _shotKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(p.join('marketing', 'screenshots', '$name.png'));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
  });
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 35));
}

void main() {
  Future<void> run(
    WidgetTester tester,
    String name,
    String Function(DemoWorld demo) location, {
    ThemeMode themeMode = ThemeMode.dark,
    Future<void> Function(WidgetTester, DemoWorld)? act,
  }) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await loadRealFonts(tester);

    final demo = await tester.runAsync(seedRichWorld) as DemoWorld;
    addTearDown(() async {
      await demo.db.close();
      if (await demo.dir.exists()) await demo.dir.delete(recursive: true);
    });

    await _pumpApp(tester, demo, location(demo), themeMode: themeMode);
    if (act != null) await act(tester, demo);
    await _capture(tester, name);
  }

  testWidgets('01 dashboard', skip: !_enabled, (tester) async {
    await run(tester, '01_dashboard', (d) => Routes.home(d.worldId));
  });

  testWidgets('02 characters gallery grid', skip: !_enabled, (tester) async {
    await run(tester, '02_characters_grid',
        (d) => Routes.browse(d.worldId, EntityKind.character));
  });

  testWidgets('03 entry with document', skip: !_enabled, (tester) async {
    await run(tester, '03_entry_document',
        (d) => Routes.entity(d.worldId, d.byName['Ravenport']!.id));
  });

  testWidgets('04 character profile statistics', skip: !_enabled,
      (tester) async {
    await run(
        tester,
        '04_character_profile',
        (d) => Routes.entity(d.worldId, d.byName['Captain Mira Voss']!.id),
        act: (tester, demo) async {
      await tester.tap(find.text('Statistics'));
      await _settle(tester);
    });
  });

  testWidgets('05 campaign dashboard', skip: !_enabled, (tester) async {
    await run(tester, '05_campaigns', (d) => Routes.campaigns(d.worldId));
  });

  testWidgets('06 relationship graph', skip: !_enabled, (tester) async {
    await run(tester, '06_graph', (d) => Routes.graph(d.worldId));
  });

  testWidgets('07 cyberpunk world', skip: !_enabled, (tester) async {
    await run(tester, '07_cyberpunk',
        (d) => Routes.browse(d.cyberWorldId, EntityKind.character));
  });

  testWidgets('08 light theme', skip: !_enabled, (tester) async {
    await run(tester, '08_light_theme',
        (d) => Routes.entity(d.worldId, d.byName['Ravenport']!.id),
        themeMode: ThemeMode.light);
  });

  testWidgets('09 spell card', skip: !_enabled, (tester) async {
    await run(tester, '09_spell_card',
        (d) => Routes.entity(d.worldId, d.byName['Tidebinding']!.id));
  });

  testWidgets('10 monster stat block', skip: !_enabled, (tester) async {
    await run(tester, '10_monster_statblock',
        (d) => Routes.entity(d.worldId, d.byName['Harbor Wyrm']!.id));
  });
}
