import 'dart:math';

import 'dice_engine.dart';

/// Tabletop systems with a dedicated roll procedure.
enum DicePresetKind {
  d20Check,
  abilityScore,
  callOfCthulhu,
  pbta,
  blades,
  fate,
  yearZero,
  savageWorlds,
  cyberpunkRed;

  static DicePresetKind? byName(Object? name) {
    for (final k in values) {
      if (k.name == name) return k;
    }
    return null;
  }
}

/// System-specific result; the UI shows it localized.
enum DiceOutcome {
  none,
  criticalSuccess,
  criticalFailure,
  success,
  failure,
  raise,
  extremeSuccess,
  hardSuccess,
  regularSuccess,
  fumble,
  miss,
  partialSuccess,
  fullSuccess;

  static DiceOutcome byName(Object? name) {
    for (final o in values) {
      if (o.name == name) return o;
    }
    return DiceOutcome.none;
  }
}

/// The Fate ladder from Terrible (-2) to Legendary (+8).
enum FateRung {
  terrible,
  poor,
  mediocre,
  average,
  fair,
  good,
  great,
  superb,
  fantastic,
  epic,
  legendary;

  /// Totals beyond the ladder clamp to its ends.
  static FateRung of(int total) =>
      FateRung.values[(total + 2).clamp(0, FateRung.values.length - 1)];
}

class PresetRoll {
  final DicePresetKind kind;

  /// The inputs, so the roll can be repeated from the history.
  final Map<String, Object?> params;
  final DiceRollResult roll;
  final DiceOutcome outcome;

  /// Fate only.
  final FateRung? rung;

  /// Year Zero: sixes rolled.
  final int? successes;

  const PresetRoll({
    required this.kind,
    required this.params,
    required this.roll,
    this.outcome = DiceOutcome.none,
    this.rung,
    this.successes,
  });

  int get total => roll.total;
}

enum D20Mode { normal, advantage, disadvantage }

int _int(Object? v, int fallback) =>
    v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? fallback);

String _signed(int n) => n == 0 ? '' : (n > 0 ? ' + $n' : ' - ${n.abs()}');

/// Roll procedures of popular systems.
class DicePresets {
  final Random random;
  final DiceEngine _engine;

  DicePresets({Random? random}) : this._(random ?? Random());

  DicePresets._(this.random) : _engine = DiceEngine(random: random);

  /// Runs [kind] with [params] as stored in the history (missing or garbled
  /// values fall back to defaults).
  PresetRoll run(DicePresetKind kind, Map<String, Object?> params) {
    return switch (kind) {
      DicePresetKind.d20Check => d20Check(
          mode: D20Mode.values
                  .where((m) => m.name == params['mode'])
                  .firstOrNull ??
              D20Mode.normal,
          modifier: _int(params['modifier'], 0),
          dc: params['dc'] == null ? null : _int(params['dc'], 10),
        ),
      DicePresetKind.abilityScore => abilityScore(),
      DicePresetKind.callOfCthulhu => callOfCthulhu(
          skill: _int(params['skill'], 50), bonus: _int(params['bonus'], 0)),
      DicePresetKind.pbta => pbta(stat: _int(params['stat'], 0)),
      DicePresetKind.blades => blades(dice: _int(params['dice'], 1)),
      DicePresetKind.fate => fate(skill: _int(params['skill'], 0)),
      DicePresetKind.yearZero => yearZero(dice: _int(params['dice'], 1)),
      DicePresetKind.savageWorlds => savageWorlds(
          traitDie: _int(params['traitDie'], 6),
          modifier: _int(params['modifier'], 0),
          wildDie: params['wildDie'] != false),
      DicePresetKind.cyberpunkRed =>
        cyberpunkRed(base: _int(params['base'], 0)),
    };
  }

  /// d20 + modifier, optionally with advantage/disadvantage and a DC.
  /// A natural 20 / 1 is reported as a critical success / failure.
  PresetRoll d20Check(
      {D20Mode mode = D20Mode.normal, int modifier = 0, int? dc}) {
    final dice = switch (mode) {
      D20Mode.normal => '1d20',
      D20Mode.advantage => '2d20kh1',
      D20Mode.disadvantage => '2d20kl1',
    };
    final roll = _engine.roll('$dice${_signed(modifier)}');
    final natural = roll.terms.first.dice.firstWhere((d) => d.kept).value;
    final outcome = natural == 20
        ? DiceOutcome.criticalSuccess
        : natural == 1
            ? DiceOutcome.criticalFailure
            : dc == null
                ? DiceOutcome.none
                : roll.total >= dc
                    ? DiceOutcome.success
                    : DiceOutcome.failure;
    return PresetRoll(
      kind: DicePresetKind.d20Check,
      params: {'mode': mode.name, 'modifier': modifier, 'dc': dc},
      roll: roll,
      outcome: outcome,
    );
  }

