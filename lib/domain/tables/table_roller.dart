import 'dart:math';

import 'package:flutter/foundation.dart';

import '../dice/dice_engine.dart';
import '../models/world_object.dart';
import '../repositories/repositories.dart';
import 'random_table.dart';
import 'table_ranges.dart';

/// Why a table (or a nested `[[reference]]`) produced no row.
enum TableRollFailure {
  /// No table of the world has the referenced name.
  notFound,

  /// The reference leads back to a table already being rolled.
  cycle,

  /// Nested deeper than [TableRoller.maxDepth].
  depthLimit,

  /// The roll expanded more nested tables than [TableRoller.maxTableRolls].
  tooMany,

  /// The table has no rows with text.
  empty,

  /// The table's dice formula does not parse.
  badFormula,
}

/// One inline expansion inside a row's text, in reading order.
@immutable
sealed class TableRollPart {
  const TableRollPart();
}

/// `{2d6}` — a dice expression rolled with the dice engine.
final class DicePart extends TableRollPart {
  final String expression;
  final int total;
  final String breakdown;
  const DicePart(this.expression, this.total, this.breakdown);
}

/// `{a|b|c}` — one alternative picked uniformly; [parts] are the
/// expansions inside the chosen alternative.
final class ChoicePart extends TableRollPart {
  final List<String> options;
  final int index;
  final String text;
  final List<TableRollPart> parts;
  const ChoicePart(this.options, this.index, this.text, this.parts);

  String get chosen => options[index];
}

/// `[[Other table]]` — a nested roll, or why it failed.
final class TablePart extends TableRollPart {
  final String name;
  final TableRollResult result;
  const TablePart(this.name, this.result);
}

/// A table roll with everything needed to explain it: the dice total,
/// the chosen row, whether the total had to be clamped onto the nearest
/// row, and the nested expansions.
@immutable
class TableRollResult {
  final String tableId;
  final String tableName;
  final String formula;

  /// Dice total for formula tables; null when rolled by weight.
  final int? total;
  final String? breakdown;

  /// Index into the table's rows; null when the roll failed.
  final int? rowIndex;

  /// The total fell outside every range and was moved to the nearest row.
  final bool clamped;

  /// The chosen row's raw text.
  final String rowText;

  /// The fully expanded text.
  final String text;
  final List<TableRollPart> parts;
  final TableRollFailure? failure;

  const TableRollResult({
    required this.tableId,
    required this.tableName,
    this.formula = '',
    this.total,
    this.breakdown,
    this.rowIndex,
    this.clamped = false,
    this.rowText = '',
    this.text = '',
    this.parts = const [],
    this.failure,
  });

  bool get ok => failure == null;

  /// Nested table results (direct children, including those inside chosen
  /// alternatives), in reading order.
  List<TablePart> get nestedTables {
    final out = <TablePart>[];
    void walk(List<TableRollPart> parts) {
      for (final p in parts) {
        switch (p) {
          case TablePart():
            out.add(p);
          case ChoicePart(:final parts):
            walk(parts);
          case DicePart():
            break;
        }
      }
    }

    walk(parts);
    return out;
  }

  /// True when this roll or any nested one failed.
  bool get hasFailure =>
      failure != null || nestedTables.any((t) => t.result.hasFailure);
}

/// Finds a table by the name used in a `[[reference]]`.
typedef TableResolver = RandomTable? Function(String name);

/// Key for case- and spacing-insensitive table name lookups.
String tableNameKey(String name) =>
    name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

/// Rolls random tables. Pure: all randomness comes from [random].
class TableRoller {
  static const maxDepth = 6;
  static const maxTableRolls = 500;

  /// Marks a nested reference that could not be rolled in [TableRollResult.text].
  static const failureMark = '⚠';

  final Random random;
  final TableResolver resolve;
  int _tableRolls = 0;

  TableRoller({required this.random, required this.resolve});

  /// A roller whose `[[references]]` resolve among [tables]; with duplicate
  /// names the first one wins.
  factory TableRoller.forTables(
    Iterable<RandomTable> tables, {
    required Random random,
  }) {
    final byName = <String, RandomTable>{};
    for (final t in tables) {
      byName.putIfAbsent(tableNameKey(t.name), () => t);
    }
    return TableRoller(
      random: random,
      resolve: (name) => byName[tableNameKey(name)],
    );
  }

