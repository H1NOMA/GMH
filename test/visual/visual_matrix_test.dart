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
import 'package:flutter_test/flutter_test.dart';

import '../support/demo_world.dart';
import '../support/visual_routes.dart';

final _full = Platform.environment['GMH_VISUAL'] == '1';

class _Variant {
  final String name;
  final Size size;
  final ThemeMode theme;
  final Locale locale;
  final double textScale;

  /// null = every route; otherwise only routes whose name passes.
  final bool Function(VisualRoute r)? only;

  const _Variant(
    this.name, {
    required this.size,
    this.theme = ThemeMode.dark,
    this.locale = const Locale('en'),
    this.textScale = 1.0,
    this.only,
  });
}

bool _core(VisualRoute r) =>
    !r.pack &&
    (!r.name.startsWith('browse:') || r.name == 'browse:character');

bool _notPack(VisualRoute r) => !r.pack;

bool _isPack(VisualRoute r) => r.pack;

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
        for (final route in visualRoutes) {
          if (variant.only != null && !variant.only!(route)) continue;
          current = route.name;
          final app = await VisualApp.pump(tester, demo, route.location(demo),
              key: ValueKey('${variant.name}/${route.name}'),
              locale: variant.locale,
              theme: variant.theme);
          final exception = tester.takeException();
          if (exception != null) {
            problems.add('[${route.name}] uncaught: $exception');
          }
          await app.dispose(tester);
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
