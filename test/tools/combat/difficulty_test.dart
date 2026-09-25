import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/combat/combatant.dart';
import 'package:gmh/domain/combat/difficulty.dart';
import 'package:gmh/domain/combat/encounter.dart';

DifficultyResult _rate(List<int> party, List<int> xp, RulesVersion rules) =>
    rateEncounter(partyLevels: party, monsterXp: xp, rules: rules);

void main() {
  group('2024 budgets', () {
    const party = [3, 3, 3, 3]; // low 600, moderate 900, high 1600

    test('summed party budgets', () {
      final r = _rate(party, const [100], RulesVersion.v2024);
      expect([for (final t in r.thresholds) t.xp], [600, 900, 1600]);
      expect([for (final t in r.thresholds) t.rating], [
        DifficultyRating.low,
        DifficultyRating.moderate,
        DifficultyRating.high,
      ]);
      expect(r.multiplier, 1);
    });

    test('classification', () {
      DifficultyRating? rate(int xp) =>
          _rate(party, [xp], RulesVersion.v2024).rating;
      expect(rate(599), DifficultyRating.trivial);
      expect(rate(600), DifficultyRating.low);
      expect(rate(899), DifficultyRating.low);
      expect(rate(900), DifficultyRating.moderate);
      expect(rate(1600), DifficultyRating.high);
      expect(rate(1601), DifficultyRating.beyondHigh);
    });

    test('table spot checks', () {
      expect(xpBudgets2024, hasLength(20));
      expect(xpBudgets2024[0], (50, 75, 100));
      expect(xpBudgets2024[4], (500, 750, 1100));
      expect(xpBudgets2024[19], (6400, 13200, 22000));
      // Levels outside 1..20 are clamped.
      final r = _rate(const [0, 25], const [10], RulesVersion.v2024);
      expect(r.thresholds.first.xp, 50 + 6400);
    });

    test('no party or no monsters: no rating', () {
      expect(_rate(const [], const [500], RulesVersion.v2024).rating, isNull);
      expect(_rate(party, const [], RulesVersion.v2024).rating, isNull);
      expect(_rate(const [], const [500], RulesVersion.v2024).thresholds,
          isEmpty);
    });

    test('negative XP is ignored in the total', () {
      expect(_rate(party, const [-50, 100], RulesVersion.v2024).totalXp, 100);
    });
  });

  group('2014 thresholds', () {
    test('group multiplier by monster count', () {
      expect(groupMultiplier2014(0), 1);
      expect(groupMultiplier2014(1), 1);
      expect(groupMultiplier2014(2), 1.5);
      expect(groupMultiplier2014(3), 2);
      expect(groupMultiplier2014(6), 2);
      expect(groupMultiplier2014(7), 2.5);
      expect(groupMultiplier2014(10), 2.5);
      expect(groupMultiplier2014(11), 3);
      expect(groupMultiplier2014(14), 3);
      expect(groupMultiplier2014(15), 4);
      expect(groupMultiplier2014(40), 4);
    });

    test('four level-1 characters against goblins', () {
      // Thresholds: easy 100, medium 200, hard 300, deadly 400.
      final one = _rate(const [1, 1, 1, 1], const [50], RulesVersion.v2014);
      expect([for (final t in one.thresholds) t.xp], [100, 200, 300, 400]);
      expect(one.adjustedXp, 50);
      expect(one.rating, DifficultyRating.trivial);

      final two = _rate(const [1, 1, 1, 1], const [50, 50], RulesVersion.v2014);
      expect(two.adjustedXp, 150);
      expect(two.rating, DifficultyRating.easy);

      final four =
          _rate(const [1, 1, 1, 1], const [50, 50, 50, 50], RulesVersion.v2014);
      expect(four.totalXp, 200);
      expect(four.adjustedXp, 400);
      expect(four.rating, DifficultyRating.deadly);

      final three =
          _rate(const [1, 1, 1, 1], const [50, 50, 25], RulesVersion.v2014);
      expect(three.adjustedXp, 250);
      expect(three.rating, DifficultyRating.medium);
    });

    test('table spot checks', () {
      expect(xpThresholds2014, hasLength(20));
      expect(xpThresholds2014[4], (250, 500, 750, 1100));
      expect(xpThresholds2014[19], (2800, 5700, 8500, 12700));
      final r = _rate(const [5], const [700], RulesVersion.v2014);
      expect(r.rating, DifficultyRating.medium);
      expect(_rate(const [5], const [750], RulesVersion.v2014).rating,
          DifficultyRating.hard);
    });
  });

  test('tiers compare across rule sets', () {
    expect(DifficultyRating.trivial.tier, 0);
    expect(DifficultyRating.low.tier, DifficultyRating.easy.tier);
    expect(DifficultyRating.moderate.tier, DifficultyRating.medium.tier);
    expect(DifficultyRating.high.tier, DifficultyRating.hard.tier);
    expect(DifficultyRating.beyondHigh.tier, DifficultyRating.deadly.tier);
  });

  test('rateCombatants counts only non-players', () {
    const encounter = Encounter(
        id: 'e', worldId: 'w', name: 'E', partyLevels: [1, 1, 1, 1],
        rulesVersion: RulesVersion.v2014);
    final r = rateCombatants(encounter, const [
      Combatant(name: 'Hero', isPlayer: true, xp: 999),
      Combatant(name: 'Goblin 1', xp: 50),
      Combatant(name: 'Goblin 2', xp: 50),
    ]);
    expect(r.monsterCount, 2);
    expect(r.totalXp, 100);
    expect(r.adjustedXp, 150);
  });
}
