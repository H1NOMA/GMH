import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/constants.dart';
import '../../core/exceptions.dart';
import '../../core/result.dart';
import '../../core/utils/dates.dart';
import '../db/app_database.dart';
import '../storage/media_vault.dart';

/// Exports a world to a portable `.gmhw` ZIP archive and restores it —
/// the backbone of backups, JSON export and device migration.
///
/// Archive layout:
/// ```
/// manifest.json     { formatVersion, appVersion, exportedAt, worldId, worldName }
/// data.json         all rows for the world, normalized by table
/// media/<hash.ext>  vault files
/// ```
/// UUIDs are stable, so import needs no id remapping. Importing a world that
/// already exists replaces it atomically.
class ProjectArchiveService {
  final AppDatabase _db;
  final MediaVault _vault;

  ProjectArchiveService(this._db, this._vault);

  // ---------------------------------------------------------------- export

  /// Serializes one world (including soft-deleted entities, versions and
  /// media metadata) into a JSON-encodable map.
  Future<Map<String, Object?>> exportWorldData(String worldId) async {
    final world = await (_db.select(_db.worlds)
          ..where((w) => w.id.equals(worldId)))
        .getSingleOrNull();
    if (world == null) {
      throw const NotFoundException('World not found.');
    }

    final categories = await (_db.select(_db.customCategories)
          ..where((c) => c.worldId.equals(worldId)))
        .get();

    final entities = await (_db.select(_db.entities)
          ..where((e) => e.worldId.equals(worldId)))
        .get();
    final entityIds = entities.map((e) => e.id).toSet();

    final documents = await (_db.select(_db.documents)
          ..where((d) => d.entityId.isIn(entityIds)))
        .get();
    final documentIds = documents.map((d) => d.id).toSet();

    final versions = await (_db.select(_db.documentVersions)
          ..where((v) => v.documentId.isIn(documentIds)))
        .get();

    final links = await (_db.select(_db.links)
          ..where((l) => l.worldId.equals(worldId)))
        .get();

    final tags = await (_db.select(_db.tags)
          ..where((t) => t.worldId.equals(worldId)))
        .get();

    final entityTags = await (_db.select(_db.entityTags)
          ..where((et) => et.entityId.isIn(entityIds)))
        .get();

    final media = await (_db.select(_db.mediaFiles)
          ..where((m) => m.worldId.equals(worldId)))
        .get();

    final entityMedia = await (_db.select(_db.entityMedia)
          ..where((em) => em.entityId.isIn(entityIds)))
        .get();

    return {
      'world': {
        'id': world.id,
        'name': world.name,
        'description': world.description,
        'coverMediaId': world.coverMediaId,
        'createdAt': world.createdAt,
        'updatedAt': world.updatedAt,
      },
      'customCategories': [
        for (final c in categories)
          {
            'id': c.id,
            'name': c.name,
            'icon': c.icon,
            'color': c.color,
            'sortOrder': c.sortOrder,
            'createdAt': c.createdAt,
          }
      ],
      'entities': [
        for (final e in entities)
          {
            'id': e.id,
            'kind': e.kind,
            'customCategoryId': e.customCategoryId,
            'name': e.name,
            'summary': e.summary,
            'attributes': jsonDecode(e.attributesJson),
            'coverMediaId': e.coverMediaId,
            'isFavorite': e.isFavorite,
            'createdAt': e.createdAt,
            'updatedAt': e.updatedAt,
            'deletedAt': e.deletedAt,
          }
      ],
      'documents': [
        for (final d in documents)
          {
            'id': d.id,
            'entityId': d.entityId,
            'content': jsonDecode(d.contentJson),
            'plainText': d.plainText,
            'wordCount': d.wordCount,
            'updatedAt': d.updatedAt,
          }
      ],
      'documentVersions': [
        for (final v in versions)
          {
            'id': v.id,
            'documentId': v.documentId,
            'content': jsonDecode(v.contentJson),
            'note': v.note,
            'createdAt': v.createdAt,
          }
      ],
      'links': [
        for (final l in links)
          {
            'id': l.id,
            'sourceId': l.sourceId,
            'targetId': l.targetId,
            'role': l.role,
            'origin': l.origin,
            'createdAt': l.createdAt,
          }
      ],
      'tags': [
        for (final t in tags)
          {'id': t.id, 'name': t.name, 'color': t.color}
      ],
      'entityTags': [
        for (final et in entityTags)
          {'entityId': et.entityId, 'tagId': et.tagId}
      ],
      'media': [
        for (final m in media)
          {
            'id': m.id,
            'fileName': m.fileName,
            'relativePath': m.relativePath,
            'mimeType': m.mimeType,
            'sizeBytes': m.sizeBytes,
            'createdAt': m.createdAt,
          }
      ],
      'entityMedia': [
        for (final em in entityMedia)
          {
            'entityId': em.entityId,
            'mediaId': em.mediaId,
            'sortOrder': em.sortOrder,
            'caption': em.caption,
          }
      ],
    };
  }

