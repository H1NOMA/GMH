import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme/gmh_theme.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/repositories/settings_repository_impl.dart';
import 'package:gmh/data/repositories/world_repository_impl.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/l10n/app_localizations.dart';

/// End-to-end widget tests of the sidebar press-and-hold drag reorder:
/// the desktop sidebar must let any tab be dragged up/down within its
/// group, re-render in the new order and persist it across restarts.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Widget shellApp(AppDatabase db, MediaVault vault, String worldId) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        mediaVaultProvider.overrideWithValue(vault),
      ],
      child: MaterialApp.router(
        theme: GmhTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: createRouter(initialLocation: Routes.home(worldId)),
      ),
    );
  }

  Future<(AppDatabase, MediaVault, String)> createWorld() async {
    final db = AppDatabase(NativeDatabase.memory());
    final vault = MediaVault('/nonexistent-test-vault');
    final world =
        await WorldRepositoryImpl(db, vault).createWorld(name: 'Testland');
    return (db, vault, world.id);
  }

  // Bounded pump: pumpAndSettle can hang forever on perpetual animations
  // (e.g. a progress indicator somewhere in the tree).
  Future<void> pumpFrames(WidgetTester tester,
      [int frames = 20,
      Duration step = const Duration(milliseconds: 50)]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(step);
    }
  }

  // Drift schedules zero-duration cleanup Timers when its query streams are
  // cancelled; the tree must be torn down and those timers pumped inside the
  // test body or the binding fails the test with "A Timer is still pending".
  Future<void> tearDownTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  }

  Future<void> dragTile(WidgetTester tester, Finder tile, Offset by) async {
    final gesture = await tester.startGesture(tester.getCenter(tile));
    // ReorderableDelayedDragStartListener arms after a long-press delay.
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    // Move in small steps so the drag recognizer tracks the pointer.
    const steps = 10;
    for (var i = 0; i < steps; i++) {
      await gesture.moveBy(by / steps.toDouble());
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await pumpFrames(tester);
  }

  void useDesktopSize(WidgetTester tester, {double height = 900}) {
    tester.view.physicalSize = Size(1400, height);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('press-and-hold drags a nav tab down and persists the order',
      (tester) async {
    useDesktopSize(tester);
    final (db, vault, worldId) = await createWorld();
    addTearDown(db.close);
    await tester.pumpWidget(shellApp(db, vault, worldId));
    await pumpFrames(tester);

    final search = find.widgetWithText(ListTile, 'Search');
    final graph = find.widgetWithText(ListTile, 'Graph View');
    expect(search, findsOneWidget);
    expect(graph, findsOneWidget);
    expect(tester.getCenter(search).dy, lessThan(tester.getCenter(graph).dy));

    // Drag "Search" down past "Graph" and "Campaigns".
    final tileHeight = tester.getSize(search).height;
    await dragTile(tester, search, Offset(0, tileHeight * 2.2));

    expect(
        tester.getCenter(find.widgetWithText(ListTile, 'Search')).dy,
        greaterThan(
            tester.getCenter(find.widgetWithText(ListTile, 'Graph View')).dy));

    // The drag must persist the new order for this world's nav group.
    final saved =
        await SettingsRepositoryImpl(db).get('sidebarOrder.$worldId.nav');
    expect(saved, isNotNull, reason: 'drag must persist the new nav order');
    final order = (jsonDecode(saved!) as List).cast<String>();
    expect(order.indexOf('search'), greaterThan(order.indexOf('graph')));
    await tearDownTree(tester);
  });

  testWidgets('reordered tabs survive an app restart', (tester) async {
    useDesktopSize(tester);
    final (db, vault, worldId) = await createWorld();
    addTearDown(db.close);
    await tester.pumpWidget(shellApp(db, vault, worldId));
    await pumpFrames(tester);

    final search = find.widgetWithText(ListTile, 'Search');
    final tileHeight = tester.getSize(search).height;
    await dragTile(tester, search, Offset(0, tileHeight * 2.2));

    // Fresh widget tree over the same database = app restart.
    await tearDownTree(tester);
    await tester.pumpWidget(shellApp(db, vault, worldId));
    await pumpFrames(tester);

    expect(
        tester.getCenter(find.widgetWithText(ListTile, 'Search')).dy,
        greaterThan(
            tester.getCenter(find.widgetWithText(ListTile, 'Graph View')).dy));
    await tearDownTree(tester);
  });

  testWidgets('world section tabs (entity kinds) reorder by drag too',
      (tester) async {
    useDesktopSize(tester, height: 1100);
    final (db, vault, worldId) = await createWorld();
    addTearDown(db.close);
    await tester.pumpWidget(shellApp(db, vault, worldId));
    await pumpFrames(tester);

    final characters = find.widgetWithText(ListTile, 'Characters');
    final locations = find.widgetWithText(ListTile, 'Locations');
    expect(characters, findsOneWidget);
    expect(locations, findsOneWidget);
    expect(tester.getCenter(characters).dy,
        lessThan(tester.getCenter(locations).dy));

    final tileHeight = tester.getSize(characters).height;
    await dragTile(tester, characters, Offset(0, tileHeight * 1.4));

    expect(
        tester.getCenter(find.widgetWithText(ListTile, 'Characters')).dy,
        greaterThan(
            tester.getCenter(find.widgetWithText(ListTile, 'Locations')).dy));
    await tearDownTree(tester);
  });
}
