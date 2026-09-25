// Visual smoke matrix: pumps the REAL app (GmhApp: router, shell, tabs,
// theme and locale wiring) on every route and fails on any framework error
// the frame produced — RenderFlex overflows, unbounded constraints, build
// exceptions, missing localizations.
//
// Real Roboto metrics are loaded so overflow detection matches production
// (the default test font renders every glyph 1em wide and would flag
// false positives everywhere).
//
// Two modes:
//  * default — one representative configuration (1280x720, dark, English);
//    runs with the normal suite as a regression net;
//  * GMH_VISUAL=1 — the full matrix: window sizes from phone to 1440p,
//    light/dark, fantasy + cyberpunk worlds, the longest-string locales
//    and a raised text scale.
//
//   GMH_VISUAL=1 flutter test test/visual/visual_matrix_test.dart

import 'dart:io';

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

import '../support/demo_world.dart';

final _full = Platform.environment['GMH_VISUAL'] == '1';

class _Route {
  final String name;
  final String Function(DemoWorld d) location;

  /// Routes that live in the cyberpunk world (styled variants).
  final bool cyber;

  /// Routes in the per-pack showcase worlds (full matrix only).
  final bool pack;
  const _Route(this.name, this.location,
      {this.cyber = false, this.pack = false});
}

String _e(DemoWorld d, String name) => Routes.entity(
    name.startsWith('cyber:') ? d.cyberWorldId : d.worldId,
    d.byName[name.replaceFirst('cyber:', '')]!.id);

final _routes = <_Route>[
  _Route('worlds', (d) => Routes.worlds()),
  _Route('home', (d) => Routes.home(d.worldId)),
  for (final kind in [
    ...EntityKind.worldKinds,
    ...EntityKind.libraryKinds,
  ])
    _Route('browse:${kind.name}', (d) => Routes.browse(d.worldId, kind)),
  _Route('category', (d) => Routes.browseCategory(d.worldId, d.guildCategoryId)),
  _Route('e:location', (d) => _e(d, 'Ravenport')),
  _Route('e:character', (d) => _e(d, 'Captain Mira Voss')),
  _Route('e:creature', (d) => _e(d, 'Harbor Wyrm')),
  _Route('e:spell', (d) => _e(d, 'Tidebinding')),
  _Route('e:item', (d) => _e(d, 'Lantern of True Names')),
  _Route('e:faction', (d) => _e(d, 'Harbor Council')),
  _Route('e:event', (d) => _e(d, 'The Night of Amber Rain')),
  _Route('e:campaign', (d) => _e(d, 'Curse of the Amber Throne')),
  _Route('e:custom', (d) => _e(d, 'The Lantern Wrights')),
  _Route('search', (d) => Routes.search(d.worldId)),
  _Route('graph', (d) => Routes.graph(d.worldId)),
  _Route('graph:local',
      (d) => Routes.graph(d.worldId, focusEntityId: d.byName['Ravenport']!.id)),
  _Route('campaigns', (d) => Routes.campaigns(d.worldId)),
  _Route('settings', (d) => Routes.settings(d.worldId)),
  _Route('help', (d) => Routes.help(d.worldId)),
  _Route('tools', (d) => Routes.tools(d.worldId)),
  for (final tool in gmhTools)
    _Route('tool:${tool.id}', (d) => Routes.tool(d.worldId, tool.id)),
  _Route('unknown-route', (d) => '/w/${d.worldId}/no-such-page'),
  // Cyberpunk world: same screens, different palette + vocabulary.
  _Route('cyber:home', (d) => Routes.home(d.cyberWorldId), cyber: true),
  _Route('cyber:browse:character',
      (d) => Routes.browse(d.cyberWorldId, EntityKind.character),
      cyber: true),
  _Route('cyber:e:character', (d) => _e(d, 'cyber:Vex'), cyber: true),
  _Route('cyber:campaigns', (d) => Routes.campaigns(d.cyberWorldId),
      cyber: true),
  // Every other setting pack: dashboard, a re-skinned list, a character
  // page and a creature stat block in the pack's palette and vocabulary.
  for (final style in WorldStyle.values)
    if (style != WorldStyle.fantasy && style != WorldStyle.cyberpunk) ...[
      _Route('pack:${style.name}:home',
          (d) => Routes.home(d.packWorldIds[style]!), pack: true),
      _Route('pack:${style.name}:browse',
          (d) => Routes.browse(d.packWorldIds[style]!, EntityKind.character),
          pack: true),
      _Route('pack:${style.name}:e:character',
          (d) => Routes.entity(
              d.packWorldIds[style]!, d.packCharacterIds[style]!),
          pack: true),
      _Route('pack:${style.name}:e:creature',
          (d) => Routes.entity(
              d.packWorldIds[style]!, d.packCreatureIds[style]!),
          pack: true),
    ],
];

class _Variant {
  final String name;
  final Size size;
  final ThemeMode theme;
  final Locale locale;
  final double textScale;

