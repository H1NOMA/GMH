import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../domain/models/media_item.dart';
import '../../domain/repositories/repositories.dart';

/// Raster images Flutter can decode. SVG is excluded: Image.file can't
/// render it, so vector maps travel as file attachments instead.
bool isImageMime(String mime) =>
    mime.startsWith('image/') && mime != 'image/svg+xml';

bool isTextLikeMime(String mime, String fileName) {
  if (mime.startsWith('text/')) return true;
  final lower = fileName.toLowerCase();
  return lower.endsWith('.md') ||
      lower.endsWith('.txt') ||
      lower.endsWith('.json') ||
      lower.endsWith('.csv') ||
      lower.endsWith('.log') ||
      lower.endsWith('.yaml') ||
      lower.endsWith('.yml');
}

IconData attachmentIcon(MediaItem item) {
  final mime = item.mimeType;
  if (isImageMime(mime)) return Icons.image_outlined;
  if (mime.startsWith('audio/')) return Icons.audiotrack_outlined;
  if (mime.startsWith('video/')) return Icons.videocam_outlined;
  if (mime == 'application/pdf') return Icons.picture_as_pdf_outlined;
  if (isTextLikeMime(mime, item.fileName)) return Icons.description_outlined;
  final lower = item.fileName.toLowerCase();
  if (lower.endsWith('.zip') ||
      lower.endsWith('.7z') ||
      lower.endsWith('.rar') ||
      lower.endsWith('.gmhw')) {
    return Icons.folder_zip_outlined;
  }
  if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
    return Icons.article_outlined;
  }
  return Icons.insert_drive_file_outlined;
}

String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

/// Short uppercase type tag shown next to the size ("PNG", "PDF"…).
String fileTypeTag(MediaItem item) {
  final dot = item.fileName.lastIndexOf('.');
  if (dot > 0 && dot < item.fileName.length - 1) {
    return item.fileName.substring(dot + 1).toUpperCase();
  }
  return item.mimeType.split('/').last.toUpperCase();
}

/// Result of importing several files: what made it into the vault, and
/// how many could not be read or stored (a locked file, a full disk).
typedef ImportOutcome = ({List<MediaItem> imported, int failed});

/// Imports picked/dropped files into the vault. One unreadable file does
/// not abort the batch; failures are counted for the caller to report.
Future<ImportOutcome> importXFiles(
  MediaRepository media, {
  required String worldId,
  required List<XFile> files,
}) async {
  final imported = <MediaItem>[];
  var failed = 0;
  for (final file in files) {
    try {
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) continue;
      imported.add(await media.import(
          worldId: worldId, fileName: file.name, bytes: bytes));
    } catch (_) {
      failed++;
    }
  }
  return (imported: imported, failed: failed);
}

/// Opens the platform file picker (all file types, multiple).
Future<List<XFile>> pickAnyFiles({String? dialogTitle}) async {
  final picked = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.any,
    dialogTitle: dialogTitle,
    withData: false,
  );
  if (picked == null) return [];
  return [
    for (final f in picked.files)
      if (f.path != null)
        XFile(f.path!, name: f.name)
      else if (f.bytes != null)
        XFile.fromData(f.bytes!, name: f.name)
  ];
}

/// Opens the platform file picker restricted to images.
Future<List<XFile>> pickImageFiles(
    {String? dialogTitle, bool allowMultiple = true}) async {
  final picked = await FilePicker.platform.pickFiles(
    allowMultiple: allowMultiple,
    type: FileType.image,
    dialogTitle: dialogTitle,
    withData: false,
  );
  if (picked == null) return [];
  return [
    for (final f in picked.files)
      if (f.path != null)
        XFile(f.path!, name: f.name)
      else if (f.bytes != null)
        XFile.fromData(f.bytes!, name: f.name)
  ];
}

/// Opens the OS photo gallery picker (mobile).
Future<List<XFile>> pickFromPhotoGallery() async {
  if (!(Platform.isAndroid || Platform.isIOS)) return [];
  return ImagePicker().pickMultiImage(limit: 20);
}

bool get supportsPhotoGallery => Platform.isAndroid || Platform.isIOS;

/// Opens an attachment with the OS default application.
Future<bool> openAttachmentExternally(WidgetRef ref, MediaItem item) async {
  final path = await ref.read(mediaRepositoryProvider).absolutePath(item);
  final uri = Uri.file(path);
  try {
    return await launchUrl(uri);
  } catch (_) {
    return false;
  }
}
