import 'grammar.dart';

/// Languages every generator ships content for; English is the fallback.
const generatorLanguages = ['en', 'ru', 'de', 'fr', 'zh'];

/// Compact source format for generator content.
///
/// * **rows** — one entry per line, translated side by side:
///   `en ¦ ru ¦ de ¦ fr ¦ zh`. A single cell applies to every language.
/// * **names** — `latin ¦ cyrillic ¦ chinese`: en/de/fr share the Latin
///   spelling, ru and zh get proper renderings. A single cell applies to
///   every language.
/// * **perLang** — lists written separately per language, one entry per
///   line (for word-building parts that are not translations).
///
/// Inside a cell, `masc~fem` gives gendered forms (read through the `_m`
/// / `_f` lists) and a trailing `#m` / `#f` marks a noun's grammatical
/// gender. A line may start with `@tag ` to attach metadata to the entry.
/// Lines starting with `//` are comments.
class PackContent {
  /// language -> list name -> entries.
  final Map<String, Map<String, List<Fragment>>> lists;

  PackContent(this.lists);

  factory PackContent.build({
    Map<String, String> rows = const {},
    Map<String, String> names = const {},
    Map<String, Map<String, String>> perLang = const {},
  }) {
    final raw = <String, Map<String, List<_Cell>>>{
      for (final lang in generatorLanguages) lang: {},
    };
    void add(String lang, String list, String text, String? tag) =>
        raw[lang]!.putIfAbsent(list, () => []).add(_Cell(text, tag));

    rows.forEach((list, block) {
      for (final (tag, cells) in _lines(block)) {
        if (cells.length == 1) {
          for (final lang in generatorLanguages) {
            add(lang, list, cells.single, tag);
          }
        } else if (cells.length == generatorLanguages.length) {
          for (var i = 0; i < cells.length; i++) {
            add(generatorLanguages[i], list, cells[i], tag);
          }
        } else {
          throw FormatException(
              'List "$list": expected 1 or 5 cells', cells.join(' ¦ '));
        }
      }
    });
    names.forEach((list, block) {
      for (final (tag, cells) in _lines(block)) {
        if (cells.length != 1 && cells.length != 3) {
          throw FormatException(
              'Names "$list": expected 1 or 3 cells', cells.join(' ¦ '));
        }
        final latin = cells[0];
        final cyrillic = cells.length == 3 ? cells[1] : latin;
        final chinese = cells.length == 3 ? cells[2] : latin;
        for (final lang in generatorLanguages) {
          add(lang, list,
              switch (lang) { 'ru' => cyrillic, 'zh' => chinese, _ => latin },
              tag);
        }
      }
    });
    perLang.forEach((lang, lists) {
      if (!raw.containsKey(lang)) {
        throw FormatException('Unknown language "$lang"');
      }
      lists.forEach((list, block) {
        for (final (tag, cells) in _lines(block)) {
          add(lang, list, cells.join(' ¦ '), tag);
        }
      });
    });

    return PackContent({
      for (final MapEntry(key: lang, value: lists) in raw.entries)
        lang: _finalize(lists),
    });
  }

  /// The lists of [lang], each falling back to English when absent.
  FragmentLibrary library(String lang) =>
      _FallbackLibrary(lists[lang] ?? const {}, lists['en'] ?? const {});

  static Iterable<(String?, List<String>)> _lines(String block) sync* {
    for (var line in block.split('\n')) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('//')) continue;
      String? tag;
      if (line.startsWith('@')) {
        final space = line.indexOf(' ');
        if (space < 0) throw FormatException('Tag without text', line);
        tag = line.substring(1, space);
        line = line.substring(space + 1).trim();
      }
      yield (tag, [for (final c in line.split('¦')) c.trim()]);
    }
  }

  static Map<String, List<Fragment>> _finalize(
      Map<String, List<_Cell>> lists) {
    final out = <String, List<Fragment>>{};
    void put(String list, String text, String? tag) =>
        out.putIfAbsent(list, () => []).add(Fragment(text, tag));

    lists.forEach((list, cells) {
      final gendered = cells.any((c) =>
          c.text.contains('~') ||
          c.text.endsWith('#m') ||
          c.text.endsWith('#f'));
      for (final cell in cells) {
        final text = cell.text;
        if (text.endsWith('#m') || text.endsWith('#f')) {
          final word = text.substring(0, text.length - 2).trim();
          put(list, word, cell.tag);
          put('${list}_${text.substring(text.length - 1)}', word, cell.tag);
        } else if (text.contains('~')) {
          final forms = text.split('~');
          if (forms.length != 2) {
            throw FormatException('Expected masc~fem', text);
          }
          put(list, forms[0].trim(), cell.tag);
          put('${list}_m', forms[0].trim(), cell.tag);
          put('${list}_f', forms[1].trim(), cell.tag);
        } else {
          put(list, text, cell.tag);
          if (gendered) {
            put('${list}_m', text, cell.tag);
            put('${list}_f', text, cell.tag);
          }
        }
      }
    });
    return out;
  }
}

class _Cell {
  final String text;
  final String? tag;
  const _Cell(this.text, this.tag);
}

class _FallbackLibrary extends FragmentLibrary {
  final Map<String, List<Fragment>> primary;
  final Map<String, List<Fragment>> fallback;

  _FallbackLibrary(this.primary, this.fallback);

  @override
  List<Fragment>? list(String name) {
    final own = primary[name];
    if (own != null && own.isNotEmpty) return own;
    // A gendered variant only exists where the language inflects; never
    // borrow English's split for a language that has the base list.
    if (primary.containsKey(_base(name))) return null;
    return fallback[name];
  }

  static String _base(String name) =>
      name.endsWith('_m') || name.endsWith('_f')
          ? name.substring(0, name.length - 2)
          : name;
}
