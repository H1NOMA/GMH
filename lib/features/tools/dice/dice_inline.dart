import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/dice/dice_engine.dart';
import '../../../domain/dice/dice_history.dart';
import '../../../domain/dice/dice_text_scanner.dart';
import 'dice_providers.dart';
import 'quick_roll_dialog.dart';

/// Splits [text] into plain spans and tappable [DiceInlineChip]s for every
/// dice expression in it ("Hit: 2d6 + 3"). Rolls are logged to [worldId]'s
/// history when given.
List<InlineSpan> diceTextSpans(String text, {String? worldId}) {
  final matches = findDiceExpressions(text);
  if (matches.isEmpty) return [TextSpan(text: text)];
  final spans = <InlineSpan>[];
  var at = 0;
  for (final m in matches) {
    if (m.start > at) spans.add(TextSpan(text: text.substring(at, m.start)));
    spans.add(WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: DiceInlineChip(
        expression: m.expression,
        display: text.substring(m.start, m.end),
        worldId: worldId,
      ),
    ));
    at = m.end;
  }
  if (at < text.length) spans.add(TextSpan(text: text.substring(at)));
  return spans;
}

/// A dice expression inside text: tap rolls it and shows the result in a
/// SnackBar; long-press opens the quick roller with it.
class DiceInlineChip extends ConsumerWidget {
  final String expression;
  final String display;
  final String? worldId;

  const DiceInlineChip({
    super.key,
    required this.expression,
    required this.display,
    this.worldId,
  });

  void _roll(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final DiceRollResult roll;
    try {
      roll = DiceEngine(random: ref.read(diceRandomProvider)).roll(expression);
    } on DiceParseException {
      return;
    }
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(SnackBar(
      content: Text(
          '${l.diceRolledSnack(roll.expression, roll.total)}  ·  ${roll.breakdown}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis),
    ));
    final world = worldId;
    if (world != null) {
      logDiceRoll(ref, world, DiceHistoryEntry.fromRoll(roll));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = worldId;
    return Tooltip(
      message: context.l10n.diceRollTooltip(expression),
      child: Material(
        color: GmhColors.ember.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _roll(context, ref),
          onLongPress: world == null
              ? null
              : () => showQuickRollDialog(context,
                  worldId: world, initialExpression: expression),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.casino_outlined, size: 12, color: GmhColors.ember),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    display,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: GmhColors.ember,
                    ),
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
