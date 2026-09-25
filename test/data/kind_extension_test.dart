import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/models/category_blueprint.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/entity_template.dart';
import 'package:gmh/domain/models/kind_extension.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/services/templates/entity_templates.dart';

import '../helpers.dart';

void main() {
  late TestHarness h;
  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  const sanity = BlueprintField(
      key: 'x_sanity', label: 'Sanity', type: FieldType.number);
  const clash =
      BlueprintField(key: 'race', label: 'Species', type: FieldType.text);

  test('extra fields follow the template, clashing keys are skipped', () {
    final base = EntityTemplates.of(EntityKind.character).sections;
    final merged = KindExtensions.sections(base, [sanity, clash], 'Custom');
    expect(merged.length, base.length + 1);
    expect(merged.last.title, 'Custom');
    expect(merged.last.fields.map((f) => f.key), ['x_sanity']);
    expect(KindExtensions.sections(base, const [], 'Custom'), same(base));
  });

  test('save creates, updates and removes the extension', () async {
    final world = await h.worlds.createWorld(name: 'W');
    Future<List<BlueprintField>> stored() async => KindExtensions.fieldsOf(
        KindExtensions.objectFor(
            await h.objects.list(world.id, WorldObjectTypes.kindExtension),
            EntityKind.character));

    await KindExtensions.save(h.objects,
        worldId: world.id, kind: EntityKind.character, fields: [sanity]);
    expect((await stored()).map((f) => f.label), ['Sanity']);

    await KindExtensions.save(h.objects,
        worldId: world.id,
        kind: EntityKind.character,
        fields: [sanity, const BlueprintField(
            key: 'x_luck', label: 'Luck', type: FieldType.number)]);
    expect((await stored()).map((f) => f.label), ['Sanity', 'Luck']);
    expect(await h.objects.list(world.id, WorldObjectTypes.kindExtension),
        hasLength(1));

    await KindExtensions.save(h.objects,
        worldId: world.id, kind: EntityKind.character, fields: const []);
    expect(await h.objects.list(world.id, WorldObjectTypes.kindExtension),
        isEmpty);
  });
}
