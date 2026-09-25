import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/features/campaigns/campaigns_screen.dart';
import 'package:gmh/app/template_l10n.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/link.dart';
import 'package:gmh/domain/services/templates/entity_templates.dart';

void main() {
  test('every entity kind has a template', () {
    for (final kind in EntityKind.values) {
      expect(() => EntityTemplates.of(kind), returnsNormally,
          reason: 'missing template for $kind');
    }
  });

  test('D&D stat card fields exist on spells, creatures and items', () {
    Set<String> keysOf(EntityKind kind) => EntityTemplates.of(kind)
        .sections
        .expand((s) => s.fields)
        .map((f) => f.key)
        .toSet();

    expect(
        keysOf(EntityKind.magicSystem),
        containsAll(['level', 'school', 'castingTime', 'range',
          'components', 'duration', 'higherLevels',
          // legacy worldbuilding fields must survive
          'source', 'rules', 'costs']));
    expect(
        keysOf(EntityKind.creature),
        containsAll(['ac', 'hp', 'speed', 'strength', 'charisma',
          'savingThrows', 'senses', 'languages', 'actions',
          'legendaryActions',
          // legacy keys must survive
          'creatureType', 'challenge', 'size', 'habitat', 'abilities']));
    expect(keysOf(EntityKind.item),
        containsAll(['weight', 'value', 'charges', 'itemType', 'rarity']));
    expect(keysOf(EntityKind.location),
        containsAll(['climate', 'inhabitants', 'locationType']));
  });

  test('extractEntityRefs mirrors ref and refList fields with roles', () {
    final template = EntityTemplates.of(EntityKind.item);
    final refs = template.extractEntityRefs({
      'currentOwner': entityRefValue('owner-1'),
      'forgedAt': entityRefValue('forge-2'),
      'relatedEvents': [entityRefValue('war-3'), entityRefValue('war-4')],
      'rarity': 'Legendary', // not a ref — ignored
    });

    expect(refs, {
      'owner-1': {LinkRoles.owner},
      'forge-2': {LinkRoles.createdAt},
      'war-3': {LinkRoles.participatedIn},
      'war-4': {LinkRoles.participatedIn},
    });
  });

  test('one target referenced from two fields keeps both roles', () {
    final template = EntityTemplates.of(EntityKind.item);
    final refs = template.extractEntityRefs({
      'currentOwner': entityRefValue('smith'),
      'forgedAt': entityRefValue('smith'),
    });
    expect(refs, {
      'smith': {LinkRoles.owner, LinkRoles.createdAt},
    });
  });

  test('sanitize coerces types and preserves unknown keys', () {
    final template = EntityTemplates.of(EntityKind.quest);
    final sanitized = template.sanitize({
      'status': 'NotARealStatus', // invalid select value → dropped
      'objectives': [
        {'text': 'Find it', 'done': true},
        {'text': 42, 'done': 'yes'}, // coerced
      ],
      'rewards': 123, // coerced to string
      'futureField': 'kept', // unknown → preserved
    });

    expect(sanitized.containsKey('status'), isFalse);
    expect(sanitized['objectives'], [
      {'text': 'Find it', 'done': true},
      {'text': '42', 'done': false},
    ]);
    expect(sanitized['rewards'], '123');
    expect(sanitized['futureField'], 'kept');
  });

  test('character template keeps all legacy field keys (data preservation)',
      () {
    final template = EntityTemplates.of(EntityKind.character);
    final keys = template.allFields.map((f) => f.key).toSet();
    // Keys that existed before the profile overhaul must survive so no
    // previously entered character data is orphaned.
    for (final legacy in [
      'title', 'race', 'characterClass', 'alignment', 'status',
      'homeLocation', 'factions', 'goals', 'secrets', 'voice',
    ]) {
      expect(keys, contains(legacy), reason: 'missing legacy key $legacy');
    }
    // And the new profile sections are present.
    for (final section in [
      'General Information', 'Statistics', 'Combat', 'Beliefs',
      'Relationships', 'Inventory', 'Abilities & Magic', 'Timeline', 'Notes',
    ]) {
      expect(template.sections.map((s) => s.title), contains(section));
    }
  });

  test('entity ref helpers round-trip', () {
    expect(parseEntityRef(entityRefValue('abc')), 'abc');
    expect(parseEntityRef('not-a-ref'), isNull);
    expect(parseEntityRef(null), isNull);
    expect(parseEntityRef('entity:'), isNull);
  });

  test('every template term is translated for Russian and Chinese', () {
    final terms = <String>{};
    for (final k in EntityKind.values) {
      for (final section in EntityTemplates.of(k).sections) {
        terms.add(section.title);
        for (final f in section.fields) {
          terms.add(f.label);
          if (f.hint.isNotEmpty) terms.add(f.hint);
          terms.addAll(f.options);
        }
      }
    }
    // Scripts differ from English, so an untranslated term is exactly one
    // that comes back unchanged.
    for (final lang in ['ru', 'zh']) {
      expect([for (final t in terms) if (trTemplateFor(lang, t) == t) t],
          isEmpty, reason: lang);
    }
  });

  test('next session number follows the highest one in use', () {
    Entity session(String name) => Entity(
        id: name,
        worldId: 'w',
        kind: EntityKind.session,
        name: name,
        createdAt: 0,
        updatedAt: 0);
    expect(nextSessionNumber(const []), 1);
    expect(
        nextSessionNumber([
          session('Session 12 — The Storm'),
          session('Session 10 — The Broken Oath'),
        ]),
        13);
    expect(nextSessionNumber([session('Prologue')]), 2);
  });
}
