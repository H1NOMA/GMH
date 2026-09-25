import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../domain/models/entity.dart';
import '../../attachments/attachment_utils.dart';
import '../../shell/ui_providers.dart';

/// The entry's cover square, editable in place: hovering reveals a pencil
/// overlay and clicking opens an image picker. The chosen image is imported
/// into the vault, attached to the entry's gallery and set as the cover, so
/// it also shows up in the attachments panel like any other image.
class EditableCoverSquare extends ConsumerStatefulWidget {
  final Entity entity;
  final double size;

  const EditableCoverSquare({super.key, required this.entity, this.size = 64});

  @override
  ConsumerState<EditableCoverSquare> createState() =>
      _EditableCoverSquareState();
}

class _EditableCoverSquareState extends ConsumerState<EditableCoverSquare> {
  bool _hovering = false;

  Future<void> _pickCover() async {
    final entity = widget.entity;
    final title = context.l10n.changeImage;
    final files =
        await pickImageFiles(dialogTitle: title, allowMultiple: false);
    final file = files.firstOrNull;
    if (file == null) return;
    if (!mounted) return;
    final media = ref.read(mediaRepositoryProvider);
    final entities = ref.read(entityServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final (:imported, :failed) =
        await importXFiles(media, worldId: entity.worldId, files: [file]);
    if (failed > 0) {
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.importFilesFailed(failed))));
    }
    final item = imported.firstOrNull;
    if (item == null) return;
    await media.addToGallery(entity.id, item.id);
    await entities.setCover(entity.id, item.id);
  }

  @override
  Widget build(BuildContext context) {
    final entity = widget.entity;
    final kind = entity.kind;
    final coverId = entity.coverMediaId;
    final path = coverId == null
        ? null
        : ref.watch(mediaPathProvider(coverId)).valueOrNull;
    final iconSize = widget.size * 0.47;

    return Tooltip(
      message: context.l10n.changeImage,
      waitDuration: const Duration(milliseconds: 600),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _pickCover,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: kind.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kind.color.withValues(alpha: 0.4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (path != null)
                  Image.file(File(path),
                      fit: BoxFit.cover,
                      cacheWidth: (widget.size * 3).round(),
                      errorBuilder: (_, _, _) => Icon(kind.icon,
                          color: kind.color, size: iconSize))
                else
                  Icon(kind.icon, color: kind.color, size: iconSize),
                // Hover affordance: darken and show the pencil.
                AnimatedOpacity(
                  opacity: _hovering ? 1 : 0,
                  duration: const Duration(milliseconds: 120),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.45),
                    child: Icon(Icons.edit_outlined,
                        color: Colors.white, size: iconSize * 0.75),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
