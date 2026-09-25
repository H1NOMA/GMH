import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/gm_screen/gm_screen_state.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/reference/conditions.dart';
import 'package:gmh/domain/reference/rules_reference.dart';

import '../../support/app_harness.dart';

void main() {
  test('every condition has rules text in every language', () {
    for (final c in srdConditions) {
      final texts = conditionRules[c.id];
      expect(texts, isNotNull, reason: c.id);
      for (final lang in ['en', 'ru', 'de', 'fr', 'zh']) {
        expect(texts![lang]?.trim(), isNotEmpty, reason: '${c.id} $lang');
      }
    }
    for (final (label, _) in difficultyLadder) {
      expect(label.keys, containsAll(['en', 'ru', 'de', 'fr', 'zh']));
    }
  });

  test('screen state tolerates garbage and round-trips', () {
    expect(GmScreenState.fromObject(null).pinnedEntities, isEmpty);
    final state = GmScreenState.fromObject(WorldObject(
        id: 'x',
        worldId: 'w',
        type: WorldObjectTypes.gmScreen,
        data: const {
          'pinnedEntities': ['a', 3, ''],
          'notes': 42,
          'hidden': ['dice', 'bogus'],
        },
        createdAt: 0,
        updatedAt: 0));
    expect(state.pinnedEntities, ['a']);
    expect(state.notes, '');
    expect(state.hidden, {GmPanel.dice});
    final back = GmScreenState.fromObject(WorldObject(
        id: 'x',
        worldId: 'w',
        type: WorldObjectTypes.gmScreen,
        data: state.copyWith(notes: 'n').toData(),
        createdAt: 0,
        updatedAt: 0));
    expect(back.notes, 'n');
    expect(back.hidden, {GmPanel.dice});
  });

  testWidgets('pin an entry, keep notes, roll, read the rules',
      (tester) async {
    final app = await AppHarness.create(tester, size: const Size(1400, 900));
    final worldId = (await app.run(() => app.container
            .read(worldRepositoryProvider)
            .createWorld(name: 'Table')))
        .id;
    await app.run(() => app.container.read(entityServiceProvider).create(
        worldId: worldId, kind: EntityKind.character, name: 'Mira Vale'));
    await app.pump(Routes.tool(worldId, 'reference'));

    Future<GmScreenState> stored() async => GmScreenState.fromObject(
        (await app.run(() => app.container
                .read(worldObjectRepositoryProvider)
                .list(worldId, WorldObjectTypes.gmScreen)))
            .firstOrNull);

    // Pin.
    await tester.tap(find.byTooltip('Pin an entry'));
    await app.settle();
    await tester.tap(find.text('Mira Vale').last);
    await app.settle();
    expect((await stored()).pinnedEntities, hasLength(1));
    expect(find.text('Mira Vale'), findsOneWidget);

    // Notes save after a pause.
    await tester.enterText(
        find.widgetWithText(TextField, 'Names you improvised, loose ends, who owes whom…'),
        'The ferryman is a spy');
    await tester.pump(const Duration(seconds: 1));
    await app.settle();
    expect((await stored()).notes, 'The ferryman is a spy');

    // Dice.
    final diceField = find.descendant(
        of: find.ancestor(
            of: find.text('Quick dice'), matching: find.byType(Card)),
        matching: find.byType(TextField));
    await tester.enterText(diceField, '3d1');
    await tester.tap(find.widgetWithText(FilledButton, 'Roll'));
    await app.settle();
    expect(find.text('3'), findsWidgets);

    // Rules.
    await tester.ensureVisible(find.text('Prone'));
    await app.settle();
    await tester.tap(find.text('Prone'));
    await app.settle();
    expect(find.textContaining('Can only crawl'), findsOneWidget);
    expect(find.text('Nearly impossible'), findsOneWidget);

    // Hide a panel.
    await tester.tap(find.byTooltip('Panels'));
    await app.settle();
    await tester.tap(find.text('Quick dice').last);
    await app.settle();
    expect((await stored()).hidden, contains(GmPanel.dice));
    expect(find.text('Quick dice'), findsNothing);
  });
}
