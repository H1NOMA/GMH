import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/tables/random_table.dart';
import 'package:gmh/domain/tables/table_text.dart';

void main() {
  group('parseTableLine', () {
    test('ranges with a pipe, colon or plain space', () {
      expect(
        parseTableLine('1-3 | Goblins'),
        const RandomTableRow('Goblins', from: 1, to: 3),
      );
      expect(
        parseTableLine('4-5: Orcs'),
        const RandomTableRow('Orcs', from: 4, to: 5),
      );
      expect(
        parseTableLine('  6 - 9   Wolves  '),
        const RandomTableRow('Wolves', from: 6, to: 9),
      );
    });

    test('en and em dashes', () {
      expect(
        parseTableLine('5–6 text'),
        const RandomTableRow('text', from: 5, to: 6),
      );
      expect(
        parseTableLine('7—8: more'),
        const RandomTableRow('more', from: 7, to: 8),
      );
    });

    test('single values', () {
      expect(
        parseTableLine('4: text'),
        const RandomTableRow('text', from: 4, to: 4),
      );
      expect(
        parseTableLine('12 | twelve'),
        const RandomTableRow('twelve', from: 12, to: 12),
      );
      expect(
        parseTableLine('3. third'),
        const RandomTableRow('third', from: 3, to: 3),
      );
      expect(
        parseTableLine('2) second'),
        const RandomTableRow('second', from: 2, to: 2),
      );
    });

    test('"00" means 100 in percentile tables', () {
      expect(
        parseTableLine('96-00 | Dragon'),
        const RandomTableRow('Dragon', from: 96, to: 100),
      );
      expect(
        parseTableLine('00: Jackpot'),
        const RandomTableRow('Jackpot', from: 100, to: 100),
      );
      expect(
        parseTableLine('0-5 | zero'),
        const RandomTableRow('zero', from: 0, to: 5),
      );
    });

    test('weights', () {
      expect(
        parseTableLine('x3 Common'),
        const RandomTableRow('Common', weight: 3),
      );
      expect(
        parseTableLine('X2 | Upper'),
        const RandomTableRow('Upper', weight: 2),
      );
      expect(
        parseTableLine('×4: Sign'),
        const RandomTableRow('Sign', weight: 4),
      );
      expect(parseTableLine('x0 Floor'), const RandomTableRow('Floor'));
    });

    test('plain lines weigh 1 and keep numbers that are not ranges', () {
      expect(
        parseTableLine('A quiet night'),
        const RandomTableRow('A quiet night'),
      );
      expect(
        parseTableLine('3.5 pounds of gold'),
        const RandomTableRow('3.5 pounds of gold'),
      );
      expect(
        parseTableLine('xylophone music'),
        const RandomTableRow('xylophone music'),
      );
      expect(
        parseTableLine('1999 was a year'),
        const RandomTableRow('1999 was a year'),
      );
    });

    test('blank lines, comments and rows without text are skipped', () {
      expect(parseTableLine(''), isNull);
      expect(parseTableLine('    '), isNull);
      expect(parseTableLine('# a comment'), isNull);
      expect(parseTableLine('   # indented comment'), isNull);
      expect(parseTableLine('1-3 |'), isNull);
      expect(parseTableLine('4:'), isNull);
    });
  });

  test('parseTableText reads mixed content and line endings', () {
    const text =
        '# Encounters\r\n'
        '1-2 | Bandits\r\n'
        '\n'
        '3: Merchant\r'
        'x2 Wolves\n'
        'Fog\n';
    expect(parseTableText(text), const [
      RandomTableRow('Bandits', from: 1, to: 2),
      RandomTableRow('Merchant', from: 3, to: 3),
      RandomTableRow('Wolves', weight: 2),
      RandomTableRow('Fog'),
    ]);
    expect(parseTableText(''), isEmpty);
  });

  group('exportTableText', () {
    test('writes ranges, single values, weights and plain rows', () {
      expect(
        exportTableText(const [
          RandomTableRow('Bandits', from: 1, to: 2),
          RandomTableRow('Merchant', from: 3, to: 3),
          RandomTableRow('Wolves', weight: 2),
          RandomTableRow('Fog'),
        ]),
        '1-2 | Bandits\n3 | Merchant\nx2 Wolves\nFog',
      );
    });

    test('escapes plain rows that would read as something else', () {
      expect(
        exportTableText(const [
          RandomTableRow('# not a comment'),
          RandomTableRow('4: looks ranged'),
          RandomTableRow('x2 looks weighted'),
          RandomTableRow('1-3 dash'),
        ]),
        'x1 # not a comment\nx1 4: looks ranged\n'
        'x1 x2 looks weighted\nx1 1-3 dash',
      );
    });

    test('drops empty rows and flattens line breaks', () {
      expect(
        exportTableText(const [
          RandomTableRow('  '),
          RandomTableRow('two\nlines\r\n here', weight: 3),
        ]),
        'x3 two lines here',
      );
    });
  });

  group('round trip', () {
    test('rows survive export and import unchanged', () {
      const rows = [
        RandomTableRow('Bandits {1d4+1}', from: 1, to: 2),
        RandomTableRow('Merchant [[Quirks]]', from: 3, to: 3),
        RandomTableRow('# hash first', from: 4, to: 4),
        RandomTableRow('Wolves', weight: 2),
        RandomTableRow('x5 literal'),
        RandomTableRow('7: literal'),
        RandomTableRow('#hashtag'),
        RandomTableRow('{a|b|c} door'),
        RandomTableRow('96-00 percent', from: 96, to: 100),
      ];
      expect(parseTableText(exportTableText(rows)), rows);
    });

    test('canonical text survives import and export', () {
      const text = '1-3 | Goblins\n4 | Ogre\nx3 Rats\nFog\nx1 # escaped';
      expect(exportTableText(parseTableText(text)), text);
    });

    test('loose input normalizes to the canonical form', () {
      expect(
        exportTableText(parseTableText('1–3 Goblins\n4: Ogre\n×2 | Rats')),
        '1-3 | Goblins\n4 | Ogre\nx2 Rats',
      );
    });
  });

  group('RandomTable codec', () {
    WorldObject object(Map<String, Object?> data) => WorldObject(
      id: 't1',
      worldId: 'w1',
      type: WorldObjectTypes.randomTable,
      name: 'Weather',
      data: data,
      sortOrder: 3,
      createdAt: 10,
      updatedAt: 20,
    );

    test('round trips through toData / fromObject', () {
      const table = RandomTable(
        id: 't1',
        worldId: 'w1',
        name: 'Weather',
        description: 'Skies',
        folder: 'Locale',
        formula: '1d6',
        rows: [
          RandomTableRow('Sun', from: 1, to: 3),
          RandomTableRow('Rain', weight: 2, from: 4, to: 6),
        ],
        source: 'library:fantasy.weather',
      );
      final back = RandomTable.fromObject(object(table.toData()));
      expect(back.name, 'Weather');
      expect(back.description, 'Skies');
      expect(back.folder, 'Locale');
      expect(back.formula, '1d6');
      expect(back.rows, table.rows);
      expect(back.source, 'library:fantasy.weather');
      expect((back.sortOrder, back.createdAt, back.updatedAt), (3, 10, 20));
      expect(back.toObject().type, WorldObjectTypes.randomTable);
    });

    test('tolerates missing and garbled data', () {
      final t = RandomTable.fromObject(
        object({
          'formula': 20,
          'rows': [
            'plain string row',
            {'text': 'zero weight', 'weight': 0},
            {'text': 'half range', 'from': 3},
            {'text': 'string numbers', 'weight': '4', 'from': '1', 'to': '2.0'},
            42,
            null,
          ],
          'source': '',
        }),
      );
      expect(t.formula, '20');
      expect(t.description, '');
      expect(t.folder, '');
      expect(t.source, RandomTableSource.user);
      expect(t.rows, const [
        RandomTableRow('plain string row'),
        RandomTableRow('zero weight'),
        RandomTableRow('half range'),
        RandomTableRow('string numbers', weight: 4, from: 1, to: 2),
        RandomTableRow(''),
        RandomTableRow(''),
      ]);
      expect(RandomTable.fromObject(object({'rows': 'nope'})).rows, isEmpty);
    });

    test('library sources', () {
      expect(RandomTableSource.library('a.b'), 'library:a.b');
      expect(RandomTableSource.libraryId('library:a.b'), 'a.b');
      expect(RandomTableSource.libraryId('user'), isNull);
    });
  });
}
