import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../../core/result.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/ids.dart';
import '../../../domain/models/entity_kind.dart';
import '../../../domain/models/link.dart';
import '../../../domain/repositories/repositories.dart';
import '../../db/app_database.dart';
import '../../storage/media_vault.dart';
import 'rich_text_converter.dart';
import 'ttg_mapping.dart';
import 'ttg_source.dart';

/// What to do when an imported record collides with existing data.
enum TtgDuplicateStrategy { skip, merge, replace, ask }

/// A duplicate the "ask" strategy surfaces to the UI.
class TtgDuplicate {
  final String name;
  final String collection;
  const TtgDuplicate({required this.name, required this.collection});
}

class TtgImportOptions {
  /// Import into this existing world; null = create a fresh world (default —
  /// existing user data is never touched unless explicitly requested).
  final String? targetWorldId;
  final String worldName;
  final TtgDuplicateStrategy duplicates;

  /// Called for each duplicate when [duplicates] is [TtgDuplicateStrategy.ask].
  final Future<TtgDuplicateStrategy> Function(TtgDuplicate duplicate)?
      onDuplicate;

  /// Polled between records; return true to stop. Progress committed so far
  /// stays in the database and the import can be resumed.
  final bool Function()? isCancelled;

  const TtgImportOptions({
    this.targetWorldId,
    required this.worldName,
    this.duplicates = TtgDuplicateStrategy.skip,
    this.onDuplicate,
    this.isCancelled,
  });
}

/// Live progress for the wizard.
class TtgImportProgress {
  final String phase; // reading | entities | links | validating | indexing
  final int total;
  final int processed;
  final String currentLabel;
  final int? etaSeconds;
  final List<String> errors;

  const TtgImportProgress({
    required this.phase,
    required this.total,
    required this.processed,
    this.currentLabel = '',
    this.etaSeconds,
    this.errors = const [],
  });

  double get fraction => total == 0 ? 0 : processed / total;
}

class TtgMigrationReport {
  final String worldId;
  final String worldName;
  final bool completed; // false = cancelled mid-way (resumable)
  final Map<String, int> importedByCollection;
  final int imported;
  final int skippedDuplicates;
  final int mergedDuplicates;
  final int replacedDuplicates;
  final int mediaImported;
  final int mediaMissing;
  final int linksCreated;
  final int repairedReferences; // dangling refs dropped or reconnected
  final int documentsCreated;
  final int tagsCreated;
  final List<String> errors;
  final Duration elapsed;
  final int sourceRecords;

  const TtgMigrationReport({
    required this.worldId,
    required this.worldName,
    required this.completed,
    required this.importedByCollection,
    required this.imported,
    required this.skippedDuplicates,
    required this.mergedDuplicates,
    required this.replacedDuplicates,
    required this.mediaImported,
    required this.mediaMissing,
    required this.linksCreated,
    required this.repairedReferences,
    required this.documentsCreated,
    required this.tagsCreated,
    required this.errors,
    required this.elapsed,
    required this.sourceRecords,
  });

  String toMarkdown() {
    final b = StringBuffer()
      ..writeln('# TTG Migration Report')
      ..writeln()
      ..writeln('World: **$worldName**')
      ..writeln()
      ..writeln('Status: ${completed ? 'completed' : 'interrupted (resumable)'}')
      ..writeln()
      ..writeln('## Totals')
      ..writeln()
      ..writeln('- Source records: $sourceRecords')
      ..writeln('- Imported: $imported')
      ..writeln('- Skipped duplicates: $skippedDuplicates')
      ..writeln('- Merged duplicates: $mergedDuplicates')
      ..writeln('- Replaced duplicates: $replacedDuplicates')
      ..writeln('- Documents created: $documentsCreated')
      ..writeln('- Tags created: $tagsCreated')
      ..writeln('- Media files imported: $mediaImported')
      ..writeln('- Media files missing in source: $mediaMissing')
      ..writeln('- Links created: $linksCreated')
      ..writeln('- References repaired: $repairedReferences')
      ..writeln('- Elapsed: ${elapsed.inSeconds}s')
      ..writeln()
      ..writeln('## By collection')
      ..writeln();
    importedByCollection.forEach((collection, count) {
      b.writeln('- $collection: $count');
    });
    if (errors.isNotEmpty) {
      b
        ..writeln()
        ..writeln('## Issues')
        ..writeln();
      for (final e in errors) {
        b.writeln('- $e');
      }
    }
    return b.toString();
  }
}

