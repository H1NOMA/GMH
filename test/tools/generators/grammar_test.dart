import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/generators/content_format.dart';
import 'package:gmh/domain/generators/grammar.dart';

import '../dice/scripted_random.dart';

MapLibrary _lib(Map<String, List<String>> lists) => MapLibrary({
      for (final e in lists.entries)
        e.key: [for (final t in e.value) Fragment(t)],
    });

GrammarContext _ctx(
  Map<String, List<String>> lists, {
  int seed = 1,
  Map<String, String>? vars,
  bool strict = false,
}) =>
    GrammarContext(
      random: Random(seed),
      library: _lib(lists),
      vars: vars,
      strict: strict,
    );

void main() {
  group('Grammar slots', () {
    test('plain text passes through', () {
      expect(Grammar.expand('A quiet night.', _ctx({})), 'A quiet night.');
    });

    test('a slot picks an entry of its list', () {
      final ctx = _ctx({
        'color': ['red', 'green', 'blue'],
      });
      expect(['red', 'green', 'blue'],
          contains(Grammar.expand('{color}', ctx)));
    });

    test('entries are expanded recursively', () {
      final ctx = _ctx({
        'phrase': ['the {adj} {noun}'],
        'adj': ['old'],
        'noun': ['mill'],
      });
      expect(Grammar.expand('{phrase}', ctx), 'the old mill');
    });

    test('capitalization modifiers', () {
      final lists = {
        'w': ['the old mill'],
      };
      expect(Grammar.expand('{w:cap}', _ctx(lists)), 'The old mill');
      expect(Grammar.expand('{w:upper}', _ctx(lists)), 'THE OLD MILL');
      expect(Grammar.expand('{w:title}', _ctx(lists)), 'The Old Mill');
      expect(
          Grammar.expand('{w:lower}', _ctx({'w': ['LOUD']})), 'loud');
    });

    test('variables are substituted, with modifiers', () {
      final ctx = _ctx({}, vars: {'name': 'mira'});
      expect(Grammar.expand('Hi {=name}, {=name:cap}!', ctx),
          'Hi mira, Mira!');
    });

    test('dice slots roll with the context random', () {
      final ctx = GrammarContext(
        random: ScriptedRandom([2, 4]), // d6 faces 3 and 5
        library: _lib({}),
      );
      expect(Grammar.expand('{#2d6*10} gold', ctx), '80 gold');
    });

    test('unknown lists stay literal unless strict', () {
      expect(Grammar.expand('a {missing} b', _ctx({})), 'a {missing} b');
      expect(() => Grammar.expand('{missing}', _ctx({}, strict: true)),
          throwsA(isA<GrammarException>()));
      expect(() => Grammar.expand('{=nobody}', _ctx({}, strict: true)),
          throwsA(isA<GrammarException>()));
    });

    test('malformed templates are rejected', () {
      for (final bad in ['{open', 'close}', '[half', '{a:shout}', '{a b}']) {
        expect(() => Grammar.references(bad),
            throwsA(isA<GrammarException>()), reason: bad);
      }
    });

    test('references collects every list a template uses', () {
      expect(Grammar.references('{a} {b|{c:cap}} [{d}] {=v} {#d6}'),
          {'a', 'c', 'd'});
    });

    test('runaway recursion is stopped', () {
      final ctx = _ctx({
        'loop': ['again {loop}'],
      });
      expect(() => Grammar.expand('{loop}', ctx),
          throwsA(isA<GrammarException>()));
    });
  });

  group('Grammar alternatives and optional parts', () {
    test('alternatives pick one option each time', () {
      final seen = <String>{};
      for (var seed = 0; seed < 40; seed++) {
        seen.add(Grammar.expand('{north|south|east}', _ctx({}, seed: seed)));
      }
      expect(seen, {'north', 'south', 'east'});
    });

    test('alternatives may contain slots', () {
      final lists = {
        'beast': ['wolf'],
      };
      final seen = <String>{};
      for (var seed = 0; seed < 30; seed++) {
        seen.add(Grammar.expand('{a {beast}|none}', _ctx(lists, seed: seed)));
      }
      expect(seen, {'a wolf', 'none'});
    });

    test('an empty alternative makes a part optional', () {
      final seen = <String>{};
      for (var seed = 0; seed < 30; seed++) {
        seen.add(Grammar.expand('old{| grey} wolf', _ctx({}, seed: seed)));
      }
      expect(seen, {'old wolf', 'old grey wolf'});
    });

    test('bracketed parts appear about half of the time', () {
      var shown = 0;
      for (var seed = 0; seed < 200; seed++) {
        if (Grammar.expand('wolf[ pack]', _ctx({}, seed: seed)) ==
            'wolf pack') {
          shown++;
        }
      }
      expect(shown, inInclusiveRange(60, 140));
    });

    test('tidy collapses spaces left by optional parts', () {
      expect(Grammar.tidy('a  b ,c .  «  d'), 'a b,c. «d');
      expect(Grammar.tidy('Bonjour ; ça va ?'), 'Bonjour ; ça va ?');
    });

    test('capitalize skips opening quotes', () {
      expect(Grammar.capitalize('«red crane»'), '«Red crane»');
      expect(Grammar.capitalize('“iron”'), '“Iron”');
      expect(Grammar.capitalize(''), '');
    });
  });

  group('No repeats within one result', () {
    test('a list never repeats until it is exhausted', () {
      for (var seed = 0; seed < 25; seed++) {
        final ctx = _ctx({
          'n': ['a', 'b', 'c', 'd'],
        }, seed: seed);
        final out = Grammar.expand('{n} {n} {n} {n}', ctx).split(' ');
        expect(out.toSet(), hasLength(4), reason: 'seed $seed');
      }
    });

    test('an exhausted list falls back to any entry', () {
      final ctx = _ctx({
        'n': ['a', 'b'],
      });
      final out = Grammar.expand('{n} {n} {n}', ctx).split(' ');
      expect(out, hasLength(3));
      expect(out.toSet(), {'a', 'b'});
    });

    test('the memory is shared across expansions of one context', () {
      final ctx = _ctx({
        'n': ['a', 'b', 'c'],
      });
      final picks = [for (var i = 0; i < 3; i++) Grammar.expand('{n}', ctx)];
      expect(picks.toSet(), hasLength(3));
    });

    test('child contexts share the memory but not the variables', () {
      final ctx = _ctx({
        'n': ['a', 'b'],
      }, vars: {'x': '1'});
      final child = ctx.child({'y': '2'});
      final a = Grammar.expand('{n}', ctx);
      final b = Grammar.expand('{n}', child);
      expect(a, isNot(b));
      expect(child.vars.containsKey('x'), isFalse);
      expect(ctx.vars.containsKey('y'), isFalse);
    });
  });

  group('Gender', () {
    test('a gender variable selects the gendered list', () {
      final lists = {
        'hero': ['hero'],
        'hero_f': ['heroine'],
        'hero_m': ['hero'],
      };
      expect(Grammar.expand('{hero}', _ctx(lists, vars: {'gender': 'f'})),
          'heroine');
      expect(Grammar.expand('{hero}', _ctx(lists, vars: {'gender': 'm'})),
          'hero');
      expect(Grammar.expand('{hero}', _ctx(lists)), 'hero');
    });

    test('lists without a gendered variant ignore the gender', () {
      expect(
          Grammar.expand('{x}', _ctx({'x': ['same']}, vars: {'gender': 'f'})),
          'same');
    });

    test('a gendered pick also blocks the base entry', () {
      final ctx = _ctx({
        'w': ['a', 'b'],
        'w_f': ['a', 'b'],
      }, vars: {'gender': 'f'});
      final first = Grammar.expand('{w}', ctx);
      ctx.vars.remove('gender');
      expect(Grammar.expand('{w}', ctx), isNot(first));
    });
  });

  group('Determinism and tags', () {
    test('the same seed gives the same text', () {
      final lists = {
        's': ['{a} {b|c} [{a}] {#3d6}'],
        'a': ['x', 'y', 'z', 'w'],
      };
      for (var seed = 0; seed < 10; seed++) {
        expect(Grammar.expand('{s}', _ctx(lists, seed: seed)),
            Grammar.expand('{s}', _ctx(lists, seed: seed)));
      }
    });

    test('tags of picks are recorded', () {
      final ctx = GrammarContext(
        random: Random(1),
        library: MapLibrary({
          'size': [const Fragment('a village', 'Village')],
        }),
      );
      Grammar.expand('{size}', ctx);
      expect(ctx.tags['size'], 'Village');
      expect(ctx.takeFirstTag(), 'Village');
      expect(ctx.takeFirstTag(), isNull);
    });
  });

  group('Libraries', () {
    test('layers are merged, exclusive lists come from the first layer', () {
      final lib = LayeredLibrary([
        _lib({
          'trait': ['brave'],
          'pattern': ['A'],
        }),
        _lib({
          'trait': ['shy'],
          'pattern': ['B'],
          'other': ['o'],
        }),
      ], exclusive: {'pattern'});
      expect(lib.list('trait')!.map((f) => f.text), ['brave', 'shy']);
      expect(lib.list('pattern')!.map((f) => f.text), ['A']);
      expect(lib.list('other')!.map((f) => f.text), ['o']);
      expect(lib.list('nothing'), isNull);
      expect(lib.has('nothing'), isFalse);
    });

    test('rows spread across languages; one cell means all languages', () {
      final content = PackContent.build(rows: {
        'x': 'one ¦ один ¦ eins ¦ un ¦ 一\nsame',
      });
      expect(content.library('de').list('x')!.map((f) => f.text),
          ['eins', 'same']);
      expect(content.library('zh').list('x')!.first.text, '一');
    });

    test('names use Latin, Cyrillic and Chinese renderings', () {
      final content = PackContent.build(names: {
        'n': 'Mira ¦ Мира ¦米拉',
      });
      expect(content.library('en').list('n')!.single.text, 'Mira');
      expect(content.library('fr').list('n')!.single.text, 'Mira');
      expect(content.library('ru').list('n')!.single.text, 'Мира');
      expect(content.library('zh').list('n')!.single.text, '米拉');
    });

    test('gender markers split lists', () {
      final content = PackContent.build(perLang: {
        'ru': {
          'noun': 'Ворон #m\nСова #f',
          'adj': 'старый~старая',
        },
      });
      final ru = content.library('ru');
      expect(ru.list('noun')!.map((f) => f.text), ['Ворон', 'Сова']);
      expect(ru.list('noun_m')!.single.text, 'Ворон');
      expect(ru.list('noun_f')!.single.text, 'Сова');
      expect(ru.list('adj_f')!.single.text, 'старая');
      expect(ru.list('adj')!.single.text, 'старый');
    });

    test('tags and comments are parsed', () {
      final content = PackContent.build(rows: {
        'x': '// a comment\n@Village a hamlet',
      });
      final entry = content.library('en').list('x')!.single;
      expect(entry.text, 'a hamlet');
      expect(entry.tag, 'Village');
    });

    test('missing languages fall back to English, gender splits do not', () {
      final content = PackContent.build(perLang: {
        'en': {
          'only': 'english',
          'w': 'he~she',
        },
        'de': {'w': 'er'},
      });
      expect(content.library('de').list('only')!.single.text, 'english');
      expect(content.library('de').list('w_f'), isNull);
      expect(content.library('en').list('w_f')!.single.text, 'she');
    });

    test('bad cell counts are rejected', () {
      expect(() => PackContent.build(rows: {'x': 'a ¦ b'}),
          throwsFormatException);
      expect(() => PackContent.build(names: {'x': 'a ¦ b'}),
          throwsFormatException);
      expect(() => PackContent.build(perLang: {'xx': {'x': 'a'}}),
          throwsFormatException);
    });
  });
}
