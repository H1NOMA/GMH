import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/maps/game_map.dart';
import 'package:gmh/domain/maps/map_pin.dart';
import 'package:gmh/domain/maps/map_search.dart';
import 'package:gmh/domain/models/world_object.dart';

WorldObject _object(
  String type,
  Map<String, Object?> data, {
  String id = 'o1',
  String name = 'Name',
  String? parentId,
}) => WorldObject(
  id: id,
  worldId: 'w1',
  type: type,
  parentId: parentId,
  name: name,
  data: data,
  sortOrder: 3,
  createdAt: 10,
  updatedAt: 20,
);

MapPin _pin(
  String id, {
  String label = '',
  String? entityId,
  String notes = '',
  bool gmOnly = false,
  String mapId = 'm1',
  int createdAt = 0,
}) => MapPin(
  id: id,
  mapId: mapId,
  label: label,
  entityId: entityId,
  notes: notes,
  gmOnly: gmOnly,
  createdAt: createdAt,
);

void main() {
  group('GameMap codec', () {
    test('round trips every field', () {
      const map = GameMap(
        id: 'o1',
        worldId: 'w1',
        name: 'Sword Coast',
        mediaId: 'media-1',
        width: 4096,
        height: 3072,
        description: 'The long coast',
        scale: MapScale(unitsPerCell: 10, unitName: 'miles', cellPx: 64),
        showGrid: true,
        pinsVisibleToPlayers: false,
        sortOrder: 3,
        createdAt: 10,
        updatedAt: 20,
      );
      final back = GameMap.fromObject(map.toObject());
      expect(back.name, 'Sword Coast');
      expect(back.mediaId, 'media-1');
      expect((back.width, back.height), (4096, 3072));
      expect(back.description, 'The long coast');
      expect(back.scale, map.scale);
      expect(back.showGrid, isTrue);
      expect(back.gridVisible, isTrue);
      expect(back.pinsVisibleToPlayers, isFalse);
      expect(back.toObject().type, WorldObjectTypes.map);
    });

    test('empty data reads as a blank map with defaults', () {
      final map = GameMap.fromObject(_object(WorldObjectTypes.map, const {}));
      expect(map.mediaId, isNull);
      expect(map.hasImage, isFalse);
      expect((map.width, map.height), (blankMapWidth, blankMapHeight));
      expect(map.scale, isNull);
      expect(map.showGrid, isFalse);
      expect(map.pinsVisibleToPlayers, isTrue);
      expect(map.description, '');
    });

    test('garbage values fall back instead of throwing', () {
      final map = GameMap.fromObject(
        _object(WorldObjectTypes.map, {
          'mediaId': 42,
          'width': 'wide',
          'height': <String>[],
          'description': {'a': 1},
          'scale': 'big',
          'showGrid': 'maybe',
          'pinsVisibleToPlayers': null,
        }),
      );
      expect(map.mediaId, '42');
      expect((map.width, map.height), (blankMapWidth, blankMapHeight));
      expect(map.description, '');
      expect(map.scale, isNull);
      expect(map.showGrid, isFalse);
      expect(map.pinsVisibleToPlayers, isTrue);
    });

    test('a broken size falls back as a pair', () {
      for (final data in [
        {'width': 0, 'height': 500},
        {'width': 800, 'height': -3},
        {'width': 800, 'height': 9999999},
      ]) {
        final map = GameMap.fromObject(_object(WorldObjectTypes.map, data));
        expect((map.width, map.height), (blankMapWidth, blankMapHeight));
      }
    });

    test('numeric strings are accepted for the size', () {
      final map = GameMap.fromObject(
        _object(WorldObjectTypes.map, {'width': '1200', 'height': 800.4}),
      );
      expect((map.width, map.height), (1200, 800));
    });

    test('blank media id means no image', () {
      final map = GameMap.fromObject(
        _object(WorldObjectTypes.map, {'mediaId': '   '}),
      );
      expect(map.mediaId, isNull);
    });

    test('scale needs positive numbers', () {
      expect(
        MapScale.fromJson({'unitsPerGridCell': 0, 'gridCellPx': 50}),
        isNull,
      );
      expect(
        MapScale.fromJson({'unitsPerGridCell': 5, 'gridCellPx': -1}),
        isNull,
      );
      expect(MapScale.fromJson({'unitsPerGridCell': 5}), isNull);
      expect(MapScale.fromJson(null), isNull);
      expect(
        MapScale.fromJson({
          'unitsPerGridCell': '2.5',
          'gridCellPx': 40,
          'unitName': ' km ',
        }),
        const MapScale(unitsPerCell: 2.5, unitName: 'km', cellPx: 40),
      );
    });

    test('grid is only visible with a scale', () {
      final map = GameMap.fromObject(
        _object(WorldObjectTypes.map, {'showGrid': true}),
      );
      expect(map.showGrid, isTrue);
      expect(map.gridVisible, isFalse);
    });

    test('units per pixel', () {
      const scale = MapScale(unitsPerCell: 5, cellPx: 50);
      expect(scale.unitsPerPixel, 0.1);
    });

    test('copyWith can clear the image and the scale', () {
      const map = GameMap(
        name: 'A',
        mediaId: 'm',
        scale: MapScale(unitsPerCell: 1, cellPx: 1),
      );
      final cleared = map.copyWith(mediaId: () => null, scale: () => null);
      expect(cleared.mediaId, isNull);
      expect(cleared.scale, isNull);
      expect(cleared.name, 'A');
      expect(cleared.toData().containsKey('mediaId'), isFalse);
    });
  });

  group('MapPin codec', () {
    test('round trips every field', () {
      const pin = MapPin(
        id: 'p1',
        worldId: 'w1',
        mapId: 'm1',
        x: 0.25,
        y: 0.75,
        label: 'Harbor',
        entityId: 'e1',
        icon: MapPinIcon.port,
        color: MapPinColor.teal,
        notes: 'Smugglers',
        gmOnly: true,
      );
      final object = pin.toObject();
      expect(object.type, WorldObjectTypes.mapPin);
      expect(object.parentId, 'm1');
      expect(object.name, 'Harbor');
      final back = MapPin.fromObject(object);
      expect((back.x, back.y), (0.25, 0.75));
      expect(back.label, 'Harbor');
      expect(back.entityId, 'e1');
      expect(back.icon, MapPinIcon.port);
      expect(back.color, MapPinColor.teal);
      expect(back.notes, 'Smugglers');
      expect(back.gmOnly, isTrue);
      expect(back.mapId, 'm1');
    });

    test('empty data reads as a centered plain pin', () {
      final pin = MapPin.fromObject(
        _object(WorldObjectTypes.mapPin, const {}, name: '', parentId: 'm'),
      );
      expect((pin.x, pin.y), (0.5, 0.5));
      expect(pin.icon, MapPinIcon.pin);
      expect(pin.color, MapPinColor.auto);
      expect(pin.entityId, isNull);
      expect(pin.gmOnly, isFalse);
      expect(pin.mapId, 'm');
    });

    test('garbage coordinates are clamped or centered', () {
      final pin = MapPin.fromObject(
        _object(WorldObjectTypes.mapPin, {'x': 7, 'y': 'NaN'}),
      );
      expect((pin.x, pin.y), (1.0, 0.5));
      final negative = MapPin.fromObject(
        _object(WorldObjectTypes.mapPin, {'x': -2, 'y': '0.3'}),
      );
      expect((negative.x, negative.y), (0.0, 0.3));
    });

    test('unknown icon and color keys fall back', () {
      final pin = MapPin.fromObject(
        _object(WorldObjectTypes.mapPin, {
          'icon': 'dragon',
          'colorKey': 12,
          'gmOnly': 'yes',
          'entityId': '',
        }),
      );
      expect(pin.icon, MapPinIcon.pin);
      expect(pin.color, MapPinColor.auto);
      expect(pin.gmOnly, isFalse);
      expect(pin.entityId, isNull);
    });

    test('a missing label falls back to the object name', () {
      final pin = MapPin.fromObject(
        _object(WorldObjectTypes.mapPin, const {}, name: 'Old tower'),
      );
      expect(pin.label, 'Old tower');
    });

    test('every icon and color key round trips', () {
      for (final icon in MapPinIcon.values) {
        expect(MapPinIcon.fromKey(icon.key), icon);
      }
      for (final color in MapPinColor.values) {
        expect(MapPinColor.fromKey(color.key), color);
      }
      expect(MapPinIcon.values.map((i) => i.key).toSet(), hasLength(15));
    });

    test('display label prefers the own label, then the entry name', () {
      expect(const MapPin(label: ' Gate ').displayLabel('Town'), 'Gate');
      expect(const MapPin().displayLabel('Town'), 'Town');
      expect(const MapPin().displayLabel(), '');
    });

    test('copyWith clamps coordinates and can unlink', () {
      const pin = MapPin(entityId: 'e1');
      final moved = pin.copyWith(x: 1.4, y: -0.2, entityId: () => null);
      expect((moved.x, moved.y), (1.0, 0.0));
      expect(moved.entityId, isNull);
      expect(moved.toData().containsKey('entityId'), isFalse);
    });
  });

  group('pin search', () {
    final pins = [
      _pin('a', label: 'Harbor Gate', notes: 'Secret tunnel', createdAt: 1),
      _pin('b', entityId: 'e1', createdAt: 2),
      _pin('c', label: 'Watchtower', gmOnly: true, createdAt: 3),
      _pin('d', createdAt: 4),
    ];
    const names = {'e1': 'Captain Mira Voss'};

    test('an empty query returns everything', () {
      expect(filterPins(pins, '  ').map((p) => p.id), ['a', 'b', 'c', 'd']);
    });

    test('matches the label case-insensitively', () {
      expect(filterPins(pins, 'harbor').map((p) => p.id), ['a']);
    });

    test('matches the linked entry name', () {
      expect(
        filterPins(pins, 'mira', entityNames: names).map((p) => p.id),
        ['b'],
      );
    });

    test('matches notes in GM view only', () {
      expect(filterPins(pins, 'tunnel').map((p) => p.id), ['a']);
      expect(filterPins(pins, 'tunnel', playerView: true), isEmpty);
    });

    test('every word must match', () {
      expect(filterPins(pins, 'gate secret').map((p) => p.id), ['a']);
      expect(filterPins(pins, 'gate dragon'), isEmpty);
    });

    test('player view hides GM-only pins', () {
      expect(filterPins(pins, 'watch', playerView: true), isEmpty);
      expect(
        visiblePins(pins, playerView: true).map((p) => p.id),
        ['a', 'b', 'd'],
      );
      expect(visiblePins(pins, playerView: false), hasLength(4));
    });

    test('sorting by label puts unnamed pins last', () {
      expect(
        sortPinsByLabel(pins, entityNames: names).map((p) => p.id),
        ['b', 'a', 'c', 'd'],
      );
    });

    test('counts pins per map', () {
      expect(
        pinCountsByMap([
          _pin('1', mapId: 'x'),
          _pin('2', mapId: 'y'),
          _pin('3', mapId: 'x'),
        ]),
        {'x': 2, 'y': 1},
      );
      expect(pinCountsByMap(const []), isEmpty);
    });

    test('finds pins linked to an entry', () {
      expect(pinsLinkedTo(pins, 'e1').map((p) => p.id), ['b']);
      expect(pinsLinkedTo(pins, 'nobody'), isEmpty);
    });
  });
}
