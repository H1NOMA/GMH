/// Domain repository contracts. The data layer implements these with drift +
/// the file vault; presentation code depends only on the abstractions.
library;

import '../models/custom_category.dart';
import '../models/document_model.dart';
import '../models/entity.dart';
import '../models/entity_kind.dart';
import '../models/link.dart';
import '../models/media_item.dart';
import '../models/search_result.dart';
import '../models/tag.dart';
import '../models/world.dart';

abstract interface class WorldRepository {
  Stream<List<World>> watchWorlds();
  Future<World?> getWorld(String id);
  Future<World> createWorld({
    required String name,
    String description,
    WorldStyle style,
  });
  Future<void> updateWorld(World world);

  /// Permanently deletes a world and all of its data and media.
  Future<void> deleteWorld(String id);
}

/// Filter/sort options for entity list queries.
enum EntitySort { nameAsc, updatedDesc, createdDesc }

/// User-defined archive categories: unlimited, renameable, reorderable.
abstract interface class CategoryRepository {
  Stream<List<CustomCategory>> watchCategories(String worldId);
  Future<List<CustomCategory>> categories(String worldId);
  Future<CustomCategory?> get(String id);

  Future<CustomCategory> create({
    required String worldId,
    required String name,
    String icon,
    int? color,
  });

  Future<void> update(CustomCategory category);

  /// Persists a new manual order (list of category ids, first = top).
  Future<void> reorder(String worldId, List<String> orderedIds);

  /// Deletes the category. Its entries are preserved: they are converted to
  /// the Concept Archive so no data is ever lost.
  Future<void> delete(String categoryId);

  Future<Map<String, int>> countsByCategory(String worldId);
}

abstract interface class EntityRepository {
  Stream<List<Entity>> watchEntities(
    String worldId, {
    EntityKind? kind,
    String? customCategoryId,
    String? tagId,
    bool favoritesOnly = false,
    EntitySort sort = EntitySort.updatedDesc,
    int limit = 500,
  });

  Stream<Entity?> watchEntity(String id);
  Future<Entity?> getEntity(String id);
  Future<List<Entity>> getEntitiesByIds(List<String> ids);
  Future<List<Entity>> getAllEntities(String worldId);

  Future<Entity> createEntity({
    required String worldId,
    required EntityKind kind,
    String? customCategoryId,
    required String name,
    String summary,
    Map<String, Object?> attributes,
  });

  Future<void> updateEntity(Entity entity);
  Future<void> setFavorite(String id, bool favorite);

  /// Soft delete — links remain until purge so the graph stays consistent.
  Future<void> softDelete(String id);
  Future<void> restore(String id);
  Future<void> purge(String id);

  Future<Map<EntityKind, int>> countsByKind(String worldId);

  /// Lightweight name lookup for the mention picker (prefix match).
  Future<List<Entity>> lookupByName(String worldId, String query,
      {int limit = 12});
}

abstract interface class DocumentRepository {
  /// Returns the entity's document, creating an empty one if missing.
  Future<DocumentModel> getOrCreate(String entityId);
  Stream<DocumentModel?> watchByEntity(String entityId);

  /// Saves content and returns the updated document. Also updates the
  /// search index and (via the link sync service) mention links.
  Future<DocumentModel> save({
    required String entityId,
    required String contentJson,
    required String plainText,
  });

  Future<List<DocumentVersion>> versions(String documentId, {int limit = 25});
  Future<void> saveVersion(String documentId, {String note});
  Future<DocumentVersion?> getVersion(String versionId);
}

abstract interface class LinkRepository {
  Stream<List<Link>> watchOutgoing(String entityId);
  Stream<List<Link>> watchIncoming(String entityId);
  Future<List<Link>> outgoing(String entityId);
  Future<List<Link>> allForWorld(String worldId);

  Future<Link> create({
    required String worldId,
    required String sourceId,
    required String targetId,
    required String role,
    required LinkOrigin origin,
  });

  Future<void> delete(String linkId);

