import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models/document_model.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/link.dart';
import '../../domain/models/media_item.dart';
import '../../domain/models/tag.dart';
import '../../domain/models/world.dart';
import '../../domain/repositories/repositories.dart';

/// Reactive read-model providers shared by all features. Each wraps a
/// repository watch stream; drift streams re-emit on any relevant write, so
/// every screen stays live without manual refresh.

final worldsProvider = StreamProvider<List<World>>(
  (ref) => ref.watch(worldRepositoryProvider).watchWorlds(),
);

final worldProvider = FutureProvider.family<World?, String>(
  (ref, worldId) {
    ref.watch(worldsProvider); // refresh when any world changes
    return ref.watch(worldRepositoryProvider).getWorld(worldId);
  },
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
    StreamProvider.family<List<Entity>, EntityListArgs>((ref, args) {
  return ref.watch(entityRepositoryProvider).watchEntities(
        args.worldId,
        kind: args.kind,
        customCategoryId: args.customCategoryId,
        tagId: args.tagId,
        favoritesOnly: args.favoritesOnly,
        sort: args.sort,
      );
});

final entityProvider = StreamProvider.family<Entity?, String>(
  (ref, entityId) => ref.watch(entityRepositoryProvider).watchEntity(entityId),
);

final entityDocumentProvider = StreamProvider.family<DocumentModel?, String>(
  (ref, entityId) =>
      ref.watch(documentRepositoryProvider).watchByEntity(entityId),
);

final outgoingLinksProvider = StreamProvider.family<List<Link>, String>(
  (ref, entityId) => ref.watch(linkRepositoryProvider).watchOutgoing(entityId),
);

final incomingLinksProvider = StreamProvider.family<List<Link>, String>(
  (ref, entityId) => ref.watch(linkRepositoryProvider).watchIncoming(entityId),
);

final entityTagsProvider = StreamProvider.family<List<Tag>, String>(
  (ref, entityId) => ref.watch(tagRepositoryProvider).watchEntityTags(entityId),
);

final worldTagsProvider = StreamProvider.family<List<Tag>, String>(
  (ref, worldId) => ref.watch(tagRepositoryProvider).watchTags(worldId),
);

final galleryProvider = StreamProvider.family<List<GalleryEntry>, String>(
  (ref, entityId) => ref.watch(mediaRepositoryProvider).watchGallery(entityId),
);

/// Absolute path of a media item, cached per media id. Thumbnails and
/// embeds resolve through this instead of ad-hoc FutureBuilders, so a
/// rebuilt card or a keystroke near an inline image no longer re-queries
/// SQLite for a path that cannot change (the vault is content-addressed).
final mediaPathProvider = FutureProvider.family<String?, String>(
  (ref, mediaId) async {
    final repository = ref.watch(mediaRepositoryProvider);
    final item = await repository.get(mediaId);
    if (item == null) return null;
    return repository.absolutePath(item);
  },
);

final entityCountsProvider =
    FutureProvider.family<Map<EntityKind, int>, String>((ref, worldId) {
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

final recentEntitiesProvider =
    FutureProvider.family<List<Entity>, String>((ref, worldId) {
  ref.watch(entityListProvider((
    worldId: worldId,
    kind: null,
    customCategoryId: null,
    tagId: null,
    favoritesOnly: false,
    sort: EntitySort.updatedDesc,
  )));
  return ref.watch(searchRepositoryProvider).recentlyOpened(worldId);
});
