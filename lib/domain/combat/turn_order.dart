import 'dart:math';

import 'package:flutter/foundation.dart';

import 'combatant.dart';

/// Initiative order: highest initiative first (no initiative yet sorts
/// last), then the higher initiative bonus, then players before monsters,
/// then by name. Ties beyond that keep creation order so the list never
/// jumps around between rebuilds.
List<Combatant> sortCombatants(Iterable<Combatant> combatants) {
  final list = combatants.toList();
  int compare(Combatant a, Combatant b) {
    final ai = a.initiative, bi = b.initiative;
    if (ai != bi) {
      if (ai == null) return 1;
      if (bi == null) return -1;
      return bi.compareTo(ai);
    }
    if (a.initiativeBonus != b.initiativeBonus) {
      return b.initiativeBonus.compareTo(a.initiativeBonus);
    }
    if (a.isPlayer != b.isPlayer) return a.isPlayer ? -1 : 1;
    final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
    if (byName != 0) return byName;
    final bySort = a.sortOrder.compareTo(b.sortOrder);
    if (bySort != 0) return bySort;
    final byCreated = a.createdAt.compareTo(b.createdAt);
    return byCreated != 0 ? byCreated : a.id.compareTo(b.id);
  }

  return list..sort(compare);
}

/// d20 + [bonus]. [random] is injectable for deterministic tests.
int rollInitiative(int bonus, Random random) => random.nextInt(20) + 1 + bonus;

/// Where the turn pointer is: [round] (1-based once combat runs) and the
/// index into the sorted order, plus the id of that combatant.
@immutable
class TurnState {
  final int round;
  final int turnIndex;
  final String? activeId;

  const TurnState(this.round, this.turnIndex, this.activeId);
}

/// The result of advancing a turn: the new pointer and the combatants whose
/// conditions changed at the end of the finished turn (to persist).
@immutable
class TurnAdvance {
  final TurnState state;
  final List<Combatant> changed;

  const TurnAdvance(this.state, [this.changed = const []]);
}

/// Resolves the current position in [sorted]: the stored [activeId] wins
/// when that combatant still exists; otherwise [turnIndex], clamped.
int resolveTurnIndex(List<Combatant> sorted, int turnIndex, String? activeId) {
  if (sorted.isEmpty) return 0;
  if (activeId != null) {
    final index = sorted.indexWhere((c) => c.id == activeId);
    if (index >= 0) return index;
  }
  return turnIndex.clamp(0, sorted.length - 1);
}

/// The pointer at the start of combat: round 1, first standing combatant.
TurnState startCombat(List<Combatant> sorted) {
  if (sorted.isEmpty) return const TurnState(1, 0, null);
  final first = sorted.indexWhere((c) => !c.defeated);
  final index = first < 0 ? 0 : first;
  return TurnState(1, index, sorted[index].id);
}

/// Decrements the timed conditions of [combatant] (end of its own turn);
/// a condition reaching 0 rounds expires. Returns [combatant] itself when
/// nothing changed.
Combatant tickConditions(Combatant combatant) {
  if (!combatant.conditions.any((c) => c.rounds != null)) return combatant;
  final next = <CombatCondition>[
    for (final c in combatant.conditions)
      if (c.rounds == null)
        c
      else if (c.rounds! - 1 > 0)
        CombatCondition(c.id, rounds: c.rounds! - 1),
  ];
  return combatant.copyWith(conditions: next);
}

/// Ends the current combatant's turn (ticking its conditions) and moves to
/// the next combatant that is not defeated; wrapping past the end starts a
/// new round. With nobody left standing the pointer stays put.
TurnAdvance nextTurn(List<Combatant> sorted, TurnState state) {
  if (sorted.isEmpty) return TurnAdvance(state);
  final current = resolveTurnIndex(sorted, state.turnIndex, state.activeId);
  final changed = <Combatant>[];
  final ticked = tickConditions(sorted[current]);
  if (!identical(ticked, sorted[current])) changed.add(ticked);

  final round = state.round < 1 ? 1 : state.round;
  for (var step = 1; step <= sorted.length; step++) {
    final index = (current + step) % sorted.length;
    if (sorted[index].defeated) continue;
    final wrapped = current + step >= sorted.length;
    return TurnAdvance(
      TurnState(wrapped ? round + 1 : round, index, sorted[index].id),
      changed,
    );
  }
  return TurnAdvance(TurnState(round, current, sorted[current].id), changed);
}

/// Steps back to the previous combatant that is not defeated, going back a
/// round when wrapping. Never goes before the first turn of round 1, and
/// does not restore conditions that already expired.
TurnState previousTurn(List<Combatant> sorted, TurnState state) {
  if (sorted.isEmpty) return state;
  final current = resolveTurnIndex(sorted, state.turnIndex, state.activeId);
  final round = state.round < 1 ? 1 : state.round;
  for (var step = 1; step <= sorted.length; step++) {
    final raw = current - step;
    final wrapped = raw < 0;
    if (wrapped && round <= 1) break;
    final index = raw % sorted.length;
    if (sorted[index].defeated) continue;
    return TurnState(wrapped ? round - 1 : round, index, sorted[index].id);
  }
  return TurnState(round, current, sorted[current].id);
}

/// Names for [count] new copies of [base], continuing any numbering already
/// in [existing] ("Goblin 1", "Goblin 2" → "Goblin 3"…). A single new
/// combatant keeps the bare name unless that name is taken.
List<String> numberedNames(String base, int count, Iterable<String> existing) {
  final name = base.trim();
  if (count <= 0) return const [];
  var highest = 0;
  var bareTaken = false;
  final pattern = RegExp('^${RegExp.escape(name)} (\\d+)\$');
  for (final other in existing) {
    final trimmed = other.trim();
    if (trimmed == name) {
      bareTaken = true;
      highest = max(highest, 1);
      continue;
    }
    final match = pattern.firstMatch(trimmed);
    if (match != null) {
      highest = max(highest, int.tryParse(match.group(1)!) ?? 0);
    }
  }
  if (count == 1 && highest == 0 && !bareTaken) return [name];
  return [for (var i = 1; i <= count; i++) '$name ${highest + i}'];
}
