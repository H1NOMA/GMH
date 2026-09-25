import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/repositories/repositories.dart';

import '../../support/app_harness.dart';

void main() {
  late String worldId;

  Future<AppHarness> start(WidgetTester tester) async {
    final app = await AppHarness.create(tester);
    worldId = (await app.run(() => app.container
            .read(worldRepositoryProvider)
            .createWorld(name: 'History')))
        .id;
    return app;
  }

  Future<Entity> entry(AppHarness app, EntityKind kind, String name,
          [Map<String, Object?> attributes = const {}]) async =>
      (await app.run(() => app.container.read(entityServiceProvider).create(
              worldId: worldId,
              kind: kind,
              name: name,
              attributes: attributes)))
          .value;

  Future<List<Entity>> events(AppHarness app) => app.run(() => app.container
      .read(entityRepositoryProvider)
      .watchEntities(worldId, kind: EntityKind.event, sort: EntitySort.nameAsc)
      .first);

  testWidgets('shows eras with their events, in order', (tester) async {
    final app = await start(tester);
    await entry(app, EntityKind.era, 'Age of Ash',
        {'startDate': '1000', 'endDate': '1400'});
    await entry(app, EntityKind.event, 'The Fall', {'date': 'Year 1200'});
    await entry(app, EntityKind.event, 'The Dawn', {'date': '1100'});
    await entry(app, EntityKind.event, 'The Myth');
    await app.pump(Routes.tool(worldId, 'timeline'));

    expect(find.text('Age of Ash'), findsWidgets);
    final dawn = tester.getTopLeft(find.text('The Dawn')).dy;
    final fall = tester.getTopLeft(find.text('The Fall')).dy;
    expect(dawn, lessThan(fall));
    expect(find.text('Undated'), findsOneWidget);
    expect(find.text('The Myth'), findsOneWidget);
  });

  testWidgets('new event, set a date, custom calendar', (tester) async {
    final app = await start(tester);
    await entry(app, EntityKind.event, 'The Myth');
    await app.pump(Routes.tool(worldId, 'timeline'));

    // Date the undated event.
    await tester.tap(find.text('Set date').first);
    await app.settle();
    await tester.enterText(find.byType(TextField).last, '300 BC');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await app.settle();
    expect((await events(app)).single.attributes['date'], '300 BC');
    expect(find.text('Undated'), findsNothing);
    expect(find.text('-300'), findsOneWidget);

    // A new event with a date (opens its page).
    await tester.tap(find.text('New event'));
    await app.settle();
    final fields = find.descendant(
        of: find.byType(AlertDialog), matching: find.byType(TextField));
    await tester.enterText(fields.first, 'The Crowning');
    await tester.enterText(fields.last, '1492');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await app.settle();
    final names = [for (final e in await events(app)) e.name];
    expect(names, contains('The Crowning'));

    // A custom calendar renames months and adds a suffix.
    await app.go(Routes.tool(worldId, 'timeline'));
    await tester.tap(find.byTooltip('Calendar'));
    await app.settle();
    final calendarFields = find.descendant(
        of: find.byType(AlertDialog), matching: find.byType(TextField));
    await tester.enterText(calendarFields.first, 'Hammer: 30\nFrostmoon: 30');
    await tester.enterText(calendarFields.last, 'DR');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await app.settle();
    final calendars = await app.run(() => app.container
        .read(worldObjectRepositoryProvider)
        .list(worldId, WorldObjectTypes.calendar));
    expect(calendars.single.data['yearSuffix'], 'DR');
    expect(find.text('1492 DR'), findsOneWidget);
  });
}
