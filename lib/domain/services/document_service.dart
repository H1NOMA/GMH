import '../../core/result.dart';
import '../models/document_model.dart';
import '../repositories/repositories.dart';
import 'linking/link_sync_service.dart';
import 'linking/mention_parser.dart';

/// Application service for rich-text saves:
///
///   extract plain text → persist → sync mention links → reindex search.
class DocumentService {
  final DocumentRepository _documents;
  final EntityRepository _entities;
  final SearchRepository _search;
  final LinkSyncService _linkSync;

  DocumentService(this._documents, this._entities, this._search, this._linkSync);

  Future<Result<DocumentModel>> save({
    required String entityId,
    required String contentJson,
  }) {
    return guard(() async {
      final plainText = extractPlainText(contentJson);
      final doc = await _documents.save(
        entityId: entityId,
        contentJson: contentJson,
        plainText: plainText,
      );
      final entity = await _entities.getEntity(entityId);
      if (entity != null) {
        await _linkSync.syncDocumentMentions(
          worldId: entity.worldId,
          entityId: entityId,
          contentJson: contentJson,
        );
      }
      await _search.reindexEntity(entityId);
      return doc;
    });
  }

  /// Manual or automatic version checkpoint.
  Future<Result<void>> checkpoint(String entityId, {String note = ''}) {
    return guard(() async {
      final doc = await _documents.getOrCreate(entityId);
      await _documents.saveVersion(doc.id, note: note);
    });
  }
}
