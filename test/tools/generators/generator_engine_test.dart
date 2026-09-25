import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/generators/content_format.dart';
import 'package:gmh/domain/generators/generator_engine.dart';
import 'package:gmh/domain/generators/grammar.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/entity_template.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/services/templates/entity_templates.dart';

const _composites = [
  GeneratorKind.npc,
  GeneratorKind.settlement,
  GeneratorKind.establishment,
  GeneratorKind.hook,
  GeneratorKind.loot,
  GeneratorKind.faction,
  GeneratorKind.weather,
  GeneratorKind.rumor,
];

String _label(String key) => '<$key>';

bool _clean(String text) =>
    text.trim().isNotEmpty &&
    !text.contains('{') &&
    !text.contains('}') &&
    !text.contains('[') &&
    !text.contains(']') &&
    !text.contains('  ') &&
    !text.contains('¦') &&
    !text.contains('~');

/// Checks [attributes] against the template of [kind]: only known keys,
/// select values among the options, numbers as numbers, and nothing that
/// sanitize() would drop.
void _expectValidAttributes(
    EntityKind kind, Map<String, Object?> attributes, String reason) {
  final template = EntityTemplates.of(kind);
  for (final MapEntry(:key, :value) in attributes.entries) {
    final def = template.field(key);
    expect(def, isNotNull, reason: '$reason: unknown key $key');
    switch (def!.type) {
      case FieldType.select:
        expect(def.options, contains(value), reason: '$reason: $key=$value');
      case FieldType.number:
        expect(value, isA<int>(), reason: '$reason: $key');
      case FieldType.checklist:
        expect(value, isA<List>(), reason: '$reason: $key');
      default:
        expect(value, isA<String>(), reason: '$reason: $key');
        expect((value as String).contains('{'), isFalse,
            reason: '$reason: $key');
    }
  }
  expect(template.sanitize(attributes), attributes, reason: reason);
}

