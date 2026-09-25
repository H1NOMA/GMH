import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

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

  /// Bumped whenever the indexed text format changes; a stale index is
  /// rebuilt once, on first use.
  ///  * 2: CJK characters indexed as separate tokens; rows keyed by the
  ///    entity's rowid.
  ///  * 3: structured field values are searchable too.
  static const _indexVersion = 3;
  static const _indexVersionKey = 'searchIndexVersion';
  Future<void>? _ready;

  Future<void> _ensureCurrent() => _ready ??= _upgradeIndex();

  Future<void> _upgradeIndex() async {
    final row = await (_db.select(_db.settings)
          ..where((s) => s.key.equals(_indexVersionKey)))
        .getSingleOrNull();
    if (int.tryParse(row?.value ?? '') == _indexVersion) return;
    await _db.transaction(() async {
      await _db.customStatement('DELETE FROM entity_search');
      final ids = await _db
          .customSelect('SELECT id FROM entities WHERE deleted_at IS NULL')
          .map((r) => r.read<String>('id'))
          .get();
      for (final id in ids) {
        await _reindex(id);
      }
      await _db.into(_db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(
              key: _indexVersionKey, value: '$_indexVersion'));
    });
  }

  static final _cjk = RegExp(
      r'[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff66-\uff9f]');

  /// unicode61 has no word segmentation for Chinese or Japanese: a whole
  /// run of characters became one token and "城堡" never matched inside
  /// "龙之谷城堡". Each CJK character is indexed as its own token, and
  /// queries become phrases over those tokens.
  @visibleForTesting
  static String spaceCjk(String text) =>
      text.replaceAllMapped(_cjk, (m) => ' ${m[0]} ');

  static final _spacedCjk = RegExp(
      '([\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff66-\uff9f])'
      '(${SearchResult.snippetMarkerEnd})?\\s+(${SearchResult.snippetMarkerStart})?'
      '(?=[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff66-\uff9f])');

  /// Free-text values of an entry's fields (race, occupation, notes,
  /// list items, checklist lines…) — entity references are links, not
  /// words, and are left out.
  static Iterable<String> _attributeText(Map<String, Object?> attributes) sync* {
    Iterable<String> texts(Object? value) sync* {
      switch (value) {
        case String s when s.isNotEmpty && !s.startsWith('entity:'):
          yield s;
        case num n:
          yield '$n';
        case Map m when m['text'] is String:
          yield m['text'] as String;
        case List items:
          for (final item in items) {
            yield* texts(item);
          }
      }
    }

    for (final value in attributes.values) {
      yield* texts(value);
    }
  }

  /// Undoes [spaceCjk] in snippets shown to the user.
  static String _unspaceCjk(String text) => text.replaceAllMapped(
      _spacedCjk, (m) => '${m[1]}${m[2] ?? ''}${m[3] ?? ''}');

  /// Builds a safe FTS5 MATCH expression: each whitespace token is quoted and
  /// suffixed with `*` for prefix (as-you-type) matching. CJK tokens
  /// become phrases of single characters (see [spaceCjk]).
  static String buildMatchQuery(String raw) {
    final tokens = raw
        .split(RegExp(r'\s+'))
        .map((t) => spaceCjk(t.replaceAll('"', ''))
            .trim()
            .replaceAll(RegExp(r'\s+'), ' '))
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
    await _ensureCurrent();

    final kindFilter = kind == null ? '' : 'AND e.kind = ? ';
    final categoryFilter =
        customCategoryId == null ? '' : 'AND e.custom_category_id = ? ';
    final rows = await _db.customSelect(
      '''
      SELECT e.id, e.kind, e.custom_category_id, e.name, e.summary,
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
        customCategoryId: row.read<String?>('custom_category_id'),
        name: row.read<String>('name'),
        summary: row.read<String>('summary'),
        snippet: _unspaceCjk(row.read<String?>('snip') ?? ''),
        rank: row.read<double?>('rank') ?? 0,
      ));
    }
    return results;
  }

  @override
  Future<void> reindexEntity(String entityId) async {
    await _ensureCurrent();
    await _reindex(entityId);
  }

  /// Rows are keyed by the entity's rowid, so replacing one is an indexed
  /// lookup instead of a scan over the whole index (entity_id is an
  /// UNINDEXED column). Delete + insert run as one transaction: two
  /// interleaved reindexes of one entry can't leave two rows or none.
  Future<void> _reindex(String entityId) => _db.transaction(() async {
        final entity = await _entities.getEntity(entityId);
        final rowIdRow = await _db
            .customSelect('SELECT rowid AS r FROM entities WHERE id = ?',
                variables: [Variable.withString(entityId)])
            .getSingleOrNull();
        final rowId = rowIdRow?.read<int>('r');
        if (rowId != null) {
          await _db.customStatement(
              'DELETE FROM entity_search WHERE rowid = ?', [rowId]);
        }
        if (entity == null || entity.isDeleted || rowId == null) return;

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
          'INSERT INTO entity_search (rowid, entity_id, name, summary, body, tags) '
          'VALUES (?, ?, ?, ?, ?, ?)',
          [
            rowId,
            entityId,
            spaceCjk(entity.name),
            spaceCjk(entity.summary),
            spaceCjk([
              doc?.plainText ?? '',
              ..._attributeText(entity.attributes),
            ].where((t) => t.isNotEmpty).join('\n')),
            spaceCjk(tagText),
          ],
        );
      });

  @override
  Future<void> rebuildIndex(String worldId) async {
    await _ensureCurrent();
    final entities = await _entities.getAllEntities(worldId);
    await _db.customStatement(
      'DELETE FROM entity_search WHERE entity_id IN '
      '(SELECT id FROM entities WHERE world_id = ?)',
      [worldId],
    );
    for (final entity in entities) {
      await _reindex(entity.id);
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
  Stream<List<Entity>> watchRecentlyOpened(String worldId, {int limit = 15}) {
    // Re-emits whenever an entry is opened (recent_items) or an entry
    // changes (entities), so "Recently opened" is always current.
    return _db
        .customSelect(
          'SELECT 1',
          readsFrom: {_db.recentItems, _db.entities},
        )
        .watch()
        .asyncMap((_) => recentlyOpened(worldId, limit: limit));
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
