import 'package:flutter/foundation.dart';

/// The rich-text body of an entity, stored as Quill Delta JSON.
/// [plainText] is extracted on save and feeds full-text search.
@immutable
class DocumentModel {
  final String id;
  final String entityId;
  final String contentJson;
  final String plainText;
  final int wordCount;
  final int updatedAt;

  const DocumentModel({
    required this.id,
    required this.entityId,
    required this.contentJson,
    required this.plainText,
    required this.wordCount,
    required this.updatedAt,
  });

  static const emptyDelta = '[{"insert":"\\n"}]';
}

/// An immutable snapshot in a document's version history.
@immutable
class DocumentVersion {
  final String id;
  final String documentId;
  final String contentJson;
  final String note;
  final int createdAt;

  const DocumentVersion({
    required this.id,
    required this.documentId,
    required this.contentJson,
    this.note = '',
    required this.createdAt,
  });
}
