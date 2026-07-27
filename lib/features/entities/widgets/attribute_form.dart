import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/template_l10n.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../core/utils/ids.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/entity_template.dart';
import '../../../domain/services/templates/entity_templates.dart';
import '../../shell/ui_providers.dart';
import 'entity_picker_dialog.dart';

/// Template-driven structured properties editor. Renders the entity kind's
/// [EntityTemplate] sections and writes changes through the entity service
/// (which mirrors entityRef fields into links and reindexes search).
class AttributeForm extends ConsumerWidget {
  final Entity entity;

  /// When set, only template sections with these titles are rendered —
  /// used by the tabbed character profile to split sections across tabs.
  final List<String>? sectionTitles;

  /// Replaces the kind's template sections entirely — used by custom
  /// sections whose fields come from the category's blueprint.
  final List<FieldSection>? sectionsOverride;

  const AttributeForm({
    super.key,
    required this.entity,
    this.sectionTitles,
    this.sectionsOverride,
  });

  Future<void> _setValue(
      WidgetRef ref, String key, Object? value) async {
    // Single-field write through the service, which re-reads the freshest
    // row: this widget's build-time snapshot must not roll back another
    // field committed a moment ago (e.g. via a dispose-commit).
    await ref
        .read(entityServiceProvider)
        .setAttribute(entity.id, key, value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = EntityTemplates.of(entity.kind);
    final sections = sectionsOverride ??
        (sectionTitles == null
            ? template.sections
            : [
                for (final s in template.sections)
                  if (sectionTitles!.contains(s.title)) s
              ]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final section in sections) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 14, 2, 8),
            child: Text(
              trTemplate(context, section.title).toUpperCase(),
              style: TextStyle(
                fontSize: 10.5,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                color: GmhColors.parchmentFaint,
              ),
            ),
          ),
          for (final field in section.fields)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _FieldEditor(
                key: ValueKey('${entity.id}:${field.key}'),
                entity: entity,
                field: field,
                onChanged: (value) => _setValue(ref, field.key, value),
              ),
            ),
        ],
      ],
    );
  }
}

class _FieldEditor extends ConsumerWidget {
  final Entity entity;
  final FieldDef field;
  final ValueChanged<Object?> onChanged;

  const _FieldEditor({
    super.key,
    required this.entity,
    required this.field,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = entity.attributes[field.key];
    switch (field.type) {
      case FieldType.text:
      case FieldType.date:
        return _TextValueField(
          label: trTemplate(context, field.label),
          hint: trTemplate(context, field.hint),
          initialValue: value?.toString() ?? '',
          onCommitted: onChanged,
        );
      case FieldType.longText:
        return _TextValueField(
          label: trTemplate(context, field.label),
          hint: trTemplate(context, field.hint),
          initialValue: value?.toString() ?? '',
          maxLines: 4,
          onCommitted: onChanged,
        );
      case FieldType.number:
        return _TextValueField(
          label: trTemplate(context, field.label),
          hint: trTemplate(context, field.hint),
          initialValue: value?.toString() ?? '',
          keyboardType: TextInputType.number,
          onCommitted: (text) =>
              onChanged(text.isEmpty ? null : num.tryParse(text)),
        );
      case FieldType.select:
        return DropdownButtonFormField<String>(
          value: field.options.contains(value) ? value as String : null,
          decoration: InputDecoration(
              labelText: trTemplate(context, field.label)),
          items: [
            const DropdownMenuItem<String>(
                value: '', child: Text('—', style: TextStyle(fontSize: 13))),
            for (final option in field.options)
              DropdownMenuItem(
                  value: option,
                  child: Text(trTemplate(context, option),
                      style: const TextStyle(fontSize: 13))),
          ],
          onChanged: (selected) =>
              onChanged(selected == null || selected.isEmpty ? null : selected),
        );
      case FieldType.stringList:
        return _StringListField(
          label: trTemplate(context, field.label),
          values: value is List ? value.map((v) => v.toString()).toList() : [],
          onChanged: onChanged,
        );
      case FieldType.checklist:
        return _ChecklistField(
          label: trTemplate(context, field.label),
          items: value is List
              ? [
                  for (final item in value)
                    if (item is Map)
                      (
                        text: item['text']?.toString() ?? '',
                        done: item['done'] == true
                      )
                ]
              : [],
          onChanged: onChanged,
        );
      case FieldType.entityRef:
        return _EntityRefField(
          worldId: entity.worldId,
          field: field,
          entityId: parseEntityRef(value),
          onChanged: onChanged,
        );
      case FieldType.entityRefList:
        return _EntityRefListField(
          worldId: entity.worldId,
          field: field,
          entityIds: value is List
              ? [
                  for (final v in value)
                    if (parseEntityRef(v) != null) parseEntityRef(v)!
                ]
              : [],
          onChanged: onChanged,
        );
    }
  }
}

// ------------------------------------------------------------ text fields

class _TextValueField extends StatefulWidget {
  final String label;
  final String hint;
  final String initialValue;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String> onCommitted;

