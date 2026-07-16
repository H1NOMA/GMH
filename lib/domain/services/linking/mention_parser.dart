import 'dart:convert';

/// Key of the custom Quill embed used for inline entity links.
const entityLinkEmbedKey = 'entityLink';

/// Parses Quill Delta JSON and returns the set of entity ids referenced by
/// inline entity-link embeds. Pure function — unit-testable without Flutter.
Set<String> extractMentionIds(String deltaJson) {
  final ids = <String>{};
  final Object? decoded;
  try {
    decoded = jsonDecode(deltaJson);
  } catch (_) {
    return ids;
  }
  if (decoded is! List) return ids;

  for (final op in decoded) {
    if (op is! Map) continue;
    final insert = op['insert'];
    if (insert is! Map) continue;
    final embed = insert[entityLinkEmbedKey];
    if (embed == null) continue;

    // Embed payload is either a JSON string or a map: {id, label}.
    Object? payload = embed;
    if (payload is String) {
      try {
        payload = jsonDecode(payload);
      } catch (_) {
        continue;
      }
    }
    if (payload is Map) {
      final id = payload['id'];
      if (id is String && id.isNotEmpty) ids.add(id);
    }
  }
  return ids;
}

/// Extracts readable plain text from Quill Delta JSON (embeds are replaced by
/// their labels where available) — used for FTS indexing and word counts.
String extractPlainText(String deltaJson) {
  final Object? decoded;
  try {
    decoded = jsonDecode(deltaJson);
  } catch (_) {
    return '';
  }
  if (decoded is! List) return '';

  final buffer = StringBuffer();
  for (final op in decoded) {
    if (op is! Map) continue;
    final insert = op['insert'];
    if (insert is String) {
      buffer.write(insert);
    } else if (insert is Map) {
      final embed = insert[entityLinkEmbedKey];
      Object? payload = embed;
      if (payload is String) {
        try {
          payload = jsonDecode(payload);
        } catch (_) {
          payload = null;
        }
      }
      if (payload is Map && payload['label'] is String) {
        buffer.write(payload['label']);
      }
    }
  }
  return buffer.toString();
}

int countWords(String text) =>
    RegExp(r'[\p{L}\p{N}]+', unicode: true).allMatches(text).length;
