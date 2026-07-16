import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/media_item.dart';
import '../../shell/ui_providers.dart';

/// Ordered image gallery for an entity, backed by the content-addressed
/// media vault. Supports add, caption, set-as-cover and remove.
class GalleryPanel extends ConsumerWidget {
  final Entity entity;

  const GalleryPanel({super.key, required this.entity});

  Future<void> _addImages(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (picked == null) return;
    final media = ref.read(mediaRepositoryProvider);
    for (final file in picked.files) {
      final bytes = file.bytes;
      if (bytes == null) continue;
      final item = await media.import(
          worldId: entity.worldId, fileName: file.name, bytes: bytes);
      await media.addToGallery(entity.id, item.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryProvider(entity.id)).valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('GALLERY',
                  style: TextStyle(
                      fontSize: 10.5,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      color: GmhColors.parchmentFaint)),
            ),
            IconButton(
              tooltip: 'Add images',
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              visualDensity: VisualDensity.compact,
              onPressed: () => _addImages(context, ref),
            ),
          ],
        ),
        if (gallery.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No images yet.',
                style:
                    TextStyle(fontSize: 12, color: GmhColors.parchmentFaint)),
          )
        else
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (final entry in gallery)
                _GalleryTile(entity: entity, entry: entry),
            ],
          ),
      ],
    );
  }
}

class _GalleryTile extends ConsumerWidget {
  final Entity entity;
  final GalleryEntry entry;

  const _GalleryTile({required this.entity, required this.entry});

  Future<void> _showActions(BuildContext context, WidgetRef ref) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: GmhColors.surfaceRaised,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Set as cover image'),
              onTap: () => Navigator.pop(context, 'cover'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit caption'),
              onTap: () => Navigator.pop(context, 'caption'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline,
                  color: GmhColors.danger),
              title: const Text('Remove from gallery',
                  style: TextStyle(color: GmhColors.danger)),
              onTap: () => Navigator.pop(context, 'remove'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case 'cover':
        await ref.read(entityServiceProvider).update(
            entity.copyWith(coverMediaId: () => entry.media.id));
      case 'remove':
        await ref
            .read(mediaRepositoryProvider)
            .removeFromGallery(entity.id, entry.media.id);
      case 'caption':
        final controller = TextEditingController(text: entry.caption);
        final caption = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Caption'),
            content: TextField(controller: controller, autofocus: true),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: const Text('Save')),
            ],
          ),
        );
        if (caption != null) {
          await ref
              .read(mediaRepositoryProvider)
              .setCaption(entity.id, entry.media.id, caption.trim());
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: ref.read(mediaRepositoryProvider).absolutePath(entry.media),
      builder: (context, snapshot) {
        final path = snapshot.data;
        return InkWell(
          onTap: () => _showActions(context, ref),
          borderRadius: BorderRadius.circular(8),
          child: Container(
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
                      errorBuilder: (_, _, _) => const Icon(
                          Icons.broken_image_outlined,
                          color: GmhColors.parchmentFaint)),
                if (entry.caption.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      color: Colors.black.withValues(alpha: 0.55),
                      child: Text(entry.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5)),
                    ),
                  ),
                if (entity.coverMediaId == entry.media.id)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(Icons.badge,
                        size: 15, color: GmhColors.ember),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
