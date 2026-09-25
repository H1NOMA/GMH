import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/maps/game_map.dart';
import '../../../domain/maps/map_geometry.dart';
import '../../../domain/maps/map_pin.dart';
import '../../../domain/models/entity.dart';
import '../../categories/category_ui.dart';
import '../../entities/widgets/entity_picker_dialog.dart';
import 'maps_style.dart';

final _numberFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d{0,7}([.,]\d{0,4})?'),
);

/// Asks for a map name. Null when cancelled or empty.
Future<String?> showMapNameDialog(
  BuildContext context, {
  required String title,
  required String initial,
  required String confirmLabel,
}) async {
  final controller = TextEditingController(text: initial)
    ..selection = TextSelection(baseOffset: 0, extentOffset: initial.length);
  ModalRoute<Object?>? dialogRoute;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      final l = context.l10n;
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 420,
          child: TextField(
            key: const ValueKey('maps-name-field'),
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(labelText: l.nameLabel),
            onSubmitted: (_) => Navigator.pop(context, true),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            key: const ValueKey('maps-name-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  final name = controller.text.trim();
  dialogRoute?.completed.whenComplete(controller.dispose);
  if (confirmed != true || name.isEmpty) return null;
  return name;
}

Future<bool> confirmDeleteMap(BuildContext context, String name) async {
  final l = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        l.mapsDeleteTitle(name),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(width: 420, child: Text(l.mapsDeleteBody)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const ValueKey('maps-delete-confirm'),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return result == true;
}

num? _parsePositive(String text) {
  final value = num.tryParse(text.trim().replaceAll(',', '.'));
  return value != null && value.isFinite && value > 0 ? value : null;
}

String _numText(num? value) {
  if (value == null) return '';
  return value == value.roundToDouble()
      ? value.round().toString()
      : formatDistance(value.toDouble());
}

/// Name, description and scale of [initial]. Null when cancelled.
Future<GameMap?> showMapDetailsDialog(
  BuildContext context, {
  required GameMap initial,
}) async {
  final name = TextEditingController(text: initial.name);
  final description = TextEditingController(text: initial.description);
  final units = TextEditingController(
    text: _numText(initial.scale?.unitsPerCell),
  );
  final unitName = TextEditingController(text: initial.scale?.unitName ?? '');
  final cellPx = TextEditingController(text: _numText(initial.scale?.cellPx));
  final controllers = [name, description, units, unitName, cellPx];
  ModalRoute<Object?>? dialogRoute;

  bool scaleEmpty() => units.text.trim().isEmpty && cellPx.text.trim().isEmpty;
  bool scaleValid() =>
      scaleEmpty() ||
      (_parsePositive(units.text) != null && _parsePositive(cellPx.text) != null);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      final l = context.l10n;
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final ok = scaleValid() && name.text.trim().isNotEmpty;
          Widget number(TextEditingController c, String key, String label) =>
              TextField(
                key: ValueKey(key),
                controller: c,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [_numberFormatter],
                decoration: InputDecoration(labelText: label, isDense: true),
                onChanged: (_) => setDialogState(() {}),
              );
          return AlertDialog(
            title: Text(l.mapsDetailsTitle),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      key: const ValueKey('maps-details-name'),
                      controller: name,
                      decoration: InputDecoration(labelText: l.nameLabel),
                      onChanged: (_) => setDialogState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('maps-details-description'),
                      controller: description,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: l.mapsDescription,
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l.mapsScale, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      l.mapsScaleHelp,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: GmhColors.parchmentDim,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: 130,
                          child: number(units, 'maps-scale-units', l.mapsUnitsPerCell),
                        ),
                        SizedBox(
                          width: 130,
                          child: TextField(
                            key: const ValueKey('maps-scale-unit-name'),
                            controller: unitName,
                            decoration: InputDecoration(
                              labelText: l.mapsUnitName,
                              hintText: l.mapsUnitHint,
                              isDense: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: number(cellPx, 'maps-scale-cell', l.mapsCellPx),
                        ),
                      ],
                    ),
                    if (!scaleValid()) ...[
                      const SizedBox(height: 8),
                      Text(
                        l.mapsScaleInvalid,
                        style: TextStyle(fontSize: 12.5, color: GmhColors.danger),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel),
              ),
              FilledButton(
                key: const ValueKey('maps-details-save'),
                onPressed: ok ? () => Navigator.pop(context, true) : null,
                child: Text(l.save),
              ),
            ],
          );
        },
      );
    },
  );
  GameMap? result;
  if (confirmed == true && name.text.trim().isNotEmpty && scaleValid()) {
    final u = _parsePositive(units.text);
    final px = _parsePositive(cellPx.text);
    result = initial.copyWith(
      name: name.text.trim(),
      description: description.text.trim(),
      scale: () => u == null || px == null
          ? null
          : MapScale(
              unitsPerCell: u,
              unitName: unitName.text.trim(),
              cellPx: px,
            ),
    );
  }
  dialogRoute?.completed.whenComplete(() {
    for (final c in controllers) {
      c.dispose();
    }
  });
  return result;
}

