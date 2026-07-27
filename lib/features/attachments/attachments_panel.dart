import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity.dart';
import '../shell/ui_providers.dart';
import '../../domain/models/media_item.dart';
import 'attachment_preview.dart';
import 'attachment_utils.dart';

/// Rich attachments panel for every entity: unlimited files of any type,
/// image thumbnail grid, file rows with size/type, drag & drop (desktop),
/// file picker + photo gallery (mobile), rename/replace/caption/cover/delete.
class AttachmentsPanel extends ConsumerStatefulWidget {
  final Entity entity;

  /// Custom sections can disable either half via their blueprint.
  final bool showImages;
  final bool showFiles;

  const AttachmentsPanel({
    super.key,
    required this.entity,
    this.showImages = true,
    this.showFiles = true,
  });

  @override
  ConsumerState<AttachmentsPanel> createState() => _AttachmentsPanelState();
}

class _AttachmentsPanelState extends ConsumerState<AttachmentsPanel> {
  bool _dragging = false;

  Entity get entity => widget.entity;

  Future<void> _attach(List<XFile> files) async {
    if (files.isEmpty) return;
    final imported = await importXFiles(ref,
        worldId: entity.worldId, files: files);
    final media = ref.read(mediaRepositoryProvider);
    for (final item in imported) {
      await media.addToGallery(entity.id, item.id);
    }
    if (mounted && imported.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.l10n.attachmentsAdded(imported.length))));
    }
  }

  Future<void> _pickFiles() async =>
      _attach(await pickAnyFiles(dialogTitle: context.l10n.addFiles));

  Future<void> _pickPhotos() async => _attach(await pickFromPhotoGallery());

  @override
  Widget build(BuildContext context) {
    final gallery = ref.watch(galleryProvider(entity.id)).valueOrNull ?? [];
    final images = [
      for (final e in gallery)
        if (isImageMime(e.media.mimeType)) e
    ];
    final files = [
      for (final e in gallery)
        if (!isImageMime(e.media.mimeType)) e
    ];
    final captions = <String, String>{
      for (final e in gallery)
        if (e.caption.isNotEmpty) e.media.id: e.caption
    };

    final panel = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(context.l10n.attachmentsCaps,
                  style: TextStyle(
                      fontSize: 10.5,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      color: GmhColors.parchmentFaint)),
            ),
            if (supportsPhotoGallery)
              IconButton(
                tooltip: context.l10n.fromGallery,
                icon: const Icon(Icons.photo_library_outlined, size: 17),
                visualDensity: VisualDensity.compact,
                onPressed: _pickPhotos,
              ),
            IconButton(
              tooltip: context.l10n.addFiles,
              icon: const Icon(Icons.attach_file, size: 17),
              visualDensity: VisualDensity.compact,
              onPressed: _pickFiles,
            ),
          ],
        ),
        if (gallery.where((e) =>
                (widget.showImages && isImageMime(e.media.mimeType)) ||
                (widget.showFiles && !isImageMime(e.media.mimeType)))
            .isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(context.l10n.noAttachments,
                style: TextStyle(
                    fontSize: 12, color: GmhColors.parchmentFaint)),
          ),
        if (widget.showImages && images.isNotEmpty)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (final entry in images)
                _ImageTile(
                  entity: entity,
                  entry: entry,
                  onTap: () => previewAttachment(context, ref, entry.media,
                      imageSiblings: [for (final e in images) e.media],
                      captions: captions),
                  onLongPress: () => _showActions(entry),
                ),
            ],
          ),
        if (widget.showFiles && files.isNotEmpty) ...[
          const SizedBox(height: 8),
          // Files use the same gallery-style grid as images.
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.55,
            children: [
              for (final entry in files)
                _FileTile(
                  entry: entry,
                  onTap: () => previewAttachment(context, ref, entry.media),
                  onMenu: () => _showActions(entry),
                ),
            ],
          ),
        ],
      ],
    );

    // Desktop drag & drop target; on mobile DropTarget is inert.
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: (details) {
        setState(() => _dragging = false);
        _attach(details.files);
      },
      child: Container(
        decoration: _dragging
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: GmhColors.ember, width: 1.5),
                color: GmhColors.ember.withValues(alpha: 0.06),
              )
            : null,
        child: _dragging
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(context.l10n.dropFilesHere,
                      style: TextStyle(color: GmhColors.emberBright)),
                ),
              )
            : panel,
      ),
    );
  }

  // ------------------------------------------------------------- actions

  Future<void> _showActions(GalleryEntry entry) async {
    final item = entry.media;
    final isImage = isImageMime(item.mimeType);
    final l = context.l10n;

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: GmhColors.surfaceRaised,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(attachmentIcon(item), color: GmhColors.ember),
              title: Text(item.fileName,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                  '${fileTypeTag(item)} · ${formatBytes(item.sizeBytes)}',
                  style: const TextStyle(fontSize: 11.5)),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.open_in_new, size: 20),
              title: Text(l.open),
              onTap: () => Navigator.pop(context, 'open'),
            ),
            if (isImage)
              ListTile(
                leading: const Icon(Icons.badge_outlined, size: 20),
                title: Text(l.setAsCover),
                onTap: () => Navigator.pop(context, 'cover'),
              ),
            ListTile(
              leading: const Icon(Icons.edit_outlined, size: 20),
              title: Text(l.rename),
              onTap: () => Navigator.pop(context, 'rename'),
            ),
            ListTile(
              leading: const Icon(Icons.notes_outlined, size: 20),
              title: Text(l.editCaption),
              onTap: () => Navigator.pop(context, 'caption'),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, size: 20),
              title: Text(l.replaceFile),
              onTap: () => Navigator.pop(context, 'replace'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline,
                  size: 20, color: GmhColors.danger),
              title: Text(l.deleteAttachment,
                  style: TextStyle(color: GmhColors.danger)),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;

    final media = ref.read(mediaRepositoryProvider);
    switch (action) {
      case 'open':
        await previewAttachment(context, ref, item);
      case 'cover':
        await ref
            .read(entityServiceProvider)
            .update(entity.copyWith(coverMediaId: () => item.id));
      case 'rename':
        final name = await _promptText(
            title: context.l10n.renameAttachmentTitle,
            initial: item.fileName);
        if (name != null && name.trim().isNotEmpty) {
          await media.rename(item.id, name.trim());
        }
      case 'caption':
        final caption = await _promptText(
            title: context.l10n.captionLabel, initial: entry.caption);
        if (caption != null) {
          await media.setCaption(entity.id, item.id, caption.trim());
        }
      case 'replace':
        final files = await pickAnyFiles(dialogTitle: context.l10n.replaceFile);
        final file = files.firstOrNull;
        if (file != null) {
          final bytes = await file.readAsBytes();
          if (bytes.isNotEmpty) {
            await media.replaceBytes(
                mediaId: item.id, fileName: file.name, bytes: bytes);
          }
        }
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                context.l10n.deleteAttachmentTitle(item.fileName)),
            content: Text(context.l10n.deleteAttachmentBody),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.cancel)),
              FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: GmhColors.danger),
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.delete),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await media.removeFromGallery(entity.id, item.id);
          if (entity.coverMediaId == item.id) {
            await ref
                .read(entityServiceProvider)
                .update(entity.copyWith(coverMediaId: () => null));
          }
          await media.deleteIfUnreferenced(item.id);
        }
    }
  }

  Future<String?> _promptText(
      {required String title, String initial = ''}) async {
    final controller = TextEditingController(text: initial);
    ModalRoute<Object?>? dialogRoute;
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        dialogRoute ??= ModalRoute.of(context);
        return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (text) => Navigator.pop(context, text),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(context.l10n.save)),
        ],
      );
      },
    );
    // Release the controller only once the dialog route is fully gone.
    dialogRoute?.completed.whenComplete(controller.dispose);
    return result;
  }
}