  PresetRoll abilityScore() => PresetRoll(
        kind: DicePresetKind.abilityScore,
        params: const {},
        roll: _engine.roll('4d6kh3'),
      );

  /// Call of Cthulhu 7e percentile roll. [bonus] > 0 adds bonus dice, < 0
  /// penalty dice (at most two either way): extra tens dice of which the
  /// best / worst is used.
  PresetRoll callOfCthulhu({required int skill, int bonus = 0}) {
    final extra = bonus.clamp(-2, 2);
    final units = random.nextInt(10);
    final tens = [
      for (var k = 0; k < 1 + extra.abs(); k++) random.nextInt(10),
    ];
    int valueOf(int t) {
      final v = t * 10 + units;
      return v == 0 ? 100 : v;
    }

    var chosen = 0;
    for (var k = 1; k < tens.length; k++) {
      final v = valueOf(tens[k]);
      final current = valueOf(tens[chosen]);
      if (extra > 0 ? v < current : v > current) chosen = k;
    }
    final result = valueOf(tens[chosen]);
    final s = skill.clamp(0, 200);
    final outcome = result == 1
        ? DiceOutcome.criticalSuccess
        : (result == 100 || (s < 50 && result >= 96))
            ? DiceOutcome.fumble
            : result <= s ~/ 5
                ? DiceOutcome.extremeSuccess
                : result <= s ~/ 2
                    ? DiceOutcome.hardSuccess
                    : result <= s
                        ? DiceOutcome.regularSuccess
                        : DiceOutcome.failure;

    final tensDice = [
      for (var k = 0; k < tens.length; k++)
        RolledDie(tens[k] * 10, dropped: k != chosen),
    ];
    final tensText = tensDice
        .map((d) => d.dropped ? '~${_pad(d.value)}~' : _pad(d.value))
        .join(', ');
    final formula = extra == 0
        ? '1d100'
        : '1d100 ${extra > 0 ? '+' : '-'}${extra.abs()}';
    return PresetRoll(
      kind: DicePresetKind.callOfCthulhu,
      params: {'skill': skill, 'bonus': extra},
      outcome: outcome,
      roll: DiceRollResult(
        expression: formula,
        total: result,
        terms: [
          DiceTermResult(
              notation: 'd10×10', value: tens[chosen] * 10, dice: tensDice),
          DiceTermResult(
              notation: 'd10', value: units, dice: [RolledDie(units)]),
        ],
        breakdown: '($tensText) + $units = $result / $skill',
      ),
    );
  }

  static String _pad(int v) => v.toString().padLeft(2, '0');

  /// Powered by the Apocalypse move: 2d6 + stat.
  PresetRoll pbta({int stat = 0}) {
    final roll = _engine.roll('2d6${_signed(stat)}');
    final t = roll.total;
    return PresetRoll(
      kind: DicePresetKind.pbta,
      params: {'stat': stat},
      roll: roll,
      outcome: t >= 10
          ? DiceOutcome.fullSuccess
          : t >= 7
              ? DiceOutcome.partialSuccess
              : DiceOutcome.miss,
    );
  }

  /// Blades in the Dark action roll: highest of a d6 pool; an empty pool
  /// rolls 2d6 and takes the lowest (and cannot crit).
  PresetRoll blades({int dice = 1}) {
    final pool = dice.clamp(0, 20);
    final roll = _engine.roll(pool == 0 ? '2d6kl1' : '${pool}d6kh1');
    final sixes = roll.terms.first.dice.where((d) => d.value == 6).length;
    final t = roll.total;
    return PresetRoll(
      kind: DicePresetKind.blades,
      params: {'dice': pool},
      roll: roll,
      outcome: t == 6
          ? (pool > 0 && sixes >= 2
              ? DiceOutcome.criticalSuccess
              : DiceOutcome.fullSuccess)
          : t >= 4
              ? DiceOutcome.partialSuccess
              : DiceOutcome.failure,
    );
  }

  /// Fate: 4dF + skill, read on the ladder.
  PresetRoll fate({int skill = 0}) {
    final roll = _engine.roll('4dF${_signed(skill)}');
    return PresetRoll(
      kind: DicePresetKind.fate,
      params: {'skill': skill},
      roll: roll,
      rung: FateRung.of(roll.total),
    );
  }

