import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../domain/dice/dice_engine.dart';
import 'dice_l10n.dart';
import 'dice_providers.dart';
import 'dice_widgets.dart';

/// A compact roller: type one expression, roll it as often as needed. Every
/// roll is logged to [worldId]'s history.
Future<void> showQuickRollDialog(BuildContext context,
    {required String worldId, String? initialExpression}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _QuickRollDialog(
        worldId: worldId, initialExpression: initialExpression ?? ''),
  );
}

class _QuickRollDialog extends ConsumerStatefulWidget {
  final String worldId;
  final String initialExpression;
  const _QuickRollDialog(
      {required this.worldId, required this.initialExpression});

  @override
  ConsumerState<_QuickRollDialog> createState() => _QuickRollDialogState();
}

class _QuickRollDialogState extends ConsumerState<_QuickRollDialog> {
  late final _controller = TextEditingController(text: widget.initialExpression);
  final _focus = FocusNode();
  DiceParseException? _error;
  ShownRoll? _shown;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _roll() {
    try {
      final roll = DiceEngine(random: ref.read(diceRandomProvider))
          .roll(_controller.text);
      final shown = ShownRoll(roll);
      setState(() {
        _shown = shown;
        _error = null;
      });
      logDiceRoll(ref, widget.worldId, shown.toEntry());
    } on DiceParseException catch (e) {
      setState(() => _error = e);
    }
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.diceQuickRollTitle),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const ValueKey('quick-roll-expression'),
                controller: _controller,
                focusNode: _focus,
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: l.diceExpressionLabel,
                  hintText: l.diceExpressionHint,
                  errorText: _error == null ? null : diceErrorText(l, _error!),
                  errorMaxLines: 2,
                  prefixIcon: const Icon(Icons.casino_outlined, size: 20),
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                onSubmitted: (_) => _roll(),
              ),
              if (_shown != null) ...[
                const SizedBox(height: 12),
                DiceResultCard(shown: _shown, maxDicePerTerm: 30),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.close)),
        FilledButton.icon(
          key: const ValueKey('quick-roll-roll'),
          onPressed: _roll,
          icon: const Icon(Icons.casino_outlined, size: 18),
          label: Text(l.diceRollAction),
        ),
      ],
    );
  }
}
