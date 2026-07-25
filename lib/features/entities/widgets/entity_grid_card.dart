import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/entity.dart';
import '../../attachments/attachment_utils.dart';
import '../../categories/category_ui.dart';
import '../../shell/ui_providers.dart';

/// Gallery-style tile for the grid view: the entry's photo fills the card
/// (cover image first, else the first image attachment) with the name on a
/// gradient overlay — like a photo gallery. Entries without any image show
/// their kind icon on a tinted placeholder.
class EntityGridCard extends ConsumerWidget {
  final Entity entity;
  final String worldId;

  const EntityGridCard({
    super.key,
    required this.entity,
    required this.worldId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryMapProvider(worldId));
    final icon = entityIcon(entity, categories);
    final color = entityColor(entity, categories);

    // Cover first; otherwise fall back to the first image attachment so a
    // freshly imported archive still looks like a gallery.
    final gallery = ref.watch(galleryProvider(entity.id)).valueOrNull ?? [];
    final imageId = entity.coverMediaId ??
        gallery
            .where((e) => isImageMime(e.media.mimeType))
            .map((e) => e.media.id)
            .firstOrNull;

    final hasImage = imageId != null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ref.read(searchRepositoryProvider).recordOpened(entity.id);
          context.go(Routes.entity(worldId, entity.id));
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageId == null)
              ColoredBox(
                color: color.withValues(alpha: 0.10),
                child: Center(
                  child:
                      Icon(icon, size: 38, color: color.withValues(alpha: 0.7)),
                ),
              )
            else
              _MediaImage(mediaId: imageId, fallbackIcon: icon, color: color),
            // Name (and summary when there is room) over a bottom gradient,
            // readable on any photo.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 22, 10, 8),
                // The white-on-gradient caption is only readable over a
                // photo; on the tinted placeholder (white-ish in light
                // themes) the theme's own text colors are used instead.
                decoration: hasImage
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xC7000000)],
                        ),
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entity.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: hasImage
                            ? const Color(0xFFF2F2F2)
                            : GmhColors.parchment,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    if (entity.summary.isNotEmpty)
                      Text(
                        entity.summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: hasImage
                                ? const Color(0xB8FFFFFF)
                                : GmhColors.parchmentDim,
                            fontSize: 10.5),
                      ),
                  ],
                ),
              ),
            ),
            if (entity.isFavorite)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.star, size: 13, color: GmhColors.ember),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MediaImage extends ConsumerStatefulWidget {
  final String mediaId;
  final IconData fallbackIcon;
  final Color color;

  const _MediaImage({
    required this.mediaId,
    required this.fallbackIcon,
    required this.color,
  });

  @override
  ConsumerState<_MediaImage> createState() => _MediaImageState();
}

class _MediaImageState extends ConsumerState<_MediaImage> {
  // Cached: a fresh future per build would re-hit the media repo (and flash
  // the placeholder) every time any watched stream above this card emits.
  late Future<String?> _path = _resolve();

  Future<String?> _resolve() async {
    final media = await ref.read(mediaRepositoryProvider).get(widget.mediaId);
    if (media == null) return null;
    return ref.read(mediaRepositoryProvider).absolutePath(media);
  }

  @override
  void didUpdateWidget(covariant _MediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mediaId != widget.mediaId) {
      _path = _resolve();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackIcon = widget.fallbackIcon;
    final color = widget.color;
    return FutureBuilder<String?>(
      future: _path,
      builder: (context, snapshot) {
        final path = snapshot.data;
        if (path == null) {
          return ColoredBox(
            color: color.withValues(alpha: 0.10),
            child: Center(
              child: Icon(fallbackIcon,
                  size: 38, color: color.withValues(alpha: 0.7)),
            ),
          );
        }
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          cacheWidth: 640,
          errorBuilder: (_, _, _) => ColoredBox(
            color: color.withValues(alpha: 0.10),
            child: Center(
              child: Icon(Icons.broken_image_outlined,
                  color: GmhColors.parchmentFaint),
            ),
          ),
        );
      },
    );
  }
}
