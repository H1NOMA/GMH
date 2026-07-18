import '../../../domain/models/entity_kind.dart';

/// Where a TTG collection lands in GMH: a built-in [EntityKind], or a custom
/// category (created on demand), optionally with an extra tag that keeps the
/// finer-grained source type (e.g. weapons are Items tagged "weapon").
class TtgTarget {
  final EntityKind? kind;
  final String? categoryName;
  final String? categoryIcon;
  final String? extraTag;

  const TtgTarget.kind(this.kind, {this.extraTag})
      : categoryName = null,
        categoryIcon = null;

  const TtgTarget.category(this.categoryName,
      {this.categoryIcon = 'folder', this.extraTag})
      : kind = null;

  bool get isCategory => categoryName != null;
}

/// Normalizes a type/table name: lowercase, alphanumeric, singular.
/// "Magic Items" -> "magicitem", "Cities" -> "city".
String normalizeType(String raw) => singularizeType(
    raw.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ''));

String singularizeType(String n) {
  if (n.length <= 3) return n;
  if (n.endsWith('ies')) return '${n.substring(0, n.length - 3)}y';
  if (n.endsWith('sses') ||
      n.endsWith('xes') ||
      n.endsWith('ches') ||
      n.endsWith('shes')) {
    return n.substring(0, n.length - 2);
  }
  if (n.endsWith('s') && !n.endsWith('ss')) {
    return n.substring(0, n.length - 1);
  }
  return n;
}

/// "city_id" -> "city", "member_of_faction" -> "member of faction".
String humanizeRole(String raw) {
  var s = raw
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .toLowerCase()
      .trim();
  for (final suffix in [' id', ' uuid', ' key']) {
    if (s.endsWith(suffix)) s = s.substring(0, s.length - suffix.length);
  }
  return s.isEmpty ? 'related' : s;
}

