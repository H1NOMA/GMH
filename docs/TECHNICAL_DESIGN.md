# GMH — Game Master's Hub

## Technical Design Document

**Version:** 1.0
**Status:** Approved for implementation
**Targets:** iPhone, iPad, macOS, Windows (plus Android/Linux for free via Flutter)

---

## 1. Vision

GMH is a professional, offline-first **world-building and campaign-management workspace**
for Dungeon Masters. It combines:

- the **structured databases** of World Anvil (characters, locations, items, creatures, factions, events…),
- the **bidirectional linking & graph** of Obsidian,
- the **relational properties** of Notion,
- and a **campaign/quest/session manager** built for running games at the table.

It is engineered to stay fast with **10,000+ interconnected objects**, entirely local,
with no account and no network dependency.

---

## 2. Technology Stack

| Concern | Choice | Rationale |
|---|---|---|
| UI framework | **Flutter** (Dart) | Single codebase for iOS, iPadOS, macOS, Windows; 120 Hz rendering; excellent desktop support |
| Database | **SQLite** via **drift** | Type-safe reactive queries, compile-time schema, migrations, FTS5 full-text search, battle-tested at 10k+ rows |
| State management | **Riverpod** | Compile-safe DI + reactive state; testable; scales to large apps |
| Navigation | **go_router** | Declarative deep-linkable routing; adaptive shell layouts |
| Rich text | **flutter_quill** (Delta format) | Structured JSON document model → custom embeds for entity links, images, versioning, and future AI processing |
| Media storage | Local file system (`path_provider`) | Content-addressed media vault per world |
| Export/backup | `archive` (ZIP), `pdf` (world books), JSON | Portable, inspectable, restorable |
| IDs | UUID v4 | Stable identity across export/import and device moves |

### Why not per-platform native?

One rendering engine guarantees identical behavior of the editor, graph view and
database layer on every target — critical for a data-heavy tool.

---

## 3. Architecture

Clean Architecture with strict inward-pointing dependencies:

```
┌─────────────────────────────────────────────────────────┐
│  PRESENTATION  (features/*)                              │
│  Widgets · Screens · Riverpod controllers                │
├─────────────────────────────────────────────────────────┤
│  DOMAIN  (domain/*)                                      │
│  Models · Repository interfaces · Services (pure Dart)   │
│  Linking engine · Search contracts · AI-ready contracts  │
├─────────────────────────────────────────────────────────┤
│  DATA  (data/*)                                          │
│  drift database + DAOs · FTS5 search index               │
│  Media vault (file system) · Backup/export/import        │
└─────────────────────────────────────────────────────────┘
```

Rules:

1. **Domain** contains no Flutter and no drift imports — pure Dart, fully unit-testable.
2. **Presentation** talks only to domain interfaces (provided via Riverpod).
3. **Data** implements domain interfaces; swapping SQLite or the file vault never
   touches UI code.
4. Every subsystem (search, linking, editor, backup, graph) is an isolated module
   with its own contract.

### 3.1 The Unified Entity Model — the key design decision

Naively, an app like this grows one table + one CRUD screen per type (characters,
weapons, monsters…), which collapses under its own weight. Instead GMH uses a
**single `entities` table** with an `EntityKind` discriminator and a **schema-driven
attribute system**:

- Common data (name, summary, tags, links, documents, media, favorites, search)
  is implemented **once** and works for every current and future kind.
