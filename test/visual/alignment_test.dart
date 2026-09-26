// Alignment audit: pumps the real app on every route and on the dialog /
// panel / error states listed in scenarios/, then checks that controls
// sharing a row line up — an input and its buttons share top and height,
// buttons and chips share a center line, single-line labels sit on the
// center of the control beside them (see support/alignment_probe.dart).
//
// Runs as a phone (Android density, padded tap targets) and as a desktop
// window (Windows density). Hard misalignments fail the test.
//
//   GMH_ALIGN_FULL=1        also Russian desktop and a phone at text x1.3
//   GMH_ALIGN_ONLY=<regex>  only routes/scenarios whose name matches
//   GMH_ALIGN_SHOTS=<dir>   PNG per screen; *.marked.png outlines issues
//   GMH_ALIGN_REPORT=<file> JSON with every issue, soft ones included
//
//   GMH_ALIGN_SHOTS=build/align flutter test test/visual/alignment_test.dart

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/theme/gmh_theme.dart';
import 'package:path/path.dart' as p;

import '../support/alignment_probe.dart';
import '../support/demo_world.dart';
import '../support/visual_routes.dart';
import 'scenarios/atlas_scenarios.dart';
import 'scenarios/content_scenarios.dart';
import 'scenarios/entries_scenarios.dart';
import 'scenarios/play_scenarios.dart';
import 'scenarios/scenario.dart';
import 'scenarios/shell_scenarios.dart';
import 'scenarios/worlds_scenarios.dart';

final _env = Platform.environment;
final _full = _env['GMH_ALIGN_FULL'] == '1';
final _only = _env['GMH_ALIGN_ONLY'] == null
    ? null
    : RegExp(_env['GMH_ALIGN_ONLY']!);
final _shots = _env['GMH_ALIGN_SHOTS'];
final _report = _env['GMH_ALIGN_REPORT'];

class _Variant {
  final String name;
  final Size size;
  final TargetPlatform platform;
  final Locale locale;
  final double textScale;

  const _Variant(this.name,
      {required this.size,
      required this.platform,
      this.locale = const Locale('en'),
      this.textScale = 1.0});
}

final _variants = <_Variant>[
  const _Variant('phone',
      size: Size(400, 800), platform: TargetPlatform.android),
  const _Variant('desktop',
      size: Size(1280, 800), platform: TargetPlatform.windows),
  if (_full) ...[
    const _Variant('desktop-ru',
        size: Size(1024, 700),
        platform: TargetPlatform.windows,
        locale: Locale('ru')),
    const _Variant('phone-x1.3',
        size: Size(400, 800),
        platform: TargetPlatform.android,
        textScale: 1.3),
  ],
];

final _screens = <AlignScenario>[
  for (final route in visualRoutes)
    if (!route.pack && !route.cyber)
      AlignScenario(route.name, route.location, (tester, d) async {}),
  ...playScenarios,
  ...contentScenarios,
  ...atlasScenarios,
  ...entriesScenarios,
  ...worldsScenarios,
  ...shellScenarios,
];

String _fileName(String variant, String screen) =>
    '${variant}__${screen.replaceAll(RegExp(r'[^A-Za-z0-9_.-]+'), '_')}';

Future<void> _capture(WidgetTester tester, GlobalKey boundaryKey,
    String name, List<AlignIssue> issues) async {
  await tester.runAsync(() async {
    final boundary = boundaryKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final image = await boundary.toImage();
    Future<void> write(ui.Image img, String file) async {
      final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      final out = File(p.join(_shots!, file));
      await out.parent.create(recursive: true);
      await out.writeAsBytes(bytes!.buffer.asUint8List());
    }

    await write(image, '$name.png');
    if (issues.isEmpty) return;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImage(image, Offset.zero, Paint());
    for (final issue in issues) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = issue.hard ? const Color(0xFFFF2D2D) : const Color(0xFFFFA000);
      canvas.drawRect(issue.a.rect.inflate(1.5), paint);
      canvas.drawRect(issue.b.rect.inflate(1.5), paint);
    }
    final marked = await recorder
        .endRecording()
        .toImage(image.width, image.height);
    await write(marked, '$name.marked.png');
  });
}

void main() {
  final report = <Map<String, Object?>>[];

  tearDownAll(() async {
    final path = _report;
    if (path == null) return;
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(report));
  });

  for (final variant in _variants) {
    testWidgets('alignment · ${variant.name}', (tester) async {
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

      final hard = <String>[];
      debugDefaultTargetPlatformOverride = variant.platform;
      GmhTheme.clearCache();
      try {
        final only = _only;
        for (final screen in _screens) {
          if (only != null && !only.hasMatch(screen.name)) continue;
          final boundaryKey = GlobalKey();
          final app = await VisualApp.pump(
              tester, demo, screen.location(demo),
              key: ValueKey('${variant.name}/${screen.name}'),
              locale: variant.locale,
              boundaryKey: boundaryKey);
          await screen.act(tester, demo);
          final issues = probeAlignment(tester);
          for (final issue in issues) {
            report.add({
              'variant': variant.name,
              'screen': screen.name,
              ...issue.toJson(),
            });
            if (issue.hard) hard.add('[${screen.name}] $issue');
          }
          if (_shots != null) {
            await _capture(tester, boundaryKey,
                _fileName(variant.name, screen.name), issues);
          }
          await app.dispose(tester);
        }
      } finally {
        debugDefaultTargetPlatformOverride = null;
        GmhTheme.clearCache();
      }
      expect(hard, isEmpty,
          reason: 'misaligned controls on ${variant.name}:\n'
              '${hard.join('\n')}');
    }, timeout: const Timeout(Duration(minutes: 30)));
  }
}
