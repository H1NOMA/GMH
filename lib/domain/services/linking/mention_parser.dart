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

/// Key of the inline file-attachment embed (its payload carries the file
/// name, which belongs in search and exports like any other word).
const fileAttachmentEmbedKey = 'fileAttachment';

/// An embed payload is either a JSON string or a map.
Map<Object?, Object?>? _payload(Object? embed) {
  Object? payload = embed;
  if (payload is String) {
    try {
      payload = jsonDecode(payload);
    } catch (_) {
      return null;
    }
  }
  return payload is Map ? payload : null;
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
      if (_payload(insert[entityLinkEmbedKey])?['label'] case final String l) {
        buffer.write(l);
      } else if (_payload(insert[fileAttachmentEmbedKey])?['name']
          case final String name) {
        buffer.write(name);
      }
    }
  }
  return buffer.toString();
}

/// Rewrites the label stored in every mention of [entityId] to [label].
/// Chips render the live name, but the stored label feeds search, word
/// counts, exports and copy/paste — after a rename they must follow.
/// Returns null when nothing changed (or the JSON is unreadable).
String? relabelMentions(String deltaJson, String entityId, String label) {
  final Object? decoded;
  try {
    decoded = jsonDecode(deltaJson);
  } catch (_) {
    return null;
  }
  if (decoded is! List) return null;
  var changed = false;
  for (final op in decoded) {
    if (op is! Map) continue;
    final insert = op['insert'];
    if (insert is! Map) continue;
    final raw = insert[entityLinkEmbedKey];
    final payload = _payload(raw);
    if (payload == null || payload['id'] != entityId) continue;
    if (payload['label'] == label) continue;
    final updated = {...payload, 'label': label};
    // Keep the payload's original shape (string or map).
    insert[entityLinkEmbedKey] = raw is String ? jsonEncode(updated) : updated;
    changed = true;
  }
  return changed ? jsonEncode(decoded) : null;
}

int countWords(String text) =>
    RegExp(r'[\p{L}\p{N}]+', unicode: true).allMatches(text).length;
