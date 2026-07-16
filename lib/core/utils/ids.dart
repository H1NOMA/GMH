import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Generates a UUID v4 — the stable identity for every object in GMH.
/// UUIDs survive export/import and device migration unchanged.
String newId() => _uuid.v4();

/// Prefix used when an entity reference is stored inside attribute JSON.
const entityRefPrefix = 'entity:';

String entityRefValue(String entityId) => '$entityRefPrefix$entityId';

/// Returns the entity id if [value] is an `entity:<uuid>` reference.
String? parseEntityRef(Object? value) {
  if (value is String && value.startsWith(entityRefPrefix)) {
    final id = value.substring(entityRefPrefix.length);
    return id.isEmpty ? null : id;
  }
  return null;
}
