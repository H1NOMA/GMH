import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/category_blueprint.dart';
import '../../domain/models/custom_category.dart';
import '../../domain/models/entity_template.dart';
import 'category_ui.dart';

/// The section constructor: a full builder for custom sections. Pick name
/// and icon, then assemble the section from modules (document, gallery,
/// files, tags, relations, fields) and define its own structured fields —
/// everything chosen here is exactly what entries of the section will have.
Future<String?> showCategoryConstructor(
  BuildContext context,
  WidgetRef ref, {
  required String worldId,
  CustomCategory? existing,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 680),
        child: _CategoryConstructor(worldId: worldId, existing: existing),
      ),
    ),
  );
}

class _CategoryConstructor extends ConsumerStatefulWidget {
  final String worldId;
  final CustomCategory? existing;

  const _CategoryConstructor({required this.worldId, this.existing});

  @override
  ConsumerState<_CategoryConstructor> createState() =>
      _CategoryConstructorState();
}

class _CategoryConstructorState extends ConsumerState<_CategoryConstructor> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late String _icon = widget.existing?.icon ?? 'folder';
  late Set<CategoryModule> _modules = {
    ...(widget.existing?.blueprint ?? CategoryBlueprint.standard).modules
  };
  late List<BlueprintField> _fields = [
    ...(widget.existing?.blueprint ?? CategoryBlueprint.standard).fields
  ];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  (String, String) _moduleText(AppLocalizations l, CategoryModule module) {
    return switch (module) {
      CategoryModule.fields => (l.moduleFields, l.moduleFieldsHint),
      CategoryModule.document => (l.moduleDocument, l.moduleDocumentHint),
      CategoryModule.gallery => (l.moduleGallery, l.moduleGalleryHint),
      CategoryModule.attachments =>
        (l.moduleAttachments, l.moduleAttachmentsHint),
      CategoryModule.tags => (l.moduleTags, l.moduleTagsHint),
      CategoryModule.relations => (l.moduleRelations, l.moduleRelationsHint),
    };
  }

  IconData _moduleIcon(CategoryModule module) => switch (module) {
        CategoryModule.fields => Icons.list_alt_outlined,
        CategoryModule.document => Icons.article_outlined,
        CategoryModule.gallery => Icons.photo_library_outlined,
        CategoryModule.attachments => Icons.attach_file,
        CategoryModule.tags => Icons.sell_outlined,
        CategoryModule.relations => Icons.hub_outlined,
      };

  String _fieldTypeLabel(AppLocalizations l, FieldType type) =>
      switch (type) {
        FieldType.text => l.fieldTypeText,
        FieldType.longText => l.fieldTypeLongText,
        FieldType.number => l.fieldTypeNumber,
        FieldType.select => l.fieldTypeSelect,
        FieldType.date => l.fieldTypeDate,
        FieldType.checklist => l.fieldTypeChecklist,
        FieldType.stringList => l.fieldTypeStringList,
        _ => type.name,
      };

  Future<void> _addOrEditField({BlueprintField? existing, int? index}) async {
    final l = context.l10n;
    final label = TextEditingController(text: existing?.label ?? '');
    final options =
        TextEditingController(text: existing?.options.join(', ') ?? '');
    var type = existing?.type ?? FieldType.text;

    ModalRoute<Object?>? dialogRoute;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        dialogRoute ??= ModalRoute.of(context);
        return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? l.addField : l.editField),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: label,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l.fieldNameLabel),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<FieldType>(
                  value: type,
                  decoration: InputDecoration(labelText: l.fieldTypeLabel),
                  items: [
                    for (final t in blueprintFieldTypes)
                      DropdownMenuItem(
                          value: t, child: Text(_fieldTypeLabel(l, t))),
                  ],
                  onChanged: (t) =>
                      setDialogState(() => type = t ?? FieldType.text),
                ),
                if (type == FieldType.select) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: options,
                    decoration: InputDecoration(
                      labelText: l.fieldOptionsLabel,
                      hintText: l.fieldOptionsHint,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(existing == null ? l.addField : l.save)),
          ],
        ),
      );
      },
    );
    final labelText = label.text.trim();
    final optionsText = options.text;
    // Release the controllers only once the dialog route is fully gone.
    dialogRoute?.completed.whenComplete(() {
      label.dispose();
      options.dispose();
    });
    if (saved != true || labelText.isEmpty) return;

    final field = BlueprintField(
      key: existing?.key ?? 'f_${newId().substring(0, 8)}',
      label: labelText,
      type: type,
      options: type == FieldType.select
          ? optionsText
              .split(',')
              .map((o) => o.trim())
              .where((o) => o.isNotEmpty)
              .toList()
          : const [],
    );
    setState(() {
      if (index == null) {
        _fields = [..._fields, field];
      } else {
        _fields = [..._fields]..[index] = field;
      }
    });
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final blueprint =
        CategoryBlueprint(modules: _modules, fields: _fields);
    final repository = ref.read(categoryRepositoryProvider);
    String id;
    if (widget.existing == null) {
      final category = await repository.create(
          worldId: widget.worldId,
          name: name,
          icon: _icon,
          blueprint: blueprint);
      id = category.id;
    } else {
      await repository.update(widget.existing!
          .copyWith(name: name, icon: _icon, blueprint: blueprint));
      id = widget.existing!.id;
    }
    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 6),
          child: Row(
            children: [
              Icon(Icons.handyman_outlined,
                  color: GmhColors.ember, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    widget.existing == null
                        ? l.constructorTitleNew
                        : l.constructorTitleEdit,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 19),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            children: [
              TextField(
                controller: _name,
                autofocus: widget.existing == null,
                decoration: InputDecoration(
                    labelText: l.categoryNameLabel,
                    hintText: l.categoryNameHint),
              ),
              const SizedBox(height: 14),
              Text(l.chooseIcon,
                  style: TextStyle(
                      fontSize: 11.5, color: GmhColors.parchmentDim)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final entry in categoryIcons.entries)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => setState(() => _icon = entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: _icon == entry.key
                                  ? GmhColors.ember
                                  : GmhColors.border,
                              width: _icon == entry.key ? 1.6 : 1),
                          color: _icon == entry.key
                              ? GmhColors.ember.withValues(alpha: 0.12)
                              : null,
                        ),
                        child: Icon(entry.value,
                            size: 20,
                            color: _icon == entry.key
                                ? GmhColors.emberBright
                                : GmhColors.parchmentDim),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(l.constructorModules.toUpperCase(),
                  style: TextStyle(
                      fontSize: 10.5,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      color: GmhColors.parchmentFaint)),
              const SizedBox(height: 2),
              Text(l.constructorModulesHint,
                  style: TextStyle(
                      fontSize: 11.5, color: GmhColors.parchmentDim)),
              const SizedBox(height: 6),
              for (final module in CategoryModule.values)
                SwitchListTile(
                  value: _modules.contains(module),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 4),
                  secondary: Icon(_moduleIcon(module),
                      size: 20,
                      color: _modules.contains(module)
                          ? GmhColors.ember
                          : GmhColors.parchmentFaint),
                  title: Text(_moduleText(l, module).$1,
                      style: const TextStyle(fontSize: 13.5)),
                  subtitle: Text(_moduleText(l, module).$2,
                      style: TextStyle(
                          fontSize: 11,
                          color: GmhColors.parchmentFaint)),
                  onChanged: (on) => setState(() {
                    if (on) {
                      _modules = {..._modules, module};
                    } else if (_modules.length > 1) {
                      // An empty section would be a blank page.
                      _modules = {..._modules}..remove(module);
                    }
                  }),
                ),
              if (_modules.contains(CategoryModule.fields)) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(l.constructorFields.toUpperCase(),
                          style: TextStyle(
                              fontSize: 10.5,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w700,
                              color: GmhColors.parchmentFaint)),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(l.addField),
                      onPressed: () => _addOrEditField(),
                    ),
                  ],
                ),
                if (_fields.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(l.constructorFieldsEmpty,
                        style: TextStyle(
                            fontSize: 11.5,
                            color: GmhColors.parchmentFaint)),
                  )
                else
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final list = [..._fields];
                        list.insert(newIndex, list.removeAt(oldIndex));
                        _fields = list;
                      });
                    },
                    children: [
                      for (var i = 0; i < _fields.length; i++)
                        ListTile(
                          key: ValueKey(_fields[i].key),
                          contentPadding:
                              const EdgeInsets.only(left: 4, right: 0),
                          leading: ReorderableDelayedDragStartListener(
                            index: i,
                            child: Icon(Icons.drag_indicator,
                                size: 18,
                                color: GmhColors.parchmentFaint),
                          ),
                          title: Text(_fields[i].label,
                              style: const TextStyle(fontSize: 13)),
                          subtitle: Text(
                            _fieldTypeLabel(l, _fields[i].type) +
                                (_fields[i].options.isEmpty
                                    ? ''
                                    : ' · ${_fields[i].options.join(", ")}'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11,
                                color: GmhColors.parchmentFaint),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit_outlined, size: 16),
                                onPressed: () => _addOrEditField(
                                    existing: _fields[i], index: i),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline,
                                    size: 16, color: GmhColors.danger),
                                onPressed: () => setState(() =>
                                    _fields = [..._fields]..removeAt(i)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l.cancel)),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _save,
                child: Text(
                    widget.existing == null ? l.create : l.save),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
