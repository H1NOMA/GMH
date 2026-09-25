import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/dice/dice_engine.dart';
import '../../../domain/dice/dice_history.dart';
import '../../../domain/dice/dice_presets.dart';
import 'dice_l10n.dart';

/// A roll as the result card shows it.
class ShownRoll {
  final DiceRollResult roll;
  final String label;
  final DicePresetKind? preset;
  final DiceOutcome outcome;
  final Map<String, Object?> params;

  const ShownRoll(
    this.roll, {
    this.label = '',
    this.preset,
    this.outcome = DiceOutcome.none,
    this.params = const {},
  });

  ShownRoll.preset(PresetRoll p, {String label = ''})
    : this(
        p.roll,
        label: label,
        preset: p.kind,
        outcome: p.outcome,
        params: p.params,
      );

  DiceHistoryEntry toEntry() => preset == null
      ? DiceHistoryEntry.fromRoll(roll, label: label)
      : DiceHistoryEntry(
          expression: roll.expression,
          total: roll.total,
          breakdown: roll.breakdown,
          label: label.trim(),
          preset: preset,
          params: params,
          outcome: outcome,
        );
}

/// Big total, formula, verdict and one chip per die.
class DiceResultCard extends StatelessWidget {
  final ShownRoll? shown;

  /// Dice shown per term before collapsing into "+N more".
  final int maxDicePerTerm;

  const DiceResultCard({super.key, this.shown, this.maxDicePerTerm = 60});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final shown = this.shown;
    final decoration = BoxDecoration(
      color: GmhColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: GmhColors.ember.withValues(alpha: 0.35)),
    );
    if (shown == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: decoration,
        child: Column(
          children: [
            Icon(
              Icons.casino_outlined,
              size: 40,
              color: GmhColors.parchmentFaint,
            ),
            const SizedBox(height: 10),
            Text(
              l.diceResultEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: GmhColors.parchmentDim),
            ),
          ],
        ),
      );
    }

    final roll = shown.roll;
    final title = shown.label.isNotEmpty
        ? shown.label
        : shown.preset != null
        ? dicePresetName(l, shown.preset!)
        : null;
    final summary = diceSummaryText(
      l,
      preset: shown.preset,
      outcome: shown.outcome,
      total: roll.total,
    );
    final diceTerms = roll.terms.where((t) => t.dice.isNotEmpty).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 56, maxWidth: 180),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${roll.total}',
                    key: const ValueKey('dice-total'),
                    style: TextStyle(
                      fontSize: 48,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: GmhColors.ember,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    Text(
                      roll.expression,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: GmhColors.parchmentDim,
                      ),
                    ),
                    if (summary != null) ...[
                      const SizedBox(height: 6),
                      DiceVerdict(
                        text: summary,
                        color: shown.preset == DicePresetKind.fate
                            ? GmhColors.ember
                            : diceOutcomeColor(shown.outcome),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (diceTerms.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 8,
              children: [
                for (final term in diceTerms)
                  _TermDice(
                    term: term,
                    maxDice: maxDicePerTerm,
                    showNotation: diceTerms.length > 1 || term.label != null,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Text(
            roll.breakdown,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: GmhColors.parchmentFaint,
            ),
          ),
        ],
      ),
    );
  }
}

/// Colored pill with a system verdict ("Partial success", "Great"…).
class DiceVerdict extends StatelessWidget {
  final String text;
  final Color color;
  const DiceVerdict({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _TermDice extends StatelessWidget {
  final DiceTermResult term;
  final int maxDice;
  final bool showNotation;
  const _TermDice({
    required this.term,
    required this.maxDice,
    required this.showNotation,
  });

  @override
  Widget build(BuildContext context) {
    final fate = term.notation.contains('dF');
    final shown = term.dice.take(maxDice).toList();
    final hidden = term.dice.length - shown.length;
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (showNotation)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              term.label == null
                  ? term.notation
                  : '${term.notation} [${term.label}]',
              style: TextStyle(fontSize: 11.5, color: GmhColors.parchmentDim),
            ),
          ),
        for (final die in shown) DieChip(die: die, fate: fate),
        if (hidden > 0)
          Text(
            context.l10n.diceMoreDice(hidden),
            style: TextStyle(fontSize: 11.5, color: GmhColors.parchmentDim),
          ),
      ],
    );
  }
}

/// One die face: dropped dice are struck through and faded, natural maxima
/// use the accent, natural 1s the danger color, explosions get a spark.
class DieChip extends StatelessWidget {
  final RolledDie die;
  final bool fate;
  const DieChip({super.key, required this.die, this.fate = false});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final Color color;
    if (die.fumble || die.failure) {
      color = GmhColors.danger;
    } else if (die.critical) {
      color = GmhColors.ember;
    } else if (die.success) {
      color = GmhColors.success;
    } else {
      color = GmhColors.parchment;
    }
    final flagged = die.fumble || die.critical || die.success || die.failure;
    final text = fate
        ? (die.value > 0
              ? '+'
              : die.value < 0
              ? '−'
              : '0')
        : '${die.value}';
    final notes = [
      if (die.dropped) l.diceDropped,
      if (die.exploded) l.diceExploded,
      if (die.rerolled) l.diceRerolled,
    ];

    Widget chip = Container(
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: flagged ? color.withValues(alpha: 0.12) : GmhColors.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: flagged ? color.withValues(alpha: 0.55) : GmhColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: flagged ? FontWeight.w800 : FontWeight.w600,
              color: color,
              decoration: die.dropped ? TextDecoration.lineThrough : null,
              decorationColor: color,
            ),
          ),
          if (die.exploded) ...[
            const SizedBox(width: 2),
            Icon(Icons.auto_awesome, size: 11, color: GmhColors.ember),
          ],
          if (die.rerolled) ...[
            const SizedBox(width: 2),
            Icon(Icons.replay, size: 11, color: GmhColors.parchmentDim),
          ],
        ],
      ),
    );
    if (die.dropped) chip = Opacity(opacity: 0.45, child: chip);
    return notes.isEmpty
        ? chip
        : Tooltip(message: notes.join(' · '), child: chip);
  }
}

/// Compact − value + control.
class DiceStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final bool signed;
  final ValueChanged<int> onChanged;

  const DiceStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = -99,
    this.max = 99,
    this.signed = true,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = signed && value > 0 ? '+$value' : '$value';
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GmhColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: GmhColors.parchmentDim),
            ),
          ),
          IconButton(
            tooltip: l.diceDecrease,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove, size: 18),
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 30),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: l.diceIncrease,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 18),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
