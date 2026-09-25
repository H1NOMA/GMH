import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/combat/combatant.dart';
import '../../../domain/combat/creature_stats.dart';
import '../../../domain/combat/encounter.dart';
import '../../../domain/combat/turn_order.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/entity_kind.dart';
import '../../../domain/models/world_object.dart';
import '../../../domain/repositories/repositories.dart';

/// Dice for initiative rolls; overridden in tests for deterministic rolls.
final combatRandomProvider = Provider<Random>((ref) => Random());

final combatActionsProvider = Provider<CombatActions>((ref) => CombatActions(
      ref.watch(worldObjectRepositoryProvider),
      ref.watch(combatRandomProvider),
    ));

/// Every write the combat tracker makes, on top of the generic
/// world-object store. Callers pass the state they currently show; the
/// drift streams bring the result back to the screen.
class CombatActions {
  final WorldObjectRepository _repo;
  final Random _random;

  CombatActions(this._repo, this._random);

  Future<Encounter> createEncounter(String worldId, String name) async {
    final object = await _repo.create(
      worldId: worldId,
      type: WorldObjectTypes.encounter,
      name: name,
      data: Encounter(id: '', worldId: worldId, name: name).toData(),
    );
    return Encounter.fromObject(object);
  }

  Future<void> saveEncounter(Encounter encounter) =>
      _repo.update(encounter.toObject());

  Future<void> saveCombatant(Combatant combatant) =>
      _repo.update(combatant.toObject());

  Future<void> deleteEncounter(String id) => _repo.delete(id);

  Future<void> removeCombatant(String id) => _repo.delete(id);

  /// A fresh copy for reuse: same combatants and party, combat state reset.
  Future<Encounter> duplicateEncounter(
      Encounter source, List<Combatant> combatants, String name) async {
    final copy = await _repo.create(
      worldId: source.worldId,
      type: WorldObjectTypes.encounter,
      name: name,
      data: source
          .copyWith(
            status: EncounterStatus.planning,
            round: 0,
            turnIndex: 0,
            activeId: () => null,
          )
          .toData(),
    );
    for (final c in combatants) {
      await _repo.create(
        worldId: source.worldId,
        type: WorldObjectTypes.combatant,
        parentId: copy.id,
        name: c.name,
        data: c.toData(),
      );
    }
    return Encounter.fromObject(copy);
  }

  Future<void> addCombatants(
      Encounter encounter, List<Combatant> drafts) async {
    for (final draft in drafts) {
      await _repo.create(
        worldId: encounter.worldId,
        type: WorldObjectTypes.combatant,
        parentId: encounter.id,
        name: draft.name,
        data: draft.toData(),
      );
    }
  }

  /// Combatants for [quantity] copies of [entity], numbered after the
  /// [existing] names. Characters join as players. Monsters joining a
  /// running fight roll initiative right away.
  List<Combatant> draftsFromEntity(
    Entity entity, {
    required int quantity,
    required Encounter encounter,
    required Iterable<String> existing,
  }) {
    final isPlayer = entity.kind == EntityKind.character;
    final stats =
        CreatureStats.fromAttributes(entity.attributes, isPlayer: isPlayer);
    final hpMax = stats.hpMax ?? 0;
    return [
      for (final name in numberedNames(entity.name, quantity, existing))
        Combatant(
          name: name,
          entityId: entity.id,
          isPlayer: isPlayer,
          initiative: !isPlayer && encounter.status == EncounterStatus.active
              ? rollInitiative(stats.initiativeBonus, _random)
              : null,
          initiativeBonus: stats.initiativeBonus,
          hpMax: hpMax,
          hpCurrent: stats.hpCurrent ?? hpMax,
          ac: stats.ac,
          cr: stats.cr,
          xp: stats.xp,
        ),
    ];
  }

  Future<void> duplicateCombatant(
      Combatant source, Iterable<Combatant> all) async {
    final base = source.name.replaceFirst(RegExp(r' \d+$'), '');
    final name =
        numberedNames(base, 1, [for (final c in all) c.name]).single;
    await _repo.create(
      worldId: source.worldId,
      type: WorldObjectTypes.combatant,
      parentId: source.encounterId,
      name: name,
      data: source.copyWith(name: name).toData(),
    );
  }

  /// Rolls d20 + bonus for every monster; players keep their own values.
  /// With [onlyMissing] monsters that already have initiative keep it.
  Future<void> rollMonsterInitiative(Iterable<Combatant> combatants,
      {bool onlyMissing = false}) async {
    for (final c in combatants) {
      if (c.isPlayer) continue;
      if (onlyMissing && c.initiative != null) continue;
      final roll = rollInitiative(c.initiativeBonus, _random);
      await saveCombatant(c.copyWith(initiative: () => roll));
    }
  }

  /// Starts (or restarts) combat at round 1. Monsters without initiative
  /// roll first so the order is complete.
  Future<void> beginCombat(
      Encounter encounter, List<Combatant> combatants) async {
    await rollMonsterInitiative(combatants, onlyMissing: true);
    final fresh = await _combatantsOf(encounter);
    final state = startCombat(sortCombatants(fresh));
    await saveEncounter(encounter.copyWith(
      status: EncounterStatus.active,
      round: state.round,
      turnIndex: state.turnIndex,
      activeId: () => state.activeId,
    ));
  }

  Future<void> endCombat(Encounter encounter) =>
      saveEncounter(encounter.copyWith(status: EncounterStatus.finished));

  Future<void> advanceTurn(Encounter encounter, List<Combatant> combatants) async {
    final advance = nextTurn(
      sortCombatants(combatants),
      TurnState(encounter.round, encounter.turnIndex, encounter.activeId),
    );
    for (final changed in advance.changed) {
      await saveCombatant(changed);
    }
    await _saveTurn(encounter, advance.state);
  }

  Future<void> rewindTurn(
      Encounter encounter, List<Combatant> combatants) async {
    final state = previousTurn(
      sortCombatants(combatants),
      TurnState(encounter.round, encounter.turnIndex, encounter.activeId),
    );
    await _saveTurn(encounter, state);
  }

  Future<void> _saveTurn(Encounter encounter, TurnState state) =>
      saveEncounter(encounter.copyWith(
        round: state.round,
        turnIndex: state.turnIndex,
        activeId: () => state.activeId,
      ));

  Future<List<Combatant>> _combatantsOf(Encounter encounter) async => [
        for (final o in await _repo.list(
            encounter.worldId, WorldObjectTypes.combatant,
            parentId: encounter.id))
          Combatant.fromObject(o),
      ];
}
