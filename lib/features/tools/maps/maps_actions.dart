import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../domain/maps/game_map.dart';
import '../../../domain/maps/map_pin.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/world_object.dart';
import '../../../domain/repositories/repositories.dart';
import '../../attachments/attachment_utils.dart';
import '../../shell/ui_providers.dart';

/// Query parameter of a map page that centers the view on one pin.
const mapPinQuery = 'pin';

/// The map page centered on [pinId].
String mapPinLocation(String worldId, String mapId, String pinId) =>
    '${Routes.tool(worldId, 'maps', mapId)}'
    '?$mapPinQuery=${Uri.encodeQueryComponent(pinId)}';

typedef MapPinsQuery = ({String worldId, String mapId});

/// The world's maps in list order.
final worldMapsProvider = Provider.autoDispose
    .family<AsyncValue<List<GameMap>>, String>((ref, worldId) {
      return ref
          .watch(
            worldObjectsProvider((
              worldId: worldId,
              type: WorldObjectTypes.map,
              parentId: null,
            )),
          )
          .whenData((objects) => [for (final o in objects) GameMap.fromObject(o)]);
    });

/// One map (null once deleted, or when [mapId] is not a map).
final gameMapProvider = Provider.autoDispose
    .family<AsyncValue<GameMap?>, String>((ref, mapId) {
      return ref
          .watch(worldObjectProvider(mapId))
          .whenData(
            (o) => o == null || o.type != WorldObjectTypes.map
                ? null
                : GameMap.fromObject(o),
          );
    });

/// Every pin of the world (all maps).
final worldPinsProvider = Provider.autoDispose
    .family<AsyncValue<List<MapPin>>, String>((ref, worldId) {
      return ref
          .watch(
            worldObjectsProvider((
              worldId: worldId,
              type: WorldObjectTypes.mapPin,
              parentId: null,
            )),
          )
          .whenData((objects) => [for (final o in objects) MapPin.fromObject(o)]);
    });

/// The pins of one map.
final mapPinsProvider = Provider.autoDispose
    .family<AsyncValue<List<MapPin>>, MapPinsQuery>((ref, q) {
      return ref
          .watch(
            worldObjectsProvider((
              worldId: q.worldId,
              type: WorldObjectTypes.mapPin,
              parentId: q.mapId,
            )),
          )
          .whenData((objects) => [for (final o in objects) MapPin.fromObject(o)]);
    });

/// Live entries linked from one map's pins (entity id -> entry); trashed
/// and missing entries are left out.
final mapPinEntitiesProvider = Provider.autoDispose
    .family<Map<String, Entity>, MapPinsQuery>((ref, q) {
      final pins = ref.watch(mapPinsProvider(q)).valueOrNull ?? const [];
      final ids = {
        for (final p in pins)
          if (p.entityId != null) p.entityId!,
      };
      return {
        for (final id in ids)
          if (ref.watch(entityProvider(id)).valueOrNull case final e?
              when !e.isDeleted)
            id: e,
      };
    });

/// Picks one image file; tests replace it (the platform picker cannot run
/// there).
final mapImagePickerProvider = Provider<Future<List<XFile>> Function()>(
  (ref) =>
      () => pickImageFiles(allowMultiple: false),
);

final mapsActionsProvider = Provider<MapsActions>(
  (ref) => MapsActions(
    ref.watch(worldObjectRepositoryProvider),
    ref.watch(mediaRepositoryProvider),
  ),
);

/// Pixel size of an encoded image, or null when it cannot be decoded.
/// Reads the header only; the pixels are never decoded.
Future<ui.Size?> decodeImageSize(Uint8List bytes) async {
  if (bytes.isEmpty) return null;
  try {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    try {
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final size = ui.Size(
        descriptor.width.toDouble(),
        descriptor.height.toDouble(),
      );
      descriptor.dispose();
      return size.width > 0 && size.height > 0 ? size : null;
    } finally {
      buffer.dispose();
    }
  } catch (_) {
    return null;
  }
}

/// A background image stored in the vault, with its pixel size.
typedef MapImage = ({String mediaId, int width, int height, String fileName});

/// Every write the maps tool makes.
class MapsActions {
  final WorldObjectRepository _repo;
  final MediaRepository _media;

  MapsActions(this._repo, this._media);

  Future<GameMap> create(String worldId, GameMap draft) async {
    final object = await _repo.create(
      worldId: worldId,
      type: WorldObjectTypes.map,
      name: draft.name,
      data: draft.toData(),
    );
    return GameMap.fromObject(object);
  }

  Future<void> save(GameMap map) => _repo.update(map.toObject());

  /// Deletes the map with its pins, then its image unless something else
  /// (a duplicate, a gallery) still uses it.
  Future<void> delete(GameMap map) async {
    await _repo.delete(map.id);
    final media = map.mediaId;
    if (media == null) return;
    try {
      await _media.deleteIfUnreferenced(media);
    } catch (_) {
      // The vault is swept by garbage collection later anyway.
    }
  }

  /// A copy of [source] and all of its pins.
  Future<GameMap> duplicate(GameMap source, String name) async {
    final copy = await create(source.worldId, source.copyWith(name: name));
    final pins = await _repo.list(
      source.worldId,
      WorldObjectTypes.mapPin,
      parentId: source.id,
    );
    for (final pin in pins) {
      await _repo.create(
        worldId: source.worldId,
        type: WorldObjectTypes.mapPin,
        parentId: copy.id,
        name: pin.name,
        data: pin.data,
        sortOrder: pin.sortOrder,
      );
    }
    return copy;
  }

  /// Stores [file] in the vault. Null when it is not a readable image.
  Future<MapImage?> importImage(String worldId, XFile file) async {
    final Uint8List bytes;
    try {
      bytes = await file.readAsBytes();
    } catch (_) {
      return null;
    }
    final size = await decodeImageSize(bytes);
    if (size == null) return null;
    final outcome = await importXFiles(
      _media,
      worldId: worldId,
      files: [XFile.fromData(bytes, name: file.name)],
    );
    if (outcome.imported.isEmpty) return null;
    final item = outcome.imported.first;
    return (
      mediaId: item.id,
      width: size.width.round(),
      height: size.height.round(),
      fileName: file.name,
    );
  }

  /// Swaps the background of [map]; pins keep their relative positions.
  Future<void> replaceImage(GameMap map, MapImage image) async {
    final old = map.mediaId;
    await save(
      map.copyWith(
        mediaId: () => image.mediaId,
        width: image.width,
        height: image.height,
      ),
    );
    if (old != null && old != image.mediaId) {
      try {
        await _media.deleteIfUnreferenced(old);
      } catch (_) {}
    }
  }

  Future<MapPin> addPin(GameMap map, MapPin draft) async {
    final object = await _repo.create(
      worldId: map.worldId,
      type: WorldObjectTypes.mapPin,
      parentId: map.id,
      name: draft.label,
      data: draft.toData(),
    );
    return MapPin.fromObject(object);
  }

  Future<void> savePin(MapPin pin) => _repo.update(pin.toObject());

  Future<void> deletePin(String id) => _repo.delete(id);
}
