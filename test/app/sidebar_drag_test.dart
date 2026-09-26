// Dragging a sidebar tile rebuilds it in the root overlay, outside any
// route: a tile reading the router state there threw, and release builds
// painted the error as a blank box over the sidebar.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme/gmh_theme.dart';

import '../support/demo_world.dart';
import '../support/visual_routes.dart';

void main() {
  testWidgets('every sidebar group drags without errors', (tester) async {
    tester.view.physicalSize = const Size(1280, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await loadRealFonts(tester);
    final demo = (await tester.runAsync(seedRichWorld))!;
    addTearDown(() async {
      await demo.db.close();
      if (await demo.dir.exists()) await demo.dir.delete(recursive: true);
    });

    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    GmhTheme.clearCache();
    try {
      final app = await VisualApp.pump(
          tester, demo, Routes.home(demo.worldId),
          key: const ValueKey('sidebar-drag'));
      final groups = find.byType(ReorderableListView);
      final count = groups.evaluate().length;
      expect(count, greaterThanOrEqualTo(4));
      for (var i = 0; i < count; i++) {
        final tile = find
            .descendant(of: groups.at(i), matching: find.byType(ListTile))
            .first;
        final gesture = await tester.startGesture(tester.getCenter(tile),
            kind: PointerDeviceKind.mouse);
        await tester.pump(const Duration(milliseconds: 600));
        for (var step = 0; step < 4; step++) {
          await gesture.moveBy(const Offset(0, 10));
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(tester.takeException(), isNull, reason: 'group $i');
        await gesture.moveBy(const Offset(0, -40));
        await gesture.up();
        await settleVisual(tester, 4);
        expect(tester.takeException(), isNull, reason: 'group $i drop');
      }
      await app.dispose(tester);
    } finally {
      debugDefaultTargetPlatformOverride = null;
      GmhTheme.clearCache();
    }
  });
}
