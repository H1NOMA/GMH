/// Lenient readers for the combat tracker's JSON payloads. Stored data may
/// come from older versions, a hand-edited backup or a half-written row:
/// every reader falls back to a default instead of throwing.
library;

int readInt(Object? value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num && value.isFinite) return value.round();
  if (value is String) {
    final parsed = num.tryParse(value.trim());
    if (parsed != null && parsed.isFinite) return parsed.round();
  }
  return fallback;
}

num? readNum(Object? value) {
  if (value is num) return value.isFinite ? value : null;
  if (value is String) {
    final parsed = num.tryParse(value.trim());
    return parsed != null && parsed.isFinite ? parsed : null;
  }
  return null;
}

String readString(Object? value, [String fallback = '']) {
  if (value is String) return value;
  if (value is num || value is bool) return '$value';
  return fallback;
}

bool readBool(Object? value, [bool fallback = false]) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final v = value.trim().toLowerCase();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;
  }
  return fallback;
}

List<Object?> readList(Object? value) =>
    value is List ? value.cast<Object?>() : const [];
