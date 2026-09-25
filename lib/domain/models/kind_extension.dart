import '../repositories/repositories.dart';
import 'category_blueprint.dart';
import 'entity_kind.dart';
import 'entity_template.dart';
import 'world_object.dart';

/// Extra fields a world adds to a built-in kind (a "Sanity" score on every
/// character, a "Faction reputation" on locations…). Stored as one world
/// object per kind: type [WorldObjectTypes.kindExtension], name = the
/// kind's id, data `{fields: [BlueprintField json…]}`.
abstract final class KindExtensions {
  /// Title of the section holding a world's extra fields — a template
  /// term, translated wherever template terms are.
  static const sectionTitle = 'Custom Fields';

  static List<BlueprintField> fieldsOf(WorldObject? object) {
    final raw = object?.data['fields'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map)
          if (BlueprintField.fromJson(item.cast<String, Object?>())
              case final BlueprintField field)
            field
    ];
  }

  static Map<String, Object?> toData(List<BlueprintField> fields) => {
        'fields': [for (final f in fields) f.toJson()],
      };

  /// The extension object for [kind] among a world's extension objects.
  static WorldObject? objectFor(List<WorldObject> objects, EntityKind kind) =>
      objects.where((o) => o.name == kind.name).firstOrNull;

  /// The kind's template sections plus a trailing section with the
  /// world's own fields (titled [sectionTitle]); the template alone when
  /// there are none. Keys that clash with template keys are skipped.
  static List<FieldSection> sections(List<FieldSection> template,
      List<BlueprintField> extra, String sectionTitle) {
    if (extra.isEmpty) return template;
    final taken = {
      for (final section in template)
        for (final field in section.fields) field.key
    };
    final own = [
      for (final f in extra)
        if (!taken.contains(f.key)) f.toFieldDef()
    ];
    if (own.isEmpty) return template;
    return [...template, FieldSection(sectionTitle, own)];
  }

  /// Creates, updates or (when [fields] is empty) removes the extension.
  static Future<void> save(WorldObjectRepository repository,
      {required String worldId,
      required EntityKind kind,
      required List<BlueprintField> fields}) async {
    final existing = objectFor(
        await repository.list(worldId, WorldObjectTypes.kindExtension), kind);
    if (fields.isEmpty) {
      if (existing != null) await repository.delete(existing.id);
      return;
    }
    if (existing == null) {
      await repository.create(
          worldId: worldId,
          type: WorldObjectTypes.kindExtension,
          name: kind.name,
          data: toData(fields));
    } else {
      await repository.update(existing.copyWith(data: toData(fields)));
    }
  }
}
