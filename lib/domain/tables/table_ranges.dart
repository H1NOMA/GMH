import 'dart:math';

import 'package:flutter/foundation.dart';

import '../dice/dice_engine.dart';
import 'random_table.dart';

/// Smallest and largest total a dice formula can produce.
typedef FormulaBounds = ({int min, int max});

/// Bounds of [formula], or null when it does not parse. Exploding dice
/// count as their nominal faces (the range a table is written for).
FormulaBounds? formulaBounds(String formula) {
  final DiceExpression expression;
  try {
    expression = DiceEngine.parse(formula);
  } on DiceParseException {
    return null;
  }
  final (lo, hi) = _bounds(expression.root);
  return (min: lo, max: hi);
}

(int, int) _bounds(DiceNode node) {
  switch (node) {
    case ConstantNode(:final value):
      return (value, value);
    case DiceTermNode():
      if (node.countsSuccesses) {
        return (node.failure != null ? -node.count : 0, node.count);
      }
      var dice = node.count;
      final keep = node.keep;
      if (keep != null) {
        final isKeep =
            keep.mode == KeepMode.keepHighest ||
            keep.mode == KeepMode.keepLowest;
        dice = isKeep
            ? min(keep.count, node.count)
            : max(0, node.count - keep.count);
      }
      return (dice * node.minFace, dice * node.maxFace);
    case NegateNode(:final child):
      final (lo, hi) = _bounds(child);
      return (-hi, -lo);
    case GroupNode(:final child):
      return _bounds(child);
    case BinaryNode(:final op, :final left, :final right):
      final (a, b) = _bounds(left);
      final (c, d) = _bounds(right);
      switch (op) {
        case '+':
          return (a + c, b + d);
        case '-':
          return (a - d, b - c);
        default:
          final values = <int>[];
          for (final x in [a, b]) {
            for (final y in [c, d]) {
              if (op == '*') {
                values.add(x * y);
              } else if (y != 0) {
                values.add((x / y).floor());
              }
            }
          }
          if (values.isEmpty) return (0, 0);
          return (values.reduce(min), values.reduce(max));
      }
  }
}

/// Gives every row a range proportional to its weight so that the rows
/// cover [bounds] from top to bottom without gaps (largest remainder; each
/// row gets at least one value while there are enough values). Rows that
/// cannot get a value keep no range.
List<RandomTableRow> autoRanges(
  List<RandomTableRow> rows,
  FormulaBounds bounds,
) {
  if (rows.isEmpty) return const [];
  final span = bounds.max - bounds.min + 1;
  if (span <= 0) return [for (final r in rows) r.withoutRange()];
  final sizes = List<int>.filled(rows.length, 0);
  if (span <= rows.length) {
    for (var i = 0; i < span; i++) {
      sizes[i] = 1;
    }
  } else {
    // Proportional shares (at least one value each), then hand out the
    // difference by largest remainder / take it back from the largest.
    final totalWeight = rows.fold<int>(0, (sum, r) => sum + max(1, r.weight));
    final remainders = <(double, int)>[];
    var given = 0;
    for (var i = 0; i < rows.length; i++) {
      final exact = span * max(1, rows[i].weight) / totalWeight;
      sizes[i] = max(1, exact.floor());
      given += sizes[i];
      remainders.add((exact - exact.floor(), i));
    }
    remainders.sort((x, y) {
      final c = y.$1.compareTo(x.$1);
      return c != 0 ? c : x.$2.compareTo(y.$2);
    });
    for (var k = 0; given < span; k++, given++) {
      sizes[remainders[k % remainders.length].$2]++;
    }
    while (given > span) {
      var largest = 0;
      for (var i = 1; i < sizes.length; i++) {
        if (sizes[i] > sizes[largest]) largest = i;
      }
      sizes[largest]--;
      given--;
    }
  }
  final out = <RandomTableRow>[];
  var next = bounds.min;
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    if (sizes[i] == 0) {
      out.add(r.withoutRange());
      continue;
    }
    out.add(
      RandomTableRow(
        r.text,
        weight: r.weight,
        from: next,
        to: next + sizes[i] - 1,
      ),
    );
    next += sizes[i];
  }
  return out;
}

enum TableIssueKind {
  /// The formula does not parse.
  badFormula,

  /// The table has no rows (or only empty ones).
  empty,

  /// A row has no text.
  emptyRow,

  /// A formula table row without a range.
  missingRange,

  /// `from` is greater than `to`.
  invertedRange,

  /// The row's range lies (partly) outside what the formula can roll.
  outOfBounds,

  /// Totals [from]..[to] that no row covers; [rows] are the neighbours.
  gap,

