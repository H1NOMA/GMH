import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/combat/combatant.dart';
import '../../../domain/combat/difficulty.dart';
import '../../../domain/combat/encounter.dart';
import 'combat_actions.dart';
import 'combat_dialogs.dart';

String difficultyLabel(AppLocalizations l, DifficultyRating rating) =>
    switch (rating) {
      DifficultyRating.trivial => l.combatRatingTrivial,
      DifficultyRating.low => l.combatRatingLow,
      DifficultyRating.moderate => l.combatRatingModerate,
      DifficultyRating.high => l.combatRatingHigh,
      DifficultyRating.beyondHigh => l.combatRatingBeyondHigh,
      DifficultyRating.easy => l.combatRatingEasy,
      DifficultyRating.medium => l.combatRatingMedium,
      DifficultyRating.hard => l.combatRatingHard,
      DifficultyRating.deadly => l.combatRatingDeadly,
    };

Color difficultyColor(DifficultyRating rating) => switch (rating.tier) {
      0 => GmhColors.parchmentDim,
      1 => GmhColors.success,
      2 => GmhColors.arcane,
      3 => GmhColors.ember,
      _ => GmhColors.danger,
    };

String formatXp(BuildContext context, int xp) =>
    NumberFormat.decimalPattern(Localizations.localeOf(context).languageCode)
        .format(xp);

/// The rating as a colored pill; nothing when the encounter cannot be
/// rated yet (no party or no monsters).
class DifficultyBadge extends StatelessWidget {
  final DifficultyResult result;
  const DifficultyBadge({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final rating = result.rating;
    if (rating == null) return const SizedBox.shrink();
    return CombatBadge(
      label: difficultyLabel(context.l10n, rating),
      color: difficultyColor(rating),
      icon: Icons.local_fire_department_outlined,
    );
  }
}

/// Party levels, rules version, XP totals and the resulting rating.
class DifficultyPanel extends ConsumerWidget {
  final Encounter encounter;
  final List<Combatant> combatants;

  const DifficultyPanel(
      {super.key, required this.encounter, required this.combatants});

  Future<void> _addLevel(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final result = await showCombatNumberDialog(context,
        title: l.combatPartyLevels,
        label: l.combatLevelLabel,
        initial: encounter.partyLevels.isEmpty
            ? null
            : encounter.partyLevels.last,
        max: 20);
    final level = result?.value;
    if (level == null || !context.mounted) return;
    await ref.read(combatActionsProvider).saveEncounter(
        encounter.copyWith(partyLevels: [...encounter.partyLevels, level]));
  }

  Future<void> _editLevel(BuildContext context, WidgetRef ref, int index) async {
    final l = context.l10n;
    final result = await showCombatNumberDialog(context,
        title: l.combatPartyLevels,
        label: l.combatLevelLabel,
        initial: encounter.partyLevels[index],
        max: 20);
    final level = result?.value;
    if (level == null || !context.mounted) return;
    final levels = [...encounter.partyLevels];
    if (index >= levels.length) return;
    levels[index] = level;
    await ref
        .read(combatActionsProvider)
        .saveEncounter(encounter.copyWith(partyLevels: levels));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final result = rateCombatants(encounter, combatants);
    final actions = ref.read(combatActionsProvider);
    final small = TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.balance_outlined, size: 18, color: GmhColors.ember),
            const SizedBox(width: 8),
            Expanded(
              child: Text(l.combatDifficulty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            Flexible(child: DifficultyBadge(result: result)),
          ],
        ),
        const SizedBox(height: 12),
        Text(l.combatRules, style: small),
        const SizedBox(height: 4),
        SegmentedButton<RulesVersion>(
          showSelectedIcon: false,
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          segments: [
            for (final rules in RulesVersion.values)
              ButtonSegment(value: rules, label: Text(rules.id)),
          ],
          selected: {encounter.rulesVersion},
          onSelectionChanged: (selection) => actions.saveEncounter(
              encounter.copyWith(rulesVersion: selection.first)),
        ),
        const SizedBox(height: 12),
        Text(l.combatPartyLevels, style: small),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < encounter.partyLevels.length; i++)
              InputChip(
                visualDensity: VisualDensity.compact,
                label: Text(l.combatLevelChip(encounter.partyLevels[i])),
                onPressed: () => _editLevel(context, ref, i),
                onDeleted: () => actions.saveEncounter(encounter.copyWith(
                    partyLevels: [...encounter.partyLevels]..removeAt(i))),
              ),
            ActionChip(
              key: const ValueKey('combat-add-level'),
              visualDensity: VisualDensity.compact,
              avatar: const Icon(Icons.add, size: 16),
              label: Text(l.combatAddLevel),
              onPressed: () => _addLevel(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(l.combatMonsterXp(formatXp(context, result.totalXp)),
            style: const TextStyle(fontSize: 13)),
        if (result.rules == RulesVersion.v2014) ...[
          const SizedBox(height: 2),
          Text(
            l.combatAdjustedXp(formatXp(context, result.adjustedXp),
                NumberFormat.decimalPattern(
                        Localizations.localeOf(context).languageCode)
                    .format(result.multiplier)),
            style: const TextStyle(fontSize: 13),
          ),
        ],
        const SizedBox(height: 8),
        if (result.thresholds.isEmpty)
          Text(l.combatNoParty, style: small)
        else
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (final t in result.thresholds)
                Text(
                  '${difficultyLabel(l, t.rating)} ${formatXp(context, t.xp)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: result.rating == t.rating
                        ? difficultyColor(t.rating)
                        : GmhColors.parchmentDim,
                    fontWeight: result.rating == t.rating
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
