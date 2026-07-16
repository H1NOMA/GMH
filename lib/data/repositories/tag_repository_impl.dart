import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../../domain/models/tag.dart' as domain;
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

/// Default tag palette cycled through as tags are created.
const _tagPalette = [
  0xFFB4846C, 0xFF7D8F69, 0xFFA26769, 0xFF6C7B95,
  0xFF9A8C98, 0xFFC9A227, 0xFF5F797B, 0xFF8E6C88,
];

class TagRepositoryImpl implements TagRepository {
  final AppDatabase _db;

  TagRepositoryImpl(this._db);

  domain.Tag _map(TagRow row) => domain.Tag(
        id: row.id,
        worldId: row.worldId,
        name: row.name,
        color: row.color,
      );

  @override
  Stream<List<domain.Tag>> watchTags(String worldId) {
    return (_db.select(_db.tags)
          ..where((t) => t.worldId.equals(worldId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  @override
  Future<domain.Tag> getOrCreate(String worldId, String name,
      {int? color}) async {
    final normalized = name.trim();
    final existing = await (_db.select(_db.tags)
          ..where((t) => t.worldId.equals(worldId) & t.name.equals(normalized)))
        .getSingleOrNull();
    if (existing != null) return _map(existing);

    final count = await (_db.selectOnly(_db.tags)
          ..addColumns([_db.tags.id.count()])
          ..where(_db.tags.worldId.equals(worldId)))
        .map((r) => r.read(_db.tags.id.count())!)
        .getSingle();

    final tag = domain.Tag(
      id: newId(),
      worldId: worldId,
      name: normalized,
      color: color ?? _tagPalette[count % _tagPalette.length],
    );
    await _db.into(_db.tags).insert(TagsCompanion.insert(
          id: tag.id,
          worldId: worldId,
          name: normalized,
          color: tag.color,
        ));
    return tag;
  }

  @override
  Future<void> rename(String tagId, String name) async {
    await (_db.update(_db.tags)..where((t) => t.id.equals(tagId)))
        .write(TagsCompanion(name: Value(name.trim())));
  }

  @override
  Future<void> setColor(String tagId, int color) async {
    await (_db.update(_db.tags)..where((t) => t.id.equals(tagId)))
        .write(TagsCompanion(color: Value(color)));
  }

  @override
  Future<void> delete(String tagId) async {
    await (_db.delete(_db.tags)..where((t) => t.id.equals(tagId))).go();
  }

  @override
  Stream<List<domain.Tag>> watchEntityTags(String entityId) {
    final join = _db.select(_db.tags).join([
      innerJoin(_db.entityTags, _db.entityTags.tagId.equalsExp(_db.tags.id)),
    ])
      ..where(_db.entityTags.entityId.equals(entityId))
      ..orderBy([OrderingTerm.asc(_db.tags.name)]);
    return join
        .watch()
        .map((rows) => rows.map((r) => _map(r.readTable(_db.tags))).toList());
  }

  @override
  Future<List<domain.Tag>> entityTags(String entityId) async {
    final join = _db.select(_db.tags).join([
      innerJoin(_db.entityTags, _db.entityTags.tagId.equalsExp(_db.tags.id)),
    ])
      ..where(_db.entityTags.entityId.equals(entityId));
    final rows = await join.get();
    return rows.map((r) => _map(r.readTable(_db.tags))).toList();
  }

  @override
  Future<void> tagEntity(String entityId, String tagId) async {
    await _db.into(_db.entityTags).insert(
          EntityTagsCompanion.insert(entityId: entityId, tagId: tagId),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<void> untagEntity(String entityId, String tagId) async {
    await (_db.delete(_db.entityTags)
          ..where((et) => et.entityId.equals(entityId) & et.tagId.equals(tagId)))
        .go();
  }
}
