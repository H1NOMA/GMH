import 'package:flutter/widgets.dart';

import '../core/exceptions.dart';
import '../core/utils/dates.dart';
import '../domain/models/entity_kind.dart';
import '../domain/models/link.dart';
import '../l10n/app_localizations.dart';

export '../l10n/app_localizations.dart';

/// Shorthand: `context.l10n.someKey`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Localized labels for entity kinds (domain enum stays language-neutral).
extension EntityKindL10n on EntityKind {
  String localizedLabel(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      EntityKind.character => l.kindCharacter,
      EntityKind.location => l.kindLocation,
      EntityKind.item => l.kindItem,
      EntityKind.creature => l.kindCreature,
      EntityKind.faction => l.kindFaction,
      EntityKind.event => l.kindEvent,
      EntityKind.era => l.kindEra,
      EntityKind.religion => l.kindReligion,
      EntityKind.magicSystem => l.kindMagicSystem,
      EntityKind.technology => l.kindTechnology,
      EntityKind.concept => l.kindConcept,
      EntityKind.loreDocument => l.kindLoreDocument,
      EntityKind.campaign => l.kindCampaign,
      EntityKind.quest => l.kindQuest,
      EntityKind.session => l.kindSession,
      // Custom entries take their category's name at call sites; this is
      // only the generic fallback.
      EntityKind.custom => l.kindCustomEntry,
    };
  }

  String localizedPlural(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      EntityKind.character => l.kindCharacterPlural,
      EntityKind.location => l.kindLocationPlural,
      EntityKind.item => l.kindItemPlural,
      EntityKind.creature => l.kindCreaturePlural,
      EntityKind.faction => l.kindFactionPlural,
      EntityKind.event => l.kindEventPlural,
      EntityKind.era => l.kindEraPlural,
      EntityKind.religion => l.kindReligionPlural,
      EntityKind.magicSystem => l.kindMagicSystemPlural,
      EntityKind.technology => l.kindTechnologyPlural,
      EntityKind.concept => l.kindConceptPlural,
      EntityKind.loreDocument => l.kindLoreDocumentPlural,
      EntityKind.campaign => l.kindCampaignPlural,
      EntityKind.quest => l.kindQuestPlural,
      EntityKind.session => l.kindSessionPlural,
      EntityKind.custom => l.kindCustomEntry,
    };
  }
}

/// Localized labels for well-known link roles; custom roles pass through.
String localizedRoleLabel(BuildContext context, String role) {
  final l = context.l10n;
  return switch (role) {
    LinkRoles.mention => l.roleMention,
    LinkRoles.related => l.roleRelated,
    LinkRoles.owner => l.roleOwner,
    LinkRoles.locatedAt => l.roleLocatedAt,
    LinkRoles.memberOf => l.roleMemberOf,
    LinkRoles.partOf => l.rolePartOf,
    LinkRoles.participatedIn => l.roleParticipatedIn,
    LinkRoles.createdAt => l.roleCreatedAt,
    LinkRoles.questGiver => l.roleQuestGiver,
    LinkRoles.ally => l.roleAlly,
    LinkRoles.friend => l.roleFriend,
    LinkRoles.family => l.roleFamily,
    LinkRoles.enemy => l.roleEnemy,
    LinkRoles.rival => l.roleRival,
    _ => role,
  };
}

/// Localized "time ago" for recents and version lists.
String localizedTimeAgo(BuildContext context, int ms) {
  final l = context.l10n;
  final diff = DateTime.now().difference(fromMs(ms));
  if (diff.inSeconds < 60) return l.justNow;
  if (diff.inMinutes < 60) return l.minutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l.hoursAgo(diff.inHours);
  if (diff.inDays < 30) return l.daysAgo(diff.inDays);
  return formatDate(ms);
}

/// Maps domain exceptions to localized, user-presentable messages.
String localizedError(BuildContext context, GmhException error) {
  final l = context.l10n;
  return switch (error) {
    ValidationException(message: 'Name cannot be empty.') => l.errorNameEmpty,
    UnexpectedException() => l.errorUnexpected,
    _ => error.userMessage,
  };
}
