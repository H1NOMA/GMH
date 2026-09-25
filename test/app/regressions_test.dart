import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/features/editor/lore_editor.dart';
import 'package:gmh/features/entities/widgets/attribute_form.dart';

import '../support/app_harness.dart';

void main() {
  late String worldId;

  Future<Entity> entry(AppHarness app, EntityKind kind, String name,
      {String? lore}) async {
    final e = (await app.run(() => app.container
            .read(entityServiceProvider)
            .create(worldId: worldId, kind: kind, name: name)))
        .value;
    if (lore != null) {
      await app.run(() => app.container.read(documentServiceProvider).save(
          entityId: e.id,
          contentJson: jsonEncode([
            {'insert': '$lore\n'}
          ])));
    }
    return e;
  }

  Future<AppHarness> start(WidgetTester tester) async {
    final app = await AppHarness.create(tester);
    worldId = (await app.run(() => app.container
            .read(worldRepositoryProvider)
            .createWorld(name: 'Regressions')))
        .id;
    return app;
  }

  testWidgets('moving A -> B never hands A\'s lore to B\'s editor',
      (tester) async {
    final app = await start(tester);
    final a = await entry(app, EntityKind.location, 'Alpha', lore: 'ALPHA-LORE');
    final b = await entry(app, EntityKind.location, 'Beta', lore: 'BETA-LORE');
    await app.pump(Routes.entity(worldId, a.id));
    expect(tester.widget<LoreEditor>(find.byType(LoreEditor)).initialContentJson,
        contains('ALPHA-LORE'));

    await app.go(Routes.entity(worldId, b.id));
    for (final editor in tester.widgetList<LoreEditor>(find.byType(LoreEditor))) {
      expect(editor.entityId, b.id);
      expect(editor.initialContentJson, isNot(contains('ALPHA-LORE')));
    }
    final doc = await app.run(
        () => app.container.read(documentRepositoryProvider).getOrCreate(b.id));
    expect(doc.contentJson, contains('BETA-LORE'));
  });

  testWidgets('Escape closes an open popup menu instead of pausing',
      (tester) async {
    final app = await start(tester);
    final a = await entry(app, EntityKind.character, 'Mira');
    await app.pump(Routes.entity(worldId, a.id));
    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await app.settle();
    expect(find.byType(PopupMenuItem<String>), findsWidgets);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await app.settle();
    expect(find.byType(PopupMenuItem<String>), findsNothing);
    expect(find.text("Game Master's Hub"), findsNothing,
        reason: 'the pause menu must not open while a popup is open');
  });

  testWidgets('a field typed into is saved when leaving with Ctrl+K',
      (tester) async {
    final app = await start(tester);
    final item = await entry(app, EntityKind.item, 'Blade');
    await app.pump(Routes.entity(worldId, item.id));
    final weight = find.widgetWithText(TextField, 'Weight');
    expect(weight, findsOneWidget);
    await tester.enterText(weight, '4 lb.');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await app.settle();
    final saved = await app.run(
        () => app.container.read(entityRepositoryProvider).getEntity(item.id));
    expect(saved!.attributes['weight'], '4 lb.');
  });

  test('number fields accept a decimal comma and reject typos', () {
    expect(parseFieldNumber('2,5'), 2.5);
    expect(parseFieldNumber(' 1 200 '), 1200);
    expect(parseFieldNumber(''), isNull);
    expect(parseFieldNumber('12a'), isNull);
  });
}
