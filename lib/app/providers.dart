import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backup/backup_service.dart';
import '../data/backup/pdf_exporter.dart';
import '../data/backup/project_archive_service.dart';
import '../data/db/app_database.dart';
import '../data/db/connection.dart';
import '../data/repositories/document_repository_impl.dart';
import '../data/repositories/entity_repository_impl.dart';
import '../data/repositories/link_repository_impl.dart';
import '../data/repositories/media_repository_impl.dart';
import '../data/repositories/search_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../data/repositories/tag_repository_impl.dart';
import '../data/repositories/world_repository_impl.dart';
import '../data/storage/media_vault.dart';
import '../domain/repositories/repositories.dart';
import '../domain/services/ai/ai_assistant.dart';
import '../domain/services/ai/lore_context.dart';
import '../domain/services/document_service.dart';
import '../domain/services/entity_service.dart';
import '../domain/services/linking/link_sync_service.dart';

/// Composition root. `main()` overrides [appRootDirProvider] with the real
/// documents directory; everything else derives from it.
final appRootDirProvider = Provider<String>(
  (ref) => throw UnimplementedError('Overridden in main()'),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openConnection(ref.watch(appRootDirProvider)));
  ref.onDispose(db.close);
  return db;
});

final mediaVaultProvider = Provider<MediaVault>(
  (ref) => MediaVault(ref.watch(appRootDirProvider)),
);

// ------------------------------------------------------------ repositories

final worldRepositoryProvider = Provider<WorldRepository>(
  (ref) => WorldRepositoryImpl(
      ref.watch(databaseProvider), ref.watch(mediaVaultProvider)),
);

final entityRepositoryProvider = Provider<EntityRepository>(
  (ref) => EntityRepositoryImpl(ref.watch(databaseProvider)),
);

final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => DocumentRepositoryImpl(ref.watch(databaseProvider)),
);

final linkRepositoryProvider = Provider<LinkRepository>(
  (ref) => LinkRepositoryImpl(ref.watch(databaseProvider)),
);

final tagRepositoryProvider = Provider<TagRepository>(
  (ref) => TagRepositoryImpl(ref.watch(databaseProvider)),
);

final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => MediaRepositoryImpl(
      ref.watch(databaseProvider), ref.watch(mediaVaultProvider)),
);

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepositoryImpl(
      ref.watch(databaseProvider), ref.watch(entityRepositoryProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(databaseProvider)),
);

// ---------------------------------------------------------------- services

final linkSyncServiceProvider = Provider<LinkSyncService>(
  (ref) => LinkSyncService(ref.watch(linkRepositoryProvider)),
);

final entityServiceProvider = Provider<EntityService>(
  (ref) => EntityService(
    ref.watch(entityRepositoryProvider),
    ref.watch(tagRepositoryProvider),
    ref.watch(searchRepositoryProvider),
    ref.watch(linkSyncServiceProvider),
  ),
);

final documentServiceProvider = Provider<DocumentService>(
  (ref) => DocumentService(
    ref.watch(documentRepositoryProvider),
    ref.watch(entityRepositoryProvider),
    ref.watch(searchRepositoryProvider),
    ref.watch(linkSyncServiceProvider),
  ),
);

final projectArchiveServiceProvider = Provider<ProjectArchiveService>(
  (ref) => ProjectArchiveService(
      ref.watch(databaseProvider), ref.watch(mediaVaultProvider)),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(projectArchiveServiceProvider),
    ref.watch(mediaVaultProvider),
    ref.watch(settingsRepositoryProvider),
  ),
);

final pdfExporterProvider = Provider<PdfExporter>(
  (ref) => PdfExporter(
      ref.watch(entityRepositoryProvider), ref.watch(documentRepositoryProvider)),
);

// ---------------------------------------------------------------- AI-ready

final aiAssistantProvider = Provider<AiAssistant>(
  (ref) => const NoopAiAssistant(),
);

final loreContextBuilderProvider = Provider<LoreContextBuilder>(
  (ref) => LoreContextBuilder(
    ref.watch(entityRepositoryProvider),
    ref.watch(linkRepositoryProvider),
    ref.watch(documentRepositoryProvider),
  ),
);
