import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/dice/dice_engine.dart';
import '../../../domain/dice/dice_presets.dart';

/// Localized message for a rejected expression.
String diceErrorText(AppLocalizations l, DiceParseException e) {
  final message = switch (e.code) {
    DiceErrorCode.empty => l.diceErrorEmpty,
    DiceErrorCode.tooLong => l.diceErrorTooLong,
    DiceErrorCode.unexpectedChar => l.diceErrorUnexpectedChar,
    DiceErrorCode.unexpectedEnd => l.diceErrorUnexpectedEnd,
    DiceErrorCode.expectedNumber => l.diceErrorExpectedNumber,
    DiceErrorCode.unbalancedParen => l.diceErrorParen,
    DiceErrorCode.tooManyDice => l.diceErrorTooManyDice,
    DiceErrorCode.badSides => l.diceErrorBadSides,
    DiceErrorCode.numberTooLarge => l.diceErrorTooLarge,
    DiceErrorCode.divisionByZero => l.diceErrorDivisionByZero,
    DiceErrorCode.duplicateModifier => l.diceErrorDuplicate,
    DiceErrorCode.impossibleReroll => l.diceErrorImpossibleReroll,
    DiceErrorCode.unterminatedLabel => l.diceErrorLabel,
  };
  final positional = switch (e.code) {
    DiceErrorCode.unexpectedChar ||
    DiceErrorCode.expectedNumber ||
    DiceErrorCode.duplicateModifier ||
    DiceErrorCode.badSides =>
      true,
    _ => false,
  };
  return positional ? l.diceErrorAt(message, e.position + 1) : message;
}

String dicePresetName(AppLocalizations l, DicePresetKind kind) =>
    switch (kind) {
      DicePresetKind.d20Check => l.dicePresetD20,
      DicePresetKind.abilityScore => l.dicePresetAbility,
      DicePresetKind.callOfCthulhu => l.dicePresetCoc,
      DicePresetKind.pbta => l.dicePresetPbta,
      DicePresetKind.blades => l.dicePresetBlades,
      DicePresetKind.fate => l.dicePresetFate,
      DicePresetKind.yearZero => l.dicePresetYearZero,
      DicePresetKind.savageWorlds => l.dicePresetSavage,
      DicePresetKind.cyberpunkRed => l.dicePresetCyberpunk,
    };

IconData dicePresetIcon(DicePresetKind kind) => switch (kind) {
      DicePresetKind.d20Check => Icons.change_history,
      DicePresetKind.abilityScore => Icons.fitness_center,
      DicePresetKind.callOfCthulhu => Icons.visibility_outlined,
      DicePresetKind.pbta => Icons.bolt,
      DicePresetKind.blades => Icons.nightlight_outlined,
      DicePresetKind.fate => Icons.exposure,
      DicePresetKind.yearZero => Icons.hexagon_outlined,
      DicePresetKind.savageWorlds => Icons.pets_outlined,
      DicePresetKind.cyberpunkRed => Icons.memory,
    };

/// null for [DiceOutcome.none].
String? diceOutcomeText(AppLocalizations l, DiceOutcome outcome) =>
    switch (outcome) {
      DiceOutcome.none => null,
      DiceOutcome.criticalSuccess => l.diceOutcomeCriticalSuccess,
      DiceOutcome.criticalFailure => l.diceOutcomeCriticalFailure,
      DiceOutcome.success => l.diceOutcomeSuccess,
      DiceOutcome.failure => l.diceOutcomeFailure,
      DiceOutcome.raise => l.diceOutcomeRaise,
      DiceOutcome.extremeSuccess => l.diceOutcomeExtreme,
      DiceOutcome.hardSuccess => l.diceOutcomeHard,
      DiceOutcome.regularSuccess => l.diceOutcomeRegular,
      DiceOutcome.fumble => l.diceOutcomeFumble,
      DiceOutcome.miss => l.diceOutcomeMiss,
      DiceOutcome.partialSuccess => l.diceOutcomePartial,
      DiceOutcome.fullSuccess => l.diceOutcomeFull,
    };

Color diceOutcomeColor(DiceOutcome outcome) => switch (outcome) {
      DiceOutcome.criticalSuccess => GmhColors.ember,
      DiceOutcome.criticalFailure || DiceOutcome.fumble => GmhColors.danger,
      DiceOutcome.failure || DiceOutcome.miss => GmhColors.parchmentDim,
      DiceOutcome.partialSuccess => GmhColors.arcane,
      DiceOutcome.none => GmhColors.parchmentDim,
      _ => GmhColors.success,
    };

/// The one-line verdict shown under a total: the Fate ladder rung, the
/// Year Zero success count, or the system outcome; null when there is none.
String? diceSummaryText(AppLocalizations l,
    {DicePresetKind? preset, DiceOutcome outcome = DiceOutcome.none,
    required int total}) {
  return switch (preset) {
    DicePresetKind.fate => fateRungName(l, FateRung.of(total)),
    DicePresetKind.yearZero => l.diceSuccesses(total),
    _ => diceOutcomeText(l, outcome),
  };
}

String fateRungName(AppLocalizations l, FateRung rung) => switch (rung) {
      FateRung.terrible => l.diceFateTerrible,
      FateRung.poor => l.diceFatePoor,
      FateRung.mediocre => l.diceFateMediocre,
      FateRung.average => l.diceFateAverage,
      FateRung.fair => l.diceFateFair,
      FateRung.good => l.diceFateGood,
      FateRung.great => l.diceFateGreat,
      FateRung.superb => l.diceFateSuperb,
      FateRung.fantastic => l.diceFateFantastic,
      FateRung.epic => l.diceFateEpic,
      FateRung.legendary => l.diceFateLegendary,
    };
