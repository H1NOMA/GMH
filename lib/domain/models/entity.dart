import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'entity_kind.dart';

/// A single world object — character, location, quest, concept…
///
/// Common data lives in typed fields; kind-specific structured data lives in
/// [attributes], whose shape is defined by the kind's `EntityTemplate`.
@immutable
class Entity {
  final String id;
  final String worldId;
  final EntityKind kind;

  /// Set when [kind] == [EntityKind.custom]: the user-defined category this
  /// entry belongs to.
  final String? customCategoryId;

  final String name;

  /// One-line description shown in lists, search results and link previews.
  final String summary;

  /// Kind-specific structured fields (validated against the kind's template).
  final Map<String, Object?> attributes;

  final String? coverMediaId;
  final bool isFavorite;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;

  const Entity({
    required this.id,
    required this.worldId,
    required this.kind,
    this.customCategoryId,
    required this.name,
    this.summary = '',
    this.attributes = const {},
    this.coverMediaId,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  bool get isDeleted => deletedAt != null;

  String get attributesJson => jsonEncode(attributes);

  static Map<String, Object?> decodeAttributes(String json) {
    if (json.isEmpty) return {};
    final decoded = jsonDecode(json);
    return decoded is Map<String, dynamic> ? decoded : {};
  }

  Entity copyWith({
    String? name,
    String? summary,
    Map<String, Object?>? attributes,
    String? Function()? coverMediaId,
    bool? isFavorite,
    int? updatedAt,
    int? Function()? deletedAt,
    String? Function()? customCategoryId,
  }) {
    return Entity(
      id: id,
      worldId: worldId,
      kind: kind,
      customCategoryId: customCategoryId != null
          ? customCategoryId()
          : this.customCategoryId,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      attributes: attributes ?? this.attributes,
      coverMediaId: coverMediaId != null ? coverMediaId() : this.coverMediaId,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt != null ? deletedAt() : this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Entity && other.id == id && other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);
}
