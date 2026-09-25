// Pumps the real GmhApp (router, shell, tabs, shortcuts) over an in-memory
// database for interaction tests.

import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/app.dart';
import 'package:gmh/app/locale_provider.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:go_router/go_router.dart';

class AppHarness {
  final WidgetTester tester;
  final ProviderContainer container;
  final AppDatabase db;
  final Directory dir;

  AppHarness._(this.tester, this.container, this.db, this.dir);

  /// Creates the container and database. Seed data with [run] before
  /// calling [pump].
  static Future<AppHarness> create(WidgetTester tester,
      {Size size = const Size(1280, 800)}) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final dir = Directory.systemTemp.createTempSync('gmh_app_');
    final db = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appRootDirProvider.overrideWithValue(dir.path),
      databaseProvider.overrideWithValue(db),
      mediaVaultProvider.overrideWithValue(MediaVault(dir.path)),
    ]);
    container.read(localeControllerProvider.notifier).seed(const Locale('en'));
    final harness = AppHarness._(tester, container, db, dir);
    addTearDown(harness._dispose);
    return harness;
  }

  /// Runs real async work (database writes) outside the fake clock.
  Future<T> run<T>(Future<T> Function() body) async =>
      (await tester.runAsync(body)) as T;

  Future<void> pump(String initialLocation) async {
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: GmhApp(initialLocation: initialLocation),
    ));
    await settle();
  }

  /// Drift streams resolve on real async: interleave real delays with
  /// frames instead of pumpAndSettle (which would never settle).
  Future<void> settle([int rounds = 10]) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 60));
    }
  }

  /// Navigates the way in-content links do (same tab).
  Future<void> go(String location) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(location);
    await settle();
  }

  Future<void> _dispose() async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
    await tester.runAsync(() async {
      container.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  }
}
