import 'package:flutter/foundation.dart';

import '../combat/json_read.dart';
import '../models/world_object.dart';

/// One row of a [RandomTable]. [from]/[to] are the inclusive range the
/// table's dice formula must hit; [weight] is used when the table has no
/// formula.
@immutable
class RandomTableRow {
  final String text;
  final int weight;
  final int? from;
  final int? to;

  const RandomTableRow(this.text, {this.weight = 1, this.from, this.to});

  bool get hasRange => from != null && to != null;

  factory RandomTableRow.fromJson(Object? json) {
    if (json is String) return RandomTableRow(json);
    if (json is! Map) return const RandomTableRow('');
    final from = readNum(json['from'])?.round();
    final to = readNum(json['to'])?.round();
    return RandomTableRow(
      readString(json['text']),
      weight: readInt(json['weight'], 1).clamp(1, 1000000),
      // A half-written range is no range: one end alone matches nothing.
      from: from != null && to != null ? from : null,
      to: from != null && to != null ? to : null,
    );
  }

  Map<String, Object?> toJson() => {
        'text': text,
        'weight': weight,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      };

  RandomTableRow copyWith({
    String? text,
    int? weight,
    int? Function()? from,
    int? Function()? to,
  }) =>
      RandomTableRow(
        text ?? this.text,
        weight: weight ?? this.weight,
        from: from != null ? from() : this.from,
        to: to != null ? to() : this.to,
      );

  /// Same row without a range.
  RandomTableRow withoutRange() => RandomTableRow(text, weight: weight);

  @override
  bool operator ==(Object other) =>
      other is RandomTableRow &&
      other.text == text &&
      other.weight == weight &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(text, weight, from, to);

  @override
  String toString() =>
      'Row(${hasRange ? '$from-$to ' : ''}x$weight "$text")';
}

/// Where a table came from: written by the user or copied from the
/// built-in library ([libraryPrefix] + library id).
abstract final class RandomTableSource {
  static const user = 'user';
  static const libraryPrefix = 'library:';

  static String library(String id) => '$libraryPrefix$id';

  static String? libraryId(String source) =>
      source.startsWith(libraryPrefix)
          ? source.substring(libraryPrefix.length)
          : null;
}

/// A rollable table ([WorldObjectTypes.randomTable]).
@immutable
class RandomTable {
  final String id;
  final String worldId;
  final String name;
  final String description;

  /// Free-text group shown as a section in the table list.
  final String folder;

  /// Dice formula such as `1d20`; empty rolls by row weights.
  final String formula;
  final List<RandomTableRow> rows;
  final String source;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;

  const RandomTable({
    this.id = '',
    this.worldId = '',
    required this.name,
    this.description = '',
    this.folder = '',
    this.formula = '',
    this.rows = const [],
    this.source = RandomTableSource.user,
    this.sortOrder = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  bool get usesFormula => formula.trim().isNotEmpty;

  factory RandomTable.fromObject(WorldObject object) {
    final d = object.data;
    final source = readString(d['source']).trim();
    return RandomTable(
      id: object.id,
      worldId: object.worldId,
      name: object.name,
      description: readString(d['description']),
      folder: readString(d['folder']).trim(),
      formula: readString(d['formula']).trim(),
      rows: [for (final r in readList(d['rows'])) RandomTableRow.fromJson(r)],
      source: source.isEmpty ? RandomTableSource.user : source,
      sortOrder: object.sortOrder,
      createdAt: object.createdAt,
      updatedAt: object.updatedAt,
    );
  }

  Map<String, Object?> toData() => {
        'description': description,
        'folder': folder,
        'formula': formula,
        'rows': [for (final r in rows) r.toJson()],
        'source': source,
      };

  WorldObject toObject() => WorldObject(
        id: id,
        worldId: worldId,
        type: WorldObjectTypes.randomTable,
        name: name,
        data: toData(),
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  RandomTable copyWith({
    String? name,
    String? description,
    String? folder,
    String? formula,
    List<RandomTableRow>? rows,
    String? source,
  }) =>
      RandomTable(
        id: id,
        worldId: worldId,
        name: name ?? this.name,
        description: description ?? this.description,
        folder: folder ?? this.folder,
        formula: formula ?? this.formula,
        rows: rows ?? this.rows,
        source: source ?? this.source,
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