const _registry = <String, TtgTarget>{
  // -- campaigns & play
  'campaign': TtgTarget.kind(EntityKind.campaign),
  'adventure': TtgTarget.kind(EntityKind.campaign),
  'quest': TtgTarget.kind(EntityKind.quest),
  'mission': TtgTarget.kind(EntityKind.quest),
  'objective': TtgTarget.kind(EntityKind.quest),
  'session': TtgTarget.kind(EntityKind.session),
  'sessionnote': TtgTarget.kind(EntityKind.session),
  'sessionlog': TtgTarget.kind(EntityKind.session),
  'encounter': TtgTarget.kind(EntityKind.event, extraTag: 'encounter'),
  'battle': TtgTarget.kind(EntityKind.event, extraTag: 'encounter'),

  // -- people
  'npc': TtgTarget.kind(EntityKind.character, extraTag: 'npc'),
  'nonplayercharacter': TtgTarget.kind(EntityKind.character, extraTag: 'npc'),
  'playercharacter':
      TtgTarget.kind(EntityKind.character, extraTag: 'player character'),
  'player': TtgTarget.kind(EntityKind.character, extraTag: 'player character'),
  'pc': TtgTarget.kind(EntityKind.character, extraTag: 'player character'),
  'character': TtgTarget.kind(EntityKind.character),
  'hero': TtgTarget.kind(EntityKind.character),
  'villain': TtgTarget.kind(EntityKind.character, extraTag: 'villain'),

  // -- creatures
  'monster': TtgTarget.kind(EntityKind.creature, extraTag: 'monster'),
  'creature': TtgTarget.kind(EntityKind.creature),
  'bestiary': TtgTarget.kind(EntityKind.creature, extraTag: 'monster'),
  'beast': TtgTarget.kind(EntityKind.creature),

  // -- rules content -> custom categories
  'spell': TtgTarget.category('Spells', categoryIcon: 'magic'),
  'cantrip': TtgTarget.category('Spells',
      categoryIcon: 'magic', extraTag: 'cantrip'),
  'class': TtgTarget.category('Classes', categoryIcon: 'star'),
  'subclass': TtgTarget.category('Subclasses', categoryIcon: 'star'),
  'archetype': TtgTarget.category('Subclasses', categoryIcon: 'star'),
  'race': TtgTarget.category('Races', categoryIcon: 'creature'),
  'species': TtgTarget.category('Races', categoryIcon: 'creature'),
  'ancestry': TtgTarget.category('Races', categoryIcon: 'creature'),
  'background': TtgTarget.category('Backgrounds', categoryIcon: 'scroll'),
  'feat': TtgTarget.category('Feats', categoryIcon: 'star'),
  'talent': TtgTarget.category('Feats', categoryIcon: 'star'),
  'condition': TtgTarget.category('Conditions', categoryIcon: 'skull'),
  'disease': TtgTarget.category('Conditions',
      categoryIcon: 'skull', extraTag: 'disease'),
  'skill': TtgTarget.category('Skills', categoryIcon: 'book'),
  'language': TtgTarget.category('Languages', categoryIcon: 'scroll'),
  'deity': TtgTarget.category('Deities', categoryIcon: 'church'),
  'god': TtgTarget.category('Deities', categoryIcon: 'church'),
  'godde': TtgTarget.category('Deities', categoryIcon: 'church'),
  'pantheon': TtgTarget.category('Deities',
      categoryIcon: 'church', extraTag: 'pantheon'),

  // -- magic
  'magic': TtgTarget.kind(EntityKind.magicSystem),
  'magicsystem': TtgTarget.kind(EntityKind.magicSystem),
  'magicschool': TtgTarget.category('Magic Schools', categoryIcon: 'magic'),
  'school': TtgTarget.category('Magic Schools', categoryIcon: 'magic'),
  'schoolofmagic': TtgTarget.category('Magic Schools', categoryIcon: 'magic'),

  // -- items
  'item': TtgTarget.kind(EntityKind.item),
  'equipment': TtgTarget.kind(EntityKind.item, extraTag: 'equipment'),
  'gear': TtgTarget.kind(EntityKind.item, extraTag: 'equipment'),
  'weapon': TtgTarget.kind(EntityKind.item, extraTag: 'weapon'),
  'armor': TtgTarget.kind(EntityKind.item, extraTag: 'armor'),
  'armour': TtgTarget.kind(EntityKind.item, extraTag: 'armor'),
  'magicitem': TtgTarget.kind(EntityKind.item, extraTag: 'magic item'),
  'artifact': TtgTarget.kind(EntityKind.item, extraTag: 'artifact'),
  'relic': TtgTarget.kind(EntityKind.item, extraTag: 'artifact'),
  'treasure': TtgTarget.kind(EntityKind.item, extraTag: 'treasure'),

  // -- society
  'religion': TtgTarget.kind(EntityKind.religion),
  'faith': TtgTarget.kind(EntityKind.religion),
  'cult': TtgTarget.kind(EntityKind.religion, extraTag: 'cult'),
  'faction': TtgTarget.kind(EntityKind.faction),
  'guild': TtgTarget.kind(EntityKind.faction, extraTag: 'guild'),
  'organization': TtgTarget.kind(EntityKind.faction, extraTag: 'organization'),
  'organisation': TtgTarget.kind(EntityKind.faction, extraTag: 'organization'),
  'org': TtgTarget.kind(EntityKind.faction, extraTag: 'organization'),
  'company': TtgTarget.kind(EntityKind.faction, extraTag: 'organization'),

  // -- places
  'kingdom': TtgTarget.kind(EntityKind.location, extraTag: 'kingdom'),
  'realm': TtgTarget.kind(EntityKind.location, extraTag: 'kingdom'),
  'empire': TtgTarget.kind(EntityKind.location, extraTag: 'kingdom'),
  'nation': TtgTarget.kind(EntityKind.location, extraTag: 'kingdom'),
  'country': TtgTarget.kind(EntityKind.location, extraTag: 'kingdom'),
  'city': TtgTarget.kind(EntityKind.location, extraTag: 'city'),
  'village': TtgTarget.kind(EntityKind.location, extraTag: 'village'),
  'town': TtgTarget.kind(EntityKind.location, extraTag: 'town'),
  'settlement': TtgTarget.kind(EntityKind.location, extraTag: 'settlement'),
  'location': TtgTarget.kind(EntityKind.location),
  'place': TtgTarget.kind(EntityKind.location),
  'region': TtgTarget.kind(EntityKind.location, extraTag: 'region'),
  'dungeon': TtgTarget.kind(EntityKind.location, extraTag: 'dungeon'),
  'shop': TtgTarget.kind(EntityKind.location, extraTag: 'shop'),
  'store': TtgTarget.kind(EntityKind.location, extraTag: 'shop'),
  'tavern': TtgTarget.kind(EntityKind.location, extraTag: 'tavern'),
  'inn': TtgTarget.kind(EntityKind.location, extraTag: 'tavern'),
  'map': TtgTarget.kind(EntityKind.location, extraTag: 'map'),

  // -- time
  'timeline': TtgTarget.kind(EntityKind.era),
  'era': TtgTarget.kind(EntityKind.era),
  'age': TtgTarget.kind(EntityKind.era),
  'event': TtgTarget.kind(EntityKind.event),
  'history': TtgTarget.kind(EntityKind.event, extraTag: 'history'),

  // -- lore & misc
  'technology': TtgTarget.kind(EntityKind.technology),
  'homebrew': TtgTarget.kind(EntityKind.concept, extraTag: 'homebrew'),
  'concept': TtgTarget.kind(EntityKind.concept),
  'idea': TtgTarget.kind(EntityKind.concept),
  'note': TtgTarget.kind(EntityKind.loreDocument),
  'document': TtgTarget.kind(EntityKind.loreDocument),
  'journal': TtgTarget.kind(EntityKind.loreDocument, extraTag: 'journal'),
  'handout': TtgTarget.kind(EntityKind.loreDocument, extraTag: 'handout'),
  'lore': TtgTarget.kind(EntityKind.loreDocument),
};

/// Prettifies an unknown collection name into a category name:
/// "magic_rituals" -> "Magic Rituals".
String prettifyCollectionName(String raw) {
  final words = raw
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .toList();
  return words.isEmpty ? 'Imported' : words.join(' ');
}

/// Resolves a source collection name to its GMH target. Unknown types land
/// in a custom category named after the collection, so nothing is dropped.
TtgTarget targetForCollection(String collectionName) {
  final target = _registry[normalizeType(collectionName)];
  if (target != null) return target;
  return TtgTarget.category(prettifyCollectionName(collectionName));
}
