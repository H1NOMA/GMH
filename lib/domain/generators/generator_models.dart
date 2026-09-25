import 'package:flutter/foundation.dart';

import '../models/entity_kind.dart';
import '../models/world.dart';

/// Every generator the tool offers, in picker order.
enum GeneratorKind {
  names,
  npc,
  settlement,
  establishment,
  hook,
  loot,
  faction,
  weather,
  rumor;

  static GeneratorKind? tryParse(String? name) {
    for (final k in values) {
      if (k.name == name) return k;
    }
    return null;
  }
}

enum NameGender { any, feminine, masculine }

/// One labeled line of a generated result.
@immutable
class GeneratedField {
  /// Unique within its result (`item2`); used for per-field rerolls.
  final String key;

  /// Label key shared by similar fields (`item`), localized by the UI.
  final String label;
  final String value;

  /// Metadata of the first tagged fragment used (a select option, a name
  /// culture id…), mapped onto entity fields.
  final String? tag;

  const GeneratedField({
    required this.key,
    required this.label,
    required this.value,
    this.tag,
  });

  GeneratedField copyWith({required String value, String? tag}) =>
      GeneratedField(key: key, label: label, value: value, tag: tag);
}

/// What a result becomes when saved to the world.
@immutable
class EntityDraft {
  final EntityKind kind;
  final String name;
  final String summary;
  final Map<String, Object?> attributes;

  const EntityDraft({
    required this.kind,
    required this.name,
    this.summary = '',
    this.attributes = const {},
  });
}

/// Localized label for a field label key (e.g. `secret` → "Secret").
typedef FieldLabeler = String Function(String labelKey);

/// A structured generator result: title, fields and the state needed to
/// reroll single fields without repeating fragments.
@immutable
class GeneratedResult {
  final String id;
  final GeneratorKind kind;
  final WorldStyle style;
  final String language;
  final List<GeneratedField> fields;

  /// Key of the field shown as the title, if any.
  final String? titleKey;

  /// Generation variables (gender, name culture, ability scores…).
  final Map<String, String> vars;

  /// Every fragment used so far, so rerolls never repeat one.
  final Set<String> used;

  const GeneratedResult({
    required this.id,
    required this.kind,
    required this.style,
    required this.language,
    required this.fields,
    this.titleKey,
    this.vars = const {},
    this.used = const {},
  });

  GeneratedField? field(String key) {
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  String value(String key) => field(key)?.value ?? '';

  /// The title (empty when the generator has no title field).
  String get title => titleKey == null ? '' : value(titleKey!);

  /// Fields shown under the title.
  List<GeneratedField> get bodyFields =>
      [for (final f in fields) if (f.key != titleKey) f];

  GeneratedResult copyWith({
    List<GeneratedField>? fields,
    Map<String, String>? vars,
    Set<String>? used,
  }) =>
      GeneratedResult(
        id: id,
        kind: kind,
        style: style,
        language: language,
        fields: fields ?? this.fields,
        titleKey: titleKey,
        vars: vars ?? this.vars,
        used: used ?? this.used,
      );

  /// Plain text for the clipboard.
  String toText(FieldLabeler label, {String? heading}) {
    final lines = <String>[
      if (title.isNotEmpty) title else ?heading,
      for (final f in bodyFields) '${label(f.label)}: ${f.value}',
    ];
    return lines.join('\n');
  }
}

/// One generated name with its optional epithet and cultural note (a
/// courtesy name, a sect title…).
@immutable
class GeneratedName {
  final String name;

  /// `f` or `m`.
  final String gender;
  final String cultureId;
  final String? epithet;

  /// The name with its epithet, phrased for the language.
  final String display;
  final String? note;
  final String? race;

  const GeneratedName({
    required this.name,
    required this.gender,
    required this.cultureId,
    this.epithet,
    String? display,
    this.note,
    this.race,
  }) : display = display ?? name;

  String toText() => [display, ?note].join(' — ');
}

/// A naming style of a pack (e.g. elvish, street handles).
@immutable
class NameCulture {
  final String id;
  final String label;
  const NameCulture(this.id, this.label);
}
