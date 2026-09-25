import 'package:flutter/material.dart';

import '../../app/l10n_ext.dart';
import '../../domain/models/world.dart';
import 'style_picker.dart';

/// Result of the world editor dialog.
class WorldDraft {
  final String name;
  final String description;
  final WorldStyle style;

  /// New worlds only: seed example content (see StarterKit).
  final bool starterContent;
  const WorldDraft(this.name, this.description, this.style,
      {this.starterContent = false});
}

/// Create (when [initial] is null) or edit a world: name, description and
/// setting pack. Returns null when cancelled or when the name is empty.
Future<WorldDraft?> showWorldEditor(BuildContext context,
    {World? initial}) async {
  final nameController = TextEditingController(text: initial?.name ?? '');
  final descriptionController =
      TextEditingController(text: initial?.description ?? '');
  var style = initial?.style ?? WorldStyle.fantasy;
  var starter = true;
  ModalRoute<Object?>? dialogRoute;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      final l = context.l10n;
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(initial == null ? l.createWorldTitle : l.editWorldTitle),
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: l.worldNameLabel,
                        hintText: l.worldNameHint),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration:
                        InputDecoration(labelText: l.worldDescriptionLabel),
                  ),
                  if (initial == null)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: starter,
                      onChanged: (v) => setDialogState(() => starter = v),
                      title: Text(l.starterContentTitle),
                      subtitle: Text(l.starterContentHint,
                          style: const TextStyle(fontSize: 12)),
                    ),
                  const SizedBox(height: 16),
                  Text(l.worldStyleLabel,
                      style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  StylePickerGrid(
                    selected: style,
                    onChanged: (value) => setDialogState(() => style = value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(initial == null ? l.create : l.save)),
          ],
        ),
      );
    },
  );
  final name = nameController.text.trim();
  final description = descriptionController.text.trim();
  // The dialog can still rebuild during its exit transition — release the
  // controllers only once the route is fully gone.
  dialogRoute?.completed.whenComplete(() {
    nameController.dispose();
    descriptionController.dispose();
  });
  if (confirmed != true || name.isEmpty) return null;
  return WorldDraft(name, description, style,
      starterContent: initial == null && starter);
}

/// Confirms permanent deletion of a world.
Future<bool> confirmDeleteWorld(BuildContext context, World world) async {
  final l = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.deleteWorldTitle(world.name)),
      content: SizedBox(width: 420, child: Text(l.deleteWorldBody)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return result == true;
}
