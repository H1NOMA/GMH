import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';

/// Value prefix for vault-backed images inside documents. Storing the media
/// id (not an absolute path) keeps documents portable across devices.
const mediaImagePrefix = 'media:';

void insertVaultImage(QuillController controller, String mediaId) {
  // selection.start/end, not base/extent: a right-to-left selection has
  // extent < base, which would produce a negative replace length.
  final index = controller.selection.start;
  final length = controller.selection.end - index;
  controller.replaceText(
    index,
    length,
    BlockEmbed.image('$mediaImagePrefix$mediaId'),
    TextSelection.collapsed(offset: index + 1),
  );
}

/// Renders standard Quill `image` embeds, resolving `media:` ids through the
/// vault and falling back to plain file paths.
class VaultImageEmbedBuilder extends EmbedBuilder {
  VaultImageEmbedBuilder();

  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final value = embedContext.node.value.data;
    final source = value is String ? value : '';
    return _VaultImage(source: source);
  }
}

class _VaultImage extends ConsumerStatefulWidget {
  final String source;
  const _VaultImage({required this.source});

  @override
  ConsumerState<_VaultImage> createState() => _VaultImageState();
}

class _VaultImageState extends ConsumerState<_VaultImage> {
  // Cached in state: a fresh future per build would collapse the image to
  // a spinner on every keystroke (the editor rebuilds its embeds often).
  late Future<String?> _path = _resolvePath();

  @override
  void didUpdateWidget(covariant _VaultImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      _path = _resolvePath();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _path,
      builder: (context, snapshot) {
        final path = snapshot.data;
        if (path == null) {
          return Container(
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: GmhColors.surfaceHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: snapshot.connectionState == ConnectionState.waiting
                ? const SizedBox(
                    width: 22, height: 22, child: CircularProgressIndicator())
                : Icon(Icons.broken_image_outlined,
                    color: GmhColors.parchmentFaint),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: Image.file(
              File(path),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                  Icons.broken_image_outlined,
                  color: GmhColors.parchmentFaint),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _resolvePath() async {
    final source = widget.source;
    if (source.startsWith(mediaImagePrefix)) {
      final mediaId = source.substring(mediaImagePrefix.length);
      final media = await ref.read(mediaRepositoryProvider).get(mediaId);
      if (media == null) return null;
      return ref.read(mediaRepositoryProvider).absolutePath(media);
    }
    if (source.isEmpty) return null;
    return source;
  }
}
