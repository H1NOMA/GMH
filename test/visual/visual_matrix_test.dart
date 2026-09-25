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
import 'package:gmh/domain/models/entity_kind.dart';

import '../support/demo_world.dart';

final _full = Platform.environment['GMH_VISUAL'] == '1';

class _Route {
  final String name;
  final String Function(DemoWorld d) location;

  /// Routes that live in the cyberpunk world (styled variants).
  final bool cyber;
  const _Route(this.name, this.location, {this.cyber = false});
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
  // Cyberpunk world: same screens, different palette + vocabulary.
  _Route('cyber:home', (d) => Routes.home(d.cyberWorldId), cyber: true),
  _Route('cyber:browse:character',
      (d) => Routes.browse(d.cyberWorldId, EntityKind.character),
      cyber: true),
  _Route('cyber:e:character', (d) => _e(d, 'cyber:Vex'), cyber: true),
  _Route('cyber:campaigns', (d) => Routes.campaigns(d.cyberWorldId),
      cyber: true),
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
    !r.name.startsWith('browse:') || r.name == 'browse:character';

final _variants = <_Variant>[
  const _Variant('1280x720 dark en', size: Size(1280, 720)),
  if (_full) ...[
    const _Variant('1920x1080 dark en', size: Size(1920, 1080)),
    const _Variant('2560x1440 dark en', size: Size(2560, 1440), only: _core),
    const _Variant('1024x640 dark en', size: Size(1024, 640)),
    const _Variant('900x600 rail en', size: Size(900, 600)),
    const _Variant('400x780 phone en', size: Size(400, 780)),
    const _Variant('1280x720 light en',
        size: Size(1280, 720), theme: ThemeMode.light),
    const _Variant('1024x640 de', size: Size(1024, 640), locale: Locale('de')),
    const _Variant('1024x640 ru', size: Size(1024, 640), locale: Locale('ru')),
    const _Variant('1024x640 fr', size: Size(1024, 640), locale: Locale('fr')),
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
          container.dispose();
          // Disposing closes drift query streams, which schedules
          // zero-length timers — let them fire.
          await tester.pump();
        }
      } finally {
        FlutterError.onError = previous;
      }
      expect(problems, isEmpty,
          reason: 'visual problems in "${variant.name}":\n'
              '${problems.join('\n')}');
    }, timeout: const Timeout(Duration(minutes: 10)));
  }
}
