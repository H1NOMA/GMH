import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/dice/dice_presets.dart';

import 'scripted_random.dart';

DicePresets dice(List<int> faces) =>
    DicePresets(random: ScriptedRandom.dice(faces));

/// CoC and Cyberpunk read `nextInt(10)` directly: raw digits 0-9.
DicePresets raw(List<int> values) => DicePresets(random: ScriptedRandom(values));

void main() {
  group('d20 check', () {
    test('normal roll with modifier and DC', () {
      final r = dice([15]).d20Check(modifier: 3);
      expect(r.total, 18);
      expect(r.outcome, DiceOutcome.none);
      expect(r.roll.expression, '1d20 + 3');
      expect(dice([15]).d20Check(modifier: 3, dc: 18).outcome,
          DiceOutcome.success);
      expect(dice([15]).d20Check(modifier: 3, dc: 19).outcome,
          DiceOutcome.failure);
    });

    test('advantage keeps the higher die; natural 20 is critical', () {
      final r = dice([5, 20]).d20Check(mode: D20Mode.advantage, modifier: 2);
      expect(r.total, 22);
      expect(r.outcome, DiceOutcome.criticalSuccess);
      expect(r.roll.expression, '2d20kh1 + 2');
    });

    test('disadvantage keeps the lower die; natural 1 fails critically', () {
      final r = dice([1, 15]).d20Check(mode: D20Mode.disadvantage, dc: 5);
      expect(r.total, 1);
      expect(r.outcome, DiceOutcome.criticalFailure);
    });

    test('negative modifier', () {
      final r = dice([10]).d20Check(modifier: -2);
      expect(r.total, 8);
      expect(r.roll.expression, '1d20 - 2');
    });
  });

  test('ability score is 4d6 keep 3', () {
    final r = dice([6, 5, 3, 1]).abilityScore();
    expect(r.total, 14);
    expect(r.roll.terms.single.dice.last.dropped, isTrue);
  });

  group('Call of Cthulhu', () {
    DiceOutcome level(int skill, int tens, int units) =>
        raw([units, tens]).callOfCthulhu(skill: skill).outcome;

    test('success levels against the skill', () {
      expect(level(50, 3, 5), DiceOutcome.regularSuccess);
      expect(level(50, 2, 5), DiceOutcome.hardSuccess);
      expect(level(50, 1, 0), DiceOutcome.extremeSuccess);
      expect(level(50, 0, 1), DiceOutcome.criticalSuccess);
      expect(level(50, 5, 1), DiceOutcome.failure);
    });

    test('00 + 0 reads as 100 and always fumbles', () {
      final r = raw([0, 0]).callOfCthulhu(skill: 99);
      expect(r.total, 100);
      expect(r.outcome, DiceOutcome.fumble);
    });

    test('96-99 fumble only below skill 50', () {
      expect(level(40, 9, 7), DiceOutcome.fumble);
      expect(level(60, 9, 7), DiceOutcome.failure);
      expect(level(50, 9, 6), DiceOutcome.failure);
    });

    test('a bonus die keeps the better tens', () {
      final r = raw([4, 7, 2]).callOfCthulhu(skill: 50, bonus: 1);
      expect(r.total, 24);
      expect(r.outcome, DiceOutcome.hardSuccess);
      final tens = r.roll.terms.first.dice;
      expect([for (final d in tens) d.value], [70, 20]);
      expect([for (final d in tens) d.dropped], [true, false]);
      expect(r.roll.expression, '1d100 +1');
    });

    test('a penalty die keeps the worse tens', () {
      final r = raw([4, 2, 7]).callOfCthulhu(skill: 30, bonus: -1);
      expect(r.total, 74);
      expect(r.outcome, DiceOutcome.failure);
      expect(r.roll.expression, '1d100 -1');
    });

    test('00 tens with a 0 unit is the worst result', () {
      expect(raw([0, 0, 5]).callOfCthulhu(skill: 60, bonus: 1).total, 50);
      expect(raw([0, 5, 0]).callOfCthulhu(skill: 60, bonus: -1).total, 100);
    });

    test('bonus dice are capped at two', () {
      final random = ScriptedRandom([3, 1, 2, 3]);
      final r = DicePresets(random: random).callOfCthulhu(skill: 50, bonus: 5);
      expect(random.remaining, 0);
      expect(r.params['bonus'], 2);
      expect(r.total, 13);
    });
  });

  group('Powered by the Apocalypse', () {
    test('bands 6-, 7-9, 10+', () {
      expect(dice([3, 2]).pbta(stat: 1).outcome, DiceOutcome.miss);
      expect(dice([4, 2]).pbta(stat: 1).outcome, DiceOutcome.partialSuccess);
      expect(dice([5, 4]).pbta(stat: 1).outcome, DiceOutcome.fullSuccess);
      final r = dice([6, 4]).pbta(stat: -1);
      expect(r.total, 9);
      expect(r.outcome, DiceOutcome.partialSuccess);
      expect(r.roll.expression, '2d6 - 1');
    });
  });

  group('Blades in the Dark', () {
    test('highest die of the pool', () {
      expect(dice([2, 5, 4]).blades(dice: 3).outcome,
          DiceOutcome.partialSuccess);
      expect(dice([6, 1, 3]).blades(dice: 3).outcome, DiceOutcome.fullSuccess);
      expect(dice([6, 6, 2]).blades(dice: 3).outcome,
          DiceOutcome.criticalSuccess);
      expect(dice([1, 2, 3]).blades(dice: 3).outcome, DiceOutcome.failure);
    });

    test('an empty pool takes the lower of 2d6 and cannot crit', () {
      final six = dice([6, 6]).blades(dice: 0);
      expect(six.total, 6);
      expect(six.outcome, DiceOutcome.fullSuccess);
      final low = dice([6, 2]).blades(dice: 0);
      expect(low.total, 2);
      expect(low.outcome, DiceOutcome.failure);
    });
  });

  group('Fate', () {
    test('4dF plus skill on the ladder', () {
      final r = raw([2, 2, 2, 2]).fate(skill: 2);
      expect(r.total, 6);
      expect(r.rung, FateRung.fantastic);
      expect(raw([0, 0, 0, 0]).fate().rung, FateRung.terrible);
    });

    test('ladder names by total', () {
      expect(FateRung.of(-2), FateRung.terrible);
      expect(FateRung.of(-1), FateRung.poor);
      expect(FateRung.of(0), FateRung.mediocre);
      expect(FateRung.of(1), FateRung.average);
      expect(FateRung.of(3), FateRung.good);
      expect(FateRung.of(8), FateRung.legendary);
      expect(FateRung.of(12), FateRung.legendary);
      expect(FateRung.of(-9), FateRung.terrible);
    });
  });

  group('Year Zero', () {
    test('counts sixes', () {
      final r = dice([6, 2, 6, 1]).yearZero(dice: 4);
      expect(r.total, 2);
      expect(r.successes, 2);
      expect(r.outcome, DiceOutcome.success);
      expect(dice([1, 2]).yearZero(dice: 2).outcome, DiceOutcome.failure);
    });
  });

  group('Savage Worlds', () {
    test('trait die against target number 4', () {
      final r = dice([5, 3]).savageWorlds(traitDie: 8);
      expect(r.total, 5);
      expect(r.outcome, DiceOutcome.success);
    });

    test('aces explode and a raise is 8+', () {
      final r = dice([8, 2, 3]).savageWorlds(traitDie: 8, modifier: -2);
      expect(r.total, 8);
      expect(r.outcome, DiceOutcome.raise);
      expect(r.roll.terms.first.dice.first.exploded, isTrue);
    });

    test('the wild die counts when higher', () {
      final r = dice([2, 6, 4]).savageWorlds(traitDie: 6);
      expect(r.total, 10);
      expect(r.roll.terms[0].dice.single.dropped, isTrue);
      expect(r.roll.terms[1].dice.every((d) => !d.dropped), isTrue);
    });

    test('snake eyes are a critical failure', () {
      expect(dice([1, 1]).savageWorlds().outcome, DiceOutcome.criticalFailure);
      expect(dice([1, 5]).savageWorlds().outcome, DiceOutcome.success);
    });

    test('without a wild die; odd dice fall back to d6', () {
      final random = ScriptedRandom.dice([3]);
      final r = DicePresets(random: random)
          .savageWorlds(traitDie: 7, wildDie: false);
      expect(r.total, 3);
      expect(r.outcome, DiceOutcome.failure);
      expect(random.requested, [6]);
      expect(r.params['traitDie'], 6);
    });
  });

  group('Cyberpunk RED', () {
    test('d10 plus stat and skill', () {
      final r = raw([5]).cyberpunkRed(base: 7);
      expect(r.total, 13);
      expect(r.outcome, DiceOutcome.none);
      expect(r.roll.expression, '1d10 + 7');
    });

    test('a natural 10 adds a d10', () {
      final r = raw([9, 3]).cyberpunkRed(base: 5);
      expect(r.total, 19);
      expect(r.outcome, DiceOutcome.criticalSuccess);
      expect(r.roll.terms.length, 3);
    });

    test('a natural 1 subtracts a d10', () {
      final r = raw([0, 5]).cyberpunkRed(base: 5);
      expect(r.total, 0);
      expect(r.outcome, DiceOutcome.criticalFailure);
      expect(r.roll.breakdown, '1d10 (1) - 1d10 (6) + 5');
    });
  });

  group('run from stored params', () {
    test('repeats a roll with the same inputs', () {
      final first = dice([12]).d20Check(mode: D20Mode.normal, modifier: 4, dc: 15);
      final again = dice([12]).run(first.kind, first.params);
      expect(again.total, first.total);
      expect(again.outcome, DiceOutcome.success);
      expect(again.roll.expression, first.roll.expression);
    });

    test('garbled params fall back to defaults', () {
      final r = dice([3, 4]).run(
          DicePresetKind.pbta, {'stat': 'lots', 'other': [1, 2]});
      expect(r.total, 7);
      final coc = raw([5, 3]).run(DicePresetKind.callOfCthulhu, const {});
      expect(coc.params['skill'], 50);
      final sw = dice([3, 1]).run(DicePresetKind.savageWorlds, {'wildDie': 0});
      expect(sw.params['wildDie'], isTrue);
    });

    test('every kind runs', () {
      for (final kind in DicePresetKind.values) {
        final r = DicePresets().run(kind, const {});
        expect(r.kind, kind);
        expect(r.roll.expression, isNotEmpty);
      }
    });

    test('names round-trip', () {
      expect(DicePresetKind.byName('fate'), DicePresetKind.fate);
      expect(DicePresetKind.byName('nope'), isNull);
      expect(DiceOutcome.byName('raise'), DiceOutcome.raise);
      expect(DiceOutcome.byName(42), DiceOutcome.none);
    });
  });
}
