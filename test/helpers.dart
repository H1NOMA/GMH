import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/repositories/document_repository_impl.dart';
import 'package:gmh/data/repositories/entity_repository_impl.dart';
import 'package:gmh/data/repositories/link_repository_impl.dart';
import 'package:gmh/data/repositories/media_repository_impl.dart';
import 'package:gmh/data/repositories/search_repository_impl.dart';
import 'package:gmh/data/repositories/settings_repository_impl.dart';
import 'package:gmh/data/repositories/tag_repository_impl.dart';
import 'package:gmh/data/repositories/world_repository_impl.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/domain/services/document_service.dart';
import 'package:gmh/domain/services/entity_service.dart';
import 'package:gmh/domain/services/linking/link_sync_service.dart';

/// In-memory test harness wiring the full data layer exactly as production
/// DI does, plus a temp-dir media vault.
class TestHarness {
  final AppDatabase db;
  final MediaVault vault;
  final Directory tempDir;

  late final worlds = WorldRepositoryImpl(db, vault);
  late final entities = EntityRepositoryImpl(db);
  late final documents = DocumentRepositoryImpl(db);
  late final links = LinkRepositoryImpl(db);
  late final tags = TagRepositoryImpl(db);
  late final media = MediaRepositoryImpl(db, vault);
  late final search = SearchRepositoryImpl(db, entities);
  late final settings = SettingsRepositoryImpl(db);

  late final linkSync = LinkSyncService(links);
  late final entityService = EntityService(entities, tags, search, linkSync);
  late final documentService =
      DocumentService(documents, entities, search, linkSync);

  TestHarness._(this.db, this.vault, this.tempDir);

  static Future<TestHarness> create() async {
    // Tests intentionally create several independent in-memory databases.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final tempDir = await Directory.systemTemp.createTemp('gmh_test_');
    final db = AppDatabase(NativeDatabase.memory());
    return TestHarness._(db, MediaVault(tempDir.path), tempDir);
  }

  Future<void> dispose() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  }
}
