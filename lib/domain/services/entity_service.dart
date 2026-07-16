import '../../core/exceptions.dart';
import '../../core/result.dart';
import '../models/entity.dart';
import '../models/entity_kind.dart';
import '../repositories/repositories.dart';
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

  EntityService(this._entities, this._tags, this._search, this._linkSync);

  Future<Result<Entity>> create({
    required String worldId,
    required EntityKind kind,
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
      await _entities.updateEntity(sanitized);
      await _linkSync.syncAttributeRefs(sanitized);
      await _search.reindexEntity(entity.id);
      return sanitized;
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
