import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/media_item.dart';
import 'attachment_utils.dart';
import 'image_viewer.dart';

/// Opens the best in-app preview for an attachment:
///  * images → full-screen viewer,
///  * text-like files (txt, md, json…) → scrollable text preview,
///  * everything else → info sheet with "open externally".
Future<void> previewAttachment(
  BuildContext context,
  WidgetRef ref,
  MediaItem item, {
  List<MediaItem>? imageSiblings,
  Map<String, String> captions = const {},
}) async {
  if (isImageMime(item.mimeType)) {
    final images = imageSiblings ?? [item];
    final index = images.indexWhere((m) => m.id == item.id);
    await showImageViewer(context,
        images: images, initialIndex: index < 0 ? 0 : index, captions: captions);
    return;
  }

  if (isTextLikeMime(item.mimeType, item.fileName)) {
    final path = await ref.read(mediaRepositoryProvider).absolutePath(item);
    String content;
    try {
      final file = File(path);
      // Cap in-app preview at 1 MB; larger text opens externally.
      if (await file.length() > 1024 * 1024) {
        if (context.mounted) await _showInfoSheet(context, ref, item);
        return;
      }
      content = utf8.decode(await file.readAsBytes(), allowMalformed: true);
    } catch (_) {
      content = '';
    }
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720, maxHeight: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 8, 6),
                child: Row(
                  children: [
                    Icon(attachmentIcon(item),
                        size: 18, color: GmhColors.parchmentDim),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item.fileName,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_new, size: 17),
                      tooltip: context.l10n.openExternally,
                      onPressed: () => openAttachmentExternally(ref, item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: SelectableText(
                    content,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return;
  }

  await _showInfoSheet(context, ref, item);
}

Future<void> _showInfoSheet(
    BuildContext context, WidgetRef ref, MediaItem item) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: GmhColors.surfaceRaised,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(attachmentIcon(item),
                    size: 28, color: GmhColors.ember),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.fileName,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${fileTypeTag(item)} · ${formatBytes(item.sizeBytes)}',
                        style: TextStyle(
                            fontSize: 12, color: GmhColors.parchmentDim),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(context.l10n.previewUnavailable,
                style: TextStyle(
                    fontSize: 12.5, color: GmhColors.parchmentDim)),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.open_in_new, size: 17),
              label: Text(context.l10n.openExternally),
              onPressed: () {
                Navigator.pop(context);
                openAttachmentExternally(ref, item);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
