import '../models/world_object.dart';
import '../repositories/repositories.dart';
import 'dice_engine.dart';
import 'dice_presets.dart';

/// One logged roll, stored as a [WorldObjectTypes.diceRoll] object.
class DiceHistoryEntry {
  final String id;
  final String expression;
  final int total;
  final String breakdown;
  final String label;
  final DicePresetKind? preset;
  final Map<String, Object?> params;
  final DiceOutcome outcome;
  final int createdAt;

  const DiceHistoryEntry({
    this.id = '',
    required this.expression,
    required this.total,
    this.breakdown = '',
    this.label = '',
    this.preset,
    this.params = const {},
    this.outcome = DiceOutcome.none,
    this.createdAt = 0,
  });

  factory DiceHistoryEntry.fromObject(WorldObject o) {
    final d = o.data;
    final total = d['total'];
    final params = d['params'];
    return DiceHistoryEntry(
      id: o.id,
      expression: d['expression'] is String ? d['expression'] as String : '',
      total: total is num ? total.toInt() : int.tryParse('$total') ?? 0,
      breakdown: d['breakdown'] is String ? d['breakdown'] as String : '',
      label: d['label'] is String ? d['label'] as String : '',
      preset: DicePresetKind.byName(d['preset']),
      params: params is Map
          ? {for (final e in params.entries) '${e.key}': e.value}
          : const {},
      outcome: DiceOutcome.byName(d['outcome']),
      createdAt: o.createdAt,
    );
  }

  Map<String, Object?> toData() => {
        'expression': expression,
        'total': total,
        'breakdown': breakdown,
        'label': label,
        if (preset != null) 'preset': preset!.name,
        if (preset != null) 'params': params,
        if (outcome != DiceOutcome.none) 'outcome': outcome.name,
      };

  /// Plain-text line for the clipboard.
  String get shareText {
    final head = label.isEmpty ? expression : '$label: $expression';
    return breakdown.isEmpty
        ? '$head = $total'
        : '$head = $total  ·  $breakdown';
  }

  static DiceHistoryEntry fromRoll(DiceRollResult roll, {String label = ''}) =>
      DiceHistoryEntry(
        expression: roll.expression,
        total: roll.total,
        breakdown: roll.breakdown,
        label: label.trim(),
      );

  static DiceHistoryEntry fromPreset(PresetRoll roll, {String label = ''}) =>
      DiceHistoryEntry(
        expression: roll.roll.expression,
        total: roll.total,
        breakdown: roll.roll.breakdown,
        label: label.trim(),
        preset: roll.kind,
        params: roll.params,
        outcome: roll.outcome,
      );
}

/// The roll log of a world: newest entries win, the oldest are trimmed.
abstract final class DiceHistory {
  static const keep = 200;

  /// Newest first.
  static List<DiceHistoryEntry> fromObjects(List<WorldObject> objects) {
    final sorted = [...objects]..sort((a, b) {
        final c = b.createdAt.compareTo(a.createdAt);
        return c != 0 ? c : b.sortOrder.compareTo(a.sortOrder);
      });
    return [for (final o in sorted) DiceHistoryEntry.fromObject(o)];
  }

  static Future<void> log(WorldObjectRepository repository, String worldId,
      DiceHistoryEntry entry) async {
    await repository.create(
      worldId: worldId,
      type: WorldObjectTypes.diceRoll,
      name: entry.label.isEmpty ? entry.expression : entry.label,
      data: entry.toData(),
    );
    await repository.trim(worldId, WorldObjectTypes.diceRoll, keep: keep);
  }

  static Future<void> clear(WorldObjectRepository repository, String worldId) =>
      repository.trim(worldId, WorldObjectTypes.diceRoll, keep: 0);
}
