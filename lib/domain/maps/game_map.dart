import 'package:flutter/foundation.dart';

import '../combat/json_read.dart';
import '../models/world_object.dart';

/// Size given to maps without an image (and to images whose size could not
/// be read).
const blankMapWidth = 1600;
const blankMapHeight = 1000;

/// Largest accepted image side; anything bigger is treated as garbage.
const maxMapSide = 100000;

/// Real-world size of the map's grid: one cell of [cellPx] image pixels
/// covers [unitsPerCell] [unitName] ("5 ft", "10 miles").
@immutable
class MapScale {
  final num unitsPerCell;
  final String unitName;
  final num cellPx;

  const MapScale({
    required this.unitsPerCell,
    this.unitName = '',
    required this.cellPx,
  });

  /// Map units per image pixel.
  double get unitsPerPixel => unitsPerCell / cellPx;

  /// Null unless both numbers are positive and finite.
  static MapScale? fromJson(Object? json) {
    if (json is! Map) return null;
    final units = readNum(json['unitsPerGridCell'] ?? json['unitsPerCell']);
    final px = readNum(json['gridCellPx'] ?? json['cellPx']);
    if (units == null || px == null || units <= 0 || px <= 0) return null;
    return MapScale(
      unitsPerCell: units,
      unitName: readString(json['unitName']).trim(),
      cellPx: px,
    );
  }

  Map<String, Object?> toJson() => {
    'unitsPerGridCell': unitsPerCell,
    'unitName': unitName,
    'gridCellPx': cellPx,
  };

  @override
  bool operator ==(Object other) =>
      other is MapScale &&
      other.unitsPerCell == unitsPerCell &&
      other.unitName == unitName &&
      other.cellPx == cellPx;

  @override
  int get hashCode => Object.hash(unitsPerCell, unitName, cellPx);
}

/// A map ([WorldObjectTypes.map]): a background image from the media vault
/// (or a blank canvas) that pins are placed on.
@immutable
class GameMap {
  final String id;
  final String worldId;
  final String name;

  /// Background image in the media vault; null for a blank map.
  final String? mediaId;

  /// Image size in pixels, cached at import. Pins are stored normalized,
  /// so the size only shapes the canvas and the scale.
  final int width;
  final int height;
  final String description;
  final MapScale? scale;
  final bool showGrid;

  /// Whether new pins start visible in player view.
  final bool pinsVisibleToPlayers;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;

  const GameMap({
    this.id = '',
    this.worldId = '',
    required this.name,
    this.mediaId,
    this.width = blankMapWidth,
    this.height = blankMapHeight,
    this.description = '',
    this.scale,
    this.showGrid = false,
    this.pinsVisibleToPlayers = true,
    this.sortOrder = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  bool get hasImage => mediaId != null;

  /// Width / height (always positive).
  double get aspectRatio => width / height;

  /// The grid can only be drawn with a scale.
  bool get gridVisible => showGrid && scale != null;

  factory GameMap.fromObject(WorldObject object) {
    final d = object.data;
    final media = readString(d['mediaId']).trim();
    final w = readInt(d['width']);
    final h = readInt(d['height']);
    // A broken size falls back as a pair: keeping one bogus side would
    // distort every pin.
    final sizeOk = w > 0 && h > 0 && w <= maxMapSide && h <= maxMapSide;
    return GameMap(
      id: object.id,
      worldId: object.worldId,
      name: object.name,
      mediaId: media.isEmpty ? null : media,
      width: sizeOk ? w : blankMapWidth,
      height: sizeOk ? h : blankMapHeight,
      description: readString(d['description']),
      scale: MapScale.fromJson(d['scale']),
      showGrid: readBool(d['showGrid']),
      pinsVisibleToPlayers: readBool(d['pinsVisibleToPlayers'], true),
      sortOrder: object.sortOrder,
      createdAt: object.createdAt,
      updatedAt: object.updatedAt,
    );
  }

  Map<String, Object?> toData() => {
    if (mediaId != null) 'mediaId': mediaId,
    'width': width,
    'height': height,
    'description': description,
    if (scale != null) 'scale': scale!.toJson(),
    'showGrid': showGrid,
    'pinsVisibleToPlayers': pinsVisibleToPlayers,
  };

  WorldObject toObject() => WorldObject(
    id: id,
    worldId: worldId,
    type: WorldObjectTypes.map,
    name: name,
    data: toData(),
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  GameMap copyWith({
    String? name,
    String? Function()? mediaId,
    int? width,
    int? height,
    String? description,
    MapScale? Function()? scale,
    bool? showGrid,
    bool? pinsVisibleToPlayers,
  }) => GameMap(
    id: id,
    worldId: worldId,
    name: name ?? this.name,
    mediaId: mediaId != null ? mediaId() : this.mediaId,
    width: width ?? this.width,
    height: height ?? this.height,
    description: description ?? this.description,
    scale: scale != null ? scale() : this.scale,
    showGrid: showGrid ?? this.showGrid,
    pinsVisibleToPlayers: pinsVisibleToPlayers ?? this.pinsVisibleToPlayers,
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
