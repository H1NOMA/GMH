import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/media_item.dart';
import '../attachments/attachment_preview.dart';
import '../attachments/attachment_utils.dart';

/// Inline file-attachment embed: serialized as
/// `{"insert": {"fileAttachment": "{\"mediaId\":…,\"name\":…}"}}`.
/// Renders as a tappable chip; tapping opens the in-app preview
/// (PDFs, documents, audio… open externally when no preview exists).
const fileAttachmentEmbedKey = 'fileAttachment';

void insertFileAttachment(QuillController controller, MediaItem item) {
  // selection.start/end, not base/extent: a right-to-left selection has
  // extent < base, which would produce a negative replace length.
  final index = controller.selection.start;
  final length = controller.selection.end - index;
  controller.replaceText(
    index,
    length,
    Embeddable(
      fileAttachmentEmbedKey,
      jsonEncode({'mediaId': item.id, 'name': item.fileName}),
    ),
    TextSelection.collapsed(offset: index + 1),
  );
  controller.replaceText(
      index + 1, 0, ' ', TextSelection.collapsed(offset: index + 2));
}

class FileAttachmentEmbedBuilder extends EmbedBuilder {
  FileAttachmentEmbedBuilder();

  @override
  String get key => fileAttachmentEmbedKey;

  @override
  bool get expanded => false;

  Map<String, Object?>? _decode(Embed node) {
    final data = node.value.data;
    if (data is Map) return data.cast<String, Object?>();
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return decoded.cast<String, Object?>();
      } catch (_) {}
    }
    return null;
  }

  @override
  String toPlainText(Embed node) =>
      _decode(node)?['name'] as String? ?? '';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final payload = _decode(embedContext.node);
    return _AttachmentChip(
      mediaId: payload?['mediaId'] as String?,
      fallbackName: payload?['name'] as String? ?? 'file',
    );
  }
}

class _AttachmentChip extends ConsumerStatefulWidget {
  final String? mediaId;
  final String fallbackName;

  const _AttachmentChip({required this.mediaId, required this.fallbackName});

  @override
  ConsumerState<_AttachmentChip> createState() => _AttachmentChipState();
}

class _AttachmentChipState extends ConsumerState<_AttachmentChip> {
  // Cached in state: a fresh future per build would flash the chip to its
  // "broken" fallback on every keystroke while the lookup re-runs.
  late Future<MediaItem?> _item = _load();

  Future<MediaItem?> _load() => widget.mediaId == null
      ? Future.value(null)
      : ref.read(mediaRepositoryProvider).get(widget.mediaId!);

  @override
  void didUpdateWidget(covariant _AttachmentChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mediaId != widget.mediaId) {
      _item = _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackName = widget.fallbackName;
    return FutureBuilder<MediaItem?>(
      future: _item,
      builder: (context, snapshot) {
        final item = snapshot.data;
        final broken = snapshot.connectionState == ConnectionState.done &&
            item == null;
        return GestureDetector(
          onTap: item == null
              ? null
              : () => previewAttachment(context, ref, item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: GmhColors.surfaceHigh,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: GmhColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item == null
                      ? Icons.insert_drive_file_outlined
                      : attachmentIcon(item),
                  size: 13,
                  color: GmhColors.parchmentDim,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    item?.fileName ?? fallbackName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: broken
                          ? GmhColors.parchmentFaint
                          : GmhColors.parchment,
                      decoration: broken ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                if (item != null) ...[
                  const SizedBox(width: 4),
                  Text(formatBytes(item.sizeBytes),
                      style: TextStyle(
                          fontSize: 10.5, color: GmhColors.parchmentFaint)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
