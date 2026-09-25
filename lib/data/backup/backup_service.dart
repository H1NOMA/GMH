import 'dart:io';

import 'package:path/path.dart' as p;

import '../../core/constants.dart';
import '../../core/exceptions.dart';
import '../../core/result.dart';
import '../../core/utils/dates.dart';
import '../../domain/repositories/repositories.dart';
import '../storage/media_vault.dart';
import 'project_archive_service.dart';

/// Why a backup was written. Each kind rotates in its own bucket, so a
/// burst of manual saves can never push out the daily automatic history,
/// and a restore's safety copy never deletes the backup being restored.
enum BackupKind {
  auto(GmhConstants.maxAutoBackups),
  manual(20),
  safety(3);

  final int keep;
  const BackupKind(this.keep);

  /// Kind encoded in a file name (`<worldId>-<kind>-<stamp>.gmhw`); names
  /// from before kinds existed count as automatic.
  static BackupKind fromFileName(String worldId, String fileName) {
    final rest = fileName.startsWith('$worldId-')
        ? fileName.substring(worldId.length + 1)
        : fileName;
    for (final kind in values) {
      if (rest.startsWith('${kind.name}-')) return kind;
    }
    return auto;
  }
}

/// A backup file on disk.
class BackupInfo {
  final String path;
  final String fileName;
  final int sizeBytes;
  final DateTime modifiedAt;
  final BackupKind kind;

  const BackupInfo({
    required this.path,
    required this.fileName,
    required this.sizeBytes,
    required this.modifiedAt,
    this.kind = BackupKind.auto,
  });
}

/// Rotating local backups of whole worlds (`.gmhw` archives in the app's
/// backups directory). Restore goes through [ProjectArchiveService].
class BackupService {
  final ProjectArchiveService _archive;
  final MediaVault _vault;
  final SettingsRepository _settings;

  BackupService(this._archive, this._vault, this._settings);

  String get backupsDir => _vault.backupsDirectory();

  String _backupPath(String worldId, BackupKind kind) {
    // Millisecond resolution: two saves within one second must not
    // overwrite each other.
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    return p.join(backupsDir,
        '$worldId-${kind.name}-$stamp.${GmhConstants.projectArchiveExtension}');
  }

  /// Writes a new archive of the world and rotates that kind's bucket.
  Future<Result<String>> backupNow(String worldId,
      {BackupKind kind = BackupKind.manual}) async {
    final result =
        await _archive.exportArchive(worldId, _backupPath(worldId, kind));
    if (result.isOk) await _rotate(worldId, kind);
    return result;
  }

  /// Automatic backup on app start, throttled to one per
  /// [GmhConstants.autoBackupInterval].
  /// Returns whether a backup was taken.
  Future<bool> autoBackupIfDue(String worldId) async {
    final key = '${SettingsKeys.lastAutoBackup}.$worldId';
    final last = int.tryParse(await _settings.get(key) ?? '') ?? 0;
    final elapsed = Duration(milliseconds: nowMs() - last);
    if (elapsed < GmhConstants.autoBackupInterval) return false;

    final result = await backupNow(worldId, kind: BackupKind.auto);
    if (result.isOk) {
      await _settings.set(key, nowMs().toString());
    }
    return result.isOk;
  }

  Future<List<BackupInfo>> listBackups({String? worldId}) async {
    final dir = Directory(backupsDir);
    if (!await dir.exists()) return [];
    final backups = <BackupInfo>[];
    await for (final item in dir.list()) {
      if (item is! File) continue;
      final name = p.basename(item.path);
      if (!name.endsWith('.${GmhConstants.projectArchiveExtension}')) continue;
      if (worldId != null && !name.startsWith('$worldId-')) continue;
      final stat = await item.stat();
      backups.add(BackupInfo(
        path: item.path,
        fileName: name,
        sizeBytes: stat.size,
        modifiedAt: stat.modified,
        kind: worldId == null
            ? BackupKind.auto
            : BackupKind.fromFileName(worldId, name),
      ));
    }
    backups.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    return backups;
  }

  /// Restores [backupPath] over [worldId], first saving the current state
  /// as a safety backup. The chosen file is copied aside before anything
  /// else, so no rotation can delete it mid-restore; if the safety backup
  /// fails, nothing is restored.
  Future<Result<String>> restore(String backupPath,
      {required String worldId}) async {
    final source = File(backupPath);
    if (!await source.exists()) {
      return const Err(ImportException('Archive file not found.'));
    }
    final staged = File(p.join(
        backupsDir, '.restore-${nowMs()}.${GmhConstants.projectArchiveExtension}'));
    try {
      await staged.parent.create(recursive: true);
      await source.copy(staged.path);
      final safety = await backupNow(worldId, kind: BackupKind.safety);
      if (safety.isErr) return Err(safety.error);
      return await _archive.importArchive(staged.path);
    } on IOException catch (e, st) {
      return Err(StorageException('Could not stage the backup: $e',
          stackTrace: st));
    } finally {
      if (await staged.exists()) {
        try {
          await staged.delete();
        } on IOException {
          // A leftover staging copy is harmless (hidden, not listed).
        }
      }
    }
  }

  Future<void> _rotate(String worldId, BackupKind kind) async {
    final backups = [
      for (final b in await listBackups(worldId: worldId))
        if (b.kind == kind) b,
    ];
    for (final old in backups.skip(kind.keep)) {
      try {
        await File(old.path).delete();
      } on IOException {
        // Rotation is best-effort; a stuck file must not fail the backup.
      }
    }
  }
}
