import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'entity_template.dart';

/// Building blocks a custom section can include. The constructor lets the
/// user add/remove these; the entry page renders only what is enabled.
enum CategoryModule {
  /// Structured fields defined in the blueprint (or the generic defaults).
  fields,

  /// The rich-text document editor.
  document,

  /// Image gallery.
  gallery,

  /// Non-image file attachments.
  attachments,

  /// Tag editor.
  tags,

  /// Relations / backlinks panel.
  relations;

  static CategoryModule? tryParse(String name) =>
      values.where((m) => m.name == name).firstOrNull;
}

/// Field types the constructor offers (a safe subset of [FieldType] —
/// entity references stay template-driven).
const blueprintFieldTypes = [
  FieldType.text,
  FieldType.longText,
  FieldType.number,
  FieldType.select,
  FieldType.date,
  FieldType.checklist,
  FieldType.stringList,
];

/// One user-defined field of a custom section.
@immutable
class BlueprintField {
  final String key;
  final String label;
  final FieldType type;

  /// Options for [FieldType.select].
  final List<String> options;

  const BlueprintField({
    required this.key,
    required this.label,
    required this.type,
    this.options = const [],
  });

  FieldDef toFieldDef() =>
      FieldDef(key: key, label: label, type: type, options: options);

  Map<String, Object?> toJson() => {
        'key': key,
        'label': label,
        'type': type.name,
        if (options.isNotEmpty) 'options': options,
      };

  static BlueprintField? fromJson(Map<String, Object?> json) {
    final key = json['key'];
    final label = json['label'];
    final type = FieldType.values
        .where((t) => t.name == json['type'])
        .firstOrNull;
    if (key is! String || key.isEmpty || label is! String || type == null) {
      return null;
    }
    return BlueprintField(
      key: key,
      label: label,
      type: blueprintFieldTypes.contains(type) ? type : FieldType.text,
      options: ((json['options'] as List?) ?? const [])
          .map((o) => o.toString())
          .toList(),
    );
  }
}

/// The full construction plan of a custom section: which modules it has and
/// which structured fields its entries carry. Stored as JSON on the
/// category; an empty/absent blueprint means "everything on, generic
/// fields" so existing categories keep working unchanged.
@immutable
class CategoryBlueprint {
  final Set<CategoryModule> modules;
  final List<BlueprintField> fields;

  const CategoryBlueprint({
    this.modules = const {...CategoryModule.values},
    this.fields = const [],
  });

  static const CategoryBlueprint standard = CategoryBlueprint();

  bool has(CategoryModule module) => modules.contains(module);

  CategoryBlueprint copyWith({
    Set<CategoryModule>? modules,
    List<BlueprintField>? fields,
  }) =>
      CategoryBlueprint(
        modules: modules ?? this.modules,
        fields: fields ?? this.fields,
      );

  String toJson() => jsonEncode({
        'modules': [for (final m in modules) m.name],
        'fields': [for (final f in fields) f.toJson()],
      });

  /// Parses stored JSON; anything malformed falls back to [standard].
  static CategoryBlueprint parse(String? json) {
    if (json == null || json.trim().isEmpty || json.trim() == '{}') {
      return standard;
    }
    try {
      final map = (jsonDecode(json) as Map).cast<String, Object?>();
      final moduleNames = (map['modules'] as List?)?.cast<Object?>();
      final modules = moduleNames == null
          ? const {...CategoryModule.values}
          : {
              for (final name in moduleNames)
                if (CategoryModule.tryParse('$name') != null)
                  CategoryModule.tryParse('$name')!
            };
      final fields = <BlueprintField>[];
      for (final raw in (map['fields'] as List?) ?? const []) {
        if (raw is Map) {
          final field = BlueprintField.fromJson(raw.cast<String, Object?>());
          if (field != null) fields.add(field);
        }
      }
      return CategoryBlueprint(
        // A section with no modules at all would be an empty page; keep at
        // least the fields module so entries remain editable.
        modules: modules.isEmpty ? {CategoryModule.fields} : modules,
        fields: fields,
      );
    } catch (_) {
      return standard;
    }
  }

  /// The attribute sections the entry page should render: the constructor's
  /// own fields when defined, else null (caller falls back to the generic
  /// custom template).
  List<FieldSection>? toSections(String sectionTitle) {
    if (fields.isEmpty) return null;
    return [
      FieldSection(sectionTitle, [for (final f in fields) f.toFieldDef()]),
    ];
  }
}
