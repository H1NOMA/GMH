import 'package:flutter/material.dart';

import '../../../domain/generators/generator_engine.dart';
import '../../../l10n/app_localizations.dart';

String generatorKindLabel(AppLocalizations l, GeneratorKind kind) =>
    switch (kind) {
      GeneratorKind.names => l.generatorsKindNames,
      GeneratorKind.npc => l.generatorsKindNpc,
      GeneratorKind.settlement => l.generatorsKindSettlement,
      GeneratorKind.establishment => l.generatorsKindEstablishment,
      GeneratorKind.hook => l.generatorsKindHook,
      GeneratorKind.loot => l.generatorsKindLoot,
      GeneratorKind.faction => l.generatorsKindFaction,
      GeneratorKind.weather => l.generatorsKindWeather,
      GeneratorKind.rumor => l.generatorsKindRumor,
    };

IconData generatorKindIcon(GeneratorKind kind) => switch (kind) {
  GeneratorKind.names => Icons.badge_outlined,
  GeneratorKind.npc => Icons.person_outline,
  GeneratorKind.settlement => Icons.holiday_village_outlined,
  GeneratorKind.establishment => Icons.storefront_outlined,
  GeneratorKind.hook => Icons.explore_outlined,
  GeneratorKind.loot => Icons.diamond_outlined,
  GeneratorKind.faction => Icons.flag_outlined,
  GeneratorKind.weather => Icons.cloud_outlined,
  GeneratorKind.rumor => Icons.record_voice_over_outlined,
};

/// Localized label of a field label key; [kind] tells a person's name
/// from a place's or group's name.
String generatorFieldLabel(
  AppLocalizations l,
  String key, {
  GeneratorKind? kind,
}) => switch (key) {
  'name' =>
    kind == null || kind == GeneratorKind.npc
        ? l.generatorsFieldName
        : l.generatorsFieldPlaceName,
  'epithet' => l.generatorsFieldEpithet,
  'ancestry' => l.generatorsFieldAncestry,
  'role' => l.generatorsFieldRole,
  'age' => l.generatorsFieldAge,
  'appearance' => l.generatorsFieldAppearance,
  'trait' => l.generatorsFieldTrait,
  'motivation' => l.generatorsFieldMotivation,
  'secret' => l.generatorsFieldSecret,
  'voice' => l.generatorsFieldVoice,
  'attributes' => l.generatorsFieldAttributes,
  'size' => l.generatorsFieldSize,
  'feature' => l.generatorsFieldFeature,
  'trouble' => l.generatorsFieldTrouble,
  'authority' => l.generatorsFieldAuthority,
  'type' => l.generatorsFieldType,
  'owner' => l.generatorsFieldOwner,
  'specialty' => l.generatorsFieldSpecialty,
  'patron' => l.generatorsFieldPatron,
  'title' => l.generatorsFieldTitle,
  'who' => l.generatorsFieldWho,
  'wants' => l.generatorsFieldWants,
  'obstacle' => l.generatorsFieldObstacle,
  'twist' => l.generatorsFieldTwist,
  'container' => l.generatorsFieldContainer,
  'coins' => l.generatorsFieldCoins,
  'item' => l.generatorsFieldItem,
  'curio' => l.generatorsFieldCurio,
  'goal' => l.generatorsFieldGoal,
  'method' => l.generatorsFieldMethod,
  'symbol' => l.generatorsFieldSymbol,
  'sky' => l.generatorsFieldSky,
  'air' => l.generatorsFieldAir,
  'omen' => l.generatorsFieldOmen,
  'rumor' => l.generatorsKindRumor,
  'source' => l.generatorsFieldSource,
  'truth' => l.generatorsFieldTruth,
  'weather' => l.generatorsKindWeather,
  _ => key,
};

String generatorGenderLabel(AppLocalizations l, NameGender gender) =>
    switch (gender) {
      NameGender.any => l.generatorsGenderAny,
      NameGender.feminine => l.generatorsGenderFeminine,
      NameGender.masculine => l.generatorsGenderMasculine,
    };