/// What the pin editor asks the page to do.
enum PinEditorAction { save, delete, openEntry }

typedef PinEditorResult = ({PinEditorAction action, MapPin pin});

/// Label, symbol, color, linked entry, notes and visibility of a pin.
Future<PinEditorResult?> showPinEditor(
  BuildContext context, {
  required String worldId,
  required MapPin initial,
  required bool isNew,
  Entity? entity,
}) {
  return showDialog<PinEditorResult>(
    context: context,
    builder: (context) => _PinEditorDialog(
      worldId: worldId,
      initial: initial,
      isNew: isNew,
      entity: entity,
    ),
  );
}

class _PinEditorDialog extends ConsumerStatefulWidget {
  final String worldId;
  final MapPin initial;
  final bool isNew;
  final Entity? entity;

  const _PinEditorDialog({
    required this.worldId,
    required this.initial,
    required this.isNew,
    this.entity,
  });

  @override
  ConsumerState<_PinEditorDialog> createState() => _PinEditorDialogState();
}

class _PinEditorDialogState extends ConsumerState<_PinEditorDialog> {
  late final _label = TextEditingController(text: widget.initial.label);
  late final _notes = TextEditingController(text: widget.initial.notes);
  late MapPinIcon _icon = widget.initial.icon;
  late MapPinColor _color = widget.initial.color;
  late bool _gmOnly = widget.initial.gmOnly;
  late String? _entityId = widget.initial.entityId;
  late Entity? _entity = widget.entity;

  @override
  void dispose() {
    _label.dispose();
    _notes.dispose();
    super.dispose();
  }

  MapPin _result() => widget.initial.copyWith(
    label: _label.text.trim(),
    notes: _notes.text.trim(),
    icon: _icon,
    color: _color,
    gmOnly: _gmOnly,
    entityId: () => _entityId,
  );

  void _finish(PinEditorAction action) =>
      Navigator.pop(context, (action: action, pin: _result()));