  /// Writes the full `.gmhw` archive to [outputPath].
  Future<Result<String>> exportArchive(String worldId, String outputPath) {
    return guard(() async {
      final data = await exportWorldData(worldId);
      final world = data['world'] as Map<String, Object?>;

      final manifest = {
        'formatVersion': GmhConstants.exportFormatVersion,
        'app': GmhConstants.appNameShort,
        'exportedAt': nowMs(),
        'worldId': worldId,
        'worldName': world['name'],
      };

      final archive = Archive();
      archive.addFile(_jsonFile('manifest.json', manifest));
      archive.addFile(_jsonFile('data.json', data));

      for (final m in (data['media'] as List).cast<Map<String, Object?>>()) {
        final relativePath = m['relativePath'] as String;
        if (await _vault.exists(worldId, relativePath)) {
          final bytes = await _vault.read(worldId, relativePath);
          archive.addFile(ArchiveFile('media/$relativePath', bytes.length, bytes));
        }
      }

      final out = File(outputPath);
      await out.parent.create(recursive: true);
      final encoded = ZipEncoder().encode(archive);
      await out.writeAsBytes(encoded, flush: true);
      return outputPath;
    });
  }

  /// Writes only `data.json` (plain JSON export).
  Future<Result<String>> exportJson(String worldId, String outputPath) {
    return guard(() async {
      final data = await exportWorldData(worldId);
      final out = File(outputPath);
      await out.parent.create(recursive: true);
      await out.writeAsString(
          const JsonEncoder.withIndent('  ').convert(data));
      return outputPath;
    });
  }

  ArchiveFile _jsonFile(String name, Object data) {
    final bytes = utf8.encode(jsonEncode(data));
    return ArchiveFile(name, bytes.length, bytes);
  }

  // ---------------------------------------------------------------- import

  /// Restores a world from a `.gmhw` archive. All-or-nothing: the database
  /// write happens in one transaction; media is restored before that and
  /// cleaned up by vault GC if the transaction fails.
  Future<Result<String>> importArchive(String archivePath) {
    return guard(() async {
      final file = File(archivePath);
      if (!await file.exists()) {
        throw const ImportException('Archive file not found.');
      }

      final Archive archive;
      try {
        archive = ZipDecoder().decodeBytes(await file.readAsBytes());
      } catch (e) {
        throw ImportException('Not a valid GMH archive: $e');
      }

      final manifestFile = archive.findFile('manifest.json');
      final dataFile = archive.findFile('data.json');
      if (manifestFile == null || dataFile == null) {
        throw const ImportException(
            'Archive is missing manifest.json or data.json.');
      }

      final manifest =
          jsonDecode(utf8.decode(manifestFile.content as List<int>)) as Map;
      final formatVersion = manifest['formatVersion'];
      if (formatVersion is! int ||
          formatVersion > GmhConstants.exportFormatVersion) {
        throw ImportException(
            'Archive format $formatVersion is newer than this app supports. '
            'Please update GMH.');
      }

      final data =
          jsonDecode(utf8.decode(dataFile.content as List<int>)) as Map;
      final worldId = (data['world'] as Map)['id'] as String;

      // Restore media files first (idempotent: content-addressed names).
      for (final entry in archive.files) {
        if (!entry.isFile || !entry.name.startsWith('media/')) continue;
        final relativePath = p.basename(entry.name);
        final target =
            File(_vault.absolutePath(worldId, relativePath));
        await target.parent.create(recursive: true);
        await target.writeAsBytes(entry.content as List<int>, flush: true);
      }

      await _restoreData(data.cast<String, Object?>());
      return worldId;
    });
  }

