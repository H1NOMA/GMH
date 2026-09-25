import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/constants.dart';
import 'package:gmh/data/backup/backup_service.dart';
import 'package:gmh/data/backup/project_archive_service.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

void main() {
  late TestHarness h;
  late ProjectArchiveService archives;
  late BackupService backups;

  setUp(() async {
    h = await TestHarness.create();
    archives = ProjectArchiveService(h.db, h.vault);
    backups = BackupService(archives, h.vault, h.settings);
  });
  tearDown(() async => h.dispose());

  Future<String> seedWorld(String name) async {
    final world = await h.worlds.createWorld(name: name);
    await h.entityService.create(
        worldId: world.id, kind: EntityKind.character, name: 'Hero');
    return world.id;
  }

  test('each backup kind rotates in its own bucket', () async {
    final worldId = await seedWorld('W');
    for (var i = 0; i < 3; i++) {
      expect((await backups.backupNow(worldId, kind: BackupKind.auto)).isOk,
          isTrue);
    }
    for (var i = 0; i < 25; i++) {
      await backups.backupNow(worldId);
    }
    final list = await backups.listBackups(worldId: worldId);
    expect(list.where((b) => b.kind == BackupKind.manual), hasLength(20));
    // A burst of manual saves never touches the automatic history.
    expect(list.where((b) => b.kind == BackupKind.auto), hasLength(3));
    // Millisecond names: nothing overwrote anything within the bucket.
    expect(list.map((b) => b.fileName).toSet(), hasLength(23));
  });

  test('legacy backup names count as automatic', () {
    expect(BackupKind.fromFileName('w1', 'w1-2026-01-01T10-00-00.gmhw'),
        BackupKind.auto);
    expect(BackupKind.fromFileName('w1', 'w1-manual-2026-01-01.gmhw'),
        BackupKind.manual);
    expect(BackupKind.fromFileName('w1', 'w1-safety-2026-01-01.gmhw'),
        BackupKind.safety);
  });

  test('restoring the oldest backup works and writes a safety copy',
      () async {
    final worldId = await seedWorld('Before');
    await backups.backupNow(worldId, kind: BackupKind.auto);
    final oldest = (await backups.listBackups(worldId: worldId)).single;
    // Fill the auto bucket to the brim so any rotation would hit `oldest`.
    for (var i = 0; i < GmhConstants.maxAutoBackups - 1; i++) {
      await backups.backupNow(worldId, kind: BackupKind.auto);
    }
    final world = await h.worlds.getWorld(worldId);
    await h.worlds.updateWorld(world!.copyWith(name: 'After'));

    final result = await backups.restore(oldest.path, worldId: worldId);
    expect(result.isOk, isTrue, reason: '${result.isErr ? result.error : ''}');
    expect((await h.worlds.getWorld(worldId))!.name, 'Before');
    final list = await backups.listBackups(worldId: worldId);
    expect(list.where((b) => b.kind == BackupKind.safety), hasLength(1));
    // No staging leftovers.
    final leftovers = Directory(backups.backupsDir)
        .listSync()
        .where((f) => p.basename(f.path).startsWith('.restore-'));
    expect(leftovers, isEmpty);
  });

  test('a failed safety backup aborts the restore', () async {
    final worldId = await seedWorld('W');
    await backups.backupNow(worldId);
    final backup = (await backups.listBackups(worldId: worldId)).single;
    // The world vanished: the safety export cannot be written.
    final result = await backups.restore(backup.path, worldId: 'missing');
    expect(result.isErr, isTrue);
    expect(await h.worlds.getWorld(worldId), isNotNull);
  });

  test('archives are written atomically', () async {
    final worldId = await seedWorld('W');
    final out = p.join(h.tempDir.path, 'exports', 'w.gmhw');
    expect((await archives.exportArchive(worldId, out)).isOk, isTrue);
    expect(File(out).existsSync(), isTrue);
    expect(File('$out.part').existsSync(), isFalse);
    final manifest = await archives.inspectArchive(out);
    expect(manifest.value.worldId, worldId);
    expect(manifest.value.worldName, 'W');
  });

  test('imports reject path traversal in ids and media paths', () async {
    Future<String> craft(String name, Map<String, Object?> data) async {
      final archive = Archive();
      final manifest = utf8.encode(jsonEncode(
          {'formatVersion': 1, 'worldId': 'x', 'worldName': 'Evil'}));
      final body = utf8.encode(jsonEncode(data));
      archive.addFile(ArchiveFile('manifest.json', manifest.length, manifest));
      archive.addFile(ArchiveFile('data.json', body.length, body));
      final path = p.join(h.tempDir.path, name);
      await File(path).writeAsBytes(ZipEncoder().encode(archive));
      return path;
    }

    final badWorld = await craft('a.gmhw', {
      'world': {'id': '../../outside', 'name': 'Evil'},
    });
    expect((await archives.importArchive(badWorld)).isErr, isTrue);

    final badMedia = await craft('b.gmhw', {
      'world': {'id': 'w-evil', 'name': 'Evil'},
      'media': [
        {'id': 'm', 'relativePath': '../../../etc/passwd', 'fileName': 'x'}
      ],
    });
    expect((await archives.importArchive(badMedia)).isErr, isTrue);
    expect(await h.worlds.getWorld('w-evil'), isNull);
  });
}
