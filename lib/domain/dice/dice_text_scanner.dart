import 'dice_engine.dart';

/// A rollable dice expression found inside free text.
class DiceTextMatch {
  final int start;
  final int end;

  /// Rollable form of `text.substring(start, end)` (typographic minus
  /// signs normalized).
  final String expression;
  const DiceTextMatch(this.start, this.end, this.expression);

  @override
  String toString() => 'DiceTextMatch($start, $end, $expression)';
}

// A dice term, then any number of `± dice` / `± constant` tails. The
// lookarounds stop matches inside words ("d20s", "Hd6x").
final _pattern = RegExp(
  r'(?<![\w])\d{0,4}[dD](?:\d{1,5}|%)(?:\s*[+\-−]\s*(?:\d{0,4}[dD](?:\d{1,5}|%)|\d{1,6}))*(?![\w%])',
);

/// Finds dice expressions such as `2d6 + 3`, `1d20+5` or `8d6` in [text]
/// (stat blocks, attack lines). Only expressions the engine accepts are
/// returned, in order and non-overlapping.
List<DiceTextMatch> findDiceExpressions(String text) {
  final out = <DiceTextMatch>[];
  for (final m in _pattern.allMatches(text)) {
    final raw = m[0]!;
    final expression = raw.replaceAll('−', '-');
    if (!DiceEngine.isValid(expression)) continue;
    out.add(DiceTextMatch(m.start, m.end, expression));
  }
  return out;
}
