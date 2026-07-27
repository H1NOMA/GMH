import '../../models/entity_kind.dart';
import '../../models/entity_template.dart';
import '../../models/link.dart';

/// Built-in structured-field templates for every entity kind.
///
/// Templates are pure data: adding a field or a whole kind here requires no
/// database migration and the attribute forms, link mirroring, export and
/// search pick it up automatically.
abstract final class EntityTemplates {
  static final Map<EntityKind, EntityTemplate> _byKind = {
    for (final t in _all) t.kind: t,
  };

  static EntityTemplate of(EntityKind kind) => _byKind[kind]!;

  static final List<EntityTemplate> _all = [
    EntityTemplate(kind: EntityKind.character, sections: [
      // Existing field keys (title, race, characterClass, alignment, status,
      // homeLocation, factions, goals, secrets, voice) are unchanged so all
      // previously entered character data is preserved. Unknown/legacy keys
      // survive sanitize() untouched, which also makes room for future
      // custom fields.
      const FieldSection('General Information', [
        FieldDef(key: 'title', label: 'Title / Epithet', type: FieldType.text, hint: 'e.g. The Ashen King'),
        FieldDef(key: 'race', label: 'Race / Ancestry', type: FieldType.text),
        FieldDef(key: 'characterClass', label: 'Class / Profession', type: FieldType.text),
        FieldDef(key: 'gender', label: 'Gender', type: FieldType.text),
        FieldDef(key: 'age', label: 'Age', type: FieldType.text),
        FieldDef(key: 'occupation', label: 'Occupation', type: FieldType.text),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Alive', 'Dead', 'Missing', 'Unknown']),
      ]),
      const FieldSection('Statistics', [
        FieldDef(key: 'strength', label: 'STR', type: FieldType.number),
        FieldDef(key: 'dexterity', label: 'DEX', type: FieldType.number),
        FieldDef(key: 'constitution', label: 'CON', type: FieldType.number),
        FieldDef(key: 'intelligence', label: 'INT', type: FieldType.number),
        FieldDef(key: 'wisdom', label: 'WIS', type: FieldType.number),
        FieldDef(key: 'charisma', label: 'CHA', type: FieldType.number),
      ]),
      const FieldSection('Combat', [
        FieldDef(key: 'hp', label: 'Hit Points', type: FieldType.text, hint: 'e.g. 34 / 40'),
        FieldDef(key: 'ac', label: 'Armor Class', type: FieldType.number),
        FieldDef(key: 'speed', label: 'Speed', type: FieldType.text, hint: 'e.g. 30 ft.'),
        FieldDef(key: 'initiative', label: 'Initiative', type: FieldType.number),
        FieldDef(key: 'passivePerception', label: 'Passive Perception', type: FieldType.number),
        FieldDef(key: 'customStats', label: 'Custom Stats', type: FieldType.stringList, hint: 'e.g. Luck: 12'),
      ]),
      FieldSection('Beliefs', [
        const FieldDef(key: 'religion', label: 'Religion', type: FieldType.text),
        const FieldDef(
          key: 'deity', label: 'Deity', type: FieldType.entityRef,
          refKinds: [EntityKind.character, EntityKind.religion],
          linkRole: LinkRoles.related),
        const FieldDef(key: 'alignment', label: 'Alignment', type: FieldType.select, options: [
          'Lawful Good', 'Neutral Good', 'Chaotic Good',
          'Lawful Neutral', 'True Neutral', 'Chaotic Neutral',
          'Lawful Evil', 'Neutral Evil', 'Chaotic Evil',
        ]),
        const FieldDef(key: 'personalityTraits', label: 'Personality Traits', type: FieldType.longText),
        const FieldDef(key: 'ideals', label: 'Ideals', type: FieldType.longText),
        const FieldDef(key: 'bonds', label: 'Bonds', type: FieldType.longText),
        const FieldDef(key: 'flaws', label: 'Flaws', type: FieldType.longText),
      ]),
      const FieldSection('Roleplay', [
        FieldDef(key: 'goals', label: 'Goals & Motivation', type: FieldType.longText),
        FieldDef(key: 'secrets', label: 'Secrets (DM only)', type: FieldType.longText),
        FieldDef(key: 'voice', label: 'Voice & Mannerisms', type: FieldType.longText),
      ]),
      FieldSection('Relationships', [
        const FieldDef(
          key: 'allies', label: 'Allies', type: FieldType.entityRefList,
          refKinds: [EntityKind.character], linkRole: LinkRoles.ally),
        const FieldDef(
          key: 'friends', label: 'Friends', type: FieldType.entityRefList,
          refKinds: [EntityKind.character], linkRole: LinkRoles.friend),
        const FieldDef(
          key: 'family', label: 'Family', type: FieldType.entityRefList,
          refKinds: [EntityKind.character], linkRole: LinkRoles.family),
        const FieldDef(
          key: 'enemies', label: 'Enemies', type: FieldType.entityRefList,
          refKinds: [EntityKind.character, EntityKind.creature],
          linkRole: LinkRoles.enemy),
        const FieldDef(
          key: 'rivals', label: 'Rivals', type: FieldType.entityRefList,
          refKinds: [EntityKind.character], linkRole: LinkRoles.rival),
        const FieldDef(
          key: 'factions', label: 'Factions', type: FieldType.entityRefList,
          refKinds: [EntityKind.faction], linkRole: LinkRoles.memberOf),
        const FieldDef(
          key: 'organizations', label: 'Organizations', type: FieldType.entityRefList,
          refKinds: [EntityKind.faction], linkRole: LinkRoles.memberOf),
        const FieldDef(
          key: 'homeLocation', label: 'Home / Base', type: FieldType.entityRef,
          refKinds: [EntityKind.location], linkRole: LinkRoles.locatedAt),
      ]),
      FieldSection('Inventory', [
        const FieldDef(key: 'equipment', label: 'Equipment', type: FieldType.longText),
        const FieldDef(
          key: 'weapons', label: 'Weapons', type: FieldType.entityRefList,
          refKinds: [EntityKind.item], linkRole: LinkRoles.owner),
        const FieldDef(
          key: 'armor', label: 'Armor', type: FieldType.entityRefList,
          refKinds: [EntityKind.item], linkRole: LinkRoles.owner),
        const FieldDef(
          key: 'magicItems', label: 'Magic Items', type: FieldType.entityRefList,
          refKinds: [EntityKind.item], linkRole: LinkRoles.owner),
        const FieldDef(key: 'currency', label: 'Currency', type: FieldType.text, hint: 'e.g. 120 gp, 34 sp'),
        const FieldDef(key: 'inventoryNotes', label: 'Inventory Notes', type: FieldType.longText),
      ]),
      const FieldSection('Abilities & Magic', [
        FieldDef(key: 'skills', label: 'Skills', type: FieldType.stringList),
        FieldDef(key: 'features', label: 'Features', type: FieldType.longText),
        FieldDef(key: 'spells', label: 'Spells', type: FieldType.stringList),
        FieldDef(key: 'powers', label: 'Powers', type: FieldType.longText),
        FieldDef(key: 'customAbilities', label: 'Custom Abilities', type: FieldType.stringList),
      ]),
      FieldSection('Timeline', [
        const FieldDef(
          key: 'importantEvents', label: 'Important Events', type: FieldType.entityRefList,
          refKinds: [EntityKind.event], linkRole: LinkRoles.participatedIn),
        const FieldDef(key: 'development', label: 'Character Development', type: FieldType.longText),
        const FieldDef(
          key: 'sessionHistory', label: 'Session History', type: FieldType.entityRefList,
          refKinds: [EntityKind.session], linkRole: LinkRoles.participatedIn),
      ]),
      const FieldSection('Notes', [
        FieldDef(key: 'notes', label: 'Working Notes', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.location, sections: [
      const FieldSection('Overview', [
        FieldDef(key: 'locationType', label: 'Type', type: FieldType.select, options: [
          'Continent', 'Country', 'Region', 'City', 'Town', 'Village',
          'Dungeon', 'Castle', 'Landmark', 'Plane', 'Other',
        ]),
        FieldDef(key: 'population', label: 'Population', type: FieldType.text),
        FieldDef(key: 'government', label: 'Government', type: FieldType.text),
        FieldDef(key: 'climate', label: 'Climate & Terrain', type: FieldType.text),
        FieldDef(key: 'inhabitants', label: 'Inhabitants', type: FieldType.text),
      ]),
      FieldSection('Connections', [
        FieldDef(
          key: 'parentLocation', label: 'Within', type: FieldType.entityRef,
          refKinds: const [EntityKind.location], linkRole: LinkRoles.partOf,
          hint: 'The larger location containing this one'),
        FieldDef(
          key: 'ruler', label: 'Ruler', type: FieldType.entityRef,
          refKinds: const [EntityKind.character], linkRole: LinkRoles.owner),
      ]),
      const FieldSection('Detail', [
        FieldDef(key: 'sights', label: 'Notable Sights', type: FieldType.longText),
        FieldDef(key: 'hooks', label: 'Adventure Hooks', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.item, sections: [
      FieldSection('Overview', [
        const FieldDef(key: 'itemType', label: 'Type', type: FieldType.select, options: [
          'Weapon', 'Armor', 'Artifact', 'Magical Item', 'Technology', 'Treasure', 'Tool', 'Other',
        ]),
        const FieldDef(key: 'rarity', label: 'Rarity', type: FieldType.select, options: [
          'Common', 'Uncommon', 'Rare', 'Very Rare', 'Legendary', 'Artifact',
        ]),
        const FieldDef(key: 'attunement', label: 'Attunement', type: FieldType.text),
        const FieldDef(key: 'properties', label: 'Properties / Damage', type: FieldType.longText),
        const FieldDef(key: 'weight', label: 'Weight', type: FieldType.text,
            hint: 'e.g. 4 lb.'),
        const FieldDef(key: 'value', label: 'Value', type: FieldType.text,
            hint: 'e.g. 500 gp'),
        const FieldDef(key: 'charges', label: 'Charges', type: FieldType.text,
            hint: 'e.g. 7, regains 1d6+1 at dawn'),
      ]),
      FieldSection('Provenance', [
        const FieldDef(
          key: 'currentOwner', label: 'Current Owner', type: FieldType.entityRef,
          refKinds: [EntityKind.character, EntityKind.faction], linkRole: LinkRoles.owner),
        const FieldDef(
          key: 'forgedAt', label: 'Created / Forged at', type: FieldType.entityRef,
          refKinds: [EntityKind.location], linkRole: LinkRoles.createdAt),
        const FieldDef(
          key: 'relatedEvents', label: 'Related Events', type: FieldType.entityRefList,
          refKinds: [EntityKind.event], linkRole: LinkRoles.participatedIn),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.creature, sections: [
      const FieldSection('Overview', [
        FieldDef(key: 'creatureType', label: 'Type', type: FieldType.select, options: [
          'Monster', 'Beast', 'Species', 'Animal', 'Undead', 'Fiend',
          'Celestial', 'Dragon', 'Elemental', 'Fey', 'Unique Entity', 'Other',
        ]),
        FieldDef(key: 'challenge', label: 'Challenge Rating', type: FieldType.text),
        FieldDef(key: 'size', label: 'Size', type: FieldType.select, options: [
          'Tiny', 'Small', 'Medium', 'Large', 'Huge', 'Gargantuan',
        ]),
      ]),
      // Full monster stat block, mirroring the classic D&D layout. The
      // ability keys are shared with the character template so the same
      // translations and grid rendering apply.
      const FieldSection('Combat', [
        FieldDef(key: 'ac', label: 'Armor Class', type: FieldType.number),
        FieldDef(key: 'hp', label: 'Hit Points', type: FieldType.text,
            hint: 'e.g. 45 (6d10 + 12)'),
        FieldDef(key: 'speed', label: 'Speed', type: FieldType.text,
            hint: 'e.g. walk 30 ft., fly 60 ft.'),
      ]),
      const FieldSection('Statistics', [
        FieldDef(key: 'strength', label: 'STR', type: FieldType.number),
        FieldDef(key: 'dexterity', label: 'DEX', type: FieldType.number),
        FieldDef(key: 'constitution', label: 'CON', type: FieldType.number),
        FieldDef(key: 'intelligence', label: 'INT', type: FieldType.number),
        FieldDef(key: 'wisdom', label: 'WIS', type: FieldType.number),
        FieldDef(key: 'charisma', label: 'CHA', type: FieldType.number),
      ]),
      const FieldSection('Defenses & Senses', [
        FieldDef(key: 'savingThrows', label: 'Saving Throws',
            type: FieldType.text, hint: 'e.g. DEX +5, WIS +3'),
        FieldDef(key: 'skills', label: 'Skills', type: FieldType.text,
            hint: 'e.g. Perception +5, Stealth +4'),
        FieldDef(key: 'resistances', label: 'Damage Resistances',
            type: FieldType.text),
        FieldDef(key: 'immunities', label: 'Damage Immunities',
            type: FieldType.text),
        FieldDef(key: 'conditionImmunities', label: 'Condition Immunities',
            type: FieldType.text),
        FieldDef(key: 'senses', label: 'Senses', type: FieldType.text,
            hint: 'e.g. darkvision 60 ft., passive Perception 13'),
        FieldDef(key: 'languages', label: 'Languages', type: FieldType.text),
      ]),
      const FieldSection('Actions', [
        FieldDef(key: 'traits', label: 'Traits', type: FieldType.longText),
        FieldDef(key: 'actions', label: 'Actions', type: FieldType.longText),
        FieldDef(key: 'reactions', label: 'Reactions', type: FieldType.longText),
        FieldDef(key: 'legendaryActions', label: 'Legendary Actions',
            type: FieldType.longText),
      ]),
      FieldSection('Ecology', [
        const FieldDef(
          key: 'habitat', label: 'Habitat', type: FieldType.entityRefList,
          refKinds: [EntityKind.location], linkRole: LinkRoles.locatedAt),
        const FieldDef(key: 'behavior', label: 'Behavior & Tactics', type: FieldType.longText),
        const FieldDef(key: 'abilities', label: 'Abilities', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.faction, sections: [
      FieldSection('Overview', [
        const FieldDef(key: 'factionType', label: 'Type', type: FieldType.select, options: [
          'Kingdom', 'Guild', 'Cult', 'Order', 'Tribe', 'Company', 'Family', 'Civilization', 'Other',
        ]),
        const FieldDef(
          key: 'leader', label: 'Leader', type: FieldType.entityRef,
          refKinds: [EntityKind.character], linkRole: LinkRoles.owner),
        const FieldDef(
          key: 'headquarters', label: 'Headquarters', type: FieldType.entityRef,
          refKinds: [EntityKind.location], linkRole: LinkRoles.locatedAt),
      ]),
      const FieldSection('Detail', [
        FieldDef(key: 'ideology', label: 'Ideology & Goals', type: FieldType.longText),
        FieldDef(key: 'resources', label: 'Resources & Assets', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.event, sections: [
      FieldSection('When & Where', [
        const FieldDef(key: 'date', label: 'In-world Date', type: FieldType.text, hint: 'e.g. 3rd Age, Year 412'),
        const FieldDef(
          key: 'era', label: 'Era', type: FieldType.entityRef,
          refKinds: [EntityKind.era], linkRole: LinkRoles.partOf),
        const FieldDef(
          key: 'locations', label: 'Locations', type: FieldType.entityRefList,
          refKinds: [EntityKind.location], linkRole: LinkRoles.locatedAt),
      ]),
      FieldSection('Who & What', [
        const FieldDef(
          key: 'participants', label: 'Participants', type: FieldType.entityRefList,
          refKinds: [EntityKind.character, EntityKind.faction, EntityKind.creature],
          linkRole: LinkRoles.participatedIn),
        const FieldDef(key: 'outcome', label: 'Outcome & Consequences', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.era, sections: [
      const FieldSection('Timeline', [
        FieldDef(key: 'startDate', label: 'Begins', type: FieldType.text),
        FieldDef(key: 'endDate', label: 'Ends', type: FieldType.text),
        FieldDef(key: 'definingTraits', label: 'Defining Traits', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.religion, sections: [
      FieldSection('Overview', [
        const FieldDef(
          key: 'deities', label: 'Deities', type: FieldType.entityRefList,
          refKinds: [EntityKind.character], linkRole: LinkRoles.related),
        const FieldDef(key: 'domains', label: 'Domains', type: FieldType.stringList),
        const FieldDef(key: 'tenets', label: 'Tenets & Rites', type: FieldType.longText),
      ]),
    ]),
    // Doubles as a D&D-style spell card (the TTG importer routes spells
    // here): the Spell section mirrors the classic stat card, while
    // Overview keeps the worldbuilding-level fields.
    EntityTemplate(kind: EntityKind.magicSystem, sections: [
      const FieldSection('Spell', [
        FieldDef(key: 'level', label: 'Level', type: FieldType.select, options: [
          'Cantrip', '1st Level', '2nd Level', '3rd Level', '4th Level',
          '5th Level', '6th Level', '7th Level', '8th Level', '9th Level',
        ]),
        FieldDef(key: 'school', label: 'School', type: FieldType.select, options: [
          'Abjuration', 'Conjuration', 'Divination', 'Enchantment',
          'Evocation', 'Illusion', 'Necromancy', 'Transmutation',
        ]),
        FieldDef(key: 'castingTime', label: 'Casting Time',
            type: FieldType.text, hint: 'e.g. 1 action'),
        FieldDef(key: 'range', label: 'Range', type: FieldType.text,
            hint: 'e.g. 60 ft.'),
        FieldDef(key: 'components', label: 'Components', type: FieldType.text,
            hint: 'e.g. V, S, M (a pinch of salt)'),
        FieldDef(key: 'duration', label: 'Duration', type: FieldType.text,
            hint: 'e.g. Concentration, up to 1 minute'),
        FieldDef(key: 'ritual', label: 'Ritual', type: FieldType.select,
            options: ['Yes', 'No']),
        FieldDef(key: 'saveAttack', label: 'Save / Attack',
            type: FieldType.text, hint: 'e.g. DEX save, half on success'),
        FieldDef(key: 'damageEffect', label: 'Damage / Effect',
            type: FieldType.text, hint: 'e.g. 8d6 fire'),
        FieldDef(key: 'classes', label: 'Classes', type: FieldType.stringList),
        FieldDef(key: 'higherLevels', label: 'At Higher Levels',
            type: FieldType.longText),
      ]),
      const FieldSection('Overview', [
        FieldDef(key: 'source', label: 'Source of Power', type: FieldType.text),
        FieldDef(key: 'rules', label: 'Rules & Limits', type: FieldType.longText),
        FieldDef(key: 'costs', label: 'Costs & Risks', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.technology, sections: [
      const FieldSection('Overview', [
        FieldDef(key: 'techLevel', label: 'Tech Level', type: FieldType.text),
        FieldDef(key: 'principles', label: 'How It Works', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.concept, sections: [
      const FieldSection('Archive', [
        FieldDef(key: 'category', label: 'Category', type: FieldType.text, hint: 'e.g. Legendary Weapon'),
        FieldDef(key: 'inspiration', label: 'Inspiration / Sources', type: FieldType.longText),
        FieldDef(key: 'notes', label: 'Working Notes', type: FieldType.longText),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.loreDocument, sections: [
      FieldSection('Book', [
        const FieldDef(
          key: 'partOfBook', label: 'Part of', type: FieldType.entityRef,
          refKinds: [EntityKind.loreDocument], linkRole: LinkRoles.partOf,
          hint: 'Parent book or volume this chapter belongs to'),
        const FieldDef(key: 'chapterNumber', label: 'Chapter #', type: FieldType.number),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.campaign, sections: [
      const FieldSection('Table', [
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: [
          'Planning', 'Active', 'On Hold', 'Completed', 'Abandoned',
        ]),
        FieldDef(key: 'players', label: 'Players', type: FieldType.stringList),
        FieldDef(key: 'currentChapter', label: 'Current Chapter', type: FieldType.text),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.quest, sections: [
      FieldSection('Quest', [
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: [
          'Idea', 'Available', 'Active', 'Completed', 'Failed', 'Abandoned',
        ]),
        const FieldDef(
          key: 'campaign', label: 'Campaign', type: FieldType.entityRef,
          refKinds: [EntityKind.campaign], linkRole: LinkRoles.partOf),
        const FieldDef(key: 'objectives', label: 'Objectives', type: FieldType.checklist),
        const FieldDef(key: 'rewards', label: 'Rewards', type: FieldType.longText),
      ]),
      FieldSection('Cast & Stage', [
        const FieldDef(
          key: 'questGiver', label: 'Quest Giver', type: FieldType.entityRef,
          refKinds: [EntityKind.character], linkRole: LinkRoles.questGiver),
        const FieldDef(
          key: 'npcs', label: 'Involved NPCs', type: FieldType.entityRefList,
          refKinds: [EntityKind.character, EntityKind.creature],
          linkRole: LinkRoles.participatedIn),
        const FieldDef(
          key: 'locations', label: 'Locations', type: FieldType.entityRefList,
          refKinds: [EntityKind.location], linkRole: LinkRoles.locatedAt),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.custom, sections: [
      const FieldSection('Overview', [
        FieldDef(key: 'subtype', label: 'Type / Subtype', type: FieldType.text),
        FieldDef(key: 'notes', label: 'Working Notes', type: FieldType.longText),
      ]),
      FieldSection('Connections', [
        const FieldDef(
          key: 'relatedEntries', label: 'Related Entries',
          type: FieldType.entityRefList, linkRole: LinkRoles.related),
      ]),
    ]),
    EntityTemplate(kind: EntityKind.session, sections: [
      FieldSection('Session', [
        const FieldDef(
          key: 'campaign', label: 'Campaign', type: FieldType.entityRef,
          refKinds: [EntityKind.campaign], linkRole: LinkRoles.partOf),
        const FieldDef(key: 'date', label: 'Session Date', type: FieldType.date),
        const FieldDef(key: 'agenda', label: 'Agenda / Planned Beats', type: FieldType.checklist),
      ]),
      const FieldSection('Outcome', [
        FieldDef(key: 'decisions', label: 'Player Decisions', type: FieldType.longText),
        FieldDef(key: 'consequences', label: 'Consequences', type: FieldType.longText),
      ]),
    ]),
  ];
}
