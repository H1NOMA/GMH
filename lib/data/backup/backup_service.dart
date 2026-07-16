import 'dart:io';

import 'package:path/path.dart' as p;

import '../../core/constants.dart';
import '../../core/result.dart';
import '../../core/utils/dates.dart';
import '../../domain/repositories/repositories.dart';
import '../storage/media_vault.dart';
import 'project_archive_service.dart';

/// A backup file on disk.
class BackupInfo {
  final String path;
  final String fileName;
  final int sizeBytes;
  final DateTime modifiedAt;

  const BackupInfo({
    required this.path,
    required this.fileName,
    required this.sizeBytes,
    required this.modifiedAt,
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

  String _backupPath(String worldId) {
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    return p.join(backupsDir,
        '$worldId-$stamp.${GmhConstants.projectArchiveExtension}');
  }

  /// Manual backup — always writes a new archive.
  Future<Result<String>> backupNow(String worldId) async {
    final result = await _archive.exportArchive(worldId, _backupPath(worldId));
    if (result.isOk) await _rotate(worldId);
    return result;
  }

  /// Automatic backup on app start, throttled to one per
  /// [GmhConstants.autoBackupInterval].
  Future<void> autoBackupIfDue(String worldId) async {
    final key = '${SettingsKeys.lastAutoBackup}.$worldId';
    final last = int.tryParse(await _settings.get(key) ?? '') ?? 0;
    final elapsed = Duration(milliseconds: nowMs() - last);
    if (elapsed < GmhConstants.autoBackupInterval) return;

    final result = await backupNow(worldId);
    if (result.isOk) {
      await _settings.set(key, nowMs().toString());
    }
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
      ));
    }
    backups.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    return backups;
  }

  Future<Result<String>> restore(String backupPath) =>
      _archive.importArchive(backupPath);

  Future<void> _rotate(String worldId) async {
    final backups = await listBackups(worldId: worldId);
    for (final old in backups.skip(GmhConstants.maxAutoBackups)) {
      try {
        await File(old.path).delete();
      } on IOException {
        // Rotation is best-effort; a stuck file must not fail the backup.
      }
    }
  }
}
