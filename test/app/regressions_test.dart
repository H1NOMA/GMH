import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/features/editor/lore_editor.dart';
import 'package:gmh/features/entities/widgets/attribute_form.dart';
import 'package:gmh/features/shell/tab_strip.dart';
import 'package:gmh/features/shell/workspace_tabs.dart';

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

  testWidgets('unreadable lore is snapshotted and salvaged, not overwritten',
      (tester) async {
    final app = await start(tester);
    final e = await entry(app, EntityKind.location, 'Ruins');
    // A retain op is valid Delta JSON but not a valid document.
    const corrupt = '[{"insert":"Old tale\\n"},{"retain":3}]';
    await app.run(() => app.container
        .read(documentServiceProvider)
        .save(entityId: e.id, contentJson: corrupt));
    await app.pump(Routes.entity(worldId, e.id));

    final editor = tester.widget<QuillEditor>(find.byType(QuillEditor));
    expect(editor.controller.document.toPlainText(), contains('Old tale'));
    final versions = await app.run(() async {
      final docs = app.container.read(documentRepositoryProvider);
      final doc = await docs.getOrCreate(e.id);
      return docs.versions(doc.id);
    });
    expect(versions.map((v) => v.contentJson), contains(corrupt));
  });

  testWidgets('an embed without a builder renders as a chip, not an error',
      (tester) async {
    final app = await start(tester);
    final e = await entry(app, EntityKind.location, 'Theatre');
    await app.run(() => app.container.read(documentServiceProvider).save(
        entityId: e.id,
        contentJson: jsonEncode([
          {'insert': 'Show: '},
          {
            'insert': {'video': 'https://example.com/a.mp4'}
          },
          {'insert': '\n'},
        ])));
    await app.pump(Routes.entity(worldId, e.id));
    expect(tester.takeException(), isNull);
    expect(find.text('video'), findsOneWidget);
  });

  testWidgets('tab keys and the tab menu work like a browser', (tester) async {
    final app = await start(tester);
    await app.pump(Routes.home(worldId));
    int tabCount() =>
        app.container.read(workspaceTabsProvider).tabs.length;
    expect(tabCount(), 1);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await app.settle();
    expect(tabCount(), 2);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyW);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await app.settle();
    expect(tabCount(), 1);

    // Right-click the tab: duplicate it from the menu.
    final tab = find.descendant(
        of: find.byType(WorkspaceTabStrip), matching: find.byType(InkWell));
    await tester.tap(tab.first, buttons: kSecondaryButton);
    await app.settle();
    await tester.tap(find.text('Duplicate tab'));
    await app.settle();
    expect(tabCount(), 2);
  });

  testWidgets('a custom field added to a kind shows on its entries',
      (tester) async {
    final app = await start(tester);
    final mira = await entry(app, EntityKind.character, 'Mira');
    await app.pump(Routes.browse(worldId, EntityKind.character));

    await tester.tap(find.byTooltip('Customize fields'));
    await app.settle();
    await tester.tap(find.text('Add field').first);
    await app.settle();
    await tester.enterText(
        find.descendant(
            of: find.byType(AlertDialog), matching: find.byType(TextField))
            .first,
        'Sanity');
    await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Add field')));
    await app.settle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await app.settle();

    await app.go(Routes.entity(worldId, mira.id));
    expect(find.text('Sanity'), findsWidgets);
  });
}
