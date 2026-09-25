import 'package:flutter/foundation.dart';

import '../../models/world.dart';
import '../random_table.dart';
import '../table_ranges.dart';
import 'cosmic_horror_tables.dart';
import 'cyberpunk_tables.dart';
import 'fantasy_tables.dart';
import 'gothic_horror_tables.dart';
import 'post_apocalypse_tables.dart';
import 'space_opera_tables.dart';
import 'steampunk_tables.dart';
import 'urban_fantasy_tables.dart';
import 'wild_west_tables.dart';
import 'wuxia_tables.dart';

/// The content languages every library text is written in.
const libraryLanguages = ['en', 'ru', 'de', 'fr', 'zh'];

/// A text in every content language; English is the fallback.
@immutable
class Tx {
  final String en;
  final String ru;
  final String de;
  final String fr;
  final String zh;

  const Tx(this.en, this.ru, this.de, this.fr, this.zh);

  String of(String lang) {
    final text = switch (lang) {
      'ru' => ru,
      'de' => de,
      'fr' => fr,
      'zh' => zh,
      _ => en,
    };
    return text.isEmpty ? en : text;
  }

  List<String> get all => [en, ru, de, fr, zh];
}

/// One library row. `[[@id]]` in the text references another table of the
/// same pack by its local id and becomes `[[Its Name]]` in each language.
@immutable
class LibraryRow {
  final Tx text;
  final int weight;

  const LibraryRow(this.text, {this.weight = 1});
}

enum LibraryFolder {
  encounters(Tx('Encounters', 'Встречи', 'Begegnungen', 'Rencontres', '遭遇')),
  rumors(Tx('Rumors & hooks', 'Слухи и зацепки', 'Gerüchte & Aufhänger',
      'Rumeurs & accroches', '传闻与线索')),
  loot(Tx('Loot & salvage', 'Добыча', 'Beute & Fundstücke', 'Butin & récup',
      '战利品')),
  locale(Tx('Places & complications', 'Места и осложнения',
      'Orte & Komplikationen', 'Lieux & complications', '场景与变数')),
  people(Tx('People', 'Персонажи', 'Personen', 'Personnages', '人物'));

  final Tx label;
  const LibraryFolder(this.label);
}

/// A built-in, read-only table template. Adding it to a world copies it
/// into a [RandomTable] in the reader's language.
@immutable
class LibraryTable {
  /// Id unique within the pack; the global id is `style.name.localId`.
  final String localId;
  final WorldStyle style;
  final LibraryFolder folder;
  final Tx name;
  final Tx description;

  /// Empty for weighted tables. Ranges follow the row weights.
  final String formula;
  final List<LibraryRow> rows;

  const LibraryTable({
    required this.localId,
    required this.style,
    required this.folder,
    required this.name,
    required this.description,
    this.formula = '',
    required this.rows,
  });

  String get id => '${style.name}.$localId';

  static final refPattern = RegExp(r'\[\[@([a-z0-9_]+)\]\]');

  /// Local ids referenced by any row (in English; the content tests check
  /// every language references the same tables).
  Set<String> get references => {
        for (final row in rows)
          for (final m in refPattern.allMatches(row.text.en)) m[1]!,
      };
}

/// Every library table, grouped by setting pack.
abstract final class TableLibrary {
  static final Map<WorldStyle, List<LibraryTable>> byStyle = {
    WorldStyle.fantasy: fantasyTables,
    WorldStyle.cyberpunk: cyberpunkTables,
    WorldStyle.spaceOpera: spaceOperaTables,
    WorldStyle.gothicHorror: gothicHorrorTables,
    WorldStyle.cosmicHorror: cosmicHorrorTables,
    WorldStyle.postApocalypse: postApocalypseTables,
    WorldStyle.steampunk: steampunkTables,
    WorldStyle.urbanFantasy: urbanFantasyTables,
    WorldStyle.wildWest: wildWestTables,
    WorldStyle.wuxia: wuxiaTables,
  };

  static List<LibraryTable> get all =>
      [for (final style in WorldStyle.values) ...?byStyle[style]];

  static List<LibraryTable> forStyle(WorldStyle style) =>
      byStyle[style] ?? const [];

  static LibraryTable? byId(String id) {
    for (final t in all) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// The pack table [localId] of [style], or null.
  static LibraryTable? resolveLocal(WorldStyle style, String localId) {
    for (final t in forStyle(style)) {
      if (t.localId == localId) return t;
    }
    return null;
  }

  /// Packs in display order with [first] (the world's own pack) leading.
  static List<WorldStyle> packOrder(WorldStyle first) =>
      [first, for (final s in WorldStyle.values) if (s != first) s];

  /// Row text in [lang] with `[[@id]]` turned into `[[Localized name]]`.
  static String rowText(LibraryTable table, LibraryRow row, String lang) =>
      row.text.of(lang).replaceAllMapped(LibraryTable.refPattern, (m) {
        final target = resolveLocal(table.style, m[1]!);
        return '[[${target?.name.of(lang) ?? m[1]!}]]';
      });

  /// [table] as an editable world table in [lang]; ranges are spread over
  /// the formula by row weight.
  static RandomTable materialize(LibraryTable table, String lang,
      {String worldId = ''}) {
    var rows = [
      for (final row in table.rows)
        RandomTableRow(rowText(table, row, lang), weight: row.weight),
    ];
    final bounds =
        table.formula.isEmpty ? null : formulaBounds(table.formula);
    if (bounds != null) rows = autoRanges(rows, bounds);
    return RandomTable(
      id: table.id,
      worldId: worldId,
      name: table.name.of(lang),
      description: table.description.of(lang),
      folder: table.folder.label.of(lang),
      formula: table.formula,
      rows: rows,
      source: RandomTableSource.library(table.id),
    );
  }

  /// Every pack table [table] references, directly or through other
  /// references, excluding [table] itself; in pack order.
  static List<LibraryTable> dependencies(LibraryTable table) {
    final seen = <String>{table.localId};
    final queue = [...table.references];
    while (queue.isNotEmpty) {
      final next = queue.removeLast();
      if (!seen.add(next)) continue;
      final target = resolveLocal(table.style, next);
      if (target != null) queue.addAll(target.references);
    }
    return [
      for (final t in forStyle(table.style))
        if (t.localId != table.localId && seen.contains(t.localId)) t,
    ];
  }
}