void main() {
  group('Every generator in every pack and language', () {
    for (final style in WorldStyle.values) {
      test('${style.name}: clean output over many seeds', () {
        for (final lang in generatorLanguages) {
          for (var seed = 0; seed < 25; seed++) {
            final engine = GeneratorEngine(random: Random(seed));
            for (final kind in _composites) {
              final r = engine.generate(kind, style: style, language: lang);
              expect(r.fields, isNotEmpty);
              for (final f in r.fields) {
                expect(_clean(f.value), isTrue,
                    reason: '$lang ${kind.name}.${f.key} "${f.value}"');
              }
              if (r.titleKey != null) expect(r.title, isNotEmpty);
            }
            for (final n in engine.names(
                style: style,
                language: lang,
                count: 4,
                epithets: seed.isOdd)) {
              expect(_clean(n.toText()), isTrue,
                  reason: '$lang name "${n.toText()}"');
            }
          }
        }
      });

      test('${style.name}: saved results fit the entity templates', () {
        for (final lang in generatorLanguages) {
          for (var seed = 0; seed < 12; seed++) {
            final engine = GeneratorEngine(random: Random(seed));
            for (final kind in _composites) {
              final r = engine.generate(kind, style: style, language: lang);
              final draft = engine.toEntity(r, _label);
              expect(draft.name.trim(), isNotEmpty);
              _expectValidAttributes(
                  draft.kind, draft.attributes, '$lang ${kind.name}');
            }
            for (final n in engine.names(style: style, language: lang)) {
              final draft = engine.nameToEntity(n, style, lang);
              expect(draft.kind, EntityKind.character);
              expect(draft.name, n.name);
              _expectValidAttributes(
                  draft.kind, draft.attributes, '$lang name');
            }
          }
        }
      });

      test('${style.name}: at least two name cultures in every language', () {
        final engine = GeneratorEngine(random: Random(1));
        final ids = engine.cultures(style, 'en').map((c) => c.id).toList();
        expect(ids.length, greaterThanOrEqualTo(2));
        for (final lang in generatorLanguages) {
          expect(engine.cultures(style, lang).map((c) => c.id), ids);
          for (final id in ids) {
            final names = engine.names(
                style: style, language: lang, cultureId: id, count: 6);
            expect(names.every((n) => n.cultureId == id), isTrue);
          }
        }
      });
    }
  });

  group('Names', () {
    test('count is clamped to 1–10', () {
      final engine = GeneratorEngine(random: Random(2));
      expect(
          engine.names(style: WorldStyle.fantasy, language: 'en', count: 0),
          hasLength(1));
      expect(
          engine.names(style: WorldStyle.fantasy, language: 'en', count: 50),
          hasLength(10));
    });

    test('gender filter is respected', () {
      final engine = GeneratorEngine(random: Random(3));
      for (final style in WorldStyle.values) {
        expect(
            engine
                .names(
                    style: style,
                    language: 'en',
                    gender: NameGender.feminine,
                    count: 10)
                .every((n) => n.gender == 'f'),
            isTrue);
        expect(
            engine
                .names(
                    style: style,
                    language: 'en',
                    gender: NameGender.masculine,
                    count: 10)
                .every((n) => n.gender == 'm'),
            isTrue);
      }
    });

    test('given and family names differ by gender (fantasy humans)', () {
      final engine = GeneratorEngine(random: Random(4));
      final f = engine.names(
          style: WorldStyle.fantasy,
          language: 'en',
          cultureId: 'human',
          gender: NameGender.feminine,
          count: 10);
      final m = engine.names(
          style: WorldStyle.fantasy,
          language: 'en',
          cultureId: 'human',
          gender: NameGender.masculine,
          count: 10);
      expect(f.every((n) => n.name.contains(' ')), isTrue);
      final fGiven = {for (final n in f) n.name.split(' ').first};
      final mGiven = {for (final n in m) n.name.split(' ').first};
      expect(fGiven.intersection(mGiven), isEmpty);
    });

    test('epithets change the display but not the name', () {
      final engine = GeneratorEngine(random: Random(5));
      for (final lang in generatorLanguages) {
        for (final n in engine.names(
            style: WorldStyle.fantasy, language: lang, epithets: true)) {
          expect(n.epithet, isNotNull);
          expect(n.display, contains(n.name));
          expect(n.display, isNot(n.name));
        }
      }
    });

    test('names in one batch do not repeat', () {
      for (var seed = 0; seed < 10; seed++) {
        final engine = GeneratorEngine(random: Random(seed));
        final names = engine.names(
            style: WorldStyle.fantasy, language: 'en', count: 10);
        expect(names.map((n) => n.name).toSet(), hasLength(10));
      }
    });

    test('Russian names are Cyrillic and Chinese names use Chinese script',
        () {
      final latin = RegExp('[A-Za-z]');
      for (final style in WorldStyle.values) {
        for (var seed = 0; seed < 8; seed++) {
          final engine = GeneratorEngine(random: Random(seed));
          for (final n in engine.names(
              style: style, language: 'ru', count: 10)) {
            expect(latin.hasMatch(n.name), isFalse,
                reason: '${style.name} ru ${n.name}');
          }
          for (final n in engine.names(
              style: style, language: 'zh', count: 10)) {
            expect(latin.hasMatch(n.name), isFalse,
                reason: '${style.name} zh ${n.name}');
          }
        }
      }
    });

    test('wuxia uses real Chinese characters and pinyin elsewhere', () {
      final han = RegExp(r'^[一-鿿·]+$');
      final engine = GeneratorEngine(random: Random(6));
      for (final n in engine.names(
          style: WorldStyle.wuxia,
          language: 'zh',
          cultureId: 'jianghu',
          count: 10)) {
        expect(han.hasMatch(n.name), isTrue, reason: n.name);
        expect(n.name.length, inInclusiveRange(2, 4));
      }
      final pinyin = RegExp(r"^[A-Z][a-z']+( [A-Z][a-z']+)+$");
      for (final lang in ['en', 'de', 'fr']) {
        for (final n in engine.names(
            style: WorldStyle.wuxia,
            language: lang,
            cultureId: 'jianghu',
            count: 10)) {
          expect(pinyin.hasMatch(n.name), isTrue, reason: n.name);
          expect(n.note, isNotNull);
        }
      }
    });

    test('a name becomes a character with a gender word', () {
      final engine = GeneratorEngine(random: Random(7));
      final n = engine
          .names(
              style: WorldStyle.fantasy,
              language: 'de',
              gender: NameGender.feminine,
              epithets: true,
              count: 1)
          .single;
      final draft = engine.nameToEntity(n, WorldStyle.fantasy, 'de');
      expect(draft.attributes['gender'], 'weiblich');
      expect(draft.attributes['title'], n.epithet);
      expect(draft.attributes['race'], isNotNull);
    });
  });

  group('Composite results', () {
    test('the same seed gives identical results', () {
      for (final kind in _composites) {
        final a = GeneratorEngine(random: Random(42))
            .generate(kind, style: WorldStyle.steampunk, language: 'fr');
        final b = GeneratorEngine(random: Random(42))
            .generate(kind, style: WorldStyle.steampunk, language: 'fr');
        expect([for (final f in a.fields) f.value],
            [for (final f in b.fields) f.value]);
      }
      final a = GeneratorEngine(random: Random(9))
          .names(style: WorldStyle.wuxia, language: 'zh', count: 10);
      final b = GeneratorEngine(random: Random(9))
          .names(style: WorldStyle.wuxia, language: 'zh', count: 10);
      expect(a.map((n) => n.toText()), b.map((n) => n.toText()));
    });

    test('different seeds give different NPCs', () {
      final seen = <String>{};
      for (var seed = 0; seed < 10; seed++) {
        seen.add(GeneratorEngine(random: Random(seed))
            .generate(GeneratorKind.npc,
                style: WorldStyle.fantasy, language: 'en')
            .fields
            .map((f) => f.value)
            .join('|'));
      }
      expect(seen, hasLength(10));
    });

    test('field keys follow the declared order', () {
      final engine = GeneratorEngine(random: Random(1));
      for (final kind in _composites) {
        final r = engine.generate(kind,
            style: WorldStyle.cyberpunk, language: 'en');
        expect([for (final f in r.fields) f.key],
            GeneratorEngine.fieldKeys(kind));
      }
    });

    test('names() is the only way to generate names', () {
      expect(
          () => GeneratorEngine().generate(GeneratorKind.names,
              style: WorldStyle.fantasy, language: 'en'),
          throwsArgumentError);
    });

    test('unknown languages fall back to English', () {
      final r = GeneratorEngine(random: Random(1)).generate(
          GeneratorKind.hook,
          style: WorldStyle.fantasy,
          language: 'es');
      expect(r.language, 'en');
      expect(GeneratorEngine.normalizeLanguage('zh'), 'zh');
    });

    test('NPC ability scores are 4d6-keep-3 values', () {
      for (var seed = 0; seed < 20; seed++) {
        final engine = GeneratorEngine(random: Random(seed));
        final r = engine.generate(GeneratorKind.npc,
            style: WorldStyle.fantasy, language: 'en');
        final scores = r.vars['stats']!.split(',').map(int.parse).toList();
        expect(scores, hasLength(6));
        expect(scores.every((s) => s >= 3 && s <= 18), isTrue);
        expect(r.value('attributes'), startsWith('STR ${scores.first}'));
        final draft = engine.toEntity(r, _label);
        expect(draft.attributes['charisma'], scores.last);
      }
    });

    test('NPC ancestry matches the name culture when it names one', () {
      final elf = RegExp('elf', caseSensitive: false);
      var checked = 0;
      for (var seed = 0; seed < 60; seed++) {
        final r = GeneratorEngine(random: Random(seed)).generate(
            GeneratorKind.npc,
            style: WorldStyle.fantasy,
            language: 'en');
        if (r.field('ancestry')?.tag == 'elf') {
          checked++;
          expect(r.vars['culture'], 'elf');
          expect(elf.hasMatch(r.value('ancestry')), isTrue);
        }
      }
      expect(checked, greaterThan(0));
    });

    test('rerolling one field keeps the others', () {
      final engine = GeneratorEngine(random: Random(11));
      final r = engine.generate(GeneratorKind.npc,
          style: WorldStyle.gothicHorror, language: 'ru');
      for (final key in ['secret', 'name', 'attributes', 'trait']) {
        final next = engine.rerollField(r, key);
        expect(next.id, r.id);
        expect(next.value(key), isNot(r.value(key)), reason: key);
        for (final f in r.fields.where((f) => f.key != key)) {
          expect(next.value(f.key), f.value);
        }
      }
    });

    test('rerolled fields never reuse a fragment of the result', () {
      final engine = GeneratorEngine(random: Random(12));
      var r = engine.generate(GeneratorKind.loot,
          style: WorldStyle.fantasy, language: 'en');
      for (var i = 0; i < 6; i++) {
        r = engine.rerollField(r, 'item2');
        final items = [r.value('item1'), r.value('item2'), r.value('item3')];
        expect(items.toSet(), hasLength(3));
      }
    });

    test('rerolling an unknown field returns the result unchanged', () {
      final engine = GeneratorEngine(random: Random(1));
      final r = engine.generate(GeneratorKind.weather,
          style: WorldStyle.fantasy, language: 'en');
      expect(identical(engine.rerollField(r, 'nope'), r), isTrue);
    });

    test('reroll all keeps the card identity', () {
      final engine = GeneratorEngine(random: Random(13));
      final r = engine.generate(GeneratorKind.faction,
          style: WorldStyle.wildWest, language: 'de');
      final next = engine.rerollAll(r);
      expect(next.id, r.id);
      expect(next.kind, r.kind);
      expect(next.fields.map((f) => f.value),
          isNot(r.fields.map((f) => f.value)));
    });

    test('toText lists the title then labeled fields', () {
      final r = GeneratorEngine(random: Random(1)).generate(
          GeneratorKind.settlement,
          style: WorldStyle.fantasy,
          language: 'en');
      final lines = r.toText(_label).split('\n');
      expect(lines.first, r.title);
      expect(lines, hasLength(r.fields.length));
      expect(lines[1], '<size>: ${r.value('size')}');
      final weather = GeneratorEngine(random: Random(1)).generate(
          GeneratorKind.weather,
          style: WorldStyle.fantasy,
          language: 'en');
      expect(weather.title, isEmpty);
      expect(weather.toText(_label, heading: 'Weather').split('\n').first,
          'Weather');
    });

    test('titles are not repeated among body fields', () {
      final r = GeneratorEngine(random: Random(1)).generate(GeneratorKind.npc,
          style: WorldStyle.fantasy, language: 'en');
      expect(r.bodyFields.any((f) => f.key == 'name'), isFalse);
      expect(r.bodyFields, hasLength(r.fields.length - 1));
    });

    test('loot items share one label key', () {
      final r = GeneratorEngine(random: Random(1)).generate(GeneratorKind.loot,
          style: WorldStyle.fantasy, language: 'en');
      expect(r.fields.where((f) => f.label == 'item'), hasLength(3));
      expect(GeneratorEngine.labelKeys, contains('item'));
      expect(GeneratorEngine.labelKeys, isNot(contains('item2')));
    });
  });

  group('Entity mapping', () {
    GeneratorEngine engine() => GeneratorEngine(random: Random(21));

    test('NPC becomes a character with its details', () {
      final e = engine();
      final r = e.generate(GeneratorKind.npc,
          style: WorldStyle.fantasy, language: 'en');
      final d = e.toEntity(r, _label);
      expect(d.kind, EntityKind.character);
      expect(d.name, r.title);
      expect(d.attributes['secrets'], r.value('secret'));
      expect(d.attributes['goals'], r.value('motivation'));
      expect(d.attributes['gender'], anyOf('female', 'male'));
    });

    test('settlement becomes a location typed by its size', () {
      final e = engine();
      final types = EntityTemplates.of(EntityKind.location)
          .field('locationType')!
          .options;
      for (final style in WorldStyle.values) {
        final d = e.toEntity(
            e.generate(GeneratorKind.settlement,
                style: style, language: 'en'),
            _label);
        expect(d.kind, EntityKind.location);
        expect(types, contains(d.attributes['locationType']));
      }
    });

    test('hook becomes an idea quest with two objectives', () {
      final e = engine();
      final r =
          e.generate(GeneratorKind.hook, style: WorldStyle.wuxia, language: 'zh');
      final d = e.toEntity(r, _label);
      expect(d.kind, EntityKind.quest);
      expect(d.attributes['status'], 'Idea');
      expect(d.attributes['objectives'], [
        {'text': r.value('wants'), 'done': false},
        {'text': r.value('obstacle'), 'done': false},
      ]);
      expect(d.summary, contains('<twist>: '));
    });

    test('loot becomes treasure, faction a typed faction', () {
      final e = engine();
      final loot = e.toEntity(
          e.generate(GeneratorKind.loot,
              style: WorldStyle.spaceOpera, language: 'en'),
          _label);
      expect(loot.kind, EntityKind.item);
      expect(loot.attributes['itemType'], 'Treasure');
      final faction = e.toEntity(
          e.generate(GeneratorKind.faction,
              style: WorldStyle.cyberpunk, language: 'en'),
          _label);
      expect(faction.kind, EntityKind.faction);
      expect(faction.attributes['factionType'], isA<String>());
    });

    test('weather and rumors become concepts with short names', () {
      final e = engine();
      for (final kind in [GeneratorKind.weather, GeneratorKind.rumor]) {
        final d = e.toEntity(
            e.generate(kind, style: WorldStyle.cosmicHorror, language: 'en'),
            _label);
        expect(d.kind, EntityKind.concept);
        expect(d.name.length, lessThanOrEqualTo(61));
        expect(d.attributes['category'], '<${kind.name}>');
      }
    });

    test('shorten cuts at a word boundary', () {
      expect(GeneratorEngine.shorten('short'), 'short');
      final long = List.filled(20, 'word').join(' ');
      final cut = GeneratorEngine.shorten(long, 20);
      expect(cut, endsWith('…'));
      expect(cut.length, lessThanOrEqualTo(21));
      expect(cut.contains('wor…'), isFalse);
    });
  });

  group('Custom libraries', () {
    test('an engine can run on a small scripted library', () {
      final lib = MapLibrary({
        'cultures': [const Fragment('Folk', 'folk')],
        'folk_given': [const Fragment('Ann')],
        'folk_family': [const Fragment('Reed')],
        'full_name': [const Fragment('{=given} {=family}')],
      });
      final engine = GeneratorEngine(
          random: Random(1), libraryFor: (style, language) => lib);
      final names = engine.names(
          style: WorldStyle.fantasy, language: 'en', count: 2);
      expect(names.map((n) => n.name), ['Ann Reed', 'Ann Reed']);
      expect(engine.cultures(WorldStyle.fantasy, 'en').single.label, 'Folk');
    });
  });
}
