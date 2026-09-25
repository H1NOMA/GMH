import 'package:flutter/foundation.dart';

import 'combatant.dart';
import 'encounter.dart';

/// Encounter difficulty, ordered from easiest. The 2024 rules use trivial /
/// low / moderate / high / beyondHigh; the 2014 rules trivial / easy /
/// medium / hard / deadly.
enum DifficultyRating {
  trivial,
  low,
  moderate,
  high,
  beyondHigh,
  easy,
  medium,
  hard,
  deadly;

  /// 0 (trivial) … 4 (the top tier), comparable across rule sets.
  int get tier => switch (this) {
        trivial => 0,
        low || easy => 1,
        moderate || medium => 2,
        high || hard => 3,
        beyondHigh || deadly => 4,
      };
}

/// Per-character XP budgets of the 2024 DMG for levels 1–20:
/// (low, moderate, high).
const xpBudgets2024 = <(int, int, int)>[
  (50, 75, 100), (100, 150, 200), (150, 225, 400), (250, 375, 500),
  (500, 750, 1100), (600, 1000, 1400), (750, 1300, 1700),
  (1000, 1700, 2100), (1300, 2000, 2600), (1600, 2300, 3100),
  (1900, 2900, 4100), (2200, 3700, 4700), (2600, 4200, 5400),
  (2900, 4900, 6200), (3300, 5400, 7800), (3800, 6100, 9800),
  (4500, 7200, 11700), (5000, 8700, 14200), (5500, 10700, 17200),
  (6400, 13200, 22000),
];

/// Per-character XP thresholds of the 2014 DMG for levels 1–20:
/// (easy, medium, hard, deadly).
const xpThresholds2014 = <(int, int, int, int)>[
  (25, 50, 75, 100), (50, 100, 150, 200), (75, 150, 225, 400),
  (125, 250, 375, 500), (250, 500, 750, 1100), (300, 600, 900, 1400),
  (350, 750, 1100, 1700), (450, 900, 1400, 2100), (550, 1100, 1600, 2400),
  (600, 1200, 1900, 2800), (800, 1600, 2400, 3600), (1000, 2000, 3000, 4500),
  (1100, 2200, 3400, 5100), (1250, 2500, 3800, 5700),
  (1400, 2800, 4300, 6400), (1600, 3200, 4800, 7200),
  (2000, 3900, 5900, 8800), (2100, 4200, 6300, 9500),
  (2400, 4900, 7300, 10900), (2800, 5700, 8500, 12700),
];

/// 2014 group multiplier by number of monsters.
double groupMultiplier2014(int monsterCount) {
  if (monsterCount <= 1) return 1;
  if (monsterCount == 2) return 1.5;
  if (monsterCount <= 6) return 2;
  if (monsterCount <= 10) return 2.5;
  if (monsterCount <= 14) return 3;
  return 4;
}

int _levelIndex(int level) => level.clamp(1, 20) - 1;

@immutable
class DifficultyThreshold {
  final DifficultyRating rating;
  final int xp;
  const DifficultyThreshold(this.rating, this.xp);
}

@immutable
class DifficultyResult {
  final RulesVersion rules;

  /// Sum of the monsters' XP.
  final int totalXp;

  /// XP compared against the thresholds: [totalXp] under 2024 rules,
  /// multiplied by [multiplier] under 2014 rules.
  final int adjustedXp;
  final double multiplier;
  final int monsterCount;

  /// The party's summed thresholds, easiest first (empty without a party).
  final List<DifficultyThreshold> thresholds;

  /// Null when there is no party or no monster to rate.
  final DifficultyRating? rating;

  const DifficultyResult({
    required this.rules,
    required this.totalXp,
    required this.adjustedXp,
    required this.multiplier,
    required this.monsterCount,
    required this.thresholds,
    required this.rating,
  });
}

/// Rates [monsterXp] (one entry per monster) against [partyLevels].
///
/// 2024: the party's budgets are summed; reaching the Low / Moderate / High
/// budget rates the encounter so, less than Low is trivial and more than
/// the High budget is beyond high.
/// 2014: XP times the group multiplier against the summed thresholds; the
/// highest threshold reached wins, below Easy is trivial.
DifficultyResult rateEncounter({
  required List<int> partyLevels,
  required List<int> monsterXp,
  required RulesVersion rules,
}) {
  final total = monsterXp.fold<int>(0, (sum, xp) => sum + (xp < 0 ? 0 : xp));
  final count = monsterXp.length;
  final List<DifficultyThreshold> thresholds;
  final double multiplier;
  if (rules == RulesVersion.v2024) {
    multiplier = 1;
    var low = 0, moderate = 0, high = 0;
    for (final level in partyLevels) {
      final b = xpBudgets2024[_levelIndex(level)];
      low += b.$1;
      moderate += b.$2;
      high += b.$3;
    }
    thresholds = partyLevels.isEmpty
        ? const []
        : [
            DifficultyThreshold(DifficultyRating.low, low),
            DifficultyThreshold(DifficultyRating.moderate, moderate),
            DifficultyThreshold(DifficultyRating.high, high),
          ];
  } else {
    multiplier = groupMultiplier2014(count);
    var easy = 0, medium = 0, hard = 0, deadly = 0;
    for (final level in partyLevels) {
      final t = xpThresholds2014[_levelIndex(level)];
      easy += t.$1;
      medium += t.$2;
      hard += t.$3;
      deadly += t.$4;
    }
    thresholds = partyLevels.isEmpty
        ? const []
        : [
            DifficultyThreshold(DifficultyRating.easy, easy),
            DifficultyThreshold(DifficultyRating.medium, medium),
            DifficultyThreshold(DifficultyRating.hard, hard),
            DifficultyThreshold(DifficultyRating.deadly, deadly),
          ];
  }
  final adjusted = (total * multiplier).round();

  DifficultyRating? rating;
  if (thresholds.isNotEmpty && count > 0) {
    rating = DifficultyRating.trivial;
    for (final t in thresholds) {
      if (adjusted >= t.xp) rating = t.rating;
    }
    if (rules == RulesVersion.v2024 && adjusted > thresholds.last.xp) {
      rating = DifficultyRating.beyondHigh;
    }
  }
  return DifficultyResult(
    rules: rules,
    totalXp: total,
    adjustedXp: adjusted,
    multiplier: multiplier,
    monsterCount: count,
    thresholds: thresholds,
    rating: rating,
  );
}

/// Rates [encounter] with its [combatants]; every non-player combatant
/// counts as a monster.
DifficultyResult rateCombatants(
        Encounter encounter, Iterable<Combatant> combatants) =>
    rateEncounter(
      partyLevels: encounter.partyLevels,
      monsterXp: [
        for (final c in combatants)
          if (!c.isPlayer) c.xp,
      ],
      rules: encounter.rulesVersion,
    );
