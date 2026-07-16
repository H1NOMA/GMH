import 'package:flutter/foundation.dart';

import 'entity_kind.dart';

/// One row returned by the global search engine.
@immutable
class SearchResult {
  final String entityId;
  final EntityKind kind;
  final String name;
  final String summary;

  /// Highlighted snippet from FTS; matched terms are wrapped in
  /// [snippetMarkerStart]/[snippetMarkerEnd] pairs which the search UI turns
  /// into highlighted spans.
  final String snippet;
  final double rank;

  const SearchResult({
    required this.entityId,
    required this.kind,
    required this.name,
    required this.summary,
    required this.snippet,
    required this.rank,
  });

  static const snippetMarkerStart = '‹‹';
  static const snippetMarkerEnd = '››';
}
