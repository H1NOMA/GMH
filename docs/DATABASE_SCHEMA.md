# GMH Database Schema

SQLite via **drift**. All IDs are UUID v4 strings. All timestamps are UTC
milliseconds since epoch. Soft deletes via `deleted_at` (NULL = alive).

```
┌──────────┐ 1     n ┌────────────┐ 1     1 ┌────────────┐ 1    n ┌────────────────────┐
│  worlds  │────────▶│  entities  │────────▶│ documents  │───────▶│ document_versions  │
└──────────┘         └─────┬──────┘         └────────────┘        └────────────────────┘
                       │ │ │
        source/target  │ │ │ n:m                n:m
      ┌────────────────┘ │ └───────────┐   ┌──────────────┐
      ▼                  ▼             ▼   ▼              │
┌──────────┐      ┌─────────────┐   ┌─────────────┐  ┌─────────┐
│  links   │      │ entity_tags │──▶│    tags     │  │ entity_ │──▶ media
└──────────┘      └─────────────┘   └─────────────┘  │ media   │
                                                     └─────────┘
```

## worlds

| column | type | notes |
|---|---|---|
| id | TEXT PK | UUID |
| name | TEXT NOT NULL | |
| description | TEXT | |
| cover_media_id | TEXT NULL | FK → media.id (SET NULL) |
| created_at / updated_at | INT NOT NULL | epoch ms |

## entities  — the unified object table

| column | type | notes |
|---|---|---|
| id | TEXT PK | UUID |
| world_id | TEXT NOT NULL | FK → worlds.id (CASCADE) |
| kind | TEXT NOT NULL | `EntityKind` name (character, location, item, creature, faction, event, era, religion, magicSystem, technology, concept, loreDocument, campaign, quest, session) |
| name | TEXT NOT NULL | |
| summary | TEXT NOT NULL DEFAULT '' | one-line description shown in lists/search |
| attributes_json | TEXT NOT NULL DEFAULT '{}' | kind-specific structured fields, validated by `EntityTemplate` |
| cover_media_id | TEXT NULL | FK → media.id (SET NULL) |
| is_favorite | BOOL DEFAULT false | |
| created_at / updated_at | INT NOT NULL | |
| deleted_at | INT NULL | soft delete |

Indexes: `(world_id, kind)`, `(world_id, is_favorite)`, `(world_id, updated_at DESC)`.

### Attribute storage

`attributes_json` holds template-defined fields, e.g. a `quest`:

```json
{
  "status": "active",
  "objectives": [{"text": "Find the Dragon Forge", "done": true}],
  "rewards": "500 gp, the Ashen Key",
  "questGiver": "entity:0f1c…"
}
```

Fields of type `entityRef` store `entity:<uuid>` and are mirrored into `links`
by the template service, so structured fields participate in
backlinks/graph automatically.

## documents

One rich-text body per entity (created lazily).

| column | type | notes |
|---|---|---|
| id | TEXT PK | UUID |
| entity_id | TEXT NOT NULL UNIQUE | FK → entities.id (CASCADE) |
| content_json | TEXT NOT NULL | Quill Delta ops |
| plain_text | TEXT NOT NULL | extracted on save; feeds FTS + word count |
| word_count | INT NOT NULL DEFAULT 0 | |
| updated_at | INT NOT NULL | |

## document_versions

| column | type | notes |
|---|---|---|
| id | TEXT PK | |
| document_id | TEXT NOT NULL | FK → documents.id (CASCADE) |
| content_json | TEXT NOT NULL | snapshot |
| note | TEXT | optional checkpoint label |
| created_at | INT NOT NULL | |

Retention: last 25 per document (pruned on insert).

## links — the relationship system

Directed, role-labeled edges. Backlinks = query by `target_id`.

| column | type | notes |
|---|---|---|
| id | TEXT PK | |
| world_id | TEXT NOT NULL | FK → worlds.id (CASCADE) |
| source_id | TEXT NOT NULL | FK → entities.id (CASCADE) |
| target_id | TEXT NOT NULL | FK → entities.id (CASCADE) |
| role | TEXT NOT NULL DEFAULT 'related' | mention, owner, locatedAt, memberOf, partOf, participatedIn, questGiver, … or custom |
| origin | TEXT NOT NULL | `manual` \| `document` \| `attribute` |
| created_at | INT NOT NULL | |

Unique: `(source_id, target_id, role, origin)`.
Indexes: `(source_id)`, `(target_id)`, `(world_id)`.

`document`-origin links are owned by the mention sync service;
`attribute`-origin links by the template service; `manual` links by the user.

## tags / entity_tags

`tags(id, world_id, name UNIQUE per world, color)` ·
`entity_tags(entity_id, tag_id)` PK(both), CASCADE both ways.

## media / entity_media

`media(id, world_id, file_name, relative_path, mime_type, size_bytes, created_at)` —
metadata for content-addressed files in the vault
(`worlds/{worldId}/media/{sha256}.{ext}`).

`entity_media(entity_id, media_id, sort_order, caption)` — ordered galleries.

## entity_search (FTS5 virtual table)

```sql
CREATE VIRTUAL TABLE entity_search USING fts5(
  entity_id UNINDEXED, name, summary, body, tags,
  tokenize = 'unicode61 remove_diacritics 2',
  prefix = '2 3 4'
);
```

Maintained by the search indexer on every entity/document/tag write.
Queried with `bm25(entity_search, 4.0, 2.0, 1.0, 2.0)` ranking (name boosted)
and `snippet()` for result previews.

## recent_items

`recent_items(entity_id PK, opened_at)` — capped at 50 per world on insert.

## settings

`settings(key PK, value)` — JSON-encoded app preferences
(last opened world, backup timestamps, theme options).

## Migration strategy

drift `schemaVersion` + stepwise `MigrationStrategy`. Rules:

1. Never repurpose a column; add new nullable/defaulted columns.
2. Attribute-level changes (templates) are **data-driven** and need no
   migration — unknown JSON keys are preserved, missing keys use defaults.
3. Every export embeds `formatVersion`; importer upgrades old archives.
