import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models/media_item.dart';
import 'attachment_utils.dart';

/// Full-screen swipeable image viewer with pinch/scroll zoom.
Future<void> showImageViewer(
  BuildContext context, {
  required List<MediaItem> images,
  required int initialIndex,
  Map<String, String> captions = const {},
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      pageBuilder: (context, animation, secondary) => FadeTransition(
        opacity: animation,
        child: _ImageViewer(
          images: images,
          initialIndex: initialIndex,
          captions: captions,
        ),
      ),
    ),
  );
}

class _ImageViewer extends ConsumerStatefulWidget {
  final List<MediaItem> images;
  final int initialIndex;
  final Map<String, String> captions;

  const _ImageViewer({
    required this.images,
    required this.initialIndex,
    required this.captions,
  });

  @override
  ConsumerState<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends ConsumerState<_ImageViewer> {
  late final PageController _pageController = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.images[_index];
    final caption = widget.captions[current.id] ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      // The backdrop is always near-black regardless of app theme, so
      // every piece of chrome here uses fixed light ink — theme colors
      // would turn invisible on the light palettes.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          current.fileName,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${_index + 1}/${widget.images.length}   '
                '${formatBytes(current.sizeBytes)}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _index = index),
              itemBuilder: (context, index) {
                final item = widget.images[index];
                return FutureBuilder<String>(
                  future: ref.read(mediaRepositoryProvider).absolutePath(item),
                  builder: (context, snapshot) {
                    final path = snapshot.data;
                    if (path == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 6,
                      child: Center(
                        child: Image.file(
                          File(path),
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (caption.isNotEmpty)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
