import 'package:flutter/foundation.dart';

/// A colored label. Tags are per-world and attach to any entity.
@immutable
class Tag {
  final String id;
  final String worldId;
  final String name;

  /// ARGB color value.
  final int color;

  /// Creation time (epoch ms); 0 for tags created before schema v3.
  final int createdAt;

  const Tag({
    required this.id,
    required this.worldId,
    required this.name,
    required this.color,
    this.createdAt = 0,
  });

  @override
  bool operator ==(Object other) =>
      other is Tag && other.id == id && other.name == name && other.color == color;

  @override
  int get hashCode => Object.hash(id, name, color);
}
