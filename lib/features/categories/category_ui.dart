import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models/custom_category.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';
import '../shell/ui_providers.dart';

/// Icon set for user-defined categories. Keys are stored in the database, so
/// they must stay stable; add new keys freely, never repurpose old ones.
const categoryIcons = <String, IconData>{
  'folder': Icons.folder_outlined,
  'book': Icons.menu_book_outlined,
  'scroll': Icons.history_edu_outlined,
  'castle': Icons.castle_outlined,
  'church': Icons.church_outlined,
  'creature': Icons.pets_outlined,
  'shield': Icons.shield_outlined,
  'magic': Icons.auto_fix_high_outlined,
  'star': Icons.star_outline,
  'gem': Icons.diamond_outlined,
  'flag': Icons.flag_outlined,
  'map': Icons.map_outlined,
  'music': Icons.music_note_outlined,
  'science': Icons.biotech_outlined,
  'skull': Icons.mood_bad_outlined,
  'anchor': Icons.anchor_outlined,
};

IconData categoryIconFor(String key) =>
    categoryIcons[key] ?? Icons.folder_outlined;

/// Live list of the world's custom categories, in manual order.
final worldCategoriesProvider =
    StreamProvider.family<List<CustomCategory>, String>(
  (ref, worldId) =>
      ref.watch(categoryRepositoryProvider).watchCategories(worldId),
);

/// Entry counts per custom category id.
final categoryCountsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, worldId) {
  ref.watch(worldCategoriesProvider(worldId));
  // countsByCategory is a one-shot query; recompute whenever the world's
  // entity list changes, mirroring entityCountsProvider — otherwise the
  // sidebar badges and dashboard tiles keep stale numbers.
  ref.watch(entityListProvider((
    worldId: worldId,
    kind: null,
    customCategoryId: null,
    tagId: null,
    favoritesOnly: false,
    sort: EntitySort.updatedDesc,
  )));
  return ref.watch(categoryRepositoryProvider).countsByCategory(worldId);
});

/// Resolves the display icon for an entity: custom entries use their
/// category's icon, built-ins use the kind icon.
IconData entityIcon(Entity entity, Map<String, CustomCategory> categories) {
  if (entity.kind == EntityKind.custom) {
    final category = categories[entity.customCategoryId];
    if (category != null) return categoryIconFor(category.icon);
  }
  return entity.kind.icon;
}

/// Resolves the display color for an entity (see [entityIcon]).
Color entityColor(Entity entity, Map<String, CustomCategory> categories) {
  if (entity.kind == EntityKind.custom) {
    final category = categories[entity.customCategoryId];
    if (category != null) return Color(category.color);
  }
  return entity.kind.color;
}

/// Categories of the entity's world as an id-keyed map (for cards/graph).
final categoryMapProvider =
    Provider.family<Map<String, CustomCategory>, String>((ref, worldId) {
  final list = ref.watch(worldCategoriesProvider(worldId)).valueOrNull ?? [];
  return {for (final c in list) c.id: c};
});