  /// Totals [from]..[to] covered by both [rows].
  overlap,
}

/// A problem found by [validateTable]. [rows] are zero-based row indices.
@immutable
class TableIssue {
  final TableIssueKind kind;
  final List<int> rows;
  final int? from;
  final int? to;

  const TableIssue(this.kind, {this.rows = const [], this.from, this.to});

  @override
  bool operator ==(Object other) =>
      other is TableIssue &&
      other.kind == kind &&
      listEquals(other.rows, rows) &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(kind, Object.hashAll(rows), from, to);

  @override
  String toString() => 'TableIssue(${kind.name}, rows: $rows, $from..$to)';
}

/// Everything that would make the table roll unexpectedly.
List<TableIssue> validateTable(RandomTable table) {
  final issues = <TableIssue>[];
  final rows = table.rows;
  if (rows.every((r) => r.text.trim().isEmpty)) {
    issues.add(const TableIssue(TableIssueKind.empty));
  } else {
    for (var i = 0; i < rows.length; i++) {
      if (rows[i].text.trim().isEmpty) {
        issues.add(TableIssue(TableIssueKind.emptyRow, rows: [i]));
      }
    }
  }
  if (!table.usesFormula) return issues;
  final bounds = formulaBounds(table.formula);
  if (bounds == null) {
    issues.add(const TableIssue(TableIssueKind.badFormula));
    return issues;
  }
  return [...issues, ...validateRanges(rows, bounds)];
}

/// Range problems of [rows] for a formula rolling [bounds].
List<TableIssue> validateRanges(
  List<RandomTableRow> rows,
  FormulaBounds bounds,
) {
  final issues = <TableIssue>[];
  final ranged = <(int, int, int)>[]; // (from, to, row)
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    if (!r.hasRange) {
      issues.add(TableIssue(TableIssueKind.missingRange, rows: [i]));
      continue;
    }
    if (r.from! > r.to!) {
      issues.add(
        TableIssue(
          TableIssueKind.invertedRange,
          rows: [i],
          from: r.from,
          to: r.to,
        ),
      );
      continue;
    }
    if (r.from! < bounds.min || r.to! > bounds.max) {
      issues.add(
        TableIssue(
          TableIssueKind.outOfBounds,
          rows: [i],
          from: r.from,
          to: r.to,
        ),
      );
    }
    ranged.add((r.from!, r.to!, i));
  }
  ranged.sort((a, b) {
    final c = a.$1.compareTo(b.$1);
    return c != 0 ? c : a.$3.compareTo(b.$3);
  });

  // Overlaps between every pair (sorted, so stop once they start later).
  for (var a = 0; a < ranged.length; a++) {
    for (var b = a + 1; b < ranged.length; b++) {
      if (ranged[b].$1 > ranged[a].$2) break;
      final ia = ranged[a].$3;
      final ib = ranged[b].$3;
      issues.add(
        TableIssue(
          TableIssueKind.overlap,
          rows: ia < ib ? [ia, ib] : [ib, ia],
          from: ranged[b].$1,
          to: min(ranged[a].$2, ranged[b].$2),
        ),
      );
    }
  }

  // Gaps inside the formula's bounds.
  var covered = bounds.min - 1;
  int? previousRow;
  for (final (from, to, row) in ranged) {
    if (from > covered + 1 && covered + 1 <= bounds.max) {
      issues.add(
        TableIssue(
          TableIssueKind.gap,
          rows: [?previousRow, row],
          from: covered + 1,
          to: min(from - 1, bounds.max),
        ),
      );
    }
    if (to > covered) {
      covered = to;
      previousRow = row;
    }
  }
  if (covered < bounds.max) {
    issues.add(
      TableIssue(
        TableIssueKind.gap,
        rows: [?previousRow],
        from: covered + 1,
        to: bounds.max,
      ),
    );
  }
  return issues;
}

const _commonDice = [2, 3, 4, 6, 8, 10, 12, 20, 30, 100];

/// A formula matching imported ranges: `1dN` when the rows cover exactly
/// 1..N for a common die, `2d6` for 2..12; otherwise null.
String? suggestFormula(List<RandomTableRow> rows) {
  final ranged = rows.where((r) => r.hasRange).toList();
  if (ranged.isEmpty || ranged.length != rows.length) return null;
  final lo = ranged.map((r) => r.from!).reduce(min);
  final hi = ranged.map((r) => r.to!).reduce(max);
  if (lo == 1 && _commonDice.contains(hi)) return '1d$hi';
  if (lo == 2 && hi == 12) return '2d6';
  if (lo == 3 && hi == 18) return '3d6';
  if (lo == 2 && hi == 20) return '2d10';
  return null;
}
