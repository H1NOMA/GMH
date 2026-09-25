import 'package:flutter/foundation.dart';

import '../models/world_object.dart';
import 'json_read.dart';

enum EncounterStatus {
  planning,
  active,
  finished;

  static EncounterStatus parse(Object? value) {
    for (final s in values) {
      if (s.name == value) return s;
    }
    return planning;
  }
}

/// Which DMG encounter-building rules the difficulty panel uses.
enum RulesVersion {
  v2024('2024'),
  v2014('2014');

  final String id;
  const RulesVersion(this.id);

  static RulesVersion parse(Object? value) {
    final text = readString(value);
    for (final r in values) {
      if (r.id == text) return r;
    }
    return v2024;
  }
}

/// A combat encounter ([WorldObjectTypes.encounter]); its combatants are
/// child objects.
@immutable
class Encounter {
  final String id;
  final String worldId;
  final String name;
  final EncounterStatus status;

  /// 0 while planning; 1 on the first round of combat.
  final int round;

  /// Index into the sorted combatant order of the combatant whose turn it
  /// is. [activeId] pins the same combatant by id so the pointer survives
  /// re-sorting (an initiative edit, a combatant added mid-fight).
  final int turnIndex;
  final String? activeId;
  final List<int> partyLevels;
  final RulesVersion rulesVersion;
  final String notes;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;

  const Encounter({
    required this.id,
    required this.worldId,
    required this.name,
    this.status = EncounterStatus.planning,
    this.round = 0,
    this.turnIndex = 0,
    this.activeId,
    this.partyLevels = const [],
    this.rulesVersion = RulesVersion.v2024,
    this.notes = '',
    this.sortOrder = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory Encounter.fromObject(WorldObject object) {
    final d = object.data;
    final levels = <int>[
      for (final value in readList(d['partyLevels']))
        if (readNum(value) != null) readInt(value).clamp(1, 20),
    ];
    final activeId = d['activeId'];
    return Encounter(
      id: object.id,
      worldId: object.worldId,
      name: object.name,
      status: EncounterStatus.parse(d['status']),
      round: readInt(d['round']).clamp(0, 1 << 30),
      turnIndex: readInt(d['turnIndex']).clamp(0, 1 << 30),
      activeId: activeId is String && activeId.isNotEmpty ? activeId : null,
      partyLevels: levels,
      rulesVersion: RulesVersion.parse(d['rulesVersion']),
      notes: readString(d['notes']),
      sortOrder: object.sortOrder,
      createdAt: object.createdAt,
      updatedAt: object.updatedAt,
    );
  }

  Map<String, Object?> toData() => {
        'status': status.name,
        'round': round,
        'turnIndex': turnIndex,
        if (activeId != null) 'activeId': activeId,
        'partyLevels': partyLevels,
        'rulesVersion': rulesVersion.id,
        'notes': notes,
      };

  /// The stored object for an update: identity and timestamps from this
  /// encounter, name and payload from the current fields.
  WorldObject toObject() => WorldObject(
        id: id,
        worldId: worldId,
        type: WorldObjectTypes.encounter,
        name: name,
        data: toData(),
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Encounter copyWith({
    String? name,
    EncounterStatus? status,
    int? round,
    int? turnIndex,
    String? Function()? activeId,
    List<int>? partyLevels,
    RulesVersion? rulesVersion,
    String? notes,
  }) {
    return Encounter(
      id: id,
      worldId: worldId,
      name: name ?? this.name,
      status: status ?? this.status,
      round: round ?? this.round,
      turnIndex: turnIndex ?? this.turnIndex,
      activeId: activeId != null ? activeId() : this.activeId,
      partyLevels: partyLevels ?? this.partyLevels,
      rulesVersion: rulesVersion ?? this.rulesVersion,
      notes: notes ?? this.notes,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
