import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/tables/random_table.dart';
import 'package:gmh/domain/tables/table_ranges.dart';

List<RandomTableRow> _rows(int n, {List<int>? weights}) => [
  for (var i = 0; i < n; i++)
    RandomTableRow('row $i', weight: weights?[i] ?? 1),
];

List<(int?, int?)> _ranges(List<RandomTableRow> rows) => [
  for (final r in rows) (r.from, r.to),
];

RandomTable _table(String formula, List<(int?, int?)> ranges) => RandomTable(
  name: 'T',
  formula: formula,
  rows: [
    for (var i = 0; i < ranges.length; i++)
      RandomTableRow('r$i', from: ranges[i].$1, to: ranges[i].$2),
  ],
);

void main() {
  group('formulaBounds', () {
    test('simple dice', () {
      expect(formulaBounds('1d20'), (min: 1, max: 20));
      expect(formulaBounds('d100'), (min: 1, max: 100));
      expect(formulaBounds('2d6'), (min: 2, max: 12));
      expect(formulaBounds('d%'), (min: 1, max: 100));
    });

    test('modifiers and arithmetic', () {
      expect(formulaBounds('1d6+2'), (min: 3, max: 8));
      expect(formulaBounds('1d6-1d4'), (min: -3, max: 5));
      expect(formulaBounds('2d6*10'), (min: 20, max: 120));
      expect(formulaBounds('(1d6+1)/2'), (min: 1, max: 3));
      expect(formulaBounds('-1d4'), (min: -4, max: -1));
    });

    test('keep/drop, fate and success counting', () {
      expect(formulaBounds('4d6kh3'), (min: 3, max: 18));
      expect(formulaBounds('4d6dl1'), (min: 3, max: 18));
      expect(formulaBounds('4dF'), (min: -4, max: 4));
      expect(formulaBounds('3d6>4'), (min: 0, max: 3));
    });

    test('invalid formulas give null', () {
      expect(formulaBounds(''), isNull);
      expect(formulaBounds('1d'), isNull);
      expect(formulaBounds('banana'), isNull);
    });
  });

  group('autoRanges', () {
    test('equal weights split the die evenly', () {
      expect(_ranges(autoRanges(_rows(4), (min: 1, max: 20))), [
        (1, 5),
        (6, 10),
        (11, 15),
        (16, 20),
      ]);
    });

    test('weights share the die proportionally', () {
      expect(
        _ranges(autoRanges(_rows(2, weights: [1, 3]), (min: 1, max: 20))),
        [(1, 5), (6, 20)],
      );
      expect(
        _ranges(
          autoRanges(_rows(3, weights: [50, 30, 20]), (min: 1, max: 100)),
        ),
        [(1, 50), (51, 80), (81, 100)],
      );
    });

    test('remainders go to the earlier rows', () {
      final rows = autoRanges(_rows(12), (min: 1, max: 20));
      final sizes = [for (final r in rows) r.to! - r.from! + 1];
      expect(sizes, [2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1]);
      expect(rows.last.to, 20);
    });

    test('every row gets a value even with tiny weights', () {
      final rows = autoRanges(_rows(3, weights: [1000, 1, 1]), (
        min: 1,
        max: 10,
      ));
      expect(_ranges(rows), [(1, 8), (9, 9), (10, 10)]);
    });

    test('non-1 starts such as 2d6', () {
      expect(_ranges(autoRanges(_rows(11), (min: 2, max: 12))), [
        for (var v = 2; v <= 12; v++) (v, v),
      ]);
    });

    test('more rows than totals leaves the extra rows without a range', () {
      expect(_ranges(autoRanges(_rows(3), (min: 1, max: 2))), [
        (1, 1),
        (2, 2),
        (null, null),
      ]);
    });

    test('keeps text and weight, handles an empty list', () {
      final rows = autoRanges(
        const [RandomTableRow('a', weight: 3)],
        (min: 1, max: 6),
      );
      expect(rows.single, const RandomTableRow('a', weight: 3, from: 1, to: 6));
      expect(autoRanges(const [], (min: 1, max: 6)), isEmpty);
    });

    test('the result always validates cleanly', () {
      for (var n = 1; n <= 20; n++) {
        final rows = autoRanges(
          _rows(n, weights: [for (var i = 0; i < n; i++) i % 4 + 1]),
          (min: 1, max: 20),
        );
        expect(
          validateRanges(rows, (min: 1, max: 20)),
          isEmpty,
          reason: '$n rows',
        );
      }
    });
  });

  group('validateTable', () {
    test('a clean formula table has no issues', () {
      expect(validateTable(_table('1d6', [(1, 2), (3, 4), (5, 6)])), isEmpty);
    });

    test('weighted tables only check row texts', () {
      expect(validateTable(_table('', [(null, null), (5, 1)])), isEmpty);
      expect(
        validateTable(
          const RandomTable(
            name: 'T',
            rows: [RandomTableRow('a'), RandomTableRow(' ')],
          ),
        ),
        [
          const TableIssue(TableIssueKind.emptyRow, rows: [1]),
        ],
      );
    });

    test('empty tables', () {
      expect(validateTable(const RandomTable(name: 'T')), [
        const TableIssue(TableIssueKind.empty),
      ]);
    });

    test('a broken formula', () {
      expect(validateTable(_table('2d', [(1, 2)])), [
        const TableIssue(TableIssueKind.badFormula),
      ]);
    });

    test('gaps name the neighbouring rows', () {
      expect(validateTable(_table('1d10', [(1, 3), (6, 10)])), [
        const TableIssue(TableIssueKind.gap, rows: [0, 1], from: 4, to: 5),
      ]);
    });

    test('leading and trailing gaps', () {
      expect(validateTable(_table('1d10', [(3, 8)])), [
        const TableIssue(TableIssueKind.gap, rows: [0], from: 1, to: 2),
        const TableIssue(TableIssueKind.gap, rows: [0], from: 9, to: 10),
      ]);
    });

    test('overlaps name both rows and the shared totals', () {
      expect(validateTable(_table('1d6', [(1, 4), (3, 6)])), [
        const TableIssue(TableIssueKind.overlap, rows: [0, 1], from: 3, to: 4),
      ]);
    });

    test('overlaps are found regardless of row order', () {
      expect(validateTable(_table('1d6', [(4, 6), (1, 2), (2, 3)])), [
        const TableIssue(TableIssueKind.overlap, rows: [1, 2], from: 2, to: 2),
      ]);
    });

    test('missing, inverted and out-of-bounds ranges', () {
      final issues = validateTable(
        _table('1d6', [(1, 3), (null, null), (6, 4), (4, 8)]),
      );
      expect(issues, [
        const TableIssue(TableIssueKind.missingRange, rows: [1]),
        const TableIssue(
          TableIssueKind.invertedRange,
          rows: [2],
          from: 6,
          to: 4,
        ),
        const TableIssue(TableIssueKind.outOfBounds, rows: [3], from: 4, to: 8),
      ]);
    });
  });

  group('suggestFormula', () {
    test('recognizes common dice', () {
      expect(suggestFormula(_table('', [(1, 10), (11, 20)]).rows), '1d20');
      expect(suggestFormula(_table('', [(1, 50), (51, 100)]).rows), '1d100');
      expect(suggestFormula(_table('', [(2, 6), (7, 12)]).rows), '2d6');
      expect(suggestFormula(_table('', [(3, 10), (11, 18)]).rows), '3d6');
    });

    test('gives up on partial or unusual ranges', () {
      expect(suggestFormula(_table('', [(1, 7)]).rows), isNull);
      expect(suggestFormula(_table('', [(1, 3), (null, null)]).rows), isNull);
      expect(suggestFormula(const []), isNull);
    });
  });
}
