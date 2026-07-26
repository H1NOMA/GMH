import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/media_item.dart';
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';
import '../storage/media_vault.dart';

const _mimeByExtension = {
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
  '.gif': 'image/gif',
  '.webp': 'image/webp',
  '.bmp': 'image/bmp',
  '.svg': 'image/svg+xml',
  '.pdf': 'application/pdf',
  '.txt': 'text/plain',
  '.md': 'text/markdown',
};

class MediaRepositoryImpl implements MediaRepository {
  final AppDatabase _db;
  final MediaVault _vault;

  MediaRepositoryImpl(this._db, this._vault);

  MediaItem _map(MediaRow row) => MediaItem(
        id: row.id,
        worldId: row.worldId,
        fileName: row.fileName,
        relativePath: row.relativePath,
        mimeType: row.mimeType,
        sizeBytes: row.sizeBytes,
        createdAt: row.createdAt,
      );

  @override
  Future<MediaItem> import({
    required String worldId,
    required String fileName,
    required List<int> bytes,
  }) async {
    final relativePath =
        await _vault.store(worldId: worldId, fileName: fileName, bytes: bytes);

    // Deduplicate: same content already registered in this world?
    final existing = await (_db.select(_db.mediaFiles)
          ..where((m) =>
              m.worldId.equals(worldId) & m.relativePath.equals(relativePath)))
        .getSingleOrNull();
    if (existing != null) return _map(existing);

    final item = MediaItem(
      id: newId(),
      worldId: worldId,
      fileName: fileName,
      relativePath: relativePath,
      mimeType: _mimeByExtension[p.extension(fileName).toLowerCase()] ??
          'application/octet-stream',
      sizeBytes: bytes.length,
      createdAt: nowMs(),
    );
    await _db.into(_db.mediaFiles).insert(MediaFilesCompanion.insert(
          id: item.id,
          worldId: worldId,
          fileName: fileName,
          relativePath: relativePath,
          mimeType: item.mimeType,
          sizeBytes: item.sizeBytes,
          createdAt: item.createdAt,
        ));
    return item;
  }

