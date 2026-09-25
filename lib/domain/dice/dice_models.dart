import 'package:flutter/foundation.dart';

/// Machine-readable reasons a dice expression is rejected; the UI maps each
/// to a localized message.
enum DiceErrorCode {
  empty,
  tooLong,
  unexpectedChar,
  unexpectedEnd,
  expectedNumber,
  unbalancedParen,
  tooManyDice,
  badSides,
  numberTooLarge,
  divisionByZero,
  duplicateModifier,
  impossibleReroll,
  unterminatedLabel,
}

class DiceParseException implements Exception {
  final DiceErrorCode code;

  /// Zero-based offset into [source] where the problem was found.
  final int position;
  final String source;

  const DiceParseException(this.code, this.position, this.source);

  @override
  String toString() => 'DiceParseException(${code.name} at $position: $source)';
}

/// One physical die after all modifiers were applied.
@immutable
class RolledDie {
  final int value;

  /// Removed by keep/drop; does not count towards the term.
  final bool dropped;

  /// Triggered an explosion (for compounding dice: absorbed extra rolls).
  final bool exploded;
  final bool rerolled;

  /// Natural maximum face.
  final bool critical;

  /// Natural 1.
  final bool fumble;
  final bool success;
  final bool failure;

  const RolledDie(
    this.value, {
    this.dropped = false,
    this.exploded = false,
    this.rerolled = false,
    this.critical = false,
    this.fumble = false,
    this.success = false,
    this.failure = false,
  });

  bool get kept => !dropped;

  RolledDie copyWith({
    int? value,
    bool? dropped,
    bool? exploded,
    bool? rerolled,
    bool? critical,
    bool? fumble,
    bool? success,
    bool? failure,
  }) =>
      RolledDie(
        value ?? this.value,
        dropped: dropped ?? this.dropped,
        exploded: exploded ?? this.exploded,
        rerolled: rerolled ?? this.rerolled,
        critical: critical ?? this.critical,
        fumble: fumble ?? this.fumble,
        success: success ?? this.success,
        failure: failure ?? this.failure,
      );

  /// Compact text form used in breakdowns: `~1~` dropped, `6!` exploded,
  /// `5*` success, `1x` failure.
  String get display {
    var text = '$value';
    if (exploded) text = '$text!';
    if (success) text = '$text*';
    if (failure) text = '${text}x';
    return dropped ? '~$text~' : text;
  }

  @override
  bool operator ==(Object other) =>
      other is RolledDie &&
      other.value == value &&
      other.dropped == dropped &&
      other.exploded == exploded &&
      other.rerolled == rerolled &&
      other.critical == critical &&
      other.fumble == fumble &&
      other.success == success &&
      other.failure == failure;

  @override
  int get hashCode => Object.hash(value, dropped, exploded, rerolled, critical,
      fumble, success, failure);

  @override
  String toString() => display;
}

/// The evaluated value of one term (a dice group or a constant).
@immutable
class DiceTermResult {
  /// Canonical notation of the term, e.g. `4d6kh3` or `5`.
  final String notation;
  final String? label;
  final int value;
  final List<RolledDie> dice;
  final bool isConstant;

  /// The term's value is a success count rather than a sum.
  final bool countsSuccesses;

  const DiceTermResult({
    required this.notation,
    this.label,
    required this.value,
    this.dice = const [],
    this.isConstant = false,
    this.countsSuccesses = false,
  });
}

@immutable
class DiceRollResult {
  /// Canonical text of the rolled expression.
  final String expression;
  final int total;
  final List<DiceTermResult> terms;

  /// The expression with every dice term followed by its faces, e.g.
  /// `4d6kh3 (6, 5, 3, ~1~) + 2`.
  final String breakdown;

  const DiceRollResult({
    required this.expression,
    required this.total,
    required this.terms,
    required this.breakdown,
  });

  Iterable<RolledDie> get allDice => terms.expand((t) => t.dice);

  bool get hasCritical => allDice.any((d) => d.kept && d.critical);
  bool get hasFumble => allDice.any((d) => d.kept && d.fumble);
}
