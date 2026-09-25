import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/world_object.dart';

import '../support/app_harness.dart';

void main() {
  Future<void> createWorld(AppHarness app, WidgetTester tester,
      {required bool starter}) async {
    await app.pump(Routes.worlds());
    await tester.tap(find.text('Create New World'));
    await app.settle();
    await tester.enterText(find.byType(TextField).first, 'Fresh World');
    if (!starter) {
      await tester.ensureVisible(find.byType(Switch));
      await app.settle();
      await tester.tap(find.byType(Switch));
      await app.settle();
    }
    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await app.settle(30);
  }

  testWidgets('a new world starts with example content', (tester) async {
    final app = await AppHarness.create(tester);
    await createWorld(app, tester, starter: true);
    final world = (await app.run(
            () => app.container.read(worldRepositoryProvider).watchWorlds().first))
        .single;
    final entries = await app.run(() =>
        app.container.read(entityRepositoryProvider).getAllEntities(world.id));
    expect(entries.length, 9);
    final tables = await app.run(() => app.container
        .read(worldObjectRepositoryProvider)
        .list(world.id, WorldObjectTypes.randomTable));
    expect(tables, isNotEmpty);
  });

  testWidgets('or empty, when the switch is off', (tester) async {
    final app = await AppHarness.create(tester);
    await createWorld(app, tester, starter: false);
    final world = (await app.run(
            () => app.container.read(worldRepositoryProvider).watchWorlds().first))
        .single;
    final entries = await app.run(() =>
        app.container.read(entityRepositoryProvider).getAllEntities(world.id));
    expect(entries, isEmpty);
  });
}
