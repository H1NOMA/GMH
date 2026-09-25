import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/dice/dice_engine.dart';
import 'package:gmh/domain/dice/dice_history.dart';
import 'package:gmh/domain/dice/dice_presets.dart';
import 'package:gmh/domain/dice/dice_text_scanner.dart';
import 'package:gmh/domain/models/world_object.dart';

import '../../helpers.dart';
import 'scripted_random.dart';

List<String> found(String text) =>
    [for (final m in findDiceExpressions(text)) m.expression];

WorldObject object(Map<String, Object?> data, {int createdAt = 1, int order = 0}) =>
    WorldObject(
      id: 'o$createdAt-$order',
      worldId: 'w',
      type: WorldObjectTypes.diceRoll,
      data: data,
      sortOrder: order,
      createdAt: createdAt,
      updatedAt: createdAt,
    );

void main() {
  group('dice in text', () {
    test('finds an expression inside parentheses', () {
      const text = '52 (8d10 + 8)';
      final matches = findDiceExpressions(text);
      expect(matches.single.expression, '8d10 + 8');
      expect(text.substring(matches.single.start, matches.single.end),
          '8d10 + 8');
    });

    test('attack lines', () {
      expect(found('Hit: 2d6 + 3.'), ['2d6 + 3']);
      expect(found('+5 to hit, 1d20+5 to confirm'), ['1d20+5']);
      expect(found('8d6 fire damage'), ['8d6']);
      expect(found('roll a d20 or d%'), ['d20', 'd%']);
    });

    test('several expressions in order', () {
      expect(found('2d10+5 piercing plus 1d8 cold'), ['2d10+5', '1d8']);
      expect(found('3d6 + 1d4 - 2 total'), ['3d6 + 1d4 - 2']);
    });

    test('ignores words and invalid dice', () {
      expect(found('d20s and Hd6 are not dice'), isEmpty);
      expect(found('level 3, 20 ft.'), isEmpty);
      expect(found('1d0 is nonsense'), isEmpty);
      expect(found(''), isEmpty);
    });

    test('a trailing sign without a number is left out', () {
      expect(found('2d6+ damage'), ['2d6']);
    });

    test('typographic minus is normalized', () {
      expect(found('1d6 − 1'), ['1d6 - 1']);
    });
  });

  group('history entries', () {
    test('a roll round-trips through the store format', () {
      final roll = DiceEngine(random: ScriptedRandom.dice([4, 2]))
          .roll('2d6+1');
      final entry = DiceHistoryEntry.fromRoll(roll, label: ' Attack ');
      final back = DiceHistoryEntry.fromObject(object(entry.toData()));
      expect(back.expression, '2d6 + 1');
      expect(back.total, 7);
      expect(back.breakdown, '2d6 (4, 2) + 1');
      expect(back.label, 'Attack');
      expect(back.preset, isNull);
      expect(back.outcome, DiceOutcome.none);
    });

    test('a preset keeps its kind, params and outcome', () {
      final roll = DicePresets(random: ScriptedRandom.dice([5, 5])).pbta(stat: 1);
      final back = DiceHistoryEntry.fromObject(
          object(DiceHistoryEntry.fromPreset(roll).toData()));
      expect(back.preset, DicePresetKind.pbta);
      expect(back.params, {'stat': 1});
      expect(back.outcome, DiceOutcome.fullSuccess);
      expect(back.total, 11);
    });

    test('garbled data falls back to defaults', () {
      final e = DiceHistoryEntry.fromObject(object({
        'expression': 12,
        'total': 'abc',
        'label': null,
        'preset': 'nope',
        'params': 'x',
        'outcome': [],
      }));
      expect(e.expression, '');
      expect(e.total, 0);
      expect(e.label, '');
      expect(e.preset, isNull);
      expect(e.params, isEmpty);
      expect(e.outcome, DiceOutcome.none);
      expect(DiceHistoryEntry.fromObject(object({'total': '7'})).total, 7);
      expect(DiceHistoryEntry.fromObject(object({'total': 7.9})).total, 7);
    });

    test('newest first', () {
      final list = DiceHistory.fromObjects([
        object({'total': 1}, createdAt: 1),
        object({'total': 3}, createdAt: 3),
        object({'total': 2}, createdAt: 2),
      ]);
      expect([for (final e in list) e.total], [3, 2, 1]);
    });

    test('share text', () {
      const entry = DiceHistoryEntry(
          expression: '1d20 + 2', total: 15, breakdown: '1d20 (13) + 2');
      expect(entry.shareText, '1d20 + 2 = 15  ·  1d20 (13) + 2');
      const labelled = DiceHistoryEntry(expression: '5', total: 5, label: 'X');
      expect(labelled.shareText, 'X: 5 = 5');
    });
  });

  group('history store', () {
    late TestHarness h;
    setUp(() async => h = await TestHarness.create());
    tearDown(() => h.dispose());

    test('logs, caps at 200 and clears', () async {
      final world = await h.worlds.createWorld(name: 'W');
      for (var k = 0; k < 205; k++) {
        await DiceHistory.log(h.objects, world.id,
            DiceHistoryEntry(expression: '1d6', total: k));
      }
      var stored = DiceHistory.fromObjects(
          await h.objects.list(world.id, WorldObjectTypes.diceRoll));
      expect(stored.length, DiceHistory.keep);
      expect(stored.first.total, 204);
      expect(stored.last.total, 5);

      await DiceHistory.clear(h.objects, world.id);
      stored = DiceHistory.fromObjects(
          await h.objects.list(world.id, WorldObjectTypes.diceRoll));
      expect(stored, isEmpty);
    });

    test('the object name is the label or the expression', () async {
      final world = await h.worlds.createWorld(name: 'W');
      await DiceHistory.log(h.objects, world.id,
          const DiceHistoryEntry(expression: '2d6', total: 7, label: 'Sneak'));
      await DiceHistory.log(h.objects, world.id,
          const DiceHistoryEntry(expression: '1d4', total: 2));
      final objects =
          await h.objects.list(world.id, WorldObjectTypes.diceRoll);
      expect({for (final o in objects) o.name}, {'Sneak', '1d4'});
    });
  });
}