  /// null = every route; otherwise only routes whose name passes.
  final bool Function(_Route r)? only;

  const _Variant(
    this.name, {
    required this.size,
    this.theme = ThemeMode.dark,
    this.locale = const Locale('en'),
    this.textScale = 1.0,
    this.only,
  });
}

bool _core(_Route r) =>
    !r.pack &&
    (!r.name.startsWith('browse:') || r.name == 'browse:character');

bool _notPack(_Route r) => !r.pack;

bool _isPack(_Route r) => r.pack;

final _variants = <_Variant>[
  const _Variant('1280x720 dark en', size: Size(1280, 720), only: _notPack),
  if (_full) ...[
    const _Variant('1280x720 packs dark', size: Size(1280, 720),
        only: _isPack),
    const _Variant('1280x720 packs light',
        size: Size(1280, 720), theme: ThemeMode.light, only: _isPack),
    const _Variant('1024x640 packs ru',
        size: Size(1024, 640), locale: Locale('ru'), only: _isPack),
    const _Variant('1024x640 packs de',
        size: Size(1024, 640), locale: Locale('de'), only: _isPack),
    const _Variant('1024x640 zh', size: Size(1024, 640),
        locale: Locale('zh'), only: _notPack),
    const _Variant('400x780 phone zh',
        size: Size(400, 780), locale: Locale('zh'), only: _core),
    const _Variant('1920x1080 dark en', size: Size(1920, 1080), only: _notPack),
    const _Variant('2560x1440 dark en', size: Size(2560, 1440), only: _core),
    const _Variant('1024x640 dark en', size: Size(1024, 640), only: _notPack),
    const _Variant('900x600 rail en', size: Size(900, 600), only: _notPack),
    const _Variant('400x780 phone en', size: Size(400, 780), only: _notPack),
    const _Variant('1280x720 light en',
        size: Size(1280, 720), theme: ThemeMode.light, only: _notPack),
    const _Variant('1024x640 de', size: Size(1024, 640), locale: Locale('de'), only: _notPack),
    const _Variant('1024x640 ru', size: Size(1024, 640), locale: Locale('ru'), only: _notPack),
    const _Variant('1024x640 fr', size: Size(1024, 640), locale: Locale('fr'), only: _notPack),
    const _Variant('400x780 phone de',
        size: Size(400, 780), locale: Locale('de'), only: _core),
    const _Variant('1280x720 text x1.3',
        size: Size(1280, 720), textScale: 1.3, only: _core),
    const _Variant('900x600 light ru',
        size: Size(900, 600),
        theme: ThemeMode.light,
        locale: Locale('ru'),
        only: _core),
  ],
];

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 40)));
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  for (final variant in _variants) {
    testWidgets('visual matrix · ${variant.name}', (tester) async {
      tester.view.physicalSize = variant.size;
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = variant.textScale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await loadRealFonts(tester);

      final demo = (await tester.runAsync(seedRichWorld))!;
      addTearDown(() async {
        await demo.db.close();
        if (await demo.dir.exists()) await demo.dir.delete(recursive: true);
      });

      final problems = <String>[];
      final previous = FlutterError.onError;
      String current = '';
      FlutterError.onError = (details) {
        final summary = details.exceptionAsString().split('\n').first;
        final where = details.context?.toDescription() ?? '';
        problems.add('[$current] $summary ${where.isEmpty ? '' : '($where)'}');
      };
      try {
        for (final route in _routes) {
          if (variant.only != null && !variant.only!(route)) continue;
          current = route.name;
          final container = ProviderContainer(overrides: [
            appRootDirProvider.overrideWithValue(demo.dir.path),
            databaseProvider.overrideWithValue(demo.db),
            mediaVaultProvider.overrideWithValue(demo.vault),
          ]);
          container.read(localeControllerProvider.notifier).seed(variant.locale);
          container.read(themeModeProvider.notifier).seed(variant.theme);
          await tester.pumpWidget(UncontrolledProviderScope(
            container: container,
            child: GmhApp(
              key: ValueKey('${variant.name}/${route.name}'),
              initialLocation: route.location(demo),
            ),
          ));
          await _settle(tester);
          final exception = tester.takeException();
          if (exception != null) {
            problems.add('[${route.name}] uncaught: $exception');
          }
          // Tear the app down and flush debouncers / animation timers so
          // the next route starts clean and no timer outlives the test.
          await tester.pumpWidget(const SizedBox());
          await tester.pump(const Duration(seconds: 5));
          // Disposing closes drift query streams, which schedules
          // zero-length timers: do it on the real event loop so they fire
          // there instead of lingering as fake-async timers.
          await tester.runAsync(() async {
            container.dispose();
            await Future<void>.delayed(const Duration(milliseconds: 20));
          });
        }
      } finally {
        FlutterError.onError = previous;
      }
      expect(problems, isEmpty,
          reason: 'visual problems in "${variant.name}":\n'
              '${problems.join('\n')}');
    }, timeout: const Timeout(Duration(minutes: 30)));
  }
}