- Kind-specific structured fields (a weapon's damage, a quest's objectives, an
  NPC's alignment) are defined declaratively in **`EntityTemplate`** objects
  (domain layer) and stored as validated JSON in `entities.attributes_json`.
- Adding a new kind = adding one template definition. No migration, no new
  screens, no new DAOs.

This is the same architecture Notion ("databases + properties") and World Anvil
("article templates") converge on, and it is what makes the linking system,
graph view, global search and export **uniform across every object type**.

**Built-in kinds (v1):**

`world` (root), `character`, `location`, `item`, `creature`, `faction`,
`event`, `era`, `religion`, `magicSystem`, `technology`, `concept`,
`loreDocument`, `campaign`, `quest`, `session`.

### 3.2 Subsystem map

```
 ┌────────────┐   deltas    ┌──────────────┐  mention sync   ┌──────────────┐
 │  Editor    │────────────▶│ Document     │────────────────▶│ Linking      │
 │  (Quill)   │             │ Service      │                 │ Engine       │
 └────────────┘             └──────┬───────┘                 └──────┬───────┘
                                   │ plain text                     │ edges
                                   ▼                                ▼
                            ┌──────────────┐                 ┌──────────────┐
                            │ FTS5 Search  │                 │ Graph View   │
                            │ Index        │                 │ (force sim)  │
                            └──────────────┘                 └──────────────┘
        ┌──────────────┐          ▲                                ▲
        │ Media Vault  │          │              ┌─────────────────┘
        └──────┬───────┘          │              │
               ▼                  │              │
        ┌─────────────────────────┴──────────────┴───┐
        │              drift / SQLite                │
        └──────────────────────┬─────────────────────┘
                               ▼
                     ┌──────────────────┐
                     │ Backup · Export  │
                     │ Import · PDF     │
                     └──────────────────┘
```

---

## 4. Project Folder Structure

```
lib/
├── main.dart                     # bootstrap: DI, DB open, auto-backup kick-off
├── app/
│   ├── app.dart                  # MaterialApp.router + theming
│   ├── router.dart               # go_router config (adaptive shell)
│   └── theme/                    # dark-fantasy design system (colors, type, spacing)
├── core/                         # shared kernel — no feature imports
│   ├── constants.dart
│   ├── result.dart               # Result<T> error handling
│   ├── exceptions.dart
│   └── utils/                    # ids, dates, debouncer, json helpers
├── domain/
│   ├── models/                   # Entity, EntityKind, EntityTemplate, Link,
│   │                             # Tag, MediaItem, DocumentModel, ...
│   ├── repositories/             # abstract contracts (EntityRepository, ...)
│   ├── services/
│   │   ├── linking/              # mention extraction, backlink logic
│   │   ├── search/               # query parsing, ranking contract
│   │   ├── templates/            # built-in EntityTemplates per kind
│   │   └── ai/                   # AI-READY contracts only (no impl)
│   └── ...
├── data/
│   ├── db/
│   │   ├── app_database.dart     # drift schema + migrations + FTS5 index
│   │   ├── tables.dart
│   │   └── connection.dart       # background-isolate SQLite connection
│   ├── repositories/             # drift-backed implementations (the DAOs)
│   ├── storage/                  # MediaVault (content-addressed file store)
│   └── backup/                   # BackupService, ProjectExporter/Importer, PdfExporter
├── features/
│   ├── shell/                    # adaptive 3-panel desktop / mobile nav shell
│   ├── home/                     # world dashboard
│   ├── worlds/                   # world CRUD + picker
│   ├── entities/                 # browser, entity page, attribute forms, galleries
│   ├── editor/                   # Quill editor, entity-link embeds, versions
│   ├── search/                   # command palette, global search
│   ├── graph/                    # force-directed relationship graph
│   ├── campaigns/                # campaign/quest/session management UI
│   └── settings/                 # backups, export/import, preferences
└── ...
test/                             # unit tests (domain + data) and widget tests
docs/                             # this document + schema reference
```

---

## 5. Database Schema

See [`DATABASE_SCHEMA.md`](DATABASE_SCHEMA.md) for the full annotated schema.
Summary of tables:

| Table | Purpose |
|---|---|
| `worlds` | Root container per universe |
| `entities` | **All** world objects (unified model, soft-deletable, favoritable) |
| `documents` | Rich-text bodies (Quill Delta JSON + extracted plain text) |
| `document_versions` | Version history snapshots |
| `links` | Directed, role-labeled edges between entities (the linking system) |
| `tags` / `entity_tags` | Colored tags, many-to-many |
| `media` / `entity_media` | Media vault metadata + per-entity ordered galleries |
| `entity_search` | **FTS5** virtual table (name, summary, body, tags) |
| `recent_items` | Recently opened, for instant navigation |
| `settings` | Key-value app settings |

Performance measures for the 10k+ target:

- FTS5 with `prefix='2 3 4'` for as-you-type search, `bm25()` ranking.
- Covering indexes on `entities(world_id, kind)`, `links(source_id)`, `links(target_id)`.
- All list queries are paged & reactive (drift streams), UI virtualises lists.
- Document plain text lives in `documents`, not in memory; search returns
  snippets, not bodies.
- Soft deletes (`deleted_at`) keep referential integrity of links until purge.

---

## 6. Subsystem Designs

### 6.1 Linking System (Obsidian-grade)

- Every object has a UUID. A link is `(source, target, role, origin)`:
  - **role**: semantic label — `mention`, `owner`, `locatedAt`, `memberOf`,
    `participatedIn`, `createdAt`, custom…
  - **origin**: `manual` (added on the relations panel) or `document`
    (auto-extracted from an inline mention embed).
- **Inline mentions:** typing `@` in the editor opens an entity picker; the
  selection is inserted as a custom Quill embed `{entityId, label}` that renders
  as a tappable chip and navigates to the entity.
- **Sync:** on document save, the `LinkSyncService` diffs mention embeds against
  stored `document`-origin links — adds new, removes stale. Manual links are
  never touched by sync.
- **Backlinks:** reactive query `links WHERE target_id = X` grouped by role,
  shown on every entity page. Two-way visibility with zero user effort.

### 6.2 Editor System

- Quill Delta JSON: headers, bold/italic/underline/strike, lists (bullet,
  ordered, checked), quotes, code, dividers, **images** (vault-backed embeds),
  **entity links** (custom embed).
- Long-form support: `loreDocument` entities can be nested (chapter →
  `partOf` → book) so entire books are ordinary linked entities.
- **Version history:** debounced snapshots into `document_versions` (keep last
  25 per document) + manual checkpoints; restore = new version, non-destructive.
- Plain text is extracted on save for FTS and word counts.

### 6.3 Search Engine

- Single FTS5 index across all kinds; fields: name (boosted), summary, body, tags.
- Command palette (`Ctrl/Cmd+K` / search tab): instant-as-you-type (prefix
  index), recents when empty, kind filters, favorites section, quick commands
  ("New character", "Open graph"…).

### 6.4 Graph View

- Custom `CustomPainter` force-directed simulation (repulsion + spring +
  centering, velocity Verlet, cooled iterations) — no heavyweight dependency.
- Modes: **world graph** (filterable by kind) and **local graph** (n-hop
  neighborhood of the current entity).
- Pan/zoom, tap-to-open, node color by kind, edge labels by role.
- Capped/sampled layout beyond ~500 visible nodes to preserve 60fps.

### 6.5 Media Vault

- Content-addressed storage: files copied into
  `{appDocs}/gmh/worlds/{worldId}/media/{sha256}.{ext}` — automatic dedup.
- DB stores metadata; galleries are ordered `entity_media` rows with captions.
- Deleting an entity never orphans files silently: vault GC runs on backup.

### 6.6 Backup / Export / Import

- **Project archive (.gmhw ZIP):** `manifest.json` (format version, app
  version), `data.json` (all rows, normalized), `media/` (vault files).
  Import validates the manifest, remaps nothing (UUIDs are stable), restores
  media — this is also the device-migration path.
- **Automatic backups:** on app start (throttled to 1/day) into
  `{appDocs}/gmh/backups/`, rotating the last 7. Manual backups any time.
- **JSON export:** the same `data.json`, standalone.
- **PDF world book:** selectable kinds/documents rendered chapter-by-chapter
  with the `pdf` package.

### 6.7 AI-Ready Architecture (contracts only — no implementation)

`domain/services/ai/` defines:

- `AiAssistant` — capability interface (`generateQuest`, `findContradictions`,
  `answerLoreQuestion`) returning `Result`s; a `NoopAiAssistant` ships now.
- `LoreContextBuilder` — serializes an entity + n-hop neighborhood + relevant
  documents into a bounded, model-agnostic context payload. This is the hard
  part of AI integration and it is ready today, reusing the linking engine.
- Feature code depends only on these interfaces; wiring a local or remote model
  later is a data-layer plug-in.

---

## 7. UI / UX

**Design language:** dark fantasy — near-black parchment surfaces, ember-gold
accents, serif display faces for headings, high-contrast readable body text.
Inspired by D&D rulebooks, Baldur's Gate 3 menus, Obsidian's calm density.

- **Desktop / iPad landscape (≥ 1000 px):** three panels —
  left: world navigator (categories, tags, favorites); center: document/entity
  editor; right: properties, gallery, relations & backlinks.
- **Tablet portrait (600–1000 px):** two panels, right panel becomes a drawer.
- **Phone (< 600 px):** bottom navigation (Home, Browse, Search, Campaigns),
  card-based lists, swipeable entity pages, FAB for creation.
- Command palette everywhere; recents & favorites one tap away.

---

## 8. Error Handling & Quality

- `Result<T>` for all service/repository operations; failures carry typed
  `GmhException`s — UI shows recoverable messages, never crashes on data errors.
- All writes are transactional; import/restore is all-or-nothing.
- Unit tests cover: schema/DAOs, link sync, search indexing, template
  validation, export→import round-trip.
- `flutter analyze` clean; strict lints (`flutter_lints`).

---

## 9. Development Plan (stages)

| Stage | Scope | Status |
|---|---|---|
| 1 | Architecture, database, DI, theming, adaptive shell, navigation | ✅ this codebase |
| 2 | Unified entities + templates + attribute forms + Quill editor | ✅ this codebase |
| 3 | Linking engine, mention embeds, backlinks, relations panel | ✅ this codebase |
| 4 | Media vault, galleries, concept archive workflows | ✅ this codebase |
| 5 | Campaign / quest / session manager | ✅ this codebase |
| 6 | Backup, export (ZIP/JSON/PDF), import/restore | ✅ this codebase |
| 7 | Polish: graph view, command palette, performance passes | ✅ this codebase |
| 8+ | Sync between devices, canvas/map pins, dice & statblocks, AI plug-in | roadmap |
