import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/media_item.dart';
import '../../attachments/attachment_preview.dart';
import '../../attachments/attachment_utils.dart';
import '../../shell/ui_providers.dart';

/// Full-width image strip under a location page: every image attached to
/// the entry becomes a cell, clicking one opens the viewer (with arrows to
/// flip through the rest), and the trailing "+" cell attaches new images.
class EntityGalleryStrip extends ConsumerWidget {
  final Entity entity;

  const EntityGalleryStrip({super.key, required this.entity});

  Future<void> _addImages(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final files = await pickImageFiles(dialogTitle: l10n.addImage);
    if (files.isEmpty) return;
    final imported =
        await importXFiles(ref, worldId: entity.worldId, files: files);
    final media = ref.read(mediaRepositoryProvider);
    for (final item in imported) {
      await media.addToGallery(entity.id, item.id);
    }
    // First image attached to a bare entry doubles as its cover.
    if (entity.coverMediaId == null && imported.isNotEmpty) {
      await ref
          .read(entityServiceProvider)
          .update(entity.copyWith(coverMediaId: () => imported.first.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryProvider(entity.id)).valueOrNull ?? [];
    final images = [
      for (final e in gallery)
        if (isImageMime(e.media.mimeType)) e
    ];
    final captions = <String, String>{
      for (final e in images)
        if (e.caption.isNotEmpty) e.media.id: e.caption
    };

    return Container(
      height: 118,
      decoration: BoxDecoration(
        color: GmhColors.surface,
        border: Border(top: BorderSide(color: GmhColors.border)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(11),
        children: [
          for (final entry in images)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _GalleryCell(
                entry: entry,
                isCover: entity.coverMediaId == entry.media.id,
                onTap: () => previewAttachment(context, ref, entry.media,
                    imageSiblings: [for (final e in images) e.media],
                    captions: captions),
              ),
            ),
          _AddCell(onTap: () => _addImages(context, ref)),
        ],
      ),
    );
  }
}

class _GalleryCell extends ConsumerWidget {
  final GalleryEntry entry;
  final bool isCover;
  final VoidCallback onTap;

  const _GalleryCell(
      {required this.entry, required this.isCover, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(mediaPathProvider(entry.media.id)).valueOrNull;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: GmhColors.border),
          color: GmhColors.surfaceHigh,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (path != null)
              Image.file(File(path),
                  fit: BoxFit.cover,
                  cacheWidth: 384,
                  errorBuilder: (_, _, _) => Icon(
                      Icons.broken_image_outlined,
                      color: GmhColors.parchmentFaint)),
            if (entry.caption.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.black.withValues(alpha: 0.55),
                  child: Text(entry.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10)),
                ),
              ),
            if (isCover)
              Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.badge, size: 14, color: GmhColors.ember),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddCell extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCell({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.addImage,
      waitDuration: const Duration(milliseconds: 600),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: GmhColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined,
                  size: 22, color: GmhColors.parchmentDim),
              const SizedBox(height: 4),
              Text(context.l10n.addImage,
                  style: TextStyle(
                      fontSize: 10.5, color: GmhColors.parchmentFaint)),
            ],
          ),
        ),
      ),
    );
  }
}
