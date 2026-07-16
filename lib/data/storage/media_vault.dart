import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../../core/exceptions.dart';

/// Content-addressed file store for images and attachments.
///
/// Files live at `{root}/worlds/{worldId}/media/{sha256}.{ext}` — identical
/// content is written once, so duplicate imports cost nothing. The database
/// (`media` table) owns metadata; the vault owns bytes.
class MediaVault {
  /// Absolute root directory (app documents dir + `gmh`).
  final String root;

  MediaVault(this.root);

  String worldDirectory(String worldId) => p.join(root, 'worlds', worldId);

  String mediaDirectory(String worldId) =>
      p.join(worldDirectory(worldId), 'media');

  String backupsDirectory() => p.join(root, 'backups');

  /// Writes [bytes] into the vault; returns the path relative to the world's
  /// media directory (this is what `media.relative_path` stores).
  Future<String> store({
    required String worldId,
    required String fileName,
    required List<int> bytes,
  }) async {
    try {
      final hash = sha256.convert(bytes).toString();
      var ext = p.extension(fileName).toLowerCase();
      if (ext.isEmpty || ext.length > 10) ext = '.bin';
      final relativePath = '$hash$ext';
      final file = File(p.join(mediaDirectory(worldId), relativePath));
      if (!await file.exists()) {
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes, flush: true);
      }
      return relativePath;
    } on IOException catch (e, st) {
      throw StorageException('Could not store "$fileName": $e', stackTrace: st);
    }
  }

  String absolutePath(String worldId, String relativePath) =>
      p.join(mediaDirectory(worldId), relativePath);

  Future<bool> exists(String worldId, String relativePath) =>
      File(absolutePath(worldId, relativePath)).exists();

  Future<List<int>> read(String worldId, String relativePath) async {
    final file = File(absolutePath(worldId, relativePath));
    if (!await file.exists()) {
      throw StorageException('Media file missing: $relativePath');
    }
    return file.readAsBytes();
  }

  Future<void> delete(String worldId, String relativePath) async {
    final file = File(absolutePath(worldId, relativePath));
    if (await file.exists()) await file.delete();
  }

  Future<void> deleteWorldDirectory(String worldId) async {
    final dir = Directory(worldDirectory(worldId));
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  /// Removes vault files that are not referenced by [referencedPaths]
  /// (called during backup, when the DB list is authoritative).
  Future<int> collectGarbage(
      String worldId, Set<String> referencedPaths) async {
    final dir = Directory(mediaDirectory(worldId));
    if (!await dir.exists()) return 0;
    var removed = 0;
    await for (final item in dir.list()) {
      if (item is File && !referencedPaths.contains(p.basename(item.path))) {
        await item.delete();
        removed++;
      }
    }
    return removed;
  }
}