  const _TextValueField({
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onCommitted,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  State<_TextValueField> createState() => _TextValueFieldState();
}

class _TextValueFieldState extends State<_TextValueField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Commit on focus loss — avoids a DB write per keystroke.
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus &&
          _controller.text.trim() != widget.initialValue) {
        widget.onCommitted(_controller.text.trim());
      }
    });
  }

  @override
  void dispose() {
    if (_controller.text.trim() != widget.initialValue) {
      widget.onCommitted(_controller.text.trim());
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 13.5),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint.isEmpty ? null : widget.hint,
      ),
      onSubmitted: widget.onCommitted,
    );
  }
}

// ------------------------------------------------------------ string list

class _StringListField extends StatelessWidget {
  final String label;
  final List<String> values;
  final ValueChanged<Object?> onChanged;

  const _StringListField({
    required this.label,
    required this.values,
    required this.onChanged,
  });

  Future<void> _add(BuildContext context) async {
    final controller = TextEditingController();
    ModalRoute<Object?>? dialogRoute;
    final added = await showDialog<String>(
      context: context,
      builder: (context) {
        dialogRoute ??= ModalRoute.of(context);
        return AlertDialog(
        title: Text(context.l10n.addToList(label)),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (text) => Navigator.pop(context, text),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(context.l10n.add)),
        ],
      );
      },
    );
    // Release the controller only once the dialog route is fully gone.
    dialogRoute?.completed.whenComplete(controller.dispose);
    final trimmed = added?.trim() ?? '';
    if (trimmed.isNotEmpty) onChanged([...values, trimmed]);
  }

  @override
  Widget build(BuildContext context) {
    return _LabeledGroup(
      label: label,
      trailing: IconButton(
        icon: const Icon(Icons.add, size: 17),
        visualDensity: VisualDensity.compact,
        onPressed: () => _add(context),
      ),
      child: values.isEmpty
          ? const _EmptyHint()
          : Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 0; i < values.length; i++)
                  Chip(
                    label: Text(values[i]),
                    onDeleted: () =>
                        onChanged([...values]..removeAt(i)),
                  ),
              ],
            ),
    );
  }
}

// -------------------------------------------------------------- checklist

typedef _CheckItem = ({String text, bool done});

class _ChecklistField extends StatelessWidget {
  final String label;
  final List<_CheckItem> items;
  final ValueChanged<Object?> onChanged;

  const _ChecklistField({
    required this.label,
    required this.items,
    required this.onChanged,
  });

  void _commit(List<_CheckItem> updated) {
    onChanged([
      for (final item in updated) {'text': item.text, 'done': item.done}
    ]);
  }

