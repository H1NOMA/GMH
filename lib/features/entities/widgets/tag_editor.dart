import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/entity.dart';
import '../../shell/ui_providers.dart';

/// Tag chips with add/remove for an entity.
class TagEditor extends ConsumerWidget {
  final Entity entity;

  const TagEditor({super.key, required this.entity});

  Future<void> _addTag(BuildContext context, WidgetRef ref) async {
    final existing =
        ref.read(worldTagsProvider(entity.worldId)).valueOrNull ?? [];
    final controller = TextEditingController();
    ModalRoute<Object?>? dialogRoute;
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        dialogRoute ??= ModalRoute.of(context);
        return AlertDialog(
          title: Text(context.l10n.addTagTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(hintText: context.l10n.tagNameHint),
                onSubmitted: (text) => Navigator.pop(context, text),
              ),
              if (existing.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in existing.take(16))
                      ActionChip(
                        label: Text(
                          tag.name,
                          style: TextStyle(
                            fontSize: 11.5,
                            // Raw stored colors are dark-tuned; adapt
                            // them so they keep contrast on light
                            // palettes.
                            color: adaptiveAccent(Color(tag.color)),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, tag.name),
                      ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(context.l10n.add),
            ),
          ],
        );
      },
    );
    // Release the controller only once the dialog route is fully gone.
    dialogRoute?.completed.whenComplete(controller.dispose);
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return;
    await ref
        .read(entityServiceProvider)
        .addTag(entity.id, entity.worldId, trimmed);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(entityTagsProvider(entity.id)).valueOrNull ?? [];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final tag in tags)
          Chip(
            label: Text(
              tag.name,
              style: TextStyle(
                fontSize: 11.5,
                color: adaptiveAccent(Color(tag.color)),
              ),
            ),
            side: BorderSide(
              color: adaptiveAccent(Color(tag.color)).withValues(alpha: 0.5),
            ),
            backgroundColor: adaptiveAccent(
              Color(tag.color),
            ).withValues(alpha: 0.12),
            visualDensity: VisualDensity.compact,
            onDeleted: () =>
                ref.read(entityServiceProvider).removeTag(entity.id, tag.id),
          ),
        ActionChip(
          avatar: Icon(Icons.add, size: 14, color: GmhColors.parchmentDim),
          label: Text(
            context.l10n.tagChip,
            style: const TextStyle(fontSize: 11.5),
          ),
          visualDensity: VisualDensity.compact,
          onPressed: () => _addTag(context, ref),
        ),
      ],
    );
  }
}
