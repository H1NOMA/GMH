import '../../core/exceptions.dart';
import '../../core/result.dart';
import '../models/entity.dart';
import '../models/entity_kind.dart';
import '../repositories/repositories.dart';
import 'document_service.dart';
import 'linking/link_sync_service.dart';
import 'templates/entity_templates.dart';

/// Application service for entity writes. Every mutation goes through here so
/// the invariants hold in one place:
///
///   sanitize attributes → persist → mirror entityRef links → reindex search.
class EntityService {
  final EntityRepository _entities;
  final TagRepository _tags;
  final SearchRepository _search;
  final LinkSyncService _linkSync;

  /// Optional so data-only callers (imports, tests) can skip mention
  /// relabeling; the app always wires it.
  final DocumentService? _documents;

  EntityService(this._entities, this._tags, this._search, this._linkSync,
      {DocumentService? documents})
      : _documents = documents;

  /// Keeps stored mention labels in other documents in step with a
  /// rename (search, exports and copy use them).
  Future<void> _afterRename(Entity before, Entity after) async {
    if (before.name != after.name) {
      await _documents?.relabelMentionsOf(after.id, after.name);
    }
  }

  Future<Result<Entity>> create({
    required String worldId,
    required EntityKind kind,
    String? customCategoryId,
    required String name,
    String summary = '',
    Map<String, Object?> attributes = const {},
  }) {
    return guard(() async {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw const ValidationException('Name cannot be empty.');
      }
      final template = EntityTemplates.of(kind);
      final entity = await _entities.createEntity(
        worldId: worldId,
        kind: kind,
        customCategoryId: kind == EntityKind.custom ? customCategoryId : null,
        name: trimmed,
        summary: summary.trim(),
        attributes: template.sanitize(attributes),
      );
      await _linkSync.syncAttributeRefs(entity);
      await _search.reindexEntity(entity.id);
      return entity;
    });
  }

  Future<Result<Entity>> update(Entity entity) {
    return guard(() async {
      if (entity.name.trim().isEmpty) {
        throw const ValidationException('Name cannot be empty.');
      }
      final template = EntityTemplates.of(entity.kind);
      final sanitized =
          entity.copyWith(attributes: template.sanitize(entity.attributes));
      final before = await _entities.getEntity(entity.id);
      await _entities.updateEntity(sanitized);
      await _linkSync.syncAttributeRefs(sanitized);
      await _search.reindexEntity(entity.id);
      if (before != null) await _afterRename(before, sanitized);
      return sanitized;
    });
  }

  /// Read-modify-write of a single attribute against the freshest row.
  /// Widgets hold build-time entity snapshots; two quick edits of different
  /// fields would otherwise overwrite each other with stale data.
  Future<Result<Entity>> setAttribute(
      String entityId, String key, Object? value) {
    return guard(() async {
      final current = await _entities.getEntity(entityId);
      if (current == null) {
        throw const ValidationException('Entry no longer exists.');
      }
      final attributes = Map<String, Object?>.of(current.attributes);
      if (value == null ||
          (value is String && value.isEmpty) ||
          (value is List && value.isEmpty)) {
        attributes.remove(key);
      } else {
        attributes[key] = value;
      }
      final template = EntityTemplates.of(current.kind);
      final updated =
          current.copyWith(attributes: template.sanitize(attributes));
      await _entities.updateEntity(updated);
      await _linkSync.syncAttributeRefs(updated);
      await _search.reindexEntity(updated.id);
      return updated;
    });
  }

  /// Renames against the freshest row (only name and summary change).
  Future<Result<Entity>> rename(String entityId,
      {required String name, required String summary}) {
    return guard(() async {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw const ValidationException('Name cannot be empty.');
      }
      final current = await _entities.getEntity(entityId);
      if (current == null) {
        throw const ValidationException('Entry no longer exists.');
      }
      final updated =
          current.copyWith(name: trimmed, summary: summary.trim());
      await _entities.updateEntity(updated);
      await _search.reindexEntity(entityId);
      await _afterRename(current, updated);
      return updated;
    });
  }

  /// Sets (or clears) the cover image against the freshest row. With
  /// [onlyIfEmpty], an existing cover is kept — used when the first image
  /// added to an entry becomes its cover.
  Future<Result<void>> setCover(String entityId, String? mediaId,
      {bool onlyIfEmpty = false}) {
    return guard(() async {
      final current = await _entities.getEntity(entityId);
      if (current == null) return;
      if (onlyIfEmpty && current.coverMediaId != null) return;
      await _entities.updateEntity(
          current.copyWith(coverMediaId: () => mediaId));
    });
  }

  Future<Result<void>> setFavorite(String id, bool favorite) =>
      guard(() => _entities.setFavorite(id, favorite));

  Future<Result<void>> moveToTrash(String id) =>
      guard(() => _entities.softDelete(id));

  Future<Result<void>> restore(String id) => guard(() async {
        await _entities.restore(id);
        await _search.reindexEntity(id);
      });

  /// Deletes a trashed entry for good (its document, links and gallery
  /// rows cascade; unused media files go at the next sweep).
  Future<Result<void>> purge(String id) => guard(() => _entities.purge(id));

  /// Purges every trashed entry of [worldId]; returns how many.
  Future<Result<int>> emptyTrash(String worldId) => guard(() async {
        final trashed = await _entities.watchTrash(worldId).first;
        for (final entity in trashed) {
          await _entities.purge(entity.id);
        }
        return trashed.length;
      });

  Future<Result<void>> addTag(String entityId, String worldId, String tagName) {
    return guard(() async {
      final tag = await _tags.getOrCreate(worldId, tagName);
      await _tags.tagEntity(entityId, tag.id);
      await _search.reindexEntity(entityId);
    });
  }

  Future<Result<void>> removeTag(String entityId, String tagId) {
    return guard(() async {
      await _tags.untagEntity(entityId, tagId);
      await _search.reindexEntity(entityId);
    });
  }
}