  Future<void> _add(BuildContext context) async {
    final controller = TextEditingController();
    ModalRoute<Object?>? dialogRoute;
    final added = await showDialog<String>(
      context: context,
      builder: (context) {
        dialogRoute ??= ModalRoute.of(context);
        return AlertDialog(
        title: Text(context.l10n.addToList(label)),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (text) => Navigator.pop(context, text),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(context.l10n.add)),
        ],
      );
      },
    );
    // Release the controller only once the dialog route is fully gone.
    dialogRoute?.completed.whenComplete(controller.dispose);
    final trimmed = added?.trim() ?? '';
    if (trimmed.isNotEmpty) _commit([...items, (text: trimmed, done: false)]);
  }

  @override
  Widget build(BuildContext context) {
    return _LabeledGroup(
      label: label,
      trailing: IconButton(
        icon: const Icon(Icons.add, size: 17),
        visualDensity: VisualDensity.compact,
        onPressed: () => _add(context),
      ),
      child: items.isEmpty
          ? const _EmptyHint()
          : Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  Row(
                    children: [
                      Checkbox(
                        value: items[i].done,
                        visualDensity: VisualDensity.compact,
                        onChanged: (checked) {
                          final updated = [...items];
                          updated[i] =
                              (text: items[i].text, done: checked ?? false);
                          _commit(updated);
                        },
                      ),
                      Expanded(
                        child: Text(
                          items[i].text,
                          style: TextStyle(
                            fontSize: 13,
                            decoration: items[i].done
                                ? TextDecoration.lineThrough
                                : null,
                            color: items[i].done
                                ? GmhColors.parchmentFaint
                                : GmhColors.parchment,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 14),
                        visualDensity: VisualDensity.compact,
                        onPressed: () =>
                            _commit([...items]..removeAt(i)),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}

// ------------------------------------------------------------- entity refs

class _EntityRefField extends ConsumerWidget {
  final String worldId;
  final FieldDef field;
  final String? entityId;
  final ValueChanged<Object?> onChanged;

  const _EntityRefField({
    required this.worldId,
    required this.field,
    required this.entityId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = entityId == null
        ? null
        : ref.watch(entityProvider(entityId!)).valueOrNull;
    return _LabeledGroup(
      label: trTemplate(context, field.label),
      trailing: entityId == null
          ? null
          : IconButton(
              icon: const Icon(Icons.close, size: 15),
              visualDensity: VisualDensity.compact,
              tooltip: context.l10n.clear,
              onPressed: () => onChanged(null),
            ),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          side: BorderSide(color: GmhColors.border),
        ),
        icon: Icon(
          target?.kind.icon ?? Icons.add_link,
          size: 16,
          color: target?.kind.color ?? GmhColors.parchmentDim,
        ),
        label: Text(
          target?.name ?? context.l10n.choose,
          style: TextStyle(
            fontSize: 13,
            color: target == null
                ? GmhColors.parchmentFaint
                : GmhColors.parchment,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () async {
          final picked = await showEntityPickerDialog(
            context,
            worldId: worldId,
            kinds: field.refKinds,
            title: trTemplate(context, field.label),
          );
          if (picked != null) onChanged(entityRefValue(picked.id));
        },
      ),
    );
  }
}

class _EntityRefListField extends ConsumerWidget {
  final String worldId;
  final FieldDef field;
  final List<String> entityIds;
  final ValueChanged<Object?> onChanged;

  const _EntityRefListField({
    required this.worldId,
    required this.field,
    required this.entityIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _LabeledGroup(
      label: trTemplate(context, field.label),
      trailing: IconButton(
        icon: const Icon(Icons.add, size: 17),
        visualDensity: VisualDensity.compact,
        onPressed: () async {
          final picked = await showEntityPickerDialog(
            context,
            worldId: worldId,
            kinds: field.refKinds,
            title: trTemplate(context, field.label),
          );
          if (picked != null && !entityIds.contains(picked.id)) {
            onChanged(
                [...entityIds, picked.id].map(entityRefValue).toList());
          }
        },
      ),
      child: entityIds.isEmpty
          ? const _EmptyHint()
          : Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final id in entityIds)
                  _EntityRefChip(
                    entityId: id,
                    onDeleted: () => onChanged(([...entityIds]..remove(id))
                        .map(entityRefValue)
                        .toList()),
                  ),
              ],
            ),
    );
  }
}

class _EntityRefChip extends ConsumerWidget {
  final String entityId;
  final VoidCallback onDeleted;

  const _EntityRefChip({required this.entityId, required this.onDeleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(entityProvider(entityId)).valueOrNull;
    return Chip(
      avatar: Icon(
        entity?.kind.icon ?? Icons.link,
        size: 14,
        color: entity?.kind.color ?? GmhColors.parchmentDim,
      ),
      label: Text(entity?.name ?? context.l10n.missingLink),
      onDeleted: onDeleted,
    );
  }
}

// ---------------------------------------------------------------- helpers

class _LabeledGroup extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final Widget child;

  const _LabeledGroup({
    required this.label,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 10),
      decoration: BoxDecoration(
        color: GmhColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GmhColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 11.5, color: GmhColors.parchmentDim)),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(context.l10n.none,
            style: TextStyle(
                fontSize: 12, color: GmhColors.parchmentFaint)),
      );
}
