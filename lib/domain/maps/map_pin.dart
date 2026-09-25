import 'package:flutter/foundation.dart';

import '../combat/json_read.dart';
import '../models/world_object.dart';
import 'map_geometry.dart';

/// Marker symbols a pin can carry. The [key]s are stored, so they must stay
/// stable; add new symbols freely, never repurpose old keys.
enum MapPinIcon {
  pin('pin'),
  castle('castle'),
  town('town'),
  dungeon('dungeon'),
  cave('cave'),
  forest('forest'),
  mountain('mountain'),
  port('port'),
  danger('danger'),
  treasure('treasure'),
  quest('quest'),
  camp('camp'),
  npc('npc'),
  portal('portal'),
  note('note');

  final String key;
  const MapPinIcon(this.key);

  /// Unknown or missing keys read as the plain [pin].
  static MapPinIcon fromKey(Object? key) {
    for (final icon in values) {
      if (icon.key == key) return icon;
    }
    return pin;
  }
}

/// Pin colors. [auto] follows the linked entry's color (the theme accent
/// without one); the rest are fixed hues adapted to the theme when shown.
enum MapPinColor {
  auto('auto'),
  ember('ember'),
  red('red'),
  orange('orange'),
  yellow('yellow'),
  green('green'),
  teal('teal'),
  blue('blue'),
  purple('purple'),
  pink('pink'),
  gray('gray');

  final String key;
  const MapPinColor(this.key);

  static MapPinColor fromKey(Object? key) {
    for (final color in values) {
      if (color.key == key) return color;
    }
    return auto;
  }
}

/// A marker on a [GameMap] ([WorldObjectTypes.mapPin], parentId = map id).
/// [x] and [y] are normalized to the image (0..1 from the top-left corner),
/// so replacing or rescaling the image keeps every pin in place.
@immutable
class MapPin {
  final String id;
  final String worldId;
  final String mapId;
  final double x;
  final double y;
  final String label;

  /// Linked world entry, if any.
  final String? entityId;
  final MapPinIcon icon;
  final MapPinColor color;
  final String notes;

  /// Hidden in player view.
  final bool gmOnly;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;

  const MapPin({
    this.id = '',
    this.worldId = '',
    this.mapId = '',
    this.x = 0.5,
    this.y = 0.5,
    this.label = '',
    this.entityId,
    this.icon = MapPinIcon.pin,
    this.color = MapPinColor.auto,
    this.notes = '',
    this.gmOnly = false,
    this.sortOrder = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory MapPin.fromObject(WorldObject object) {
    final d = object.data;
    final entity = readString(d['entityId']).trim();
    final label = readString(d['label']);
    return MapPin(
      id: object.id,
      worldId: object.worldId,
      mapId: object.parentId ?? '',
      x: clampUnit(readNum(d['x'])?.toDouble()),
      y: clampUnit(readNum(d['y'])?.toDouble()),
      // Older rows may only carry the object name.
      label: label.isEmpty ? object.name : label,
      entityId: entity.isEmpty ? null : entity,
      icon: MapPinIcon.fromKey(d['icon']),
      color: MapPinColor.fromKey(d['colorKey'] ?? d['color']),
      notes: readString(d['notes']),
      gmOnly: readBool(d['gmOnly']),
      sortOrder: object.sortOrder,
      createdAt: object.createdAt,
      updatedAt: object.updatedAt,
    );
  }

  Map<String, Object?> toData() => {
    'x': x,
    'y': y,
    'label': label,
    if (entityId != null) 'entityId': entityId,
    'icon': icon.key,
    'colorKey': color.key,
    'notes': notes,
    'gmOnly': gmOnly,
  };

  WorldObject toObject() => WorldObject(
    id: id,
    worldId: worldId,
    type: WorldObjectTypes.mapPin,
    parentId: mapId,
    name: label,
    data: toData(),
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// The label to show: the pin's own, else the linked entry's name.
  String displayLabel([String? entityName]) {
    final own = label.trim();
    if (own.isNotEmpty) return own;
    return entityName?.trim() ?? '';
  }

  MapPin copyWith({
    String? mapId,
    double? x,
    double? y,
    String? label,
    String? Function()? entityId,
    MapPinIcon? icon,
    MapPinColor? color,
    String? notes,
    bool? gmOnly,
  }) => MapPin(
    id: id,
    worldId: worldId,
    mapId: mapId ?? this.mapId,
    x: x == null ? this.x : clampUnit(x),
    y: y == null ? this.y : clampUnit(y),
    label: label ?? this.label,
    entityId: entityId != null ? entityId() : this.entityId,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    notes: notes ?? this.notes,
    gmOnly: gmOnly ?? this.gmOnly,
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  @override
  String toString() => 'MapPin($id "$label" @ $x,$y)';
}