  Future<void> _pickEntity() async {
    final picked = await showEntityPickerDialog(
      context,
      worldId: widget.worldId,
      title: context.l10n.mapsLinkEntry,
    );
    if (picked == null || !mounted) return;
    setState(() {
      // A label that only repeated the old entry's name follows the new one.
      if (_label.text.trim() == _entity?.name) _label.clear();
      _entity = picked;
      _entityId = picked.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final categories = ref.watch(categoryMapProvider(widget.worldId));
    final entity = _entity;
    final linkedColor = entity == null ? null : entityColor(entity, categories);
    final color = pinColor(_color, entityColor: linkedColor);

    Widget section(String title) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );

    return AlertDialog(
      title: Text(widget.isNew ? l.mapsNewPin : l.mapsEditPin),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const ValueKey('maps-pin-label'),
                controller: _label,
                autofocus: widget.isNew,
                decoration: InputDecoration(
                  labelText: l.mapsPinLabel,
                  hintText: entity?.name,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PinBadge(icon: _icon, color: color, size: 26),
                  ),
                ),
                onSubmitted: (_) => _finish(PinEditorAction.save),
              ),
              section(l.mapsLinkedEntry),
              _EntityRow(
                entity: entity,
                missing: _entityId != null && entity == null,
                color: linkedColor,
                icon: entity == null ? null : entityIcon(entity, categories),
                onPick: _pickEntity,
                onUnlink: () => setState(() {
                  if (_label.text.trim() == _entity?.name) _label.clear();
                  _entity = null;
                  _entityId = null;
                }),
                onOpen: entity == null
                    ? null
                    : () => _finish(PinEditorAction.openEntry),
              ),
              section(l.mapsPinIcon),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final icon in MapPinIcon.values)
                    _Choice(
                      key: ValueKey('maps-icon-${icon.key}'),
                      tooltip: pinIconLabel(l, icon),
                      selected: icon == _icon,
                      onTap: () => setState(() => _icon = icon),
                      child: Icon(
                        pinIconData(icon),
                        size: 20,
                        color: icon == _icon ? color : GmhColors.parchmentDim,
                      ),
                    ),
                ],
              ),
              section(l.mapsPinColor),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final c in MapPinColor.values)
                    _Choice(
                      key: ValueKey('maps-color-${c.key}'),
                      tooltip: pinColorLabel(l, c),
                      selected: c == _color,
                      round: true,
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: pinColor(c, entityColor: linkedColor),
                          shape: BoxShape.circle,
                        ),
                        child: c == MapPinColor.auto
                            ? Icon(
                                Icons.auto_awesome,
                                size: 13,
                                color: readableOn(
                                  pinColor(c, entityColor: linkedColor),
                                ),
                              )
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('maps-pin-notes'),
                controller: _notes,
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: l.mapsPinNotes,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                key: const ValueKey('maps-pin-gm-only'),
                contentPadding: EdgeInsets.zero,
                value: _gmOnly,
                onChanged: (v) => setState(() => _gmOnly = v),
                title: Text(l.mapsPinGmOnly),
                subtitle: Text(l.mapsPinGmOnlyHint),
                secondary: const Icon(Icons.visibility_off_outlined),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (!widget.isNew)
          TextButton(
            key: const ValueKey('maps-pin-delete'),
            style: TextButton.styleFrom(foregroundColor: GmhColors.danger),
            onPressed: () => _finish(PinEditorAction.delete),
            child: Text(l.mapsDeletePin),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const ValueKey('maps-pin-save'),
          onPressed: () => _finish(PinEditorAction.save),
          child: Text(widget.isNew ? l.create : l.save),
        ),
      ],
    );
  }
}

class _EntityRow extends StatelessWidget {
  final Entity? entity;
  final bool missing;
  final Color? color;
  final IconData? icon;
  final VoidCallback onPick;
  final VoidCallback onUnlink;
  final VoidCallback? onOpen;

  const _EntityRow({
    required this.entity,
    required this.missing,
    required this.color,
    required this.icon,
    required this.onPick,
    required this.onUnlink,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final e = entity;
    if (e == null && !missing) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: OutlinedButton.icon(
          key: const ValueKey('maps-pin-link'),
          onPressed: onPick,
          icon: const Icon(Icons.link, size: 18),
          label: Text(l.mapsLinkEntry),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 4, 6),
      decoration: BoxDecoration(
        color: GmhColors.surfaceHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GmhColors.border),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  e == null ? Icons.link_off : icon,
                  size: 18,
                  color: e == null ? GmhColors.danger : color,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    e?.name ?? l.mapsEntryMissing,
                    key: const ValueKey('maps-pin-entity-name'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: e == null ? GmhColors.danger : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onOpen != null)
            TextButton.icon(
              key: const ValueKey('maps-pin-open-entry'),
              onPressed: onOpen,
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text(l.mapsOpenEntry),
            ),
          TextButton(
            key: const ValueKey('maps-pin-change-entry'),
            onPressed: onPick,
            child: Text(l.mapsChangeEntry),
          ),
          TextButton(
            key: const ValueKey('maps-pin-unlink'),
            onPressed: onUnlink,
            child: Text(l.mapsUnlink),
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  final String tooltip;
  final bool selected;
  final bool round;
  final VoidCallback onTap;
  final Widget child;

  const _Choice({
    super.key,
    required this.tooltip,
    required this.selected,
    required this.onTap,
    required this.child,
    this.round = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(round ? 20 : 8);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected
            ? GmhColors.ember.withValues(alpha: 0.14)
            : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: selected ? GmhColors.ember : GmhColors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