  /// Year Zero Engine: a d6 pool, every six is a success.
  PresetRoll yearZero({int dice = 1}) {
    final pool = dice.clamp(1, 50);
    final roll = _engine.roll('${pool}d6>=6');
    return PresetRoll(
      kind: DicePresetKind.yearZero,
      params: {'dice': pool},
      roll: roll,
      successes: roll.total,
      outcome: roll.total > 0 ? DiceOutcome.success : DiceOutcome.failure,
    );
  }

  static const savageTraitDice = [4, 6, 8, 10, 12];

  /// Savage Worlds trait test: trait die and wild d6 both ace (explode),
  /// the higher counts; target number 4, a raise per 4 above. Natural 1 on
  /// both dice is a critical failure.
  PresetRoll savageWorlds(
      {int traitDie = 6, int modifier = 0, bool wildDie = true}) {
    final sides = savageTraitDice.contains(traitDie) ? traitDie : 6;
    final trait = _engine.roll('1d$sides!').terms.first;
    final wild = wildDie ? _engine.roll('1d6!').terms.first : null;
    final useWild = wild != null && wild.value > trait.value;
    final best = useWild ? wild.value : trait.value;
    final total = best + modifier;
    final snakeEyes = trait.dice.first.value == 1 &&
        (wild == null || wild.dice.first.value == 1);

    List<RolledDie> mark(DiceTermResult t, bool drop) =>
        [for (final d in t.dice) d.copyWith(dropped: drop)];
    final terms = <DiceTermResult>[
      DiceTermResult(
          notation: '1d$sides!',
          value: trait.value,
          dice: mark(trait, useWild)),
      if (wild != null)
        DiceTermResult(
            notation: '1d6!', value: wild.value, dice: mark(wild, !useWild)),
      if (modifier != 0)
        DiceTermResult(notation: '$modifier', value: modifier, isConstant: true),
    ];
    String faces(DiceTermResult t) => t.dice.map((d) => d.display).join(', ');
    final formula =
        '1d$sides!${wild == null ? '' : ' | 1d6!'}${_signed(modifier)}';
    final breakdown = '1d$sides! (${faces(trait)})'
        '${wild == null ? '' : ' | 1d6! (${faces(wild)})'}'
        '${_signed(modifier)}';

    return PresetRoll(
      kind: DicePresetKind.savageWorlds,
      params: {'traitDie': sides, 'modifier': modifier, 'wildDie': wildDie},
      roll: DiceRollResult(
          expression: formula, total: total, terms: terms, breakdown: breakdown),
      outcome: snakeEyes
          ? DiceOutcome.criticalFailure
          : total >= 8
              ? DiceOutcome.raise
              : total >= 4
                  ? DiceOutcome.success
                  : DiceOutcome.failure,
    );
  }

  /// Cyberpunk RED check: d10 + stat + skill ([base]); a natural 10 adds
  /// another d10, a natural 1 subtracts one.
  PresetRoll cyberpunkRed({int base = 0}) {
    final first = random.nextInt(10) + 1;
    int? extra;
    if (first == 10 || first == 1) extra = random.nextInt(10) + 1;
    final delta = extra == null ? 0 : (first == 10 ? extra : -extra);
    final total = first + delta + base;
    final terms = <DiceTermResult>[
      DiceTermResult(
        notation: '1d10',
        value: first,
        dice: [
          RolledDie(first,
              critical: first == 10, fumble: first == 1, exploded: first == 10)
        ],
      ),
      if (extra != null)
        DiceTermResult(
            notation: first == 10 ? '+1d10' : '-1d10',
            value: delta,
            dice: [RolledDie(extra)]),
      if (base != 0)
        DiceTermResult(notation: '$base', value: base, isConstant: true),
    ];
    final extraText =
        extra == null ? '' : (first == 10 ? ' + 1d10 ($extra)' : ' - 1d10 ($extra)');
    return PresetRoll(
      kind: DicePresetKind.cyberpunkRed,
      params: {'base': base},
      outcome: first == 10
          ? DiceOutcome.criticalSuccess
          : first == 1
              ? DiceOutcome.criticalFailure
              : DiceOutcome.none,
      roll: DiceRollResult(
        expression: '1d10${_signed(base)}',
        total: total,
        terms: terms,
        breakdown: '1d10 ($first)$extraText${_signed(base)}',
      ),
    );
  }
}
