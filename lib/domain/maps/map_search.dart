/// Pin lists: search, player-view visibility and grouping.
library;

import 'map_pin.dart';

/// Pins players may see (all of them in GM view).
List<MapPin> visiblePins(Iterable<MapPin> pins, {required bool playerView}) => [
  for (final p in pins)
    if (!playerView || !p.gmOnly) p,
];

/// Pins whose label, linked entry name ([entityNames]: entity id -> name)
/// or notes contain every word of [query], ignoring case. Player view
/// hides GM-only pins and never searches notes (they may hold secrets).
List<MapPin> filterPins(
  Iterable<MapPin> pins,
  String query, {
  Map<String, String> entityNames = const {},
  bool playerView = false,
}) {
  final words = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  return [
    for (final pin in visiblePins(pins, playerView: playerView))
      if (words.isEmpty || _matches(pin, words, entityNames, playerView)) pin,
  ];
}

bool _matches(
  MapPin pin,
  List<String> words,
  Map<String, String> entityNames,
  bool playerView,
) {
  final entityName = pin.entityId == null ? null : entityNames[pin.entityId];
  final haystack = [
    pin.label,
    if (entityName != null) entityName,
    if (!playerView) pin.notes,
  ].join('\n').toLowerCase();
  return words.every(haystack.contains);
}

/// [pins] sorted by their shown label (case-insensitive); unnamed last.
List<MapPin> sortPinsByLabel(
  Iterable<MapPin> pins, {
  Map<String, String> entityNames = const {},
}) {
  String key(MapPin p) =>
      p.displayLabel(entityNames[p.entityId]).toLowerCase();
  return pins.toList()..sort((a, b) {
    final ka = key(a);
    final kb = key(b);
    if (ka.isEmpty != kb.isEmpty) return ka.isEmpty ? 1 : -1;
    final byLabel = ka.compareTo(kb);
    return byLabel != 0 ? byLabel : a.createdAt.compareTo(b.createdAt);
  });
}

/// Pin count per map id.
Map<String, int> pinCountsByMap(Iterable<MapPin> pins) {
  final counts = <String, int>{};
  for (final p in pins) {
    counts[p.mapId] = (counts[p.mapId] ?? 0) + 1;
  }
  return counts;
}

/// Pins linked to [entityId], in the given order.
List<MapPin> pinsLinkedTo(Iterable<MapPin> pins, String entityId) => [
  for (final p in pins)
    if (p.entityId == entityId) p,
];
