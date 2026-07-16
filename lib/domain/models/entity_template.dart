import 'package:flutter/foundation.dart';

import '../../core/utils/ids.dart';
import 'entity_kind.dart';

/// The type of a structured attribute field.
enum FieldType {
  /// Single-line text.
  text,

  /// Multi-line text.
  longText,

  /// Numeric value.
  number,

  /// One value from [FieldDef.options].
  select,

  /// Free-form list of strings (e.g. player names, titles).
  stringList,

  /// Checklist of `{text, done}` items (quest objectives, session agenda).
  checklist,

  /// Reference to another entity (stored as `entity:<uuid>`), mirrored into
  /// the links table so it appears in backlinks and the graph.
  entityRef,

  /// Ordered list of entity references.
  entityRefList,

  /// Date/time stored as ISO-8601 string (in-world dates are plain [text]).
  date,
}

/// Declarative definition of one structured field on an entity kind.
@immutable
class FieldDef {
  final String key;
  final String label;
  final FieldType type;

  /// Allowed values for [FieldType.select].
  final List<String> options;

  /// For entityRef fields: which kinds the picker offers (empty = any).
  final List<EntityKind> refKinds;

  /// Link role written when mirroring entityRef fields into the links table.
  final String linkRole;

  final String hint;

  const FieldDef({
    required this.key,
    required this.label,
    required this.type,
    this.options = const [],
    this.refKinds = const [],
    this.linkRole = 'related',
    this.hint = '',
  });
}

/// A group of fields rendered as one section on the entity page.
@immutable
class FieldSection {
  final String title;
  final List<FieldDef> fields;
  const FieldSection(this.title, this.fields);
}

/// Declarative schema for one [EntityKind]: which structured fields it has
/// and how they are grouped. Adding/changing templates requires no database
/// migration — attributes are stored as JSON and unknown keys are preserved.
@immutable
class EntityTemplate {
  final EntityKind kind;
  final List<FieldSection> sections;

  const EntityTemplate({required this.kind, required this.sections});

  List<FieldDef> get allFields =>
      [for (final s in sections) ...s.fields];

  FieldDef? field(String key) {
    for (final f in allFields) {
      if (f.key == key) return f;
    }
    return null;
  }

  /// Extracts every entity reference held in [attributes] together with the
  /// link role of its field — used to mirror structured refs into the
  /// links table.
  Map<String, String> extractEntityRefs(Map<String, Object?> attributes) {
    final refs = <String, String>{}; // entityId -> role
    for (final field in allFields) {
      final value = attributes[field.key];
      switch (field.type) {
        case FieldType.entityRef:
          final id = parseEntityRef(value);
          if (id != null) refs[id] = field.linkRole;
        case FieldType.entityRefList:
          if (value is List) {
            for (final item in value) {
              final id = parseEntityRef(item);
              if (id != null) refs[id] = field.linkRole;
            }
          }
        default:
          break;
      }
    }
    return refs;
  }

  /// Normalizes raw attribute JSON: keeps unknown keys (forward
  /// compatibility), coerces obviously-wrong types to safe defaults.
  Map<String, Object?> sanitize(Map<String, Object?> attributes) {
    final result = Map<String, Object?>.of(attributes);
    for (final field in allFields) {
      final value = result[field.key];
      if (value == null) continue;
      switch (field.type) {
        case FieldType.text:
        case FieldType.longText:
        case FieldType.date:
        case FieldType.entityRef:
          if (value is! String) result[field.key] = value.toString();
        case FieldType.select:
          if (value is! String || !field.options.contains(value)) {
            result.remove(field.key);
          }
        case FieldType.number:
          if (value is! num) {
            final parsed = num.tryParse(value.toString());
            if (parsed == null) {
              result.remove(field.key);
            } else {
              result[field.key] = parsed;
            }
          }
        case FieldType.stringList:
        case FieldType.entityRefList:
          if (value is! List) result.remove(field.key);
        case FieldType.checklist:
          if (value is! List) {
            result.remove(field.key);
          } else {
            result[field.key] = [
              for (final item in value)
                if (item is Map)
                  {
                    'text': item['text']?.toString() ?? '',
                    'done': item['done'] == true,
                  }
            ];
          }
      }
    }
    return result;
  }
}
