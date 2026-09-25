import 'package:flutter/foundation.dart';

import '../models/world_object.dart';
import 'json_read.dart';

/// A condition on a combatant. [rounds] counts down at the end of the
/// combatant's own turns; null lasts until removed.
@immutable
class CombatCondition {
  final String id;
  final int? rounds;

  const CombatCondition(this.id, {this.rounds});

  static CombatCondition? fromJson(Object? json) {
    if (json is String && json.isNotEmpty) return CombatCondition(json);
    if (json is! Map) return null;
    final id = json['id'];
    if (id is! String || id.isEmpty) return null;
    final rounds = readNum(json['rounds']);
    return CombatCondition(id,
        rounds: rounds == null || rounds < 1 ? null : rounds.round());
  }

  Map<String, Object?> toJson() => {
        'id': id,
        if (rounds != null) 'rounds': rounds,
      };

  CombatCondition withRounds(int? rounds) => CombatCondition(id,
      rounds: rounds == null || rounds < 1 ? null : rounds);

  @override
  bool operator ==(Object other) =>
      other is CombatCondition && other.id == id && other.rounds == rounds;

  @override
  int get hashCode => Object.hash(id, rounds);
}

/// One participant of an encounter ([WorldObjectTypes.combatant], child of
/// the encounter). [entityId] links it to a world entry it was added from.
@immutable
class Combatant {
  final String id;
  final String worldId;
  final String encounterId;
  final String name;
  final String? entityId;
  final bool isPlayer;
  final num? initiative;
  final int initiativeBonus;
  final int hpMax;
  final int hpCurrent;
  final int hpTemp;
  final int? ac;
  final List<CombatCondition> conditions;
  final bool concentration;
  final bool defeated;
  final int xp;
  final String cr;
  final String notes;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;

  const Combatant({
    this.id = '',
    this.worldId = '',
    this.encounterId = '',
    required this.name,
    this.entityId,
    this.isPlayer = false,
    this.initiative,
    this.initiativeBonus = 0,
    this.hpMax = 0,
    this.hpCurrent = 0,
    this.hpTemp = 0,
    this.ac,
    this.conditions = const [],
    this.concentration = false,
    this.defeated = false,
    this.xp = 0,
    this.cr = '',
    this.notes = '',
    this.sortOrder = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory Combatant.fromObject(WorldObject object) {
    final d = object.data;
    final entityId = d['entityId'];
    final hpMax = readInt(d['hpMax']).clamp(0, 1 << 30);
    final ac = readNum(d['ac']);
    final seen = <String>{};
    return Combatant(
      id: object.id,
      worldId: object.worldId,
      encounterId: object.parentId ?? '',
      name: object.name.isNotEmpty ? object.name : readString(d['name']),
      entityId: entityId is String && entityId.isNotEmpty ? entityId : null,
      isPlayer: readBool(d['isPlayer']),
      initiative: readNum(d['initiative']),
      initiativeBonus: readInt(d['initiativeBonus']),
      hpMax: hpMax,
      hpCurrent: readInt(d['hpCurrent'], hpMax).clamp(0, 1 << 30),
      hpTemp: readInt(d['hpTemp']).clamp(0, 1 << 30),
      ac: ac?.round(),
      conditions: [
        for (final raw in readList(d['conditions']))
          if (CombatCondition.fromJson(raw) case final c?)
            if (seen.add(c.id)) c,
      ],
      concentration: readBool(d['concentration']),
      defeated: readBool(d['defeated']),
      xp: readInt(d['xp']).clamp(0, 1 << 30),
      cr: readString(d['cr']),
      notes: readString(d['notes']),
      sortOrder: object.sortOrder,
      createdAt: object.createdAt,
      updatedAt: object.updatedAt,
    );
  }

  Map<String, Object?> toData() => {
        'name': name,
        if (entityId != null) 'entityId': entityId,
        'isPlayer': isPlayer,
        'initiative': initiative,
        'initiativeBonus': initiativeBonus,
        'hpMax': hpMax,
        'hpCurrent': hpCurrent,
        'hpTemp': hpTemp,
        'ac': ac,
        'conditions': [for (final c in conditions) c.toJson()],
        'concentration': concentration,
        'defeated': defeated,
        'xp': xp,
        'cr': cr,
        'notes': notes,
      };

  WorldObject toObject() => WorldObject(
        id: id,
        worldId: worldId,
        type: WorldObjectTypes.combatant,
        parentId: encounterId,
        name: name,
        data: toData(),
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  bool hasCondition(String conditionId) =>
      conditions.any((c) => c.id == conditionId);

  Combatant copyWith({
    String? name,
    String? Function()? entityId,
    bool? isPlayer,
    num? Function()? initiative,
    int? initiativeBonus,
    int? hpMax,
    int? hpCurrent,
    int? hpTemp,
    int? Function()? ac,
    List<CombatCondition>? conditions,
    bool? concentration,
    bool? defeated,
    int? xp,
    String? cr,
    String? notes,
  }) {
    return Combatant(
      id: id,
      worldId: worldId,
      encounterId: encounterId,
      name: name ?? this.name,
      entityId: entityId != null ? entityId() : this.entityId,
      isPlayer: isPlayer ?? this.isPlayer,
      initiative: initiative != null ? initiative() : this.initiative,
      initiativeBonus: initiativeBonus ?? this.initiativeBonus,
      hpMax: hpMax ?? this.hpMax,
      hpCurrent: hpCurrent ?? this.hpCurrent,
      hpTemp: hpTemp ?? this.hpTemp,
      ac: ac != null ? ac() : this.ac,
      conditions: conditions ?? this.conditions,
      concentration: concentration ?? this.concentration,
      defeated: defeated ?? this.defeated,
      xp: xp ?? this.xp,
      cr: cr ?? this.cr,
      notes: notes ?? this.notes,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
