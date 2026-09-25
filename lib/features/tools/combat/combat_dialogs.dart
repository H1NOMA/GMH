import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/l10n_ext.dart';
import '../../../domain/combat/combatant.dart';
import '../../../domain/combat/creature_stats.dart';

final _intFormatter = FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'));
final _positiveFormatter = FilteringTextInputFormatter.digitsOnly;

/// Asks for a name (new encounter, rename). Null when cancelled or empty.
Future<String?> showCombatNameDialog(
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
            key: const ValueKey('combat-name-field'),
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(labelText: l.combatEncounterNameLabel),
            onSubmitted: (_) => Navigator.pop(context, true),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmLabel)),
        ],
      );
    },
  );
  final name = controller.text.trim();
  // The dialog can still rebuild during its exit transition — release the
  // controller only once the route is fully gone.
  dialogRoute?.completed.whenComplete(controller.dispose);
  if (confirmed != true || name.isEmpty) return null;
  return name;
}

Future<bool> confirmDeleteEncounter(BuildContext context, String name) async {
  final l = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.combatDeleteTitle(name)),
      content: SizedBox(width: 420, child: Text(l.combatDeleteBody)),
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

/// How many copies of [name] to add (1–20).
Future<int?> showQuantityDialog(BuildContext context, String name) {
  var quantity = 1;
  return showDialog<int>(
    context: context,
    builder: (context) {
      final l = context.l10n;
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.combatQuantityTitle(name),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          content: SizedBox(
            width: 320,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  key: const ValueKey('combat-quantity-minus'),
                  tooltip: '−1',
                  onPressed: quantity > 1
                      ? () => setDialogState(() => quantity--)
                      : null,
                  icon: const Icon(Icons.remove, size: 18),
                ),
                SizedBox(
                  width: 64,
                  child: Text('$quantity',
                      key: const ValueKey('combat-quantity-value'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
                IconButton.outlined(
                  key: const ValueKey('combat-quantity-plus'),
                  tooltip: '+1',
                  onPressed: quantity < 20
                      ? () => setDialogState(() => quantity++)
                      : null,
                  icon: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, quantity),
                child: Text(l.add)),
          ],
        ),
      );
    },
  );
}

/// A single number (party level, condition rounds). [allowEmpty] lets the
/// user confirm an empty field, returned as `(value: null)`.
Future<({int? value})?> showCombatNumberDialog(
  BuildContext context, {
  required String title,
  required String label,
  int? initial,
  bool allowEmpty = false,
  int min = 1,
  int max = 999,
}) async {
  final controller = TextEditingController(text: initial?.toString() ?? '');
  ModalRoute<Object?>? dialogRoute;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      final l = context.l10n;
      return AlertDialog(
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        content: SizedBox(
          width: 360,
          child: TextField(
            key: const ValueKey('combat-number-field'),
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [_positiveFormatter],
            decoration: InputDecoration(labelText: label),
            onSubmitted: (_) => Navigator.pop(context, true),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.save)),
        ],
      );
    },
  );
  final parsed = int.tryParse(controller.text.trim());
  dialogRoute?.completed.whenComplete(controller.dispose);
  if (confirmed != true) return null;
  if (parsed == null) return allowEmpty ? (value: null) : null;
  return (value: parsed.clamp(min, max));
}

