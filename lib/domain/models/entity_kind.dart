import 'package:flutter/material.dart';

/// Every object type in GMH. The unified entity model means all kinds share
/// one table, one linking system, one search index and one browser UI —
/// adding a kind here (plus a template) is all it takes to introduce a new
/// object type.
enum EntityKind {
  character('Character', 'Characters', Icons.person_outline),
  location('Location', 'Locations', Icons.castle_outlined),
  item('Item', 'Items', Icons.colorize_outlined),
  creature('Creature', 'Creatures', Icons.pets_outlined),
  faction('Faction', 'Factions', Icons.shield_outlined),
  event('Event', 'Events', Icons.local_fire_department_outlined),
  era('Era', 'Eras', Icons.hourglass_bottom_outlined),
  religion('Religion', 'Religions', Icons.church_outlined),
  magicSystem('Magic System', 'Magic Systems', Icons.auto_fix_high_outlined),
  technology('Technology', 'Technologies', Icons.precision_manufacturing_outlined),
  concept('Concept', 'Concept Archive', Icons.lightbulb_outline),
  loreDocument('Lore Document', 'Lore Documents', Icons.menu_book_outlined),
  campaign('Campaign', 'Campaigns', Icons.map_outlined),
  quest('Quest', 'Quests', Icons.flag_outlined),
  session('Session', 'Sessions', Icons.event_note_outlined),

  /// Entries in a user-defined category (`entities.custom_category_id`).
  /// Name, icon and color come from the category, not from this enum.
  custom('Custom', 'Custom', Icons.category_outlined);

  final String label;
  final String pluralLabel;
  final IconData icon;

  const EntityKind(this.label, this.pluralLabel, this.icon);

  static EntityKind? tryParse(String name) {
    for (final kind in values) {
      if (kind.name == name) return kind;
    }
    return null;
  }

  /// Kinds shown in the "World" navigation section.
  static const worldKinds = [
    character,
    location,
    item,
    creature,
    faction,
    event,
    era,
    religion,
    magicSystem,
    technology,
  ];

  /// Kinds shown in the "Library" navigation section.
  static const libraryKinds = [loreDocument, concept];

  /// Kinds managed by the campaign manager.
  static const campaignKinds = [campaign, quest, session];

  bool get isCampaignKind => campaignKinds.contains(this);

  /// Node color in the graph view and accent color in lists.
  Color get color => switch (this) {
        character => const Color(0xFFE0A458),
        location => const Color(0xFF6FA8DC),
        item => const Color(0xFFC27BA0),
        creature => const Color(0xFF93C47D),
        faction => const Color(0xFFCC4125),
        event => const Color(0xFFE06666),
        era => const Color(0xFFAF8C5E),
        religion => const Color(0xFFB4A7D6),
        magicSystem => const Color(0xFF8E7CC3),
        technology => const Color(0xFF76A5AF),
        concept => const Color(0xFFFFD966),
        loreDocument => const Color(0xFFD9B382),
        campaign => const Color(0xFF6AA84F),
        quest => const Color(0xFFF6B26B),
        session => const Color(0xFF9FC5E8),
        custom => const Color(0xFFB98BC9),
      };
}
