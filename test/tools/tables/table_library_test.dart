import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/dice/dice_engine.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/tables/content/table_library.dart';
import 'package:gmh/domain/tables/random_table.dart';
import 'package:gmh/domain/tables/table_ranges.dart';
import 'package:gmh/domain/tables/table_roller.dart';

final _brace = RegExp(r'\{([^{}]*)\}');

/// Inline `{…}` groups of [text]: dice expressions verbatim, alternatives
/// as their count (translations differ, the number of options must not).
List<String> _inlineShape(String text) => [
      for (final m in _brace.allMatches(text))
        m[1]!.contains('|') ? 'choice:${m[1]!.split('|').length}' : m[1]!,
    ];

void main() {
  test('every setting pack has at least five tables', () {
    for (final style in WorldStyle.values) {
      expect(TableLibrary.forStyle(style).length, greaterThanOrEqualTo(5),
          reason: style.name);
      for (final t in TableLibrary.forStyle(style)) {
        expect(t.style, style, reason: t.id);
      }
    }
  });

  test('ids are unique and resolvable', () {
    final ids = [for (final t in TableLibrary.all) t.id];
    expect(ids.toSet().length, ids.length);
    for (final t in TableLibrary.all) {
      expect(TableLibrary.byId(t.id), same(t));
      expect(TableLibrary.resolveLocal(t.style, t.localId), same(t));
    }
  });

  test('every table has 10–20 rows', () {
    for (final t in TableLibrary.all) {
      expect(t.rows.length, inInclusiveRange(10, 20), reason: t.id);
    }
  });

  test('all five languages are written for names, descriptions and rows', () {
    for (final folder in LibraryFolder.values) {
      for (final text in folder.label.all) {
        expect(text.trim(), isNotEmpty, reason: folder.name);
      }
    }
    for (final t in TableLibrary.all) {
      for (final tx in [t.name, t.description, for (final r in t.rows) r.text]) {
        final all = tx.all;
        expect(all, hasLength(libraryLanguages.length));
        for (var i = 0; i < all.length; i++) {
          expect(all[i].trim(), isNotEmpty,
              reason: '${t.id} ${libraryLanguages[i]}: ${tx.en}');
          expect(all[i], all[i].trim(), reason: '${t.id}: ${tx.en}');
        }
        // Non-English entries are translations, not English copies.
        for (final lang in ['ru', 'zh']) {
          expect(tx.of(lang) == tx.en, isFalse,
              reason: '${t.id} $lang untranslated: ${tx.en}');
        }
      }
    }
  });

  test('no duplicate rows within a table, in any language', () {
    for (final t in TableLibrary.all) {
      for (final lang in libraryLanguages) {
        final texts = [for (final r in t.rows) r.text.of(lang)];
        expect(texts.toSet().length, texts.length,
            reason: '${t.id} $lang has duplicate rows');
      }
    }
  });

  test('table names are unique within each pack and language', () {
    for (final style in WorldStyle.values) {
      for (final lang in libraryLanguages) {
        final names = [
          for (final t in TableLibrary.forStyle(style))
            tableNameKey(t.name.of(lang)),
        ];
        expect(names.toSet().length, names.length,
            reason: '${style.name} $lang');
      }
    }
  });

  test('translations keep the same references, dice and alternatives', () {
    for (final t in TableLibrary.all) {
      for (final row in t.rows) {
        final refs = [
          for (final m in LibraryTable.refPattern.allMatches(row.text.en)) m[1],
        ];
        final shape = _inlineShape(row.text.en);
        for (final lang in libraryLanguages) {
          final text = row.text.of(lang);
          expect(
              [
                for (final m in LibraryTable.refPattern.allMatches(text)) m[1],
              ],
              refs,
              reason: '${t.id} $lang: $text');
          expect(_inlineShape(text), shape, reason: '${t.id} $lang: $text');
        }
        for (final expression in shape.where((s) => !s.startsWith('choice'))) {
          expect(DiceEngine.isValid(expression), isTrue,
              reason: '${t.id}: {$expression}');
        }
      }
    }
  });

  test('nested references resolve within the pack and never form a cycle', () {
    for (final style in WorldStyle.values) {
      final pack = TableLibrary.forStyle(style);
      for (final t in pack) {
        for (final ref in t.references) {
          expect(TableLibrary.resolveLocal(style, ref), isNotNull,
              reason: '${t.id} -> $ref');
          expect(ref, isNot(t.localId), reason: '${t.id} references itself');
        }
        // Depth-first walk: reaching the start again is a cycle.
        void walk(LibraryTable current, List<String> path) {
          for (final ref in current.references) {
            expect(path.contains(ref), isFalse,
                reason: 'cycle ${[...path, ref].join(' -> ')}');
            walk(TableLibrary.resolveLocal(style, ref)!, [...path, ref]);
          }
        }

        walk(t, [t.localId]);
      }
      final referencing = pack.where((t) => t.references.isNotEmpty);
      expect(referencing.length, greaterThanOrEqualTo(2), reason: style.name);
    }
  });

  test('every pack uses inline dice, alternatives and a weighted table', () {
    for (final style in WorldStyle.values) {
      final pack = TableLibrary.forStyle(style);
      final texts = [
        for (final t in pack)
          for (final r in t.rows) r.text.en,
      ];
      expect(texts.any((s) => _inlineShape(s).any((x) => !x.startsWith('c'))),
          isTrue, reason: style.name);
      expect(texts.any((s) => _inlineShape(s).any((x) => x.startsWith('c'))),
          isTrue, reason: style.name);
      expect(pack.any((t) => t.formula.isEmpty), isTrue, reason: style.name);
      expect(pack.where((t) => t.formula.isNotEmpty).length,
          greaterThanOrEqualTo(3), reason: style.name);
    }
  });

  test('formula tables cover the whole die without gaps or overlaps', () {
    for (final t in TableLibrary.all) {
      if (t.formula.isEmpty) continue;
      final bounds = formulaBounds(t.formula);
      expect(bounds, isNotNull, reason: t.id);
      expect(t.rows.length, lessThanOrEqualTo(bounds!.max - bounds.min + 1),
          reason: '${t.id}: more rows than totals');
      for (final lang in libraryLanguages) {
        final table = TableLibrary.materialize(t, lang);
        expect(table.rows.every((r) => r.hasRange), isTrue, reason: t.id);
        expect(table.rows.first.from, bounds.min, reason: t.id);
        expect(table.rows.last.to, bounds.max, reason: t.id);
        expect(validateTable(table), isEmpty, reason: '${t.id} $lang');
      }
    }
  });

  test('materialized tables carry their language, folder and source', () {
    final t = TableLibrary.forStyle(WorldStyle.fantasy).first;
    for (final lang in libraryLanguages) {
      final table = TableLibrary.materialize(t, lang, worldId: 'w');
      expect(table.name, t.name.of(lang));
      expect(table.description, t.description.of(lang));
      expect(table.folder, t.folder.label.of(lang));
      expect(table.source, RandomTableSource.library(t.id));
      expect(table.worldId, 'w');
      expect(table.rows.map((r) => r.text).join(),
          isNot(contains('[[@')), reason: lang);
    }
    // Unknown languages fall back to English.
    expect(TableLibrary.materialize(t, 'xx').name, t.name.en);
  });

  test('every table rolls cleanly in every language', () {
    for (final style in WorldStyle.values) {
      for (final lang in libraryLanguages) {
        final tables = [
          for (final t in TableLibrary.forStyle(style))
            TableLibrary.materialize(t, lang),
        ];
        for (var seed = 0; seed < 25; seed++) {
          final roller =
              TableRoller.forTables(tables, random: Random(seed * 31 + 7));
          for (final table in tables) {
            final result = roller.roll(table);
            expect(result.hasFailure, isFalse,
                reason: '${table.name} ($lang): ${result.text}');
            expect(result.text, isNot(contains('[[')), reason: result.text);
            expect(result.text, isNot(contains('{')), reason: result.text);
            expect(result.text.trim(), isNotEmpty);
          }
        }
      }
    }
  });

  test('dependencies follow references transitively', () {
    for (final t in TableLibrary.all) {
      final deps = TableLibrary.dependencies(t);
      final ids = {for (final d in deps) d.localId};
      expect(ids.contains(t.localId), isFalse);
      expect(ids.containsAll(t.references), isTrue, reason: t.id);
      for (final d in deps) {
        expect(ids.containsAll(d.references.difference({t.localId})), isTrue,
            reason: '${t.id} via ${d.id}');
      }
    }
    final rumors = TableLibrary.resolveLocal(WorldStyle.fantasy, 'tavern_rumors')!;
    expect([for (final d in TableLibrary.dependencies(rumors)) d.localId],
        ['road_encounters', 'treasure', 'weather', 'quirks']);
  });

  test('pack order puts the world pack first', () {
    final order = TableLibrary.packOrder(WorldStyle.wuxia);
    expect(order.first, WorldStyle.wuxia);
    expect(order.toSet(), WorldStyle.values.toSet());
    expect(order, hasLength(WorldStyle.values.length));
  });
}
