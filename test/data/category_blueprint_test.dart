import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/data/backup/project_archive_service.dart';
import 'package:gmh/data/repositories/category_repository_impl.dart';
import 'package:gmh/domain/models/category_blueprint.dart';
import 'package:gmh/domain/models/entity_template.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

void main() {
  late TestHarness h;
  late CategoryRepositoryImpl categories;

  setUp(() async {
    h = await TestHarness.create();
    categories = CategoryRepositoryImpl(h.db);
  });
  tearDown(() async => h.dispose());

  const blueprint = CategoryBlueprint(
    modules: {
      CategoryModule.fields,
      CategoryModule.gallery,
      CategoryModule.tags,
    },
    fields: [
      BlueprintField(key: 'f_level', label: 'Level', type: FieldType.number),
      BlueprintField(
          key: 'f_school',
          label: 'School',
          type: FieldType.select,
          options: ['Evocation', 'Abjuration']),
    ],
  );

  test('blueprint JSON round-trips', () {
    final parsed = CategoryBlueprint.parse(blueprint.toJson());
    expect(parsed.modules, blueprint.modules);
    expect(parsed.fields.length, 2);
    expect(parsed.fields[1].options, ['Evocation', 'Abjuration']);
    expect(parsed.has(CategoryModule.document), isFalse);
    expect(parsed.has(CategoryModule.gallery), isTrue);
  });

  test('malformed or empty JSON falls back to the standard layout', () {
    expect(CategoryBlueprint.parse(null).modules,
        {...CategoryModule.values});
    expect(CategoryBlueprint.parse('{}').fields, isEmpty);
    expect(CategoryBlueprint.parse('not json').modules,
        {...CategoryModule.values});
    // No modules at all would render a blank page — fields stays on.
    expect(CategoryBlueprint.parse('{"modules": []}').modules,
        {CategoryModule.fields});
  });

  test('blueprint persists through the repository', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final created = await categories.create(
        worldId: world.id, name: 'Spells', blueprint: blueprint);
    final loaded = await categories.get(created.id);
    expect(loaded!.blueprint.fields.length, 2);
    expect(loaded.blueprint.has(CategoryModule.document), isFalse);

    // Update replaces the blueprint.
    await categories.update(loaded.copyWith(
        blueprint: loaded.blueprint.copyWith(
            modules: {...loaded.blueprint.modules, CategoryModule.document})));
    final updated = await categories.get(created.id);
    expect(updated!.blueprint.has(CategoryModule.document), isTrue);
  });

  test('blueprint survives archive export -> import', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final category = await categories.create(
        worldId: world.id, name: 'Spells', blueprint: blueprint);

    final service = ProjectArchiveService(h.db, h.vault);
    final path = p.join(h.tempDir.path, 'w.gmhw');
    expect((await service.exportArchive(world.id, path)).isOk, isTrue);
    await h.worlds.deleteWorld(world.id);

    expect((await service.importArchive(path)).isOk, isTrue);
    final restored = await categories.get(category.id);
    expect(restored!.blueprint.fields.map((f) => f.label),
        ['Level', 'School']);
    expect(restored.blueprint.has(CategoryModule.relations), isFalse);
  });

  test('toSections exposes constructor fields for the attribute form', () {
    final sections = blueprint.toSections('Fields')!;
    expect(sections.single.fields.map((f) => f.key),
        ['f_level', 'f_school']);
    expect(const CategoryBlueprint().toSections('Fields'), isNull);
  });
}