  TableRollResult roll(RandomTable table) {
    _tableRolls = 0;
    return _rollTable(table, 0, const []);
  }

  static String _key(RandomTable t) =>
      t.id.isNotEmpty ? t.id : 'name:${tableNameKey(t.name)}';

  TableRollResult _rollTable(RandomTable table, int depth, List<String> path) {
    _tableRolls++;
    TableRollResult fail(TableRollFailure f, {int? total, String? breakdown}) =>
        TableRollResult(
          tableId: table.id,
          tableName: table.name,
          formula: table.formula,
          total: total,
          breakdown: breakdown,
          failure: f,
        );

    final candidates = <int>[
      for (var i = 0; i < table.rows.length; i++)
        if (table.rows[i].text.trim().isNotEmpty) i,
    ];
    if (candidates.isEmpty) return fail(TableRollFailure.empty);

    int? total;
    String? breakdown;
    var clamped = false;
    int index;
    if (table.usesFormula) {
      final DiceRollResult dice;
      try {
        dice = DiceEngine(random: random).roll(table.formula);
      } on DiceParseException {
        return fail(TableRollFailure.badFormula);
      }
      total = dice.total;
      breakdown = dice.breakdown;
      final pick = _pickByTotal(table, candidates, total);
      if (pick == null) {
        return fail(TableRollFailure.empty, total: total, breakdown: breakdown);
      }
      (index, clamped) = pick;
    } else {
      index = _pickByWeight(table, candidates);
    }

    final rowText = table.rows[index].text;
    final parts = <TableRollPart>[];
    final text = _expand(rowText, depth, [...path, _key(table)], parts);
    return TableRollResult(
      tableId: table.id,
      tableName: table.name,
      formula: table.formula,
      total: total,
      breakdown: breakdown,
      rowIndex: index,
      clamped: clamped,
      rowText: rowText,
      text: text,
      parts: parts,
    );
  }

  int _pickByWeight(RandomTable table, List<int> candidates) {
    final sum = candidates.fold<int>(
      0,
      (s, i) => s + max(1, table.rows[i].weight),
    );
    var r = random.nextInt(sum);
    for (final i in candidates) {
      r -= max(1, table.rows[i].weight);
      if (r < 0) return i;
    }
    return candidates.last;
  }

  /// The row whose range contains [total]; outside every range, the
  /// nearest row (ties go to the earlier row) with `clamped` set.
  (int, bool)? _pickByTotal(
    RandomTable table,
    List<int> candidates,
    int total,
  ) {
    var ranges = <(int, int, int)>[
      for (final i in candidates)
        if (table.rows[i].hasRange && table.rows[i].from! <= table.rows[i].to!)
          (table.rows[i].from!, table.rows[i].to!, i),
    ];
    if (ranges.isEmpty) {
      // No ranges written yet: spread the rows over the formula's totals.
      final bounds = formulaBounds(table.formula);
      if (bounds == null) return null;
      final rows = autoRanges([
        for (final i in candidates) table.rows[i].withoutRange(),
      ], bounds);
      ranges = [
        for (var k = 0; k < rows.length; k++)
          if (rows[k].hasRange) (rows[k].from!, rows[k].to!, candidates[k]),
      ];
      if (ranges.isEmpty) return null;
    }
    for (final (from, to, i) in ranges) {
      if (total >= from && total <= to) return (i, false);
    }
    var best = ranges.first;
    var bestDistance = 1 << 62;
    for (final r in ranges) {
      final distance = total < r.$1 ? r.$1 - total : total - r.$2;
      if (distance < bestDistance ||
          (distance == bestDistance && r.$3 < best.$3)) {
        best = r;
        bestDistance = distance;
      }
    }
    return (best.$3, true);
  }

