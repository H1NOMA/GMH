import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models/document_model.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/link.dart';
import '../../domain/models/media_item.dart';
import '../../domain/models/tag.dart';
import '../../domain/models/world.dart';
import '../../domain/models/world_object.dart';
import '../../domain/repositories/repositories.dart';

/// Reactive read-model providers shared by all features. Each wraps a
/// repository watch stream; drift streams re-emit on any relevant write, so
/// every screen stays live without manual refresh.

final worldsProvider = StreamProvider<List<World>>(
  (ref) => ref.watch(worldRepositoryProvider).watchWorlds(),
);

/// One world, derived synchronously from the live [worldsProvider] list:
/// renames and style switches apply on the next frame, and there is no
/// extra async hop that would paint a cyberpunk world in fantasy colors
/// for a frame while a per-world query loads.
final worldProvider = Provider.family<AsyncValue<World?>, String>(
  (ref, worldId) => ref.watch(worldsProvider).whenData(
      (worlds) => worlds.where((w) => w.id == worldId).firstOrNull),
);

typedef EntityListArgs = ({
  String worldId,
  EntityKind? kind,
  String? customCategoryId,
  String? tagId,
  bool favoritesOnly,
  EntitySort sort,
});

final entityListProvider =
    StreamProvider.autoDispose.family<List<Entity>, EntityListArgs>((ref, args) {
  return ref.watch(entityRepositoryProvider).watchEntities(
        args.worldId,
        kind: args.kind,
        customCategoryId: args.customCategoryId,
        tagId: args.tagId,
        favoritesOnly: args.favoritesOnly,
        sort: args.sort,
      );
});

final entityProvider = StreamProvider.autoDispose.family<Entity?, String>(
  (ref, entityId) => ref.watch(entityRepositoryProvider).watchEntity(entityId),
);

final entityDocumentProvider = StreamProvider.autoDispose.family<DocumentModel?, String>(
  (ref, entityId) =>
      ref.watch(documentRepositoryProvider).watchByEntity(entityId),
);

final outgoingLinksProvider = StreamProvider.autoDispose.family<List<Link>, String>(
  (ref, entityId) => ref.watch(linkRepositoryProvider).watchOutgoing(entityId),
);

final incomingLinksProvider = StreamProvider.autoDispose.family<List<Link>, String>(
  (ref, entityId) => ref.watch(linkRepositoryProvider).watchIncoming(entityId),
);

final entityTagsProvider = StreamProvider.autoDispose.family<List<Tag>, String>(
  (ref, entityId) => ref.watch(tagRepositoryProvider).watchEntityTags(entityId),
);

final worldTagsProvider = StreamProvider.family<List<Tag>, String>(
  (ref, worldId) => ref.watch(tagRepositoryProvider).watchTags(worldId),
);

final galleryProvider = StreamProvider.autoDispose.family<List<GalleryEntry>, String>(
  (ref, entityId) => ref.watch(mediaRepositoryProvider).watchGallery(entityId),
);

/// Absolute path of a media item, cached per media id. Thumbnails and
/// embeds resolve through this instead of ad-hoc FutureBuilders, so a
/// rebuilt card or a keystroke near an inline image no longer re-queries
/// SQLite for a path that cannot change (the vault is content-addressed).
/// A vault item by id (null once it is gone); cached while shown.
final mediaItemProvider =
    FutureProvider.autoDispose.family<MediaItem?, String>(
  (ref, mediaId) => ref.watch(mediaRepositoryProvider).get(mediaId),
);

final mediaPathProvider = FutureProvider.autoDispose.family<String?, String>(
  (ref, mediaId) async {
    final repository = ref.watch(mediaRepositoryProvider);
    final item = await repository.get(mediaId);
    if (item == null) return null;
    return repository.absolutePath(item);
  },
);

final entityCountsProvider =
    FutureProvider.autoDispose.family<Map<EntityKind, int>, String>(
        (ref, worldId) {
  // Recompute whenever the entity list of the world changes.
  ref.watch(entityListProvider((
    worldId: worldId,
    kind: null,
    customCategoryId: null,
    tagId: null,
    favoritesOnly: false,
    sort: EntitySort.updatedDesc,
  )));
  return ref.watch(entityRepositoryProvider).countsByKind(worldId);
});

/// Recently opened entries; live, so opening an entry updates the
/// dashboard and search lists immediately.
final recentEntitiesProvider =
    StreamProvider.autoDispose.family<List<Entity>, String>(
  (ref, worldId) =>
      ref.watch(searchRepositoryProvider).watchRecentlyOpened(worldId),
);

// ------------------------------------------------------------ GM tools

typedef WorldObjectQuery = ({String worldId, String type, String? parentId});

/// Live objects of one type in a world (optionally one parent's children).
/// autoDispose: tools come and go; their streams must not outlive them.
final worldObjectsProvider = StreamProvider.autoDispose
    .family<List<WorldObject>, WorldObjectQuery>(
  (ref, q) => ref
      .watch(worldObjectRepositoryProvider)
      .watch(q.worldId, q.type, parentId: q.parentId),
);

final worldObjectProvider =
    StreamProvider.autoDispose.family<WorldObject?, String>(
  (ref, id) => ref.watch(worldObjectRepositoryProvider).watchOne(id),
);

/// Trashed entries of a world, most recently deleted first.
final trashProvider =
    StreamProvider.autoDispose.family<List<Entity>, String>(
  (ref, worldId) => ref.watch(entityRepositoryProvider).watchTrash(worldId),
);
