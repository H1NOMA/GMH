import 'package:flutter/foundation.dart';

/// Visual & terminology flavor of a world, chosen at creation time.
/// Fantasy keeps the classic candle-lit design; cyberpunk switches the whole
/// app to a neon palette and slang labels (Runners, Sectors, Gigs…).
enum WorldStyle {
  fantasy,
  cyberpunk;

  static WorldStyle parse(String? name) =>
      values.firstWhere((s) => s.name == name, orElse: () => fantasy);
}

/// The root container of a universe. Everything else (entities, documents,
/// links, tags, media) belongs to exactly one world.
@immutable
class World {
  final String id;
  final String name;
  final String description;
  final String? coverMediaId;
  final WorldStyle style;
  final int createdAt;
  final int updatedAt;

  const World({
    required this.id,
    required this.name,
    this.description = '',
    this.coverMediaId,
    this.style = WorldStyle.fantasy,
    required this.createdAt,
    required this.updatedAt,
  });

  World copyWith({
    String? name,
    String? description,
    String? Function()? coverMediaId,
    WorldStyle? style,
    int? updatedAt,
  }) {
    return World(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverMediaId: coverMediaId != null ? coverMediaId() : this.coverMediaId,
      style: style ?? this.style,
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
