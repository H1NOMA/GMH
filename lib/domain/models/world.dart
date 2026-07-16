import 'package:flutter/foundation.dart';

/// The root container of a universe. Everything else (entities, documents,
/// links, tags, media) belongs to exactly one world.
@immutable
class World {
  final String id;
  final String name;
  final String description;
  final String? coverMediaId;
  final int createdAt;
  final int updatedAt;

  const World({
    required this.id,
    required this.name,
    this.description = '',
    this.coverMediaId,
    required this.createdAt,
    required this.updatedAt,
  });

  World copyWith({
    String? name,
    String? description,
    String? Function()? coverMediaId,
    int? updatedAt,
  }) {
    return World(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverMediaId: coverMediaId != null ? coverMediaId() : this.coverMediaId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is World && other.id == id && other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);
}
