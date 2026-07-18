import 'package:flutter/foundation.dart';

import 'category_blueprint.dart';

/// A user-defined archive category. Entities of [kind == EntityKind.custom]
/// reference one and otherwise behave exactly like built-in kinds:
/// documents, attachments, links, tags, search, graph and export are all
/// shared machinery.
@immutable
class CustomCategory {
  final String id;
  final String worldId;
  final String name;

  /// Key into the UI icon set (see `categoryIconFor`).
  final String icon;

  /// ARGB color value.
  final int color;
  final int sortOrder;

  /// The section's construction plan: enabled modules + custom fields.
  final CategoryBlueprint blueprint;
  final int createdAt;

  const CustomCategory({
    required this.id,
    required this.worldId,
    required this.name,
    required this.icon,
    required this.color,
    required this.sortOrder,
    this.blueprint = CategoryBlueprint.standard,
    required this.createdAt,
  });

  CustomCategory copyWith({
    String? name,
    String? icon,
    int? color,
    CategoryBlueprint? blueprint,
  }) {
    return CustomCategory(
      id: id,
      worldId: worldId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder,
      blueprint: blueprint ?? this.blueprint,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CustomCategory &&
      other.id == id &&
      other.name == name &&
      other.icon == icon &&
      other.color == color &&
      other.sortOrder == sortOrder &&
      other.blueprint.toJson() == blueprint.toJson();

  @override
  int get hashCode =>
      Object.hash(id, name, icon, color, sortOrder, blueprint.toJson());
}
