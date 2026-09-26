// Every screen of the app as a route over the demo world, shared by the
// visual matrix (framework errors) and the alignment audit (geometry).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/app.dart';
import 'package:gmh/app/locale_provider.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme_provider.dart';
import 'package:gmh/app/tools.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world.dart';

import 'demo_world.dart';

class VisualRoute {
  final String name;
  final String Function(DemoWorld d) location;

  /// Routes that live in the cyberpunk world (styled variants).
  final bool cyber;

  /// Routes in the per-pack showcase worlds.
  final bool pack;
  const VisualRoute(this.name, this.location,
      {this.cyber = false, this.pack = false});
}

String _e(DemoWorld d, String name) => Routes.entity(
    name.startsWith('cyber:') ? d.cyberWorldId : d.worldId,
    d.byName[name.replaceFirst('cyber:', '')]!.id);

final visualRoutes = <VisualRoute>[
  VisualRoute('worlds', (d) => Routes.worlds()),
  VisualRoute('home', (d) => Routes.home(d.worldId)),
  for (final kind in [
    ...EntityKind.worldKinds,
    ...EntityKind.libraryKinds,
  ])
    VisualRoute('browse:${kind.name}', (d) => Routes.browse(d.worldId, kind)),
  VisualRoute(
      'category', (d) => Routes.browseCategory(d.worldId, d.guildCategoryId)),
  VisualRoute('e:location', (d) => _e(d, 'Ravenport')),
  VisualRoute('e:character', (d) => _e(d, 'Captain Mira Voss')),
  VisualRoute('e:creature', (d) => _e(d, 'Harbor Wyrm')),
  VisualRoute('e:spell', (d) => _e(d, 'Tidebinding')),
  VisualRoute('e:item', (d) => _e(d, 'Lantern of True Names')),
  VisualRoute('e:faction', (d) => _e(d, 'Harbor Council')),
  VisualRoute('e:event', (d) => _e(d, 'The Night of Amber Rain')),
  VisualRoute('e:campaign', (d) => _e(d, 'Curse of the Amber Throne')),
  VisualRoute('e:custom', (d) => _e(d, 'The Lantern Wrights')),
  VisualRoute('search', (d) => Routes.search(d.worldId)),
  VisualRoute('graph', (d) => Routes.graph(d.worldId)),
  VisualRoute('graph:local',
      (d) => Routes.graph(d.worldId, focusEntityId: d.byName['Ravenport']!.id)),
  VisualRoute('campaigns', (d) => Routes.campaigns(d.worldId)),
  VisualRoute('settings', (d) => Routes.settings(d.worldId)),
  VisualRoute('help', (d) => Routes.help(d.worldId)),
  VisualRoute('trash', (d) => Routes.trash(d.worldId)),
  VisualRoute('map', (d) => Routes.tool(d.worldId, 'maps', d.mapId)),
  VisualRoute('encounter',
      (d) => Routes.tool(d.worldId, 'combat', d.encounterId)),
  VisualRoute(
      'table', (d) => Routes.tool(d.worldId, 'tables', d.tableId)),
  VisualRoute(
      'tables-library', (d) => Routes.tool(d.worldId, 'tables', 'library')),
  VisualRoute('tools', (d) => Routes.tools(d.worldId)),
  for (final tool in gmhTools)
    VisualRoute('tool:${tool.id}', (d) => Routes.tool(d.worldId, tool.id)),
  VisualRoute('unknown-route', (d) => '/w/${d.worldId}/no-such-page'),
  // Cyberpunk world: same screens, different palette + vocabulary.
  VisualRoute('cyber:home', (d) => Routes.home(d.cyberWorldId), cyber: true),
  VisualRoute('cyber:browse:character',
      (d) => Routes.browse(d.cyberWorldId, EntityKind.character),
      cyber: true),
  VisualRoute('cyber:e:character', (d) => _e(d, 'cyber:Vex'), cyber: true),
  VisualRoute('cyber:campaigns', (d) => Routes.campaigns(d.cyberWorldId),
      cyber: true),
  // Every other setting pack: dashboard, a re-skinned list, a character
  // page and a creature stat block in the pack's palette and vocabulary.
  for (final style in WorldStyle.values)
    if (style != WorldStyle.fantasy && style != WorldStyle.cyberpunk) ...[
      VisualRoute('pack:${style.name}:home',
          (d) => Routes.home(d.packWorldIds[style]!), pack: true),
      VisualRoute('pack:${style.name}:browse',
          (d) => Routes.browse(d.packWorldIds[style]!, EntityKind.character),
          pack: true),
      VisualRoute('pack:${style.name}:e:character',
          (d) => Routes.entity(
              d.packWorldIds[style]!, d.packCharacterIds[style]!),
          pack: true),
      VisualRoute('pack:${style.name}:e:creature',
          (d) => Routes.entity(
              d.packWorldIds[style]!, d.packCreatureIds[style]!),
          pack: true),
    ],
];

/// Pumps / settles / disposes the real app over the demo world.
class VisualApp {
  final ProviderContainer container;
  VisualApp._(this.container);

  static Future<VisualApp> pump(
    WidgetTester tester,
    DemoWorld demo,
    String location, {
    required Key key,
    Locale locale = const Locale('en'),
    ThemeMode theme = ThemeMode.dark,
    GlobalKey? boundaryKey,
  }) async {
    final container = ProviderContainer(overrides: [
      appRootDirProvider.overrideWithValue(demo.dir.path),
      databaseProvider.overrideWithValue(demo.db),
      mediaVaultProvider.overrideWithValue(demo.vault),
    ]);
    container.read(localeControllerProvider.notifier).seed(locale);
    container.read(themeModeProvider.notifier).seed(theme);
    Widget app = GmhApp(key: key, initialLocation: location);
    if (boundaryKey != null) {
      app = RepaintBoundary(key: boundaryKey, child: app);
    }
    await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: app));
    await settleVisual(tester);
    return VisualApp._(container);
  }

  /// Tears the app down and flushes debouncers / animation timers so the
  /// next screen starts clean and no timer outlives the test.
  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
    // Disposing closes drift query streams, which schedules zero-length
    // timers: do it on the real event loop so they fire there instead of
    // lingering as fake-async timers.
    await tester.runAsync(() async {
      container.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
  }
}

Future<void> settleVisual(WidgetTester tester, [int rounds = 10]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 40)));
    await tester.pump(const Duration(milliseconds: 100));
  }
}