/// Preview shown before the import runs.
class TtgPreview {
  final String suggestedWorldName;
  final Map<String, int> collectionCounts;
  final Map<String, String> collectionTargets; // collection -> target label
  final List<String> issues;
  final bool resumable; // a matching interrupted import exists

  const TtgPreview({
    required this.suggestedWorldName,
    required this.collectionCounts,
    required this.collectionTargets,
    required this.issues,
    required this.resumable,
  });

  int get totalRecords =>
      collectionCounts.values.fold(0, (sum, c) => sum + c);
}

const _imageExtensions = {'.png', '.jpg', '.jpeg', '.webp', '.gif', '.bmp'};

const _mimeByExtension = {
  '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg',
  '.webp': 'image/webp', '.gif': 'image/gif', '.svg': 'image/svg+xml',
  '.bmp': 'image/bmp', '.pdf': 'application/pdf',
  '.docx':
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  '.doc': 'application/msword', '.txt': 'text/plain',
  '.md': 'text/markdown', '.rtf': 'application/rtf',
  '.mp3': 'audio/mpeg', '.wav': 'audio/wav', '.ogg': 'audio/ogg',
  '.flac': 'audio/flac', '.m4a': 'audio/mp4',
  '.mp4': 'video/mp4', '.webm': 'video/webm', '.mov': 'video/quicktime',
  '.avi': 'video/x-msvideo', '.mkv': 'video/x-matroska',
  '.zip': 'application/zip',
};

/// Migrates a TTG D&D database into GMH: every record, relationship, tag,
/// document and media file, converted to the native schema, validated and
/// reported. Deterministic ids make the import idempotent and resumable.
class TtgMigrationService {
  final AppDatabase _db;
  final MediaVault _vault;
  final SearchRepository _search;
  final SettingsRepository _settings;

  TtgMigrationService(this._db, this._vault, this._search, this._settings);

  /// Stable id for a source record: the same source always maps to the same
  /// GMH id, which is what makes resume and duplicate detection reliable.
  static String deterministicId(String worldId, String recordKey) {
    final digest = md5.convert(utf8.encode('gmh-ttg:$worldId:$recordKey'));
    final h = digest.toString();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
        '${h.substring(16, 20)}-${h.substring(20, 32)}';
  }

  // ------------------------------------------------------------- analyze

  Future<Result<TtgPreview>> analyze(String path) {
    return guard(() async {
      final source = await readTtgSource(path);
      final checkpoint = await _loadCheckpoint();
      return TtgPreview(
        suggestedWorldName: source.name,
        collectionCounts: {
          for (final e in source.collections.entries) e.key: e.value.length,
        },
        collectionTargets: {
          for (final name in source.collections.keys)
            name: _targetLabel(targetForCollection(name)),
        },
        issues: source.issues,
        resumable: checkpoint != null && checkpoint['path'] == path,
      );
    });
  }

  String _targetLabel(TtgTarget target) =>
      target.isCategory ? target.categoryName! : target.kind!.pluralLabel;

