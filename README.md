# GMH — Game Master's Hub

An **offline-first world-building and campaign-management workspace** for
Dungeon Masters. Think *Obsidian × Notion × World Anvil*, built for running
D&D worlds with thousands of interconnected objects — entirely local, no
account, no cloud.

**Targets:** iPhone · iPad · macOS · Windows (Android/Linux build too — one
Flutter codebase).

## What it does

- **World database** — characters, locations, items, creatures, factions,
  events, eras, religions, magic systems, technologies, all in one unified,
  template-driven entity system.
- **Concept archive** — categories, tags, notes, image galleries, and
  relationships for every creative idea.
- **Advanced linking** — inline `@` mentions in documents, role-labeled
  relations (`owner`, `locatedAt`, `questGiver`, …), automatic backlinks, and
  structured fields that mirror into the link graph.
- **Rich lore editor** — headers, lists, quotes, checklists, images from the
  local media vault, entity-link chips, autosave and version history.
- **Campaign manager** — campaigns, quests with objective checklists and a
  status quest board, session logs with player decisions and consequences.
- **Instant global search** — SQLite FTS5 across names, summaries, document
  bodies and tags, with prefix (as-you-type) matching, kind filters, recents
  and favorites. Built to stay fast past 10,000 entries.
- **Graph view** — force-directed relationship map (whole world or the local
  neighborhood of one entry), colored by kind, tap to navigate.
- **Backups & portability** — rotating automatic backups, one-file `.gmhw`
  project archives (database + media) for device migration, JSON export, and
  printable PDF world books.
- **Attachments everywhere** — unlimited files of any type on every entry:
  image galleries with a full-screen viewer, PDFs, documents, audio, video,
  archives; drag & drop on desktop, photo gallery import on mobile; rename,
  replace, captions and safe deletion with vault garbage collection.
- **Bilingual UI** — full English and Russian localization with a language
  switcher in Settings; the system language is detected on first launch.
- **AI-ready** — grounding/context-building contracts are in place
  (`domain/services/ai/`); no AI is implemented or required.

## Architecture

Clean Architecture in three strict layers (see
[`docs/TECHNICAL_DESIGN.md`](docs/TECHNICAL_DESIGN.md) and
[`docs/DATABASE_SCHEMA.md`](docs/DATABASE_SCHEMA.md)):

```
presentation  lib/features/*   Flutter widgets + Riverpod controllers
domain        lib/domain/*     pure-Dart models, contracts, services
data          lib/data/*       drift/SQLite, FTS5, media vault, backup
```

Key decisions:

- **Unified entity model** — one `entities` table + declarative
  `EntityTemplate`s per kind; new object types need no migrations and get
  linking/search/graph/export for free.
- **drift (SQLite)** with reactive streams — every screen is live.
- **Content-addressed media vault** — images dedupe automatically and export
  byte-for-byte.
- **Everything is a `Result`** — typed failures end as friendly messages,
  never crashes.

## Getting started

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift codegen
flutter run            # pick your device: macOS, Windows, iOS, Android
```

Run the checks:

```sh
flutter analyze
flutter test
```

## Repository layout

| Path | Contents |
|---|---|
| `docs/` | Technical design + database schema documentation |
| `lib/app/` | Bootstrap, DI composition root, router, dark-fantasy theme |
| `lib/core/` | Result type, exceptions, constants, small utilities |
| `lib/domain/` | Models, repository contracts, linking/template/AI services |
| `lib/data/` | drift database, repositories, media vault, backup/export |
| `lib/features/` | Shell, worlds, entities, editor, search, graph, campaigns, settings |
| `test/` | Unit tests (domain + full data layer) and widget smoke tests |

All user data lives under the app documents directory:
`gmh/gmh.db` (SQLite), `gmh/worlds/<id>/media/` (vault),
`gmh/backups/` (rotating archives), `gmh/exports/`.