// ------------------------------------------------------------------ tiles

class _ImageTile extends ConsumerWidget {
  final Entity entity;
  final GalleryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ImageTile({
    required this.entity,
    required this.entry,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cached path lookup — image tiles rebuild with every gallery change.
    return Builder(
      builder: (context) {
        final path =
            ref.watch(mediaPathProvider(entry.media.id)).valueOrNull;
        return InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onSecondaryTap: onLongPress,
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
                      cacheWidth: 480,
                      errorBuilder: (_, _, _) => Icon(
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
                  Positioned(
                    top: 4,
                    right: 4,
                    child:
                        Icon(Icons.badge, size: 15, color: GmhColors.ember),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Grid tile for a non-image attachment: big type icon, file type badge,
/// name and size — visually consistent with the image grid above it.
class _FileTile extends StatelessWidget {
  final GalleryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  const _FileTile({
    required this.entry,
    required this.onTap,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final item = entry.media;
    return InkWell(
      onTap: onTap,
      onLongPress: onMenu,
      onSecondaryTap: onMenu,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: GmhColors.border),
          color: GmhColors.surfaceHigh,
        ),
        padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(attachmentIcon(item),
                    size: 22, color: GmhColors.ember),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(99),
                  onTap: onMenu,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.more_vert,
                        size: 15, color: GmhColors.parchmentDim),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(item.fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, height: 1.2)),
            const SizedBox(height: 2),
            Text(
              '${fileTypeTag(item)} · ${formatBytes(item.sizeBytes)}'
              '${entry.caption.isNotEmpty ? ' · ${entry.caption}' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10.5, color: GmhColors.parchmentFaint),
            ),
          ],
        ),
      ),
    );
  }
}
