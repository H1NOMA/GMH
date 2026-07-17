import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The GMH SQLite database.
///
/// Schema documentation lives in `docs/DATABASE_SCHEMA.md`. The FTS5 search
/// index (`entity_search`) is a virtual table created in the migration
/// callbacks below because drift table classes cannot express FTS5 options
/// like prefix indexes.
@DriftDatabase(tables: [
  Worlds,
  CustomCategories,
  Entities,
  Documents,
  DocumentVersions,
  Links,
  Tags,
  EntityTags,
  MediaFiles,
  EntityMedia,
  RecentItems,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createSearchIndex();
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2: user-defined archive categories.
            await m.createTable(customCategories);
            await m.addColumn(entities, entities.customCategoryId);
          }
          if (from < 3) {
            // v3: tag creation timestamps for the Tag Manager. Existing
            // tags get 0 (sorted as oldest) — no other data changes.
            await m.addColumn(tags, tags.createdAt);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createSearchIndex() async {
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS entity_search USING fts5(
        entity_id UNINDEXED, name, summary, body, tags,
        tokenize = 'unicode61 remove_diacritics 2',
        prefix = '2 3 4'
      )
    ''');
  }

  Future<void> _createIndexes() async {
    await customStatement('CREATE INDEX IF NOT EXISTS idx_entities_world_kind '
        'ON entities (world_id, kind)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_entities_updated '
        'ON entities (world_id, updated_at DESC)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_links_source '
        'ON links (source_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_links_target '
        'ON links (target_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_links_world '
        'ON links (world_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_versions_document '
        'ON document_versions (document_id, created_at DESC)');
  }
}
