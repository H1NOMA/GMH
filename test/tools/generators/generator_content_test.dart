import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/generators/content/content.dart';
import 'package:gmh/domain/generators/content_format.dart';
import 'package:gmh/domain/generators/grammar.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/services/templates/entity_templates.dart';

/// Lists every pack writes itself, in every language.
const _required = [
  'cultures',
  'epithet',
  'ancestry',
  'role',
  'settle_size',
  'settle_feature',
  'settle_trouble',
  'settle_authority',
  'est_type',
  'est_adj',
  'est_noun',
  'est_specialty',
  'est_patron',
  'hook_title',
  'hook_who',
  'hook_wants',
  'hook_obstacle',
  'hook_twist',
  'loot_container',
  'loot_coin',
  'loot_item',
  'loot_curio',
  'faction_noun',
  'faction_of',
  'faction_goal',
  'faction_method',
  'faction_symbol',
  'weather_sky',
  'weather_air',
  'weather_omen',
  'rumor_source',
  'rumor_text',
];

bool _has(Map<String, List<Fragment>> lists, String name) =>
    (lists[name]?.isNotEmpty ?? false) ||
    ((lists['${name}_m']?.isNotEmpty ?? false) &&
        (lists['${name}_f']?.isNotEmpty ?? false));

bool _resolves(FragmentLibrary lib, String name) =>
    lib.has(name) || (lib.has('${name}_m') && lib.has('${name}_f'));

List<String> _options(EntityKind kind, String key) =>
    EntityTemplates.of(kind).field(key)!.options;

void _expectCleanLists(Map<String, List<Fragment>> lists, String where) {
  lists.forEach((name, entries) {
    expect(entries, isNotEmpty, reason: '$where $name');
    final seen = <String>{};
    for (final f in entries) {
      expect(f.text.trim(), isNotEmpty, reason: '$where $name');
      expect(f.text, f.text.trim(), reason: '$where $name "${f.text}"');
      expect(seen.add(f.text), isTrue,
          reason: '$where $name duplicate "${f.text}"');
    }
  });
}

void main() {
  group('Shared content', () {
    test('every language has every shared list, without empties or repeats',
        () {
      final en = commonContent.lists['en']!.keys.toSet();
      for (final lang in generatorLanguages) {
        final lists = commonContent.lists[lang]!;
        _expectCleanLists(lists, 'common/$lang');
        for (final name in en) {
          if (name.endsWith('_m') || name.endsWith('_f')) continue;
          expect(_has(lists, name), isTrue, reason: '$lang lacks $name');
        }
      }
    });

    test('ability abbreviations and gender words exist in every language',
        () {
      for (final lang in generatorLanguages) {
        final lists = commonContent.lists[lang]!;
        expect(lists['stat_abbr'], hasLength(6), reason: lang);
        expect(lists['gender_word']!.map((f) => f.tag).toSet(), {'f', 'm'},
            reason: lang);
      }
    });

    test('shared lists translate row by row', () {
      final en = commonContent.lists['en']!;
      for (final lang in generatorLanguages) {
        final lists = commonContent.lists[lang]!;
        for (final name in ['trait', 'voice', 'appearance', 'motivation']) {
          expect(lists[name]!.length, en[name]!.length,
              reason: '$lang $name');
        }
      }
    });
  });

  for (final style in WorldStyle.values) {
    group('${style.name} pack', () {
      final pack = packContent(style);

      test('writes every generator list in all five languages', () {
        for (final lang in generatorLanguages) {
          final lists = pack.lists[lang]!;
          for (final name in _required) {
            expect(_has(lists, name), isTrue, reason: '$lang lacks $name');
          }
        }
      });

      test('has no empty or duplicate entries', () {
        for (final lang in generatorLanguages) {
          _expectCleanLists(pack.lists[lang]!, '${style.name}/$lang');
        }
      });

      test('every referenced list exists in every language', () {
        for (final lang in generatorLanguages) {
          final lib = generatorLibrary(style, lang);
          final names = {
            ...pack.lists[lang]!.keys,
            ...pack.lists['en']!.keys,
            ...commonContent.lists[lang]!.keys,
          };
          for (final name in names) {
            for (final f in lib.list(name) ?? const <Fragment>[]) {
              for (final ref in Grammar.references(f.text)) {
                expect(_resolves(lib, ref), isTrue,
                    reason: '$lang $name → {$ref} in "${f.text}"');
              }
            }
          }
        }
      });

      test('every name culture has names in every language', () {
        for (final lang in generatorLanguages) {
          final lists = pack.lists[lang]!;
          final cultures = lists['cultures']!;
          expect(cultures.length, greaterThanOrEqualTo(2));
          for (final c in cultures) {
            expect(c.tag, isNotNull, reason: '$lang ${c.text}');
            expect(_has(lists, '${c.tag}_given'), isTrue,
                reason: '$lang ${c.tag}_given');
          }
        }
      });

      test('overridden naming patterns cover all five languages', () {
        final overridden = {
          for (final lang in generatorLanguages)
            ...pack.lists[lang]!.keys.where(patternLists.contains),
        };
        for (final name in overridden) {
          for (final lang in generatorLanguages) {
            expect(pack.lists[lang]!.containsKey(name), isTrue,
                reason: '$lang lacks $name');
          }
        }
      });

      test('tags are valid template options and culture ids', () {
        final locationTypes = _options(EntityKind.location, 'locationType');
        final factionTypes = _options(EntityKind.faction, 'factionType');
        for (final lang in generatorLanguages) {
          final lists = pack.lists[lang]!;
          final cultureIds = {for (final c in lists['cultures']!) c.tag};
          for (final f in lists['settle_size']!) {
            expect(locationTypes, contains(f.tag), reason: '$lang ${f.text}');
          }
          for (final f in lists['faction_noun']!) {
            expect(factionTypes, contains(f.tag), reason: '$lang ${f.text}');
          }
          for (final f in lists['ancestry']!) {
            if (f.tag != null) {
              expect(cultureIds, contains(f.tag), reason: '$lang ${f.text}');
            }
          }
        }
      });

      test('translated lists keep the same length in every language', () {
        final en = pack.lists['en']!;
        for (final name in _required) {
          if (!en.containsKey(name)) continue;
          for (final lang in generatorLanguages) {
            final lists = pack.lists[lang]!;
            // Word-building lists (settlement parts, establishment
            // adjectives and nouns) are written per language.
            if (name.startsWith('est_adj') || name.startsWith('est_noun')) {
              continue;
            }
            expect(lists[name]?.length, en[name]!.length,
                reason: '$lang $name');
          }
        }
      });
    });
  }
}
