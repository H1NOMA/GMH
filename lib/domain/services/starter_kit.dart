import 'dart:math';

import '../../core/utils/ids.dart';
import '../generators/generator_engine.dart';
import '../models/entity.dart';
import '../models/entity_kind.dart';
import '../models/world.dart';
import '../models/world_object.dart';
import '../repositories/repositories.dart';
import '../tables/content/table_library.dart';
import 'entity_service.dart';

/// Localized names the kit needs from the UI.
class StarterKitLabels {
  final String campaignName;
  final String sessionName;
  final FieldLabeler fieldLabel;

  const StarterKitLabels({
    required this.campaignName,
    required this.sessionName,
    required this.fieldLabel,
  });
}

/// Seeds a new world so it doesn't open empty: a settlement with three
/// of its people, a faction, two adventure hooks as quests of a first
/// campaign with its first session, and the setting's ready-made random
/// tables — all generated for the world's setting, in the UI language.
/// Every piece is an ordinary entry the user can edit or delete.
class StarterKit {
  final EntityService _entities;
  final WorldObjectRepository _objects;
  final GeneratorEngine _generators;

  StarterKit(this._entities, this._objects, {Random? random})
      : _generators = GeneratorEngine(random: random);

  Future<List<Entity>> seed({
    required String worldId,
    required WorldStyle style,
    required String language,
    required StarterKitLabels labels,
  }) async {
    final created = <Entity>[];

    Future<Entity?> add(EntityDraft draft,
        {Map<String, Object?> extra = const {}}) async {
      final result = await _entities.create(
        worldId: worldId,
        kind: draft.kind,
        name: draft.name,
        summary: draft.summary,
        attributes: {
          for (final MapEntry(:key, :value) in draft.attributes.entries)
            if (value != null && value.toString().isNotEmpty) key: value,
          ...extra,
        },
      );
      if (result.isErr) return null;
      created.add(result.value);
      return result.value;
    }

    Future<Entity?> generated(GeneratorKind kind,
            {Map<String, Object?> extra = const {}}) =>
        add(
            _generators.toEntity(
                _generators.generate(kind, style: style, language: language),
                labels.fieldLabel),
            extra: extra);

    final settlement = await generated(GeneratorKind.settlement);
    for (var i = 0; i < 3; i++) {
      await generated(GeneratorKind.npc, extra: {
        if (settlement != null)
          'homeLocation': entityRefValue(settlement.id),
      });
    }
    await generated(GeneratorKind.faction);

    final campaign = await add(EntityDraft(
      kind: EntityKind.campaign,
      name: labels.campaignName,
      attributes: const {'status': 'Planning'},
    ));
    final inCampaign = {
      if (campaign != null) 'campaign': entityRefValue(campaign.id),
    };
    for (var i = 0; i < 2; i++) {
      await generated(GeneratorKind.hook, extra: inCampaign);
    }
    await add(
        EntityDraft(kind: EntityKind.session, name: labels.sessionName),
        extra: inCampaign);

    for (final table in TableLibrary.forStyle(style)) {
      final draft = TableLibrary.materialize(table, language, worldId: worldId);
      await _objects.create(
        worldId: worldId,
        type: WorldObjectTypes.randomTable,
        name: draft.name,
        data: draft.toData(),
      );
    }
    return created;
  }
}