  Future<void> _restoreData(Map<String, Object?> data) async {
    final world = (data['world'] as Map).cast<String, Object?>();
    final worldId = world['id'] as String;

    List<Map<String, Object?>> rows(String key) =>
        ((data[key] as List?) ?? const [])
            .map((e) => (e as Map).cast<String, Object?>())
            .toList();

    await _db.transaction(() async {
      // Replace an existing copy of this world atomically.
      await _db.customStatement(
        'DELETE FROM entity_search WHERE entity_id IN '
        '(SELECT id FROM entities WHERE world_id = ?)',
        [worldId],
      );
      await (_db.delete(_db.worlds)..where((w) => w.id.equals(worldId))).go();

      await _db.into(_db.worlds).insert(WorldsCompanion.insert(
            id: worldId,
            name: world['name'] as String? ?? 'Imported World',
            description: Value(world['description'] as String? ?? ''),
            coverMediaId: Value(world['coverMediaId'] as String?),
            createdAt: (world['createdAt'] as num?)?.toInt() ?? nowMs(),
            updatedAt: nowMs(),
          ));

      for (final c in rows('customCategories')) {
        await _db.into(_db.customCategories).insert(
              CustomCategoriesCompanion.insert(
                id: c['id'] as String,
                worldId: worldId,
                name: c['name'] as String? ?? 'Category',
                icon: Value(c['icon'] as String? ?? 'folder'),
                color: (c['color'] as num?)?.toInt() ?? 0xFFB98BC9,
                sortOrder: Value((c['sortOrder'] as num?)?.toInt() ?? 0),
                createdAt: (c['createdAt'] as num?)?.toInt() ?? nowMs(),
              ),
            );
      }

      for (final e in rows('entities')) {
        await _db.into(_db.entities).insert(EntitiesCompanion.insert(
              id: e['id'] as String,
              worldId: worldId,
              kind: e['kind'] as String,
              customCategoryId: Value(e['customCategoryId'] as String?),
              name: e['name'] as String? ?? 'Unnamed',
              summary: Value(e['summary'] as String? ?? ''),
              attributesJson: Value(jsonEncode(e['attributes'] ?? {})),
              coverMediaId: Value(e['coverMediaId'] as String?),
              isFavorite: Value(e['isFavorite'] == true),
              createdAt: (e['createdAt'] as num?)?.toInt() ?? nowMs(),
              updatedAt: (e['updatedAt'] as num?)?.toInt() ?? nowMs(),
              deletedAt: Value((e['deletedAt'] as num?)?.toInt()),
            ));
      }

      for (final d in rows('documents')) {
        await _db.into(_db.documents).insert(DocumentsCompanion.insert(
              id: d['id'] as String,
              entityId: d['entityId'] as String,
              contentJson: jsonEncode(d['content'] ?? []),
              plainText: Value(d['plainText'] as String? ?? ''),
              wordCount: Value((d['wordCount'] as num?)?.toInt() ?? 0),
              updatedAt: (d['updatedAt'] as num?)?.toInt() ?? nowMs(),
            ));
      }

      for (final v in rows('documentVersions')) {
        await _db
            .into(_db.documentVersions)
            .insert(DocumentVersionsCompanion.insert(
              id: v['id'] as String,
              documentId: v['documentId'] as String,
              contentJson: jsonEncode(v['content'] ?? []),
              note: Value(v['note'] as String? ?? ''),
              createdAt: (v['createdAt'] as num?)?.toInt() ?? nowMs(),
            ));
      }

      for (final t in rows('tags')) {
        await _db.into(_db.tags).insert(TagsCompanion.insert(
              id: t['id'] as String,
              worldId: worldId,
              name: t['name'] as String,
              color: (t['color'] as num?)?.toInt() ?? 0xFF888888,
            ));
      }

      for (final et in rows('entityTags')) {
        await _db.into(_db.entityTags).insert(
              EntityTagsCompanion.insert(
                entityId: et['entityId'] as String,
                tagId: et['tagId'] as String,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }

      for (final m in rows('media')) {
        await _db.into(_db.mediaFiles).insert(MediaFilesCompanion.insert(
              id: m['id'] as String,
              worldId: worldId,
              fileName: m['fileName'] as String? ?? 'file',
              relativePath: m['relativePath'] as String,
              mimeType: m['mimeType'] as String? ?? 'application/octet-stream',
              sizeBytes: (m['sizeBytes'] as num?)?.toInt() ?? 0,
              createdAt: (m['createdAt'] as num?)?.toInt() ?? nowMs(),
            ));
      }

      for (final em in rows('entityMedia')) {
        await _db.into(_db.entityMedia).insert(
              EntityMediaCompanion.insert(
                entityId: em['entityId'] as String,
                mediaId: em['mediaId'] as String,
                sortOrder: Value((em['sortOrder'] as num?)?.toInt() ?? 0),
                caption: Value(em['caption'] as String? ?? ''),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }

      for (final l in rows('links')) {
        await _db.into(_db.links).insert(
              LinksCompanion.insert(
                id: l['id'] as String,
                worldId: worldId,
                sourceId: l['sourceId'] as String,
                targetId: l['targetId'] as String,
                role: Value(l['role'] as String? ?? 'related'),
                origin: l['origin'] as String? ?? 'manual',
                createdAt: (l['createdAt'] as num?)?.toInt() ?? nowMs(),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
    });
  }
}
