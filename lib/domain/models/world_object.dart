import 'package:flutter/foundation.dart';

/// Well-known [WorldObject.type] values. Each GM tool owns one or more
/// types; the payload schema of each is defined by the tool's own model
/// class (`fromObject` / `toData`).
abstract final class WorldObjectTypes {
  static const map = 'map';
  static const mapPin = 'mapPin';
  static const randomTable = 'randomTable';
  static const encounter = 'encounter';
  static const combatant = 'combatant';
  static const diceRoll = 'diceRoll';
  static const kindExtension = 'kindExtension';
  static const calendar = 'calendar';
  static const gmScreen = 'gmScreen';
}

/// A world-scoped object stored in the generic `world_objects` table.
/// [data] is the JSON payload; [parentId] links children (pins, combatants)
/// to their owner, which deletes them along with itself.
@immutable
class WorldObject {
  final String id;
  final String worldId;
  final String type;
  final String? parentId;
  final String name;
  final Map<String, Object?> data;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;

  const WorldObject({
    required this.id,
    required this.worldId,
    required this.type,
    this.parentId,
    this.name = '',
    this.data = const {},
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  WorldObject copyWith({
    String? name,
    Map<String, Object?>? data,
    int? sortOrder,
    String? Function()? parentId,
  }) {
    return WorldObject(
      id: id,
      worldId: worldId,
      type: type,
      parentId: parentId != null ? parentId() : this.parentId,
      name: name ?? this.name,
      data: data ?? this.data,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is WorldObject && other.id == id && other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);
}
