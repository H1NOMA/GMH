import 'package:flutter/foundation.dart';

/// A colored label. Tags are per-world and attach to any entity.
@immutable
class Tag {
  final String id;
  final String worldId;
  final String name;

  /// ARGB color value.
  final int color;

  const Tag({
    required this.id,
    required this.worldId,
    required this.name,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      other is Tag && other.id == id && other.name == name && other.color == color;

  @override
  int get hashCode => Object.hash(id, name, color);
}
