import 'package:flutter/foundation.dart';

/// Metadata for a file in the media vault. The bytes live on disk at
/// `{worldsDir}/{worldId}/media/{relativePath}` (content-addressed by hash,
/// so identical files are stored once).
@immutable
class MediaItem {
  final String id;
  final String worldId;
  final String fileName;
  final String relativePath;
  final String mimeType;
  final int sizeBytes;
  final int createdAt;

  const MediaItem({
    required this.id,
    required this.worldId,
    required this.fileName,
    required this.relativePath,
    required this.mimeType,
    required this.sizeBytes,
    required this.createdAt,
  });
}

/// One image in an entity's ordered gallery.
@immutable
class GalleryEntry {
  final MediaItem media;
  final int sortOrder;
  final String caption;

  const GalleryEntry({
    required this.media,
    required this.sortOrder,
    this.caption = '',
  });
}