  String _expand(
    String text,
    int depth,
    List<String> path,
    List<TableRollPart> parts,
  ) {
    final out = StringBuffer();
    var i = 0;
    while (i < text.length) {
      if (text.startsWith('[[', i)) {
        final end = text.indexOf(']]', i + 2);
        final name = end < 0 ? '' : text.substring(i + 2, end).trim();
        if (end < 0 || name.isEmpty) {
          out.write('[[');
          i += 2;
          continue;
        }
        final part = _rollReference(name, depth, path);
        parts.add(part);
        out.write(part.result.ok ? part.result.text : '$failureMark[[$name]]');
        i = end + 2;
        continue;
      }
      if (text[i] == '{') {
        final end = _matchingBrace(text, i);
        if (end < 0) {
          out.write(text.substring(i));
          break;
        }
        final inner = text.substring(i + 1, end);
        final options = _splitAlternatives(inner);
        if (options.length > 1) {
          final index = random.nextInt(options.length);
          final sub = <TableRollPart>[];
          final chosen = _expand(options[index], depth, path, sub);
          parts.add(ChoicePart(options, index, chosen, sub));
          out.write(chosen);
        } else {
          final expression = inner.trim();
          DiceRollResult? dice;
          if (expression.isNotEmpty) {
            try {
              dice = DiceEngine(random: random).roll(expression);
            } on DiceParseException {
              dice = null;
            }
          }
          if (dice == null) {
            out.write(text.substring(i, end + 1));
          } else {
            parts.add(DicePart(expression, dice.total, dice.breakdown));
            out.write(dice.total);
          }
        }
        i = end + 1;
        continue;
      }
      out.write(text[i]);
      i++;
    }
    return out.toString();
  }

  TablePart _rollReference(String name, int depth, List<String> path) {
    TablePart fail(TableRollFailure f, [RandomTable? t]) => TablePart(
      name,
      TableRollResult(
        tableId: t?.id ?? '',
        tableName: t?.name ?? name,
        failure: f,
      ),
    );
    final table = resolve(name);
    if (table == null) return fail(TableRollFailure.notFound);
    if (path.contains(_key(table))) return fail(TableRollFailure.cycle, table);
    if (depth + 1 > maxDepth) return fail(TableRollFailure.depthLimit, table);
    if (_tableRolls >= maxTableRolls) {
      return fail(TableRollFailure.tooMany, table);
    }
    return TablePart(name, _rollTable(table, depth + 1, path));
  }

  /// Index of the `}` closing the `{` at [start] (nested braces count),
  /// or -1.
  static int _matchingBrace(String text, int start) {
    var level = 0;
    for (var k = start; k < text.length; k++) {
      final c = text[k];
      if (c == '{') level++;
      if (c == '}') {
        level--;
        if (level == 0) return k;
      }
    }
    return -1;
  }

  /// Splits on `|` outside nested braces and `[[…]]`.
  static List<String> _splitAlternatives(String inner) {
    final out = <String>[];
    var level = 0;
    var brackets = false;
    var start = 0;
    for (var k = 0; k < inner.length; k++) {
      if (inner.startsWith('[[', k)) {
        brackets = true;
      } else if (inner.startsWith(']]', k)) {
        brackets = false;
      }
      final c = inner[k];
      if (c == '{') level++;
      if (c == '}') level--;
      if (c == '|' && level == 0 && !brackets) {
        out.add(inner.substring(start, k));
        start = k + 1;
      }
    }
    out.add(inner.substring(start));
    return out;
  }
}

/// Every table of [worldId].
Future<List<RandomTable>> loadWorldTables(
  WorldObjectRepository repo,
  String worldId,
) async => [
  for (final o in await repo.list(worldId, WorldObjectTypes.randomTable))
    RandomTable.fromObject(o),
];

/// Rolls the world's table called [name] (case-insensitive) and returns
/// the expanded text, or null when the world has no such table or it
/// cannot be rolled (no rows, broken formula). For other tools that want
/// a table result ("roll on Weather").
Future<String?> rollTableByName(
  WorldObjectRepository repo,
  String worldId,
  String name,
  Random random,
) async {
  final tables = await loadWorldTables(repo, worldId);
  final roller = TableRoller.forTables(tables, random: random);
  final table = roller.resolve(name);
  if (table == null) return null;
  final result = roller.roll(table);
  return result.ok ? result.text : null;
}
