import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/link.dart' as domain;
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

class LinkRepositoryImpl implements LinkRepository {
  final AppDatabase _db;

  LinkRepositoryImpl(this._db);

  domain.Link _map(LinkRow row) => domain.Link(
        id: row.id,
        worldId: row.worldId,
        sourceId: row.sourceId,
        targetId: row.targetId,
        role: row.role,
        origin: domain.LinkOrigin.parse(row.origin),
        createdAt: row.createdAt,
      );

  // Links whose other end is in the trash are hidden (and the stream
  // re-emits when an entry is trashed or restored), so panels never show
  // role headings over nothing.
  Stream<List<domain.Link>> _watchLive(
      String entityId, GeneratedColumn<String> own, GeneratedColumn<String> other) {
    final query = _db.select(_db.links).join([
      innerJoin(_db.entities, _db.entities.id.equalsExp(other)),
    ])
      ..where(own.equals(entityId) & _db.entities.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.links.role)]);
    return query
        .watch()
        .map((rows) => [for (final r in rows) _map(r.readTable(_db.links))]);
  }

  @override
  Stream<List<domain.Link>> watchOutgoing(String entityId) =>
      _watchLive(entityId, _db.links.sourceId, _db.links.targetId);

  @override
  Stream<List<domain.Link>> watchIncoming(String entityId) =>
      _watchLive(entityId, _db.links.targetId, _db.links.sourceId);

  @override
  Future<List<domain.Link>> outgoing(String entityId) async {
    final rows = await (_db.select(_db.links)
          ..where((l) => l.sourceId.equals(entityId)))
        .get();
    return rows.map(_map).toList();
  }

  @override
  Future<List<domain.Link>> allForWorld(String worldId) async {
    final rows = await (_db.select(_db.links)
          ..where((l) => l.worldId.equals(worldId)))
        .get();
    return rows.map(_map).toList();
  }

  @override
  Future<domain.Link> create({
    required String worldId,
    required String sourceId,
    required String targetId,
    required String role,
    required domain.LinkOrigin origin,
  }) async {
    final link = domain.Link(
      id: newId(),
      worldId: worldId,
      sourceId: sourceId,
      targetId: targetId,
      role: role,
      origin: origin,
      createdAt: nowMs(),
    );
    await _db.into(_db.links).insert(
          LinksCompanion.insert(
            id: link.id,
            worldId: worldId,
            sourceId: sourceId,
            targetId: targetId,
            role: Value(role),
            origin: origin.name,
            createdAt: link.createdAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return link;
  }

  @override
  Future<void> delete(String linkId) async {
    await (_db.delete(_db.links)..where((l) => l.id.equals(linkId))).go();
  }

  @override
  Future<void> replaceForOrigin({
    required String worldId,
    required String sourceId,
    required domain.LinkOrigin origin,
    required Map<String, Set<String>> targets,
  }) async {
    bool wanted(String targetId, String role) =>
        targets[targetId]?.contains(role) ?? false;
    await _db.transaction(() async {
      final existing = await (_db.select(_db.links)
            ..where((l) =>
                l.sourceId.equals(sourceId) & l.origin.equals(origin.name)))
          .get();

      // Remove links whose (target, role) pair is no longer wanted.
      for (final row in existing) {
        if (!wanted(row.targetId, row.role)) {
          await (_db.delete(_db.links)..where((l) => l.id.equals(row.id)))
              .go();
        }
      }

      // Add missing pairs; skip targets that no longer exist.
      final kept = {
        for (final row in existing)
          if (wanted(row.targetId, row.role)) (row.targetId, row.role)
      };
      for (final MapEntry(key: targetId, value: roles) in targets.entries) {
        final missing = roles.where((r) => !kept.contains((targetId, r)));
        if (missing.isEmpty) continue;
        // Same-world targets only: a chip pasted from another world's lore
        // must not wire that world's entry into this graph.
        final targetExists = await (_db.select(_db.entities)
              ..where((e) => e.id.equals(targetId) & e.worldId.equals(worldId)))
            .getSingleOrNull();
        if (targetExists == null) continue;
        for (final role in missing) {
          await _db.into(_db.links).insert(
                LinksCompanion.insert(
                  id: newId(),
                  worldId: worldId,
                  sourceId: sourceId,
                  targetId: targetId,
                  role: Value(role),
                  origin: origin.name,
                  createdAt: nowMs(),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }
    });
  }
}