  @override
  Future<MediaItem?> get(String id) async {
    final row = await (_db.select(_db.mediaFiles)
          ..where((m) => m.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<String> absolutePath(MediaItem item) async =>
      _vault.absolutePath(item.worldId, item.relativePath);

  @override
  Future<void> rename(String mediaId, String newFileName) async {
    final trimmed = newFileName.trim();
    if (trimmed.isEmpty) return;
    // Only re-derive the mime when the new name carries a known extension.
    // Renaming "hero.png" to "Hero portrait" is a display rename — the
    // bytes are untouched, and downgrading the mime to octet-stream would
    // silently demote the image to a generic file tile everywhere.
    final derived = _mimeByExtension[p.extension(trimmed).toLowerCase()];
    await (_db.update(_db.mediaFiles)..where((m) => m.id.equals(mediaId)))
        .write(MediaFilesCompanion(
      fileName: Value(trimmed),
      mimeType: derived != null ? Value(derived) : const Value.absent(),
    ));
  }

  @override
  Future<MediaItem> replaceBytes({
    required String mediaId,
    required String fileName,
    required List<int> bytes,
  }) async {
    final row = await (_db.select(_db.mediaFiles)
          ..where((m) => m.id.equals(mediaId)))
        .getSingle();
    final oldPath = row.relativePath;

    final newPath = await _vault.store(
        worldId: row.worldId, fileName: fileName, bytes: bytes);
    await (_db.update(_db.mediaFiles)..where((m) => m.id.equals(mediaId)))
        .write(MediaFilesCompanion(
      fileName: Value(fileName),
      relativePath: Value(newPath),
      mimeType: Value(_mimeByExtension[p.extension(fileName).toLowerCase()] ??
          'application/octet-stream'),
      sizeBytes: Value(bytes.length),
    ));

    if (newPath != oldPath) {
      await _deleteVaultFileIfOrphan(row.worldId, oldPath);
    }
    return (await get(mediaId))!;
  }

  @override
  Future<void> deleteIfUnreferenced(String mediaId) async {
    final row = await (_db.select(_db.mediaFiles)
          ..where((m) => m.id.equals(mediaId)))
        .getSingleOrNull();
    if (row == null) return;

    final referenced = await _isReferenced(mediaId);
    if (referenced) return;

    await (_db.delete(_db.mediaFiles)..where((m) => m.id.equals(mediaId)))
        .go();
    await _deleteVaultFileIfOrphan(row.worldId, row.relativePath);
  }

  Future<bool> _isReferenced(String mediaId) async {
    final gallery = await _db.customSelect(
      'SELECT 1 FROM entity_media WHERE media_id = ? LIMIT 1',
      variables: [Variable.withString(mediaId)],
    ).get();
    if (gallery.isNotEmpty) return true;

    final cover = await _db.customSelect(
      'SELECT 1 FROM entities WHERE cover_media_id = ? LIMIT 1',
      variables: [Variable.withString(mediaId)],
    ).get();
    if (cover.isNotEmpty) return true;

    final worldCover = await _db.customSelect(
      'SELECT 1 FROM worlds WHERE cover_media_id = ? LIMIT 1',
      variables: [Variable.withString(mediaId)],
    ).get();
    if (worldCover.isNotEmpty) return true;

    // Inline embeds inside rich text store the id as "media:<id>" or in a
    // fileAttachment payload — a LIKE probe covers both.
    final docs = await _db.customSelect(
      'SELECT 1 FROM documents WHERE content_json LIKE ? LIMIT 1',
      variables: [Variable.withString('%$mediaId%')],
    ).get();
    return docs.isNotEmpty;
  }

  Future<void> _deleteVaultFileIfOrphan(
      String worldId, String relativePath) async {
    final sharing = await (_db.select(_db.mediaFiles)
          ..where((m) =>
              m.worldId.equals(worldId) & m.relativePath.equals(relativePath))
          ..limit(1))
        .get();
    if (sharing.isEmpty) {
      await _vault.delete(worldId, relativePath);
    }
  }

  @override
  Stream<List<GalleryEntry>> watchGallery(String entityId) {
    final join = _db.select(_db.entityMedia).join([
      innerJoin(
          _db.mediaFiles, _db.mediaFiles.id.equalsExp(_db.entityMedia.mediaId)),
    ])
      ..where(_db.entityMedia.entityId.equals(entityId))
      ..orderBy([OrderingTerm.asc(_db.entityMedia.sortOrder)]);
    return join.watch().map((rows) => [
          for (final row in rows)
            GalleryEntry(
              media: _map(row.readTable(_db.mediaFiles)),
              sortOrder: row.readTable(_db.entityMedia).sortOrder,
              caption: row.readTable(_db.entityMedia).caption,
            )
        ]);
  }

  @override
  Future<void> addToGallery(String entityId, String mediaId,
      {String caption = ''}) async {
    final maxOrder = await (_db.selectOnly(_db.entityMedia)
          ..addColumns([_db.entityMedia.sortOrder.max()])
          ..where(_db.entityMedia.entityId.equals(entityId)))
        .map((r) => r.read(_db.entityMedia.sortOrder.max()))
        .getSingle();
    await _db.into(_db.entityMedia).insert(
          EntityMediaCompanion.insert(
            entityId: entityId,
            mediaId: mediaId,
            sortOrder: Value((maxOrder ?? -1) + 1),
            caption: Value(caption),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<void> removeFromGallery(String entityId, String mediaId) async {
    await (_db.delete(_db.entityMedia)
          ..where(
              (em) => em.entityId.equals(entityId) & em.mediaId.equals(mediaId)))
        .go();
  }

  @override
  Future<void> setCaption(
      String entityId, String mediaId, String caption) async {
    await (_db.update(_db.entityMedia)
          ..where(
              (em) => em.entityId.equals(entityId) & em.mediaId.equals(mediaId)))
        .write(EntityMediaCompanion(caption: Value(caption)));
  }

  @override
  Future<List<MediaItem>> allForWorld(String worldId) async {
    final rows = await (_db.select(_db.mediaFiles)
          ..where((m) => m.worldId.equals(worldId)))
        .get();
    return rows.map(_map).toList();
  }
}