  Future<Map<String, Object?>?> _loadCheckpoint() async {
    final raw = await _settings.get(SettingsKeys.ttgImportState);
    if (raw == null) return null;
    try {
      return (jsonDecode(raw) as Map).cast<String, Object?>();
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------- migrate

  Future<Result<TtgMigrationReport>> migrate(
    String path,
    TtgImportOptions options, {
    void Function(TtgImportProgress progress)? onProgress,
  }) {
    return guard(() async {
      final started = DateTime.now();
      final errors = <String>[];

      void progress(String phase, int total, int done, [String label = '']) {
        if (onProgress == null) return;
        int? eta;
        final elapsed = DateTime.now().difference(started).inMilliseconds;
        if (done > 0 && done < total && elapsed > 500) {
          eta = ((elapsed / done) * (total - done) / 1000).round();
        }
        onProgress(TtgImportProgress(
          phase: phase,
          total: total,
          processed: done,
          currentLabel: label,
          etaSeconds: eta,
          errors: List.unmodifiable(errors),
        ));
      }

      progress('reading', 1, 0);
      final source = await readTtgSource(path);
      errors.addAll(source.issues);

      // Resume: same source file interrupted earlier -> reuse its world and
      // skip records that are already in (deterministic ids make that safe).
      final checkpoint = await _loadCheckpoint();
      final resuming = checkpoint != null &&
          checkpoint['path'] == path &&
          options.targetWorldId == null;

      final worldId = resuming
          ? checkpoint['worldId'] as String
          : (options.targetWorldId ?? await _createWorld(options.worldName));
      final worldName = resuming
          ? (checkpoint['worldName'] as String? ?? options.worldName)
          : options.worldName;

      await _settings.set(
        SettingsKeys.ttgImportState,
        jsonEncode({
          'path': path,
          'worldId': worldId,
          'worldName': worldName,
          'startedAt': nowMs(),
        }),
      );

      // Existing state used for duplicate detection.
      final existingByName = <String, String>{}; // 'kindOrCat|name' -> id
      final existingIds = <String>{};
      for (final row
          in await (_db.select(_db.entities)
                ..where((e) => e.worldId.equals(worldId)))
              .get()) {
        existingIds.add(row.id);
        final scope = row.customCategoryId ?? row.kind;
        existingByName['$scope|${row.name.trim().toLowerCase()}'] = row.id;
      }
      final tagIdByName = <String, String>{};
      for (final t in await (_db.select(_db.tags)
            ..where((t) => t.worldId.equals(worldId)))
          .get()) {
        tagIdByName[t.name.trim().toLowerCase()] = t.id;
      }
      final mediaIdByPath = <String, String>{};
      for (final m in await (_db.select(_db.mediaFiles)
            ..where((m) => m.worldId.equals(worldId)))
          .get()) {
        mediaIdByPath[m.relativePath] = m.id;
      }

      final categoryIdByName = await _ensureCategories(worldId, source);

      var imported = 0;
      var skipped = 0;
      var merged = 0;
      var replaced = 0;
      var mediaImported = 0;
      var mediaMissing = 0;
      var documentsCreated = 0;
      var tagsCreated = 0;
      final importedByCollection = <String, int>{};
      final idByKey = <String, String>{};
      final total = source.totalRecords;
      var done = 0;
      var cancelled = false;

      // ---------------------------------------------------- pass A: records
      for (final entry in source.collections.entries) {
        if (cancelled) break;
        final collection = entry.key;
        final target = targetForCollection(collection);
        final kindName = target.isCategory
            ? EntityKind.custom.name
            : target.kind!.name;
        final categoryId =
            target.isCategory ? categoryIdByName[target.categoryName!] : null;
        final scope = categoryId ?? kindName;
        importedByCollection.putIfAbsent(collection, () => 0);

        await _db.transaction(() async {
          for (final record in entry.value) {
            if (options.isCancelled?.call() == true) {
              cancelled = true;
              break;
            }
            done++;
            progress('entities', total, done, record.name);

            final id = deterministicId(worldId, record.key);
            final nameKey = '$scope|${record.name.trim().toLowerCase()}';
            String targetId = id;
            var strategy = options.duplicates;

            final existsById = existingIds.contains(id);
            final byNameId = existingByName[nameKey];
            final isDuplicate = existsById || byNameId != null;

            if (isDuplicate) {
              if (resuming && existsById) {
                // Interrupted import laying down the same records again.
                strategy = TtgDuplicateStrategy.skip;
              } else if (strategy == TtgDuplicateStrategy.ask) {
                strategy = await options.onDuplicate?.call(TtgDuplicate(
                        name: record.name, collection: collection)) ??
                    TtgDuplicateStrategy.skip;
              }
              targetId = existsById ? id : byNameId!;
              idByKey[record.key] = targetId;
              if (strategy == TtgDuplicateStrategy.skip ||
                  strategy == TtgDuplicateStrategy.ask) {
                skipped++;
                continue;
              }
              if (strategy == TtgDuplicateStrategy.merge) merged++;
              if (strategy == TtgDuplicateStrategy.replace) replaced++;
            } else {
              idByKey[record.key] = id;
            }

            try {
              final conversion = convertRichText(record.body);
              final mediaIds = <String>[];
              final allMedia = [
                ...record.media,
                for (final ref in conversion.imageRefs)
                  TtgMediaRef(ref: ref, fileName: p.basename(ref)),
              ];
              for (final m in allMedia) {
                final mediaId = await _importMedia(
                    worldId, m, source.readMedia, mediaIdByPath);
                if (mediaId == null) {
                  mediaMissing++;
                  if (m.ref != null) {
                    errors.add(
                        'Media not found for "${record.name}": ${m.ref}');
                  }
                } else {
                  mediaImported++;
                  mediaIds.add(mediaId);
                }
              }

              final isMerge =
                  isDuplicate && strategy == TtgDuplicateStrategy.merge;
              await _writeEntity(
                worldId: worldId,
                id: targetId,
                kindName: kindName,
                categoryId: categoryId,
                record: record,
                conversion: conversion,
                coverMediaId: mediaIds
                    .where((mid) => _isImage(mediaIdByPath, mid))
                    .firstOrNull,
                merge: isMerge,
              );
              if (conversion.plainText.isNotEmpty || !isMerge) {
                documentsCreated++;
              }

              // Tags: source tags + the mapping's finer-grained type tag.
              for (final tagName in {
                ...record.tags,
                if (target.extraTag != null) target.extraTag!,
              }) {
                final key = tagName.trim().toLowerCase();
                if (key.isEmpty) continue;
                var tagId = tagIdByName[key];
                if (tagId == null) {
                  tagId = newId();
                  tagIdByName[key] = tagId;
                  tagsCreated++;
                  await _db.into(_db.tags).insert(TagsCompanion.insert(
                        id: tagId,
                        worldId: worldId,
                        name: tagName.trim(),
                        color: _tagColor(tagName),
                        createdAt: Value(nowMs()),
                      ));
                }
                await _db.into(_db.entityTags).insert(
                      EntityTagsCompanion.insert(
                          entityId: targetId, tagId: tagId),
                      mode: InsertMode.insertOrIgnore,
                    );
              }

              // Gallery rows.
              var order = 0;
              for (final mediaId in mediaIds) {
                await _db.into(_db.entityMedia).insert(
                      EntityMediaCompanion.insert(
                        entityId: targetId,
                        mediaId: mediaId,
                        sortOrder: Value(order++),
                      ),
                      mode: InsertMode.insertOrIgnore,
                    );
              }

              existingIds.add(targetId);
              existingByName[nameKey] = targetId;
              if (!isDuplicate) {
                imported++;
                importedByCollection[collection] =
                    importedByCollection[collection]! + 1;
              }
            } catch (e) {
              errors.add('Failed to import "${record.name}" '
                  '($collection): $e');
            }
          }
        });
      }

      // ----------------------------------------------------- pass B: links
      var linksCreated = 0;
      var repaired = 0;
      if (!cancelled) {
        final allRelations = <(String, TtgRelation)>[];
        final nameByKey = <String, String>{};
        for (final records in source.collections.values) {
          for (final record in records) {
            nameByKey[record.key] = record.name;
            for (final relation in record.relations) {
              allRelations.add((record.key, relation));
            }
          }
        }
        var linkDone = 0;
        await _db.transaction(() async {
          for (final (sourceKey, relation) in allRelations) {
            linkDone++;
            progress('links', allRelations.length, linkDone);
            final sourceId = idByKey[sourceKey] ??
                deterministicId(worldId, sourceKey);
            var targetId = idByKey[relation.targetKey] ??
                deterministicId(worldId, relation.targetKey);
            if (!existingIds.contains(sourceId)) continue;
            if (!existingIds.contains(targetId)) {
              // Broken source reference — repair by name where possible:
              // some exports point at ids that were renumbered.
              final targetName =
                  nameByKey[relation.targetKey]?.trim().toLowerCase();
              String? recovered;
              if (targetName != null) {
                recovered = existingByName.entries
                    .where((e) => e.key.endsWith('|$targetName'))
                    .map((e) => e.value)
                    .firstOrNull;
              }
              if (recovered == null) {
                repaired++; // dropped: better than a dangling link
                errors.add('Dropped broken reference '
                    '${relation.role}: $sourceKey -> ${relation.targetKey}');
                continue;
              }
              targetId = recovered;
              repaired++;
            }
            if (sourceId == targetId) continue;
            final linkId = deterministicId(
                worldId, 'link:$sourceId>$targetId:${relation.role}');
            final inserted = await _db.into(_db.links).insert(
                  LinksCompanion.insert(
                    id: linkId,
                    worldId: worldId,
                    sourceId: sourceId,
                    targetId: targetId,
                    role: Value(relation.role),
                    origin: LinkOrigin.manual.name,
                    createdAt: nowMs(),
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
            if (inserted > 0) linksCreated++;
          }
        });
      }

      // ------------------------------------------------------- validation
      if (!cancelled) {
        progress('validating', 1, 0);
        repaired += await _repairIntegrity(worldId, errors);

        progress('indexing', 1, 0);
        await _search.rebuildIndex(worldId);
        await _db.customStatement('ANALYZE');
        await _settings.remove(SettingsKeys.ttgImportState);
      }

      final report = TtgMigrationReport(
        worldId: worldId,
        worldName: worldName,
        completed: !cancelled,
        importedByCollection: importedByCollection,
        imported: imported,
        skippedDuplicates: skipped,
        mergedDuplicates: merged,
        replacedDuplicates: replaced,
        mediaImported: mediaImported,
        mediaMissing: mediaMissing,
        linksCreated: linksCreated,
        repairedReferences: repaired,
        documentsCreated: documentsCreated,
        tagsCreated: tagsCreated,
        errors: errors,
        elapsed: DateTime.now().difference(started),
        sourceRecords: total,
      );

      if (!cancelled) {
        await _writeReportDocument(worldId, report);
      }
      return report;
    });
  }

  // ------------------------------------------------------------ helpers

  Future<String> _createWorld(String name) async {
    // Never collide with an existing world of the same name.
    final names = (await _db.select(_db.worlds).get())
        .map((w) => w.name.trim().toLowerCase())
        .toSet();
    var unique = name.trim().isEmpty ? 'Imported World' : name.trim();
    var n = 2;
    while (names.contains(unique.toLowerCase())) {
      unique = '$name ($n)';
      n++;
    }
    final id = newId();
    await _db.into(_db.worlds).insert(WorldsCompanion.insert(
          id: id,
          name: unique,
          description:
              const Value('Imported from a TTG D&D database.'),
          createdAt: nowMs(),
          updatedAt: nowMs(),
        ));
    return id;
  }

  Future<Map<String, String>> _ensureCategories(
      String worldId, TtgSourceData source) async {
    final existing = await (_db.select(_db.customCategories)
          ..where((c) => c.worldId.equals(worldId)))
        .get();
    final byName = {
      for (final c in existing) c.name.trim().toLowerCase(): c.id,
    };
    var sortOrder = existing.length;
    final result = <String, String>{};
    for (final collection in source.collections.keys) {
      final target = targetForCollection(collection);
      if (!target.isCategory) continue;
      final name = target.categoryName!;
      final key = name.trim().toLowerCase();
      if (byName.containsKey(key)) {
        result[name] = byName[key]!;
        continue;
      }
      final id = newId();
      await _db.into(_db.customCategories).insert(
            CustomCategoriesCompanion.insert(
              id: id,
              worldId: worldId,
              name: name,
              icon: Value(target.categoryIcon ?? 'folder'),
              color: _tagColor(name),
              sortOrder: Value(sortOrder++),
              createdAt: nowMs(),
            ),
          );
      byName[key] = id;
      result[name] = id;
    }
    return result;
  }

  Future<String?> _importMedia(
    String worldId,
    TtgMediaRef media,
    Future<List<int>?> Function(String ref) readMedia,
    Map<String, String> mediaIdByPath,
  ) async {
    final bytes = media.bytes ??
        (media.ref == null ? null : await readMedia(media.ref!));
    if (bytes == null || bytes.isEmpty) return null;
    final relativePath = await _vault.store(
        worldId: worldId, fileName: media.fileName, bytes: bytes);
    final existing = mediaIdByPath[relativePath];
    if (existing != null) return existing;
    final id = newId();
    final ext = p.extension(media.fileName).toLowerCase();
    await _db.into(_db.mediaFiles).insert(MediaFilesCompanion.insert(
          id: id,
          worldId: worldId,
          fileName: media.fileName,
          relativePath: relativePath,
          mimeType: _mimeByExtension[ext] ?? 'application/octet-stream',
          sizeBytes: bytes.length,
          createdAt: nowMs(),
        ));
    mediaIdByPath[relativePath] = id;
    return id;
  }

  bool _isImage(Map<String, String> mediaIdByPath, String mediaId) {
    final path = mediaIdByPath.entries
        .where((e) => e.value == mediaId)
        .map((e) => e.key)
        .firstOrNull;
    if (path == null) return false;
    return _imageExtensions.contains(p.extension(path).toLowerCase());
  }

  Future<void> _writeEntity({
    required String worldId,
    required String id,
    required String kindName,
    required String? categoryId,
    required TtgRecord record,
    required RichTextConversion conversion,
    required String? coverMediaId,
    required bool merge,
  }) async {
    final existing = await (_db.select(_db.entities)
          ..where((e) => e.id.equals(id)))
        .getSingleOrNull();

    final summary = record.summary.isNotEmpty
        ? record.summary
        : (conversion.plainText.length > 300
            ? '${conversion.plainText.substring(0, 300)}…'
            : conversion.plainText);

    if (existing == null) {
      await _db.into(_db.entities).insert(EntitiesCompanion.insert(
            id: id,
            worldId: worldId,
            kind: kindName,
            customCategoryId: Value(categoryId),
            name: record.name,
            summary: Value(summary),
            attributesJson: Value(jsonEncode(record.attributes)),
            coverMediaId: Value(coverMediaId),
            isFavorite: Value(record.favorite),
            createdAt: record.createdAt ?? nowMs(),
            updatedAt: record.updatedAt ?? nowMs(),
          ));
    } else if (merge) {
      // Merge: only fill gaps, never overwrite user edits.
      final mergedAttributes = <String, Object?>{
        ...record.attributes,
        ...(jsonDecode(existing.attributesJson) as Map)
            .cast<String, Object?>(),
      };
      await (_db.update(_db.entities)..where((e) => e.id.equals(id))).write(
        EntitiesCompanion(
          summary: existing.summary.isEmpty
              ? Value(summary)
              : const Value.absent(),
          attributesJson: Value(jsonEncode(mergedAttributes)),
          coverMediaId: existing.coverMediaId == null
              ? Value(coverMediaId)
              : const Value.absent(),
          updatedAt: Value(nowMs()),
        ),
      );
    } else {
      // Replace.
      await (_db.update(_db.entities)..where((e) => e.id.equals(id))).write(
        EntitiesCompanion(
          name: Value(record.name),
          summary: Value(summary),
          attributesJson: Value(jsonEncode(record.attributes)),
          coverMediaId:
              coverMediaId == null ? const Value.absent() : Value(coverMediaId),
          isFavorite: Value(record.favorite),
          updatedAt: Value(nowMs()),
          deletedAt: const Value(null),
        ),
      );
    }

    // Document: create or update unless merging over an existing body.
    final existingDoc = await (_db.select(_db.documents)
          ..where((d) => d.entityId.equals(id)))
        .getSingleOrNull();
    final wordCount = conversion.plainText.isEmpty
        ? 0
        : conversion.plainText.split(RegExp(r'\s+')).length;
    if (existingDoc == null) {
      await _db.into(_db.documents).insert(DocumentsCompanion.insert(
            id: newId(),
            entityId: id,
            contentJson: conversion.contentJson,
            plainText: Value(conversion.plainText),
            wordCount: Value(wordCount),
            updatedAt: nowMs(),
          ));
    } else if (!merge || existingDoc.plainText.trim().isEmpty) {
      if (conversion.plainText.isNotEmpty) {
        await (_db.update(_db.documents)
              ..where((d) => d.id.equals(existingDoc.id)))
            .write(DocumentsCompanion(
          contentJson: Value(conversion.contentJson),
          plainText: Value(conversion.plainText),
          wordCount: Value(wordCount),
          updatedAt: Value(nowMs()),
        ));
      }
    }
  }

  /// Post-import integrity pass. Returns the number of repairs made.
  Future<int> _repairIntegrity(String worldId, List<String> errors) async {
    var repairs = 0;

    // Links whose endpoints vanished (any origin, any source).
    final dangling = await _db.customSelect(
      'SELECT id FROM links WHERE world_id = ? AND ('
      'source_id NOT IN (SELECT id FROM entities) OR '
      'target_id NOT IN (SELECT id FROM entities))',
      variables: [Variable.withString(worldId)],
    ).get();
    for (final row in dangling) {
      await (_db.delete(_db.links)
            ..where((l) => l.id.equals(row.read<String>('id'))))
          .go();
      repairs++;
    }
    if (dangling.isNotEmpty) {
      errors.add('Removed ${dangling.length} dangling link(s).');
    }

    // Covers pointing at missing media.
    final badCovers = await _db.customSelect(
      'SELECT id FROM entities WHERE world_id = ? AND cover_media_id IS NOT '
      'NULL AND cover_media_id NOT IN (SELECT id FROM media_files)',
      variables: [Variable.withString(worldId)],
    ).get();
    for (final row in badCovers) {
      await (_db.update(_db.entities)
            ..where((e) => e.id.equals(row.read<String>('id'))))
          .write(const EntitiesCompanion(coverMediaId: Value(null)));
      repairs++;
    }

    // Gallery rows pointing at missing media or entities.
    await _db.customStatement(
      'DELETE FROM entity_media WHERE '
      'media_id NOT IN (SELECT id FROM media_files) OR '
      'entity_id NOT IN (SELECT id FROM entities)',
    );

    return repairs;
  }

  Future<void> _writeReportDocument(
      String worldId, TtgMigrationReport report) async {
    final id = newId();
    final conversion = convertRichText(report.toMarkdown());
    await _db.into(_db.entities).insert(EntitiesCompanion.insert(
          id: id,
          worldId: worldId,
          kind: EntityKind.loreDocument.name,
          name: 'TTG Migration Report — ${formatDateTime(nowMs())}',
          summary: Value(
              '${report.imported} records imported, ${report.linksCreated} '
              'links, ${report.mediaImported} media files.'),
          attributesJson: const Value('{}'),
          createdAt: nowMs(),
          updatedAt: nowMs(),
        ));
    await _db.into(_db.documents).insert(DocumentsCompanion.insert(
          id: newId(),
          entityId: id,
          contentJson: conversion.contentJson,
          plainText: Value(conversion.plainText),
          wordCount: Value(conversion.plainText.split(RegExp(r'\s+')).length),
          updatedAt: nowMs(),
        ));
    await _search.reindexEntity(id);
  }

  static int _tagColor(String name) {
    const palette = [
      0xFFB98BC9, 0xFF8BC9A8, 0xFFC9A88B, 0xFF8BA8C9,
      0xFFC98B8B, 0xFFC9C48B, 0xFF8BC9C4, 0xFFA88BC9,
    ];
    return palette[name.hashCode.abs() % palette.length];
  }
}
