import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/tables/random_table.dart';
import 'package:gmh/domain/tables/table_roller.dart';

import '../../helpers.dart';
import '../dice/scripted_random.dart';

RandomTable _weighted(String name, List<String> rows, {List<int>? weights}) =>
    RandomTable(
      id: 'id-$name',
      name: name,
      rows: [
        for (var i = 0; i < rows.length; i++)
          RandomTableRow(rows[i], weight: weights?[i] ?? 1),
      ],
    );

RandomTable _ranged(String formula, List<(int, int, String)> rows) =>
    RandomTable(
      id: 'ranged',
      name: 'Ranged',
      formula: formula,
      rows: [for (final (a, b, t) in rows) RandomTableRow(t, from: a, to: b)],
    );

TableRoller _roller(Random random, [List<RandomTable> tables = const []]) =>
    TableRoller.forTables(tables, random: random);

void main() {
  group('weights', () {
    final table =
        _weighted('W', ['low', 'heavy', 'last'], weights: [1, 2, 1]);

    test('picks by cumulative weight', () {
      final expected = ['low', 'heavy', 'heavy', 'last'];
      for (var v = 0; v < 4; v++) {
        final random = ScriptedRandom([v]);
        final result = _roller(random).roll(table);
        expect(result.text, expected[v]);
        expect(random.requested, [4]);
        expect(result.total, isNull);
        expect(result.clamped, isFalse);
      }
    });

    test('reports row index and raw text', () {
      final result = _roller(ScriptedRandom([3])).roll(table);
      expect(result.rowIndex, 2);
      expect(result.rowText, 'last');
      expect(result.ok, isTrue);
      expect(result.tableName, 'W');
    });

    test('skips rows without text', () {
      final t = _weighted('W', ['', 'only', '   ']);
      final random = ScriptedRandom([0]);
      final result = _roller(random).roll(t);
      expect(result.text, 'only');
      expect(result.rowIndex, 1);
      expect(random.requested, [1]);
    });

    test('an empty table fails instead of throwing', () {
      final result = _roller(ScriptedRandom([])).roll(_weighted('E', []));
      expect(result.failure, TableRollFailure.empty);
      expect(result.ok, isFalse);
      expect(result.rowIndex, isNull);
    });
  });

  group('formula', () {
    final d6 = _ranged('1d6', [(1, 2, 'a'), (3, 4, 'b'), (5, 6, 'c')]);

    test('picks the row whose range holds the total', () {
      for (final (face, text) in [(1, 'a'), (2, 'a'), (4, 'b'), (6, 'c')]) {
        final result = _roller(ScriptedRandom.dice([face])).roll(d6);
        expect(result.text, text, reason: 'face $face');
        expect(result.total, face);
        expect(result.clamped, isFalse);
      }
    });

    test('sums multi-dice formulas', () {
      final t = _ranged('2d6', [(2, 6, 'low'), (7, 7, 'seven'), (8, 12, 'hi')]);
      final result = _roller(ScriptedRandom.dice([3, 4])).roll(t);
      expect(result.total, 7);
      expect(result.text, 'seven');
      expect(result.breakdown, contains('3'));
    });

    test('totals above every range clamp to the last row', () {
      final t = _ranged('1d8', [(1, 3, 'a'), (4, 5, 'b')]);
      final result = _roller(ScriptedRandom.dice([8])).roll(t);
      expect(result.text, 'b');
      expect(result.total, 8);
      expect(result.clamped, isTrue);
    });

    test('totals below every range clamp to the first row', () {
      final t = _ranged('1d6-3', [(1, 3, 'a'), (4, 6, 'b')]);
      final result = _roller(ScriptedRandom.dice([1])).roll(t);
      expect(result.total, -2);
      expect(result.text, 'a');
      expect(result.clamped, isTrue);
    });

    test('totals in a gap go to the nearest row, ties to the earlier', () {
      final t = _ranged('1d6', [(1, 1, 'a'), (5, 6, 'b')]);
      expect(_roller(ScriptedRandom.dice([2])).roll(t).text, 'a');
      expect(_roller(ScriptedRandom.dice([4])).roll(t).text, 'b');
      final tie = _roller(ScriptedRandom.dice([3])).roll(t);
      expect(tie.text, 'a');
      expect(tie.clamped, isTrue);
    });

    test('the first matching row wins on overlaps', () {
      final t = _ranged('1d6', [(1, 4, 'first'), (3, 6, 'second')]);
      expect(_roller(ScriptedRandom.dice([3])).roll(t).text, 'first');
      expect(_roller(ScriptedRandom.dice([5])).roll(t).text, 'second');
    });

    test('rows without ranges are spread over the formula', () {
      final t = RandomTable(name: 'T', formula: '1d6', rows: const [
        RandomTableRow('a'),
        RandomTableRow('b'),
        RandomTableRow('c'),
      ]);
      expect(_roller(ScriptedRandom.dice([5])).roll(t).text, 'c');
      expect(_roller(ScriptedRandom.dice([2])).roll(t).text, 'a');
    });

    test('inverted ranges are ignored', () {
      final t = _ranged('1d4', [(4, 1, 'bad'), (1, 4, 'good')]);
      expect(_roller(ScriptedRandom.dice([2])).roll(t).text, 'good');
    });

    test('weights do not matter when a formula is set', () {
      final t = RandomTable(name: 'T', formula: '1d4', rows: const [
        RandomTableRow('a', weight: 100, from: 1, to: 1),
        RandomTableRow('b', from: 2, to: 4),
      ]);
      expect(_roller(ScriptedRandom.dice([3])).roll(t).text, 'b');
    });

    test('a broken formula fails', () {
      final t = _ranged('1d', [(1, 2, 'a')]);
      final result = _roller(ScriptedRandom([])).roll(t);
      expect(result.failure, TableRollFailure.badFormula);
    });
  });

  group('inline expansions', () {
    RandomTable one(String text) => _weighted('One', [text]);

    test('rolls dice in braces', () {
      final result =
          _roller(ScriptedRandom([0, 2, 3])).roll(one('Found {2d6} coins'));
      expect(result.text, 'Found 7 coins');
      final dice = result.parts.single as DicePart;
      expect((dice.expression, dice.total), ('2d6', 7));
    });

    test('supports modifiers and several dice groups', () {
      final result = _roller(ScriptedRandom([0, 2, 0]))
          .roll(one('{1d4+1} wolves and {1d6} crows'));
      expect(result.text, '4 wolves and 1 crows');
      expect(result.parts, hasLength(2));
    });

    test('leaves braces that are not dice untouched', () {
      final result = _roller(ScriptedRandom([0])).roll(one('a {not dice} b {}'));
      expect(result.text, 'a {not dice} b {}');
      expect(result.parts, isEmpty);
    });

    test('an unclosed brace is literal', () {
      final result = _roller(ScriptedRandom([0])).roll(one('a {1d6 b'));
      expect(result.text, 'a {1d6 b');
    });

    test('picks one alternative uniformly', () {
      for (var v = 0; v < 3; v++) {
        final random = ScriptedRandom([0, v]);
        final result = _roller(random).roll(one('A {red|green|blue} door'));
        expect(result.text, 'A ${['red', 'green', 'blue'][v]} door');
        expect(random.requested, [1, 3]);
        final choice = result.parts.single as ChoicePart;
        expect(choice.index, v);
        expect(choice.options, ['red', 'green', 'blue']);
      }
    });

    test('alternatives may be empty and may contain dice', () {
      expect(_roller(ScriptedRandom([0, 0])).roll(one('x{|!}y')).text, 'xy');
      final result =
          _roller(ScriptedRandom([0, 0, 1])).roll(one('{{1d4} rats|a cat}'));
      expect(result.text, '2 rats');
      final choice = result.parts.single as ChoicePart;
      expect(choice.parts.single, isA<DicePart>());
    });
  });

  group('nested tables', () {
    final other = _weighted('Other Table', ['a goblin']);

    test('resolve case-insensitively and splice their text', () {
      final main = _weighted('Main', ['You meet [[  other   TABLE ]].']);
      final result = _roller(ScriptedRandom([0, 0]), [main, other]).roll(main);
      expect(result.text, 'You meet a goblin.');
      final nested = result.nestedTables.single;
      expect(nested.name, 'other   TABLE');
      expect(nested.result.tableName, 'Other Table');
      expect(nested.result.rowIndex, 0);
      expect(result.hasFailure, isFalse);
    });

    test('an unknown table is marked, not thrown', () {
      final main = _weighted('Main', ['See [[Missing]] now']);
      final result = _roller(ScriptedRandom([0]), [main]).roll(main);
      expect(result.text, 'See ${TableRoller.failureMark}[[Missing]] now');
      expect(result.nestedTables.single.result.failure,
          TableRollFailure.notFound);
      expect(result.hasFailure, isTrue);
      expect(result.ok, isTrue);
    });

    test('empty brackets stay literal', () {
      final main = _weighted('Main', ['[[ ]] and [[open']);
      expect(_roller(ScriptedRandom([0]), [main]).roll(main).text,
          '[[ ]] and [[open');
    });

    test('a table referencing itself is a cycle', () {
      final self = _weighted('Loop', ['again [[loop]]']);
      final result = _roller(ScriptedRandom([0]), [self]).roll(self);
      expect(result.text, 'again ${TableRoller.failureMark}[[loop]]');
      expect(result.nestedTables.single.result.failure, TableRollFailure.cycle);
    });

    test('two tables referencing each other stop at the cycle', () {
      final a = _weighted('A', ['a [[B]]']);
      final b = _weighted('B', ['b [[A]]']);
      final result = _roller(ScriptedRandom([0, 0]), [a, b]).roll(a);
      expect(result.text, 'a b ${TableRoller.failureMark}[[A]]');
      final inner = result.nestedTables.single.result;
      expect(inner.tableName, 'B');
      expect(inner.nestedTables.single.result.failure, TableRollFailure.cycle);
    });

    test('the same table may appear twice when it is not an ancestor', () {
      final main = _weighted('Main', ['[[Other Table]] and [[Other Table]]']);
      final result = _roller(ScriptedRandom([0, 0, 0]), [main, other]).roll(main);
      expect(result.text, 'a goblin and a goblin');
      expect(result.hasFailure, isFalse);
    });

    test('nesting stops at the depth cap', () {
      final chain = [
        for (var i = 0; i < 10; i++) _weighted('T$i', ['$i [[T${i + 1}]]']),
        _weighted('T10', ['end']),
      ];
      final result =
          _roller(Random(3), chain).roll(chain.first);
      var node = result;
      var depth = 0;
      while (node.nestedTables.isNotEmpty &&
          node.nestedTables.single.result.ok) {
        node = node.nestedTables.single.result;
        depth++;
      }
      expect(depth, TableRoller.maxDepth);
      expect(node.nestedTables.single.result.failure,
          TableRollFailure.depthLimit);
      expect(result.text, startsWith('0 1 2 3 4 5 6 ${TableRoller.failureMark}'));
    });

    test('a runaway fan-out is capped', () {
      String refs(String name) => List.filled(10, '[[$name]]').join(' ');
      final tables = [
        _weighted('A', [refs('B')]),
        _weighted('B', [refs('C')]),
        _weighted('C', [refs('D')]),
        _weighted('D', ['x']),
      ];
      final result = _roller(Random(1), tables).roll(tables.first);
      expect(result.hasFailure, isTrue);
      final failures = <TableRollFailure>[];
      void collect(TableRollResult r) {
        for (final t in r.nestedTables) {
          if (t.result.failure != null) failures.add(t.result.failure!);
          collect(t.result);
        }
      }

      collect(result);
      expect(failures, contains(TableRollFailure.tooMany));
    });

    test('references inside alternatives are rolled', () {
      final main = _weighted('Main', ['{[[Other Table]]|nobody}']);
      final result = _roller(ScriptedRandom([0, 0, 0]), [main, other]).roll(main);
      expect(result.text, 'a goblin');
      expect(result.nestedTables.single.result.tableName, 'Other Table');
    });

    test('nested formula tables keep their own totals', () {
      final loot = _ranged('1d4', [(1, 2, 'copper'), (3, 4, 'gold')]);
      final named = RandomTable(
          id: 'loot', name: 'Loot', formula: loot.formula, rows: loot.rows);
      final main = _weighted('Main', ['Chest: [[Loot]]']);
      final result = _roller(ScriptedRandom([0, 3]), [main, named]).roll(main);
      expect(result.text, 'Chest: gold');
      expect(result.nestedTables.single.result.total, 4);
    });

    test('the first of two tables with the same name wins', () {
      final first = _weighted('Dup', ['first']);
      final second = _weighted('dup', ['second']);
      final roller = _roller(ScriptedRandom([0]), [first, second]);
      expect(roller.resolve('DUP'), same(first));
    });
  });

  group('rollTableByName', () {
    late TestHarness h;
    late String worldId;

    setUp(() async {
      h = await TestHarness.create();
      worldId = (await h.worlds.createWorld(name: 'W')).id;
      for (final t in [
        _weighted('Weather', ['Rain on [[Road]]']),
        _weighted('Road', ['the old road']),
        _weighted('Empty', []),
      ]) {
        await h.objects.create(
          worldId: worldId,
          type: WorldObjectTypes.randomTable,
          name: t.name,
          data: t.toData(),
        );
      }
    });

    tearDown(() => h.dispose());

    test('rolls a world table by name, nested references included', () async {
      expect(await rollTableByName(h.objects, worldId, 'weather', Random(1)),
          'Rain on the old road');
    });

    test('returns null for unknown names and unrollable tables', () async {
      expect(await rollTableByName(h.objects, worldId, 'Nope', Random(1)),
          isNull);
      expect(await rollTableByName(h.objects, worldId, 'Empty', Random(1)),
          isNull);
    });

    test('only sees tables of the given world', () async {
      final other = (await h.worlds.createWorld(name: 'Other')).id;
      expect(await rollTableByName(h.objects, other, 'Weather', Random(1)),
          isNull);
    });
  });
}
