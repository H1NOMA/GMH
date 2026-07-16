import 'package:flutter/foundation.dart';

/// Who owns a link — determines which subsystem may create/delete it.
enum LinkOrigin {
  /// Added by the user on the relations panel.
  manual,

  /// Auto-extracted from an inline mention embed in a document; owned by the
  /// mention sync service.
  document,

  /// Mirrored from a structured entityRef attribute; owned by the template
  /// service.
  attribute;

  static LinkOrigin parse(String name) =>
      values.firstWhere((v) => v.name == name, orElse: () => manual);
}

/// Well-known semantic roles. Links may also carry free-form custom roles.
abstract final class LinkRoles {
  static const mention = 'mention';
  static const related = 'related';
  static const owner = 'owner';
  static const locatedAt = 'locatedAt';
  static const memberOf = 'memberOf';
  static const partOf = 'partOf';
  static const participatedIn = 'participatedIn';
  static const createdAt = 'createdAt';
  static const questGiver = 'questGiver';

  static const suggestions = [
    related,
    owner,
    locatedAt,
    memberOf,
    partOf,
    participatedIn,
    createdAt,
  ];

  /// Human-readable label for a role, tolerant of custom roles.
  static String label(String role) => switch (role) {
        mention => 'Mentioned in',
        related => 'Related to',
        owner => 'Owner',
        locatedAt => 'Located at',
        memberOf => 'Member of',
        partOf => 'Part of',
        participatedIn => 'Participated in',
        createdAt => 'Created at',
        questGiver => 'Quest giver',
        _ => role,
      };
}

/// A directed, role-labeled edge between two entities.
/// Backlinks are simply links queried by target.
@immutable
class Link {
  final String id;
  final String worldId;
  final String sourceId;
  final String targetId;
  final String role;
  final LinkOrigin origin;
  final int createdAt;

  const Link({
    required this.id,
    required this.worldId,
    required this.sourceId,
    required this.targetId,
    required this.role,
    required this.origin,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) => other is Link && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