/// Creates (when [initial] is null) or edits a combatant. The result keeps
/// [initial]'s identity; a new combatant starts at full hit points.
Future<Combatant?> showCombatantEditor(BuildContext context,
    {Combatant? initial}) async {
  final isNew = initial == null;
  final c = initial ?? const Combatant(name: '');
  String text(num? v) => v == null ? '' : '$v';
  final name = TextEditingController(text: c.name);
  final initiative = TextEditingController(text: text(c.initiative));
  final bonus = TextEditingController(
      text: isNew && c.initiativeBonus == 0 ? '' : '${c.initiativeBonus}');
  final ac = TextEditingController(text: text(c.ac));
  final hpMax = TextEditingController(text: c.hpMax == 0 ? '' : '${c.hpMax}');
  final hpCurrent = TextEditingController(text: '${c.hpCurrent}');
  final hpTemp = TextEditingController(text: c.hpTemp == 0 ? '' : '${c.hpTemp}');
  final cr = TextEditingController(text: c.cr);
  final xp = TextEditingController(text: c.xp == 0 ? '' : '${c.xp}');
  final notes = TextEditingController(text: c.notes);
  final controllers = [
    name, initiative, bonus, ac, hpMax, hpCurrent, hpTemp, cr, xp, notes,
  ];
  var isPlayer = c.isPlayer;
  ModalRoute<Object?>? dialogRoute;

  Widget numberField(TextEditingController controller, String label,
          {String? key, bool signed = false}) =>
      TextField(
        key: key == null ? null : ValueKey(key),
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(signed: signed),
        inputFormatters: [signed ? _intFormatter : _positiveFormatter],
        decoration: InputDecoration(labelText: label),
      );

  Widget pair(Widget a, Widget b) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ]),
      );

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      final l = context.l10n;
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isNew ? l.combatAddCombatant : l.combatEditCombatant),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const ValueKey('combatant-name'),
                    controller: name,
                    autofocus: true,
                    decoration: InputDecoration(labelText: l.nameLabel),
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isPlayer,
                    title: Text(l.combatPlayer,
                        style: const TextStyle(fontSize: 13.5)),
                    onChanged: (value) =>
                        setDialogState(() => isPlayer = value),
                  ),
                  pair(
                    numberField(initiative, l.combatInitiative,
                        key: 'combatant-initiative', signed: true),
                    numberField(bonus, l.combatInitiativeBonus,
                        key: 'combatant-bonus', signed: true),
                  ),
                  pair(
                    numberField(hpMax, l.combatHpMax, key: 'combatant-hp'),
                    numberField(ac, l.combatArmorClass, key: 'combatant-ac'),
                  ),
                  if (!isNew)
                    pair(
                      numberField(hpCurrent, l.combatHpCurrent,
                          key: 'combatant-hp-current'),
                      numberField(hpTemp, l.combatHpTemp),
                    ),
                  if (!isPlayer)
                    pair(
                      TextField(
                        key: const ValueKey('combatant-cr'),
                        controller: cr,
                        decoration:
                            InputDecoration(labelText: l.combatChallenge),
                        onChanged: (value) {
                          final auto = xpForChallenge(value);
                          if (auto != null) xp.text = '$auto';
                        },
                      ),
                      numberField(xp, l.combatXp, key: 'combatant-xp'),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notes,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(labelText: l.combatNotes),
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
                child: Text(isNew ? l.add : l.save)),
          ],
        ),
      );
    },
  );

  int? parse(TextEditingController controller) =>
      int.tryParse(controller.text.trim());
  final result = () {
    final trimmed = name.text.trim();
    if (confirmed != true || trimmed.isEmpty) return null;
    final max = (parse(hpMax) ?? 0).clamp(0, 1 << 30);
    final current = isNew ? max : (parse(hpCurrent) ?? 0).clamp(0, 1 << 30);
    final crText = cr.text.trim();
    return c.copyWith(
      name: trimmed,
      isPlayer: isPlayer,
      initiative: () => parse(initiative),
      initiativeBonus: parse(bonus) ?? 0,
      ac: () => parse(ac),
      hpMax: max,
      hpCurrent: max > 0 && current > max ? max : current,
      hpTemp: (parse(hpTemp) ?? 0).clamp(0, 1 << 30),
      cr: isPlayer ? '' : crText,
      xp: isPlayer ? 0 : parse(xp) ?? xpForChallenge(crText) ?? 0,
      notes: notes.text.trim(),
    );
  }();
  dialogRoute?.completed.whenComplete(() {
    for (final controller in controllers) {
      controller.dispose();
    }
  });
  return result;
}

/// Small pill used for statuses and difficulty ratings.
class CombatBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const CombatBadge(
      {super.key, required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ),
        ],
      ),
    );
  }
}
