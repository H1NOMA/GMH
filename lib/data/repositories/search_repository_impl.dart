import 'package:drift/drift.dart';

import '../../core/constants.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/search_result.dart';
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

/// FTS5-backed search. The `entity_search` virtual table is maintained here:
/// application services call [reindexEntity] after every entity, document or
/// tag write.
class SearchRepositoryImpl implements SearchRepository {
  final AppDatabase _db;
  final EntityRepository _entities;

  SearchRepositoryImpl(this._db, this._entities);

  /// Builds a safe FTS5 MATCH expression: each whitespace token is quoted and
  /// suffixed with `*` for prefix (as-you-type) matching.
  static String buildMatchQuery(String raw) {
    final tokens = raw
        .split(RegExp(r'\s+'))
        .map((t) => t.replaceAll('"', '').trim())
        .where((t) => t.isNotEmpty)
        .toList();
    return tokens.map((t) => '"$t"*').join(' ');
  }

  @override
  Future<List<SearchResult>> search(
    String worldId,
    String query, {
    EntityKind? kind,
    String? customCategoryId,
    int limit = 40,
  }) async {
    final match = buildMatchQuery(query);
    if (match.isEmpty) return [];

    final kindFilter = kind == null ? '' : 'AND e.kind = ? ';
    final categoryFilter =
        customCategoryId == null ? '' : 'AND e.custom_category_id = ? ';
    final rows = await _db.customSelect(
      '''
      SELECT e.id, e.kind, e.name, e.summary,
             snippet(entity_search, 3, '${SearchResult.snippetMarkerStart}',
                     '${SearchResult.snippetMarkerEnd}', '…', 14) AS snip,
             bm25(entity_search, 0.0, 4.0, 2.0, 1.0, 2.0) AS rank
      FROM entity_search
      JOIN entities e ON e.id = entity_search.entity_id
      WHERE entity_search MATCH ?
        AND e.world_id = ?
        AND e.deleted_at IS NULL
        $kindFilter
        $categoryFilter
      ORDER BY rank
      LIMIT ?
      ''',
      variables: [
        Variable.withString(match),
        Variable.withString(worldId),
        if (kind != null) Variable.withString(kind.name),
        if (customCategoryId != null) Variable.withString(customCategoryId),
        Variable.withInt(limit),
      ],
      readsFrom: {_db.entities},
    ).get();

    final results = <SearchResult>[];
    for (final row in rows) {
      final entityKind = EntityKind.tryParse(row.read<String>('kind'));
      if (entityKind == null) continue;
      results.add(SearchResult(
        entityId: row.read<String>('id'),
        kind: entityKind,
        name: row.read<String>('name'),
        summary: row.read<String>('summary'),
        snippet: row.read<String?>('snip') ?? '',
        rank: row.read<double?>('rank') ?? 0,
      ));
    }
    return results;
  }

  @override
  Future<void> reindexEntity(String entityId) async {
    final entity = await _entities.getEntity(entityId);
    await _db.customStatement(
        'DELETE FROM entity_search WHERE entity_id = ?', [entityId]);
    if (entity == null || entity.isDeleted) return;

    final doc = await (_db.select(_db.documents)
          ..where((d) => d.entityId.equals(entityId)))
        .getSingleOrNull();

    final tagRows = await _db.customSelect(
      'SELECT t.name FROM tags t '
      'JOIN entity_tags et ON et.tag_id = t.id WHERE et.entity_id = ?',
      variables: [Variable.withString(entityId)],
    ).get();
    final tagText = tagRows.map((r) => r.read<String>('name')).join(' ');

    await _db.customStatement(
      'INSERT INTO entity_search (entity_id, name, summary, body, tags) '
      'VALUES (?, ?, ?, ?, ?)',
      [
        entityId,
        entity.name,
        entity.summary,
        doc?.plainText ?? '',
        tagText,
      ],
    );
  }

  @override
  Future<void> rebuildIndex(String worldId) async {
    final entities = await _entities.getAllEntities(worldId);
    await _db.customStatement(
      'DELETE FROM entity_search WHERE entity_id IN '
      '(SELECT id FROM entities WHERE world_id = ?)',
      [worldId],
    );
    for (final entity in entities) {
      await reindexEntity(entity.id);
    }
  }

  @override
  Future<void> recordOpened(String entityId) async {
    await _db.into(_db.recentItems).insert(
          RecentItemsCompanion.insert(entityId: entityId, openedAt: nowMs()),
          mode: InsertMode.insertOrReplace,
        );
    // Cap per world.
    await _db.customStatement('''
      DELETE FROM recent_items WHERE entity_id IN (
        SELECT r.entity_id FROM recent_items r
        JOIN entities e ON e.id = r.entity_id
        WHERE e.world_id = (SELECT world_id FROM entities WHERE id = ?)
        ORDER BY r.opened_at DESC
        LIMIT -1 OFFSET ?
      )
    ''', [entityId, GmhConstants.maxRecentItems]);
  }

  @override
  Future<List<Entity>> recentlyOpened(String worldId, {int limit = 15}) async {
    final rows = await _db.customSelect(
      '''
      SELECT e.id FROM recent_items r
      JOIN entities e ON e.id = r.entity_id
      WHERE e.world_id = ? AND e.deleted_at IS NULL
      ORDER BY r.opened_at DESC
      LIMIT ?
      ''',
      variables: [Variable.withString(worldId), Variable.withInt(limit)],
      readsFrom: {_db.recentItems, _db.entities},
    ).get();
    final ids = rows.map((r) => r.read<String>('id')).toList();
    final entities = await _entities.getEntitiesByIds(ids);
    // Preserve recency order.
    final byId = {for (final e in entities) e.id: e};
    return [
      for (final id in ids)
        if (byId[id] != null) byId[id]!
    ];
  }
}
