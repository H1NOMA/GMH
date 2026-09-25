import 'dart:io';
import 'dart:isolate';

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
      // Hashing a 50 MB map on the UI isolate stalls frames; big files
      // are hashed on a background isolate.
      final hash = bytes.length > 512 * 1024
          ? await _hashInBackground(bytes)
          : sha256.convert(bytes).toString();
      var ext = p.extension(fileName).toLowerCase();
      if (ext.isEmpty ||
          ext.length > 10 ||
          !RegExp(r'^\.[a-z0-9]+$').hasMatch(ext)) {
        ext = '.bin';
      }
      final relativePath = '$hash$ext';
      final file = File(p.join(mediaDirectory(worldId), relativePath));
      // A file under the content hash is trusted as complete forever, so
      // it must only ever appear fully written: temp file, then rename.
      if (!await file.exists() || await file.length() != bytes.length) {
        await file.parent.create(recursive: true);
        final partial = File('${file.path}.part');
        await partial.writeAsBytes(bytes, flush: true);
        if (await file.exists()) await file.delete();
        await partial.rename(file.path);
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

  /// Removes vault files that no media row points at. Files modified
  /// after [olderThan] are kept: an import may have stored the file and
  /// not yet written its row.
  Future<int> collectGarbage(String worldId, Set<String> referencedPaths,
      {DateTime? olderThan}) async {
    final dir = Directory(mediaDirectory(worldId));
    if (!await dir.exists()) return 0;
    final referenced = {for (final path in referencedPaths) p.basename(path)};
    var removed = 0;
    await for (final item in dir.list()) {
      if (item is! File || referenced.contains(p.basename(item.path))) {
        continue;
      }
      if (olderThan != null &&
          (await item.lastModified()).isAfter(olderThan)) {
        continue;
      }
      try {
        await item.delete();
        removed++;
      } on FileSystemException {
        // Locked by another process: next pass.
      }
    }
    return removed;
  }
}

/// Top-level so the isolate message carries only the bytes.
Future<String> _hashInBackground(List<int> bytes) =>
    Isolate.run(() => sha256.convert(bytes).toString());
