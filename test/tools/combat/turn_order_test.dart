import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/combat/combatant.dart';
import 'package:gmh/domain/combat/turn_order.dart';

Combatant _c(
  String id, {
  num? init,
  int bonus = 0,
  bool player = false,
  bool defeated = false,
  List<CombatCondition> conditions = const [],
  String? name,
}) =>
    Combatant(
      id: id,
      name: name ?? id,
      initiative: init,
      initiativeBonus: bonus,
      isPlayer: player,
      defeated: defeated,
      conditions: conditions,
    );

List<String> _ids(List<Combatant> list) => [for (final c in list) c.id];

void main() {
  group('sortCombatants', () {
    test('initiative descending, missing initiative last', () {
      final sorted = sortCombatants([
        _c('a', init: 5),
        _c('b'),
        _c('c', init: 18),
        _c('d', init: 12.5),
      ]);
      expect(_ids(sorted), ['c', 'd', 'a', 'b']);
    });

    test('ties: bonus, then players first, then name', () {
      final sorted = sortCombatants([
        _c('x', init: 10, bonus: 1, name: 'Zed'),
        _c('y', init: 10, bonus: 3, name: 'Yara'),
        _c('m', init: 10, bonus: 1, name: 'Aaron'),
        _c('p', init: 10, bonus: 1, player: true, name: 'Pia'),
      ]);
      expect(_ids(sorted), ['y', 'p', 'm', 'x']);
    });

    test('name comparison ignores case', () {
      final sorted = sortCombatants([
        _c('1', init: 3, name: 'goblin'),
        _c('2', init: 3, name: 'Bandit'),
      ]);
      expect(_ids(sorted), ['2', '1']);
    });

    test('does not mutate the input', () {
      final input = [_c('a', init: 1), _c('b', init: 2)];
      sortCombatants(input);
      expect(_ids(input), ['a', 'b']);
    });
  });

  group('rollInitiative', () {
    test('d20 + bonus, deterministic with a seeded Random', () {
      final a = [for (var i = 0; i < 20; i++) rollInitiative(2, Random(7))];
      final b = [for (var i = 0; i < 20; i++) rollInitiative(2, Random(7))];
      expect(a, b);
      final rng = Random(42);
      final expected = Random(42);
      for (var i = 0; i < 200; i++) {
        final roll = rollInitiative(-1, rng);
        expect(roll, expected.nextInt(20) + 1 - 1);
        expect(roll, inInclusiveRange(0, 19));
      }
    });

    test('covers the whole d20 range', () {
      final rng = Random(1);
      final seen = {for (var i = 0; i < 2000; i++) rollInitiative(0, rng)};
      expect(seen, {for (var i = 1; i <= 20; i++) i});
    });
  });

  group('turn cycling', () {
    final order = [
      _c('a', init: 20),
      _c('b', init: 15, defeated: true),
      _c('c', init: 10),
      _c('d', init: 5),
    ];

    test('start of combat: round 1 on the first standing combatant', () {
      final s = startCombat([_c('x', defeated: true), _c('y')]);
      expect((s.round, s.turnIndex, s.activeId), (1, 1, 'y'));
      expect(startCombat(const []).round, 1);
    });

    test('next skips defeated and wraps into a new round', () {
      var s = startCombat(order);
      expect(s.activeId, 'a');
      s = nextTurn(order, s).state;
      expect((s.round, s.activeId), (1, 'c'));
      s = nextTurn(order, s).state;
      expect((s.round, s.activeId), (1, 'd'));
      s = nextTurn(order, s).state;
      expect((s.round, s.turnIndex, s.activeId), (2, 0, 'a'));
    });

    test('wrap when the first combatants are defeated', () {
      final list = [
        _c('a', init: 20, defeated: true),
        _c('b', init: 10),
        _c('c', init: 5),
      ];
      var s = const TurnState(3, 2, 'c');
      s = nextTurn(list, s).state;
      expect((s.round, s.activeId), (4, 'b'));
    });

    test('a lone combatant starts a new round each turn', () {
      final list = [_c('solo', init: 3)];
      final s = nextTurn(list, const TurnState(1, 0, 'solo')).state;
      expect((s.round, s.activeId), (2, 'solo'));
    });

    test('nobody standing: pointer stays', () {
      final list = [_c('a', defeated: true), _c('b', defeated: true)];
      final s = nextTurn(list, const TurnState(2, 1, 'b')).state;
      expect((s.round, s.turnIndex), (2, 1));
    });

    test('activeId wins over a stale index after re-sorting', () {
      // 'c' was at index 2, an initiative edit moved it to the top.
      final resorted = [
        _c('c', init: 25),
        _c('a', init: 20),
        _c('d', init: 5),
      ];
      final s = nextTurn(resorted, const TurnState(1, 2, 'c')).state;
      expect(s.activeId, 'a');
      expect(resolveTurnIndex(resorted, 9, 'gone'), 2);
      expect(resolveTurnIndex(const [], 3, null), 0);
    });

    test('previous goes back, skipping defeated, across rounds', () {
      var s = const TurnState(2, 0, 'a');
      s = previousTurn(order, s);
      expect((s.round, s.activeId), (1, 'd'));
      s = previousTurn(order, s);
      expect((s.round, s.activeId), (1, 'c'));
      s = previousTurn(order, s);
      expect((s.round, s.activeId), (1, 'a'));
      // Never before the first turn of round 1.
      s = previousTurn(order, s);
      expect((s.round, s.activeId), (1, 'a'));
    });

    test('empty list keeps the state', () {
      const s = TurnState(4, 1, null);
      expect(nextTurn(const [], s).state, same(s));
      expect(previousTurn(const [], s), same(s));
    });
  });

  group('condition durations', () {
    test('tick at the end of the affected combatant turn and expire at 0',
        () {
      final list = [
        _c('a', init: 20, conditions: const [
          CombatCondition('poisoned', rounds: 2),
          CombatCondition('prone'),
          CombatCondition('stunned', rounds: 1),
        ]),
        _c('b', init: 10, conditions: const [
          CombatCondition('blinded', rounds: 1),
        ]),
      ];
      final first = nextTurn(list, const TurnState(1, 0, 'a'));
      expect(first.changed, hasLength(1));
      final a = first.changed.single;
      expect(a.id, 'a');
      expect(a.conditions, const [
        CombatCondition('poisoned', rounds: 1),
        CombatCondition('prone'),
      ]);
      // b's condition is untouched until b's own turn ends.
      expect(first.state.activeId, 'b');

      final after = [a, list[1]];
      final second = nextTurn(after, first.state);
      expect(second.changed.single.id, 'b');
      expect(second.changed.single.conditions, isEmpty);

      final third = nextTurn([a, second.changed.single], second.state);
      expect(third.changed.single.conditions, const [CombatCondition('prone')]);
    });

    test('no timed conditions: nothing to persist', () {
      final c = _c('a', conditions: const [CombatCondition('prone')]);
      expect(tickConditions(c), same(c));
      expect(nextTurn([c], const TurnState(1, 0, 'a')).changed, isEmpty);
    });

    test('previous turn does not tick conditions', () {
      final list = [
        _c('a', init: 20),
        _c('b',
            init: 10,
            conditions: const [CombatCondition('poisoned', rounds: 1)]),
      ];
      final s = previousTurn(list, const TurnState(1, 1, 'b'));
      expect(s.activeId, 'a');
      expect(list[1].conditions, hasLength(1));
    });
  });

  group('numberedNames', () {
    test('single new combatant keeps the bare name', () {
      expect(numberedNames('Goblin', 1, const []), ['Goblin']);
      expect(numberedNames(' Goblin ', 1, const ['Orc']), ['Goblin']);
    });

    test('several get numbered 1..N', () {
      expect(numberedNames('Goblin', 3, const []),
          ['Goblin 1', 'Goblin 2', 'Goblin 3']);
    });

    test('continues existing numbering', () {
      expect(numberedNames('Goblin', 2, const ['Goblin 1', 'Goblin 4', 'Orc 9']),
          ['Goblin 5', 'Goblin 6']);
      expect(numberedNames('Goblin', 1, const ['Goblin']), ['Goblin 2']);
      expect(numberedNames('Goblin', 0, const []), isEmpty);
    });

    test('regex characters in names are literal', () {
      expect(numberedNames('Cult (x)', 1, const ['Cult (x) 2']),
          ['Cult (x) 3']);
    });
  });
}