  /// Replaces all links of [origin] from [sourceId] with [targets]
  /// (targetId -> role). Used by mention sync and attribute mirroring.
  Future<void> replaceForOrigin({
    required String worldId,
    required String sourceId,
    required LinkOrigin origin,
    required Map<String, String> targets,
  });
}

abstract interface class TagRepository {
  Stream<List<Tag>> watchTags(String worldId);
  Future<Tag> getOrCreate(String worldId, String name, {int? color});
  Future<void> rename(String tagId, String name);
  Future<void> setColor(String tagId, int color);

  /// Deletes the tag and detaches it from every entry (the entries
  /// themselves are untouched).
  Future<void> delete(String tagId);

  /// How many entries use each tag (tagId -> count).
  Future<Map<String, int>> usageCounts(String worldId);

  /// Moves every assignment of [fromTagId] onto [intoTagId] (duplicates
  /// collapse) and deletes [fromTagId] — the merge tool for duplicate tags.
  Future<void> merge({required String fromTagId, required String intoTagId});

  Stream<List<Tag>> watchEntityTags(String entityId);
  Future<List<Tag>> entityTags(String entityId);
  Future<void> tagEntity(String entityId, String tagId);
  Future<void> untagEntity(String entityId, String tagId);
}

abstract interface class MediaRepository {
  /// Imports bytes into the world's content-addressed vault and records
  /// metadata. Identical content is deduplicated.
  Future<MediaItem> import({
    required String worldId,
    required String fileName,
    required List<int> bytes,
  });

  Future<MediaItem?> get(String id);

  /// Absolute path of the media file on disk.
  Future<String> absolutePath(MediaItem item);

  /// Renames the display name of an attachment (the vault file itself is
  /// content-addressed and never renamed, so links stay valid).
  Future<void> rename(String mediaId, String newFileName);

  /// Replaces the bytes behind an attachment. Every entry referencing this
  /// media id sees the new content; the old vault file is removed when no
  /// other media row shares it.
  Future<MediaItem> replaceBytes({
    required String mediaId,
    required String fileName,
    required List<int> bytes,
  });

  /// Deletes the media row and its vault file if nothing references it
  /// anymore (galleries, covers, or inline document embeds).
  Future<void> deleteIfUnreferenced(String mediaId);

  Stream<List<GalleryEntry>> watchGallery(String entityId);
  Future<void> addToGallery(String entityId, String mediaId,
      {String caption});
  Future<void> removeFromGallery(String entityId, String mediaId);
  Future<void> setCaption(String entityId, String mediaId, String caption);

  Future<List<MediaItem>> allForWorld(String worldId);
}

abstract interface class SearchRepository {
  Future<List<SearchResult>> search(
    String worldId,
    String query, {
    EntityKind? kind,
    String? customCategoryId,
    int limit = 40,
  });

  /// Re-indexes a single entity (called after entity/document/tag writes).
  Future<void> reindexEntity(String entityId);

  /// Rebuilds the whole index (after import/restore).
  Future<void> rebuildIndex(String worldId);

  Future<void> recordOpened(String entityId);
  Future<List<Entity>> recentlyOpened(String worldId, {int limit = 15});
}

abstract interface class SettingsRepository {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
  Future<void> remove(String key);
}

/// Well-known settings keys.
abstract final class SettingsKeys {
  static const lastOpenedWorld = 'lastOpenedWorld';
  static const lastAutoBackup = 'lastAutoBackup';

  /// Explicit UI language ('en'/'ru'); absent = follow the system language.
  static const appLocale = 'appLocale';

  /// Explicit theme ('light'/'dark'); absent = follow the system theme.
  static const themeMode = 'themeMode';

  /// Selected campaign per world (`selectedCampaign.<worldId>`).
  static const selectedCampaign = 'selectedCampaign';

  /// Last visited route, restored on startup.
  static const lastLocation = 'lastLocation';

  /// Entity list sort order per world (`entitySort.<worldId>`).
  static const entitySort = 'entitySort';

  /// Checkpoint of an interrupted TTG migration (JSON), enabling resume.
  static const ttgImportState = 'ttgImportState';

  /// User-defined sidebar tab order (`sidebarOrder.<worldId>.<group>`).
  static const sidebarOrder = 'sidebarOrder';
}
