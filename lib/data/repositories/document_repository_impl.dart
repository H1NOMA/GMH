import 'package:drift/drift.dart';

import '../../core/constants.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/document_model.dart';
import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final AppDatabase _db;

  DocumentRepositoryImpl(this._db);

  DocumentModel _map(DocumentRow row) => DocumentModel(
        id: row.id,
        entityId: row.entityId,
        contentJson: row.contentJson,
        plainText: row.plainText,
        wordCount: row.wordCount,
        updatedAt: row.updatedAt,
      );

  DocumentVersion _mapVersion(DocumentVersionRow row) => DocumentVersion(
        id: row.id,
        documentId: row.documentId,
        contentJson: row.contentJson,
        note: row.note,
        createdAt: row.createdAt,
      );

  @override
  Future<DocumentModel> getOrCreate(String entityId) async {
    final existing = await (_db.select(_db.documents)
          ..where((d) => d.entityId.equals(entityId)))
        .getSingleOrNull();
    if (existing != null) return _map(existing);

    final now = nowMs();
    final doc = DocumentModel(
      id: newId(),
      entityId: entityId,
      contentJson: DocumentModel.emptyDelta,
      plainText: '',
      wordCount: 0,
      updatedAt: now,
    );
    await _db.into(_db.documents).insert(
          DocumentsCompanion.insert(
            id: doc.id,
            entityId: entityId,
            contentJson: doc.contentJson,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    // Re-read in case of a concurrent create (unique entity_id).
    final row = await (_db.select(_db.documents)
          ..where((d) => d.entityId.equals(entityId)))
        .getSingle();
    return _map(row);
  }

  @override
  Stream<DocumentModel?> watchByEntity(String entityId) {
    return (_db.select(_db.documents)
          ..where((d) => d.entityId.equals(entityId)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _map(row));
  }

  @override
  Future<DocumentModel> save({
    required String entityId,
    required String contentJson,
    required String plainText,
  }) async {
    final doc = await getOrCreate(entityId);
    final words = RegExp(r'[\p{L}\p{N}]+', unicode: true)
        .allMatches(plainText)
        .length;
    await (_db.update(_db.documents)..where((d) => d.id.equals(doc.id)))
        .write(DocumentsCompanion(
      contentJson: Value(contentJson),
      plainText: Value(plainText),
      wordCount: Value(words),
      updatedAt: Value(nowMs()),
    ));
    return DocumentModel(
      id: doc.id,
      entityId: entityId,
      contentJson: contentJson,
      plainText: plainText,
      wordCount: words,
      updatedAt: nowMs(),
    );
  }

  @override
  Future<List<DocumentVersion>> versions(String documentId,
      {int limit = 25}) async {
    final rows = await (_db.select(_db.documentVersions)
          ..where((v) => v.documentId.equals(documentId))
          ..orderBy([(v) => OrderingTerm.desc(v.createdAt)])
          ..limit(limit))
        .get();
    return rows.map(_mapVersion).toList();
  }

  @override
  Future<void> saveVersion(String documentId, {String note = ''}) async {
    final doc = await (_db.select(_db.documents)
          ..where((d) => d.id.equals(documentId)))
        .getSingleOrNull();
    if (doc == null) return;

    await _db.transaction(() async {
      // Skip if identical to the latest snapshot.
      final latest = await (_db.select(_db.documentVersions)
            ..where((v) => v.documentId.equals(documentId))
            ..orderBy([(v) => OrderingTerm.desc(v.createdAt)])
            ..limit(1))
          .getSingleOrNull();
      if (latest != null && latest.contentJson == doc.contentJson) return;

      await _db.into(_db.documentVersions).insert(
            DocumentVersionsCompanion.insert(
              id: newId(),
              documentId: documentId,
              contentJson: doc.contentJson,
              note: Value(note),
              createdAt: nowMs(),
            ),
          );
      // Prune beyond retention.
      await _db.customStatement('''
        DELETE FROM document_versions WHERE document_id = ? AND id NOT IN (
          SELECT id FROM document_versions WHERE document_id = ?
          ORDER BY created_at DESC LIMIT ?
        )
      ''', [documentId, documentId, GmhConstants.maxDocumentVersions]);
    });
  }

  @override
  Future<DocumentVersion?> getVersion(String versionId) async {
    final row = await (_db.select(_db.documentVersions)
          ..where((v) => v.id.equals(versionId)))
        .getSingleOrNull();
    return row == null ? null : _mapVersion(row);
  }
}
