import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/dice/dice_presets.dart';
import 'dice_l10n.dart';
import 'dice_widgets.dart';

/// Asks for the inputs of a system roll; returns the params for
/// [DicePresets.run], or null when cancelled.
Future<Map<String, Object?>?> showDicePresetDialog(
    BuildContext context, DicePresetKind kind) {
  return showDialog<Map<String, Object?>>(
    context: context,
    builder: (context) => _PresetDialog(kind: kind),
  );
}

class _PresetDialog extends StatefulWidget {
  final DicePresetKind kind;
  const _PresetDialog({required this.kind});

  @override
  State<_PresetDialog> createState() => _PresetDialogState();
}

class _PresetDialogState extends State<_PresetDialog> {
  // The controllers live in this State, which is only disposed once the
  // dialog route has finished its exit transition.
  final _skill = TextEditingController(text: '50');
  final _dc = TextEditingController();
  final _base = TextEditingController(text: '10');

  var _mode = D20Mode.normal;
  var _modifier = 0;
  var _bonus = 0;
  var _stat = 0;
  var _pool = 2;
  var _fateSkill = 2;
  var _traitDie = 6;
  var _wildDie = true;

  @override
  void dispose() {
    _skill.dispose();
    _dc.dispose();
    _base.dispose();
    super.dispose();
  }

  Map<String, Object?> get _params => switch (widget.kind) {
        DicePresetKind.d20Check => {
            'mode': _mode.name,
            'modifier': _modifier,
            'dc': int.tryParse(_dc.text.trim()),
          },
        DicePresetKind.abilityScore => const {},
        DicePresetKind.callOfCthulhu => {
            'skill': (int.tryParse(_skill.text.trim()) ?? 50).clamp(0, 200),
            'bonus': _bonus,
          },
        DicePresetKind.pbta => {'stat': _stat},
        DicePresetKind.blades => {'dice': _pool},
        DicePresetKind.fate => {'skill': _fateSkill},
        DicePresetKind.yearZero => {'dice': _pool},
        DicePresetKind.savageWorlds => {
            'traitDie': _traitDie,
            'modifier': _modifier,
            'wildDie': _wildDie,
          },
        DicePresetKind.cyberpunkRed => {
            'base': (int.tryParse(_base.text.trim()) ?? 0).clamp(-99, 99),
          },
      };

  void _submit() => Navigator.pop(context, _params);

  Widget _numberField(TextEditingController controller, String label) =>
      TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
        decoration: InputDecoration(labelText: label, isDense: true),
        onSubmitted: (_) => _submit(),
      );

  Widget _choices<T>(List<T> values, T selected, String Function(T) label,
          ValueChanged<T> onSelected) =>
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final v in values)
            ChoiceChip(
              label: Text(label(v)),
              selected: v == selected,
              onSelected: (_) => setState(() => onSelected(v)),
            ),
        ],
      );

  List<Widget> _fields(AppLocalizations l) {
    switch (widget.kind) {
      case DicePresetKind.d20Check:
        return [
          _choices<D20Mode>(
            D20Mode.values,
            _mode,
            (m) => switch (m) {
              D20Mode.normal => l.diceModeNormal,
              D20Mode.advantage => l.diceAdvantage,
              D20Mode.disadvantage => l.diceDisadvantage,
            },
            (m) => _mode = m,
          ),
          DiceStepper(
            label: l.diceModifier,
            value: _modifier,
            onChanged: (v) => setState(() => _modifier = v),
          ),
          _numberField(_dc, l.diceDc),
        ];
      case DicePresetKind.abilityScore:
        return const [];
      case DicePresetKind.callOfCthulhu:
        return [
          _numberField(_skill, l.diceSkill),
          DiceStepper(
            label: l.diceBonusDice,
            value: _bonus,
            min: -2,
            max: 2,
            onChanged: (v) => setState(() => _bonus = v),
          ),
        ];
      case DicePresetKind.pbta:
        return [
          DiceStepper(
            label: l.diceStat,
            value: _stat,
            min: -3,
            max: 6,
            onChanged: (v) => setState(() => _stat = v),
          ),
        ];
      case DicePresetKind.blades || DicePresetKind.yearZero:
        final blades = widget.kind == DicePresetKind.blades;
        return [
          DiceStepper(
            label: l.diceDicePool,
            value: _pool,
            min: blades ? 0 : 1,
            max: blades ? 10 : 30,
            signed: false,
            onChanged: (v) => setState(() => _pool = v),
          ),
        ];
      case DicePresetKind.fate:
        return [
          DiceStepper(
            label: l.diceSkill,
            value: _fateSkill,
            min: -2,
            max: 10,
            onChanged: (v) => setState(() => _fateSkill = v),
          ),
        ];
      case DicePresetKind.savageWorlds:
        return [
          Text(l.diceTraitDie,
              style: TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim)),
          _choices<int>(DicePresets.savageTraitDice, _traitDie, (s) => 'd$s',
              (s) => _traitDie = s),
          DiceStepper(
            label: l.diceModifier,
            value: _modifier,
            onChanged: (v) => setState(() => _modifier = v),
          ),
          // Without the switch's own side padding its track ends flush with
          // the dialog's content edge, like the actions below.
          Theme(
            data: Theme.of(context).copyWith(
              switchTheme: Theme.of(context)
                  .switchTheme
                  .copyWith(padding: EdgeInsets.zero),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.diceWildDie),
              value: _wildDie,
              onChanged: (v) => setState(() => _wildDie = v),
            ),
          ),
        ];
      case DicePresetKind.cyberpunkRed:
        return [_numberField(_base, l.diceStatSkill)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fields = _fields(l);
    return AlertDialog(
      title: Row(
        children: [
          Icon(dicePresetIcon(widget.kind), size: 20, color: GmhColors.ember),
          const SizedBox(width: 10),
          Expanded(
            child: Text(dicePresetName(l, widget.kind),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var k = 0; k < fields.length; k++) ...[
                if (k > 0) const SizedBox(height: 12),
                fields[k],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.casino_outlined, size: 18),
          label: Text(l.diceRollAction),
        ),
      ],
    );
  }
}
