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

  @override
  Stream<List<domain.Link>> watchOutgoing(String entityId) {
    return (_db.select(_db.links)
          ..where((l) => l.sourceId.equals(entityId))
          ..orderBy([(l) => OrderingTerm.asc(l.role)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  @override
  Stream<List<domain.Link>> watchIncoming(String entityId) {
    return (_db.select(_db.links)
          ..where((l) => l.targetId.equals(entityId))
          ..orderBy([(l) => OrderingTerm.asc(l.role)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

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
    required Map<String, String> targets,
  }) async {
    await _db.transaction(() async {
      final existing = await (_db.select(_db.links)
            ..where((l) =>
                l.sourceId.equals(sourceId) & l.origin.equals(origin.name)))
          .get();

      // Remove links whose (target, role) pair is no longer wanted.
      for (final row in existing) {
        if (targets[row.targetId] != row.role) {
          await (_db.delete(_db.links)..where((l) => l.id.equals(row.id)))
              .go();
        }
      }

      // Add missing links; skip targets that no longer exist.
      final kept = {
        for (final row in existing)
          if (targets[row.targetId] == row.role) row.targetId
      };
      for (final entry in targets.entries) {
        if (kept.contains(entry.key)) continue;
        final targetExists = await (_db.select(_db.entities)
              ..where((e) => e.id.equals(entry.key)))
            .getSingleOrNull();
        if (targetExists == null) continue;
        await _db.into(_db.links).insert(
              LinksCompanion.insert(
                id: newId(),
                worldId: worldId,
                sourceId: sourceId,
                targetId: entry.key,
                role: Value(entry.value),
                origin: origin.name,
                createdAt: nowMs(),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
    });
  }
}
