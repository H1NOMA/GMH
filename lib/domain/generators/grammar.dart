import 'dart:math';

import '../dice/dice_engine.dart';

/// One entry of a fragment list. [tag] is optional row metadata (a select
/// option such as `Village`, or a name-culture id) that generators map onto
/// entity fields; it is never part of the text.
class Fragment {
  final String text;
  final String? tag;

  const Fragment(this.text, [this.tag]);

  @override
  bool operator ==(Object other) =>
      other is Fragment && other.text == text && other.tag == tag;

  @override
  int get hashCode => Object.hash(text, tag);

  @override
  String toString() => tag == null ? text : '@$tag $text';
}

/// Named fragment lists for one pack and language.
abstract class FragmentLibrary {
  /// The entries of [name], or null when no such list exists.
  List<Fragment>? list(String name);

  bool has(String name) => (list(name) ?? const []).isNotEmpty;
}

/// A library backed by a plain map.
class MapLibrary extends FragmentLibrary {
  final Map<String, List<Fragment>> lists;
  MapLibrary(this.lists);

  @override
  List<Fragment>? list(String name) => lists[name];
}

/// Stacks libraries: a list is the concatenation of every layer's entries
/// of that name (pack-specific first, then shared ones), so shared lists
/// such as personality traits gain genre flavor from the pack.
class LayeredLibrary extends FragmentLibrary {
  final List<FragmentLibrary> layers;

  /// Lists taken whole from the first layer that has them instead of
  /// merged (naming patterns a pack replaces rather than extends).
  final Set<String> exclusive;
  final Map<String, List<Fragment>?> _cache = {};

  LayeredLibrary(this.layers, {this.exclusive = const {}});

  @override
  List<Fragment>? list(String name) => _cache.putIfAbsent(name, () {
        List<Fragment>? merged;
        for (final layer in layers) {
          final entries = layer.list(name);
          if (entries == null || entries.isEmpty) continue;
          if (exclusive.contains(name)) return entries;
          (merged ??= []).addAll(entries);
        }
        return merged;
      });
}

class GrammarException implements Exception {
  final String message;
  const GrammarException(this.message);

  @override
  String toString() => 'GrammarException: $message';
}

/// Mutable state of one generated result: the random source, the entries
/// already used (so no fragment repeats within a result), variables such
/// as the character's gender, and the tags of the picks made.
class GrammarContext {
  final Random random;
  final FragmentLibrary library;

  /// `list\u0000text` keys of every pick so far.
  final Set<String> used;
  final Map<String, String> vars;

  /// Tags of tagged picks, keyed by list name (last pick wins).
  final Map<String, String> tags = {};

  /// Tag of the first tagged pick since the last [takeFirstTag].
  String? _firstTag;

  /// Unknown lists throw in strict mode; otherwise the slot is left in
  /// the text verbatim so a content gap never crashes the UI.
  final bool strict;

  GrammarContext({
    required this.random,
    required this.library,
    Set<String>? used,
    Map<String, String>? vars,
    this.strict = false,
  })  : used = used ?? <String>{},
        vars = vars ?? <String, String>{};

  /// A context sharing randomness and the no-repeat memory but with its
  /// own variables — for a nested name inside a larger result.
  GrammarContext child([Map<String, String> vars = const {}]) =>
      GrammarContext(
        random: random,
        library: library,
        used: used,
        vars: Map.of(vars),
        strict: strict,
      );

  String? takeFirstTag() {
    final tag = _firstTag;
    _firstTag = null;
    return tag;
  }

  /// The gender-specific variant of [name] (`role_f`) when the context
  /// has a gender and the library has such a list, else [name].
  String resolve(String name) {
    final gender = vars['gender'];
    if (gender != null && gender.isNotEmpty) {
      final specific = '${name}_$gender';
      if (library.has(specific)) return specific;
    }
    return name;
  }

  /// Picks an unused entry of list [name] (after gender resolution).
  /// Falls back to any entry once every entry has been used.
  Fragment? pick(String name) {
    final resolved = resolve(name);
    final entries = library.list(resolved);
    if (entries == null || entries.isEmpty) {
      if (strict) throw GrammarException('Unknown list "$name"');
      return null;
    }
    var candidates = [
      for (final e in entries)
        if (!used.contains(_key(resolved, e.text))) e,
    ];
    if (candidates.isEmpty) candidates = entries;
    final chosen = candidates[random.nextInt(candidates.length)];
    used.add(_key(resolved, chosen.text));
    // Gendered lists share entries with their base list: remember both so
    // a later ungendered pick does not repeat the entry either.
    if (resolved != name) used.add(_key(name, chosen.text));
    if (chosen.tag != null) {
      tags[name] = chosen.tag!;
      _firstTag ??= chosen.tag;
    }
    return chosen;
  }

  static String _key(String list, String text) => '$list\u0000$text';
}

/// Expands templates:
///
/// * `{list}` — a random unused entry of a named list, itself expanded;
///   with a `gender` variable `{role}` prefers `role_f` / `role_m`;
/// * `{list:cap}` / `:upper` / `:lower` / `:title` — capitalization;
/// * `{=var}` — a context variable (also takes modifiers);
/// * `{#2d6*10}` — a dice roll's total;
/// * `{a|b|c}` — one alternative (each may contain markup; an empty
///   alternative makes the part optional);
/// * `[text]` — included half of the time.
///
/// Repeated spaces left by optional parts are collapsed.
abstract final class Grammar {
  static const maxDepth = 12;
  static final Map<String, _Seq> _parsed = {};

  static String expand(String template, GrammarContext context) {
    final text = _expand(template, context, 0);
    return tidy(text);
  }

  /// Collapses doubled spaces and spaces before commas and full stops
  /// (French spacing before `;:!?` is left alone).
  static String tidy(String text) => text
      .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
      .replaceAllMapped(RegExp(r' +([,.)])'), (m) => m[1]!)
      .replaceAllMapped(RegExp(r'([«(]) +'), (m) => m[1]!)
      .trim();

  static String _expand(String template, GrammarContext context, int depth) {
    if (depth > maxDepth) {
      throw const GrammarException('Template nesting too deep');
    }
    final seq = _parsed.putIfAbsent(template, () => _Parser(template).parse());
    final out = StringBuffer();
    seq.render(out, context, depth);
    return out.toString();
  }

  /// Checks [template] parses; returns the list names it references.
  static Set<String> references(String template) {
    final seq = _parsed.putIfAbsent(template, () => _Parser(template).parse());
    final names = <String>{};
    seq.collect(names);
    return names;
  }

  static String applyModifier(String text, String? modifier) {
    switch (modifier) {
      case null || '':
        return text;
      case 'cap':
        return capitalize(text);
      case 'upper':
        return text.toUpperCase();
      case 'lower':
        return text.toLowerCase();
      case 'title':
        return text.split(' ').map(capitalize).join(' ');
      default:
        throw GrammarException('Unknown modifier "$modifier"');
    }
  }

  /// Upper-cases the first letter (skipping leading quotes and brackets).
  static String capitalize(String text) {
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if ('«"„“\'(['.contains(ch)) continue;
      return text.substring(0, i) + ch.toUpperCase() + text.substring(i + 1);
    }
    return text;
  }
}

// ------------------------------------------------------------------ AST

abstract class _Node {
  void render(StringBuffer out, GrammarContext context, int depth);
  void collect(Set<String> names) {}
}

class _Seq extends _Node {
  final List<_Node> parts;
  _Seq(this.parts);

  @override
  void render(StringBuffer out, GrammarContext context, int depth) {
    for (final p in parts) {
      p.render(out, context, depth);
    }
  }

  @override
  void collect(Set<String> names) {
    for (final p in parts) {
      p.collect(names);
    }
  }
}

class _Text extends _Node {
  final String text;
  _Text(this.text);

  @override
  void render(StringBuffer out, GrammarContext context, int depth) =>
      out.write(text);
}

class _Slot extends _Node {
  final String name;
  final String? modifier;
  _Slot(this.name, this.modifier);

  @override
  void render(StringBuffer out, GrammarContext context, int depth) {
    final fragment = context.pick(name);
    if (fragment == null) {
      out.write('{$name}');
      return;
    }
    final text = Grammar._expand(fragment.text, context, depth + 1);
    out.write(Grammar.applyModifier(text, modifier));
  }

  @override
  void collect(Set<String> names) => names.add(name);
}

class _Var extends _Node {
  final String name;
  final String? modifier;
  _Var(this.name, this.modifier);

  @override
  void render(StringBuffer out, GrammarContext context, int depth) {
    final value = context.vars[name];
    if (value == null) {
      if (context.strict) throw GrammarException('Unknown variable "$name"');
      out.write('{=$name}');
      return;
    }
    out.write(Grammar.applyModifier(value, modifier));
  }
}

class _Dice extends _Node {
  final String expression;
  _Dice(this.expression) {
    DiceEngine.parse(expression); // validate early
  }

  @override
  void render(StringBuffer out, GrammarContext context, int depth) {
    out.write(DiceEngine(random: context.random).roll(expression).total);
  }
}

class _Choice extends _Node {
  final List<_Seq> options;
  _Choice(this.options);

  @override
  void render(StringBuffer out, GrammarContext context, int depth) =>
      options[context.random.nextInt(options.length)]
          .render(out, context, depth);

  @override
  void collect(Set<String> names) {
    for (final o in options) {
      o.collect(names);
    }
  }
}

class _Optional extends _Node {
  final _Seq body;
  _Optional(this.body);

  @override
  void render(StringBuffer out, GrammarContext context, int depth) {
    if (context.random.nextInt(2) == 1) body.render(out, context, depth);
  }

  @override
  void collect(Set<String> names) => body.collect(names);
}

// ---------------------------------------------------------------- parser

class _Parser {
  final String src;
  int pos = 0;

  _Parser(this.src);

  _Seq parse() {
    final seq = _sequence(const {});
    if (pos < src.length) {
      throw GrammarException('Unexpected "${src[pos]}" at $pos in "$src"');
    }
    return seq;
  }

  /// Reads until one of [stops] (unconsumed) or the end.
  _Seq _sequence(Set<String> stops) {
    final parts = <_Node>[];
    final text = StringBuffer();
    void flush() {
      if (text.isNotEmpty) {
        parts.add(_Text(text.toString()));
        text.clear();
      }
    }

    while (pos < src.length) {
      final ch = src[pos];
      if (stops.contains(ch)) break;
      if (ch == '{') {
        flush();
        parts.add(_brace());
      } else if (ch == '[') {
        flush();
        pos++;
        final body = _sequence(const {']'});
        _expect(']');
        parts.add(_Optional(body));
      } else if (ch == '}' || ch == ']') {
        throw GrammarException('Unbalanced "$ch" at $pos in "$src"');
      } else {
        text.write(ch);
        pos++;
      }
    }
    flush();
    return _Seq(parts);
  }

  _Node _brace() {
    _expect('{');
    final start = pos;
    // A plain slot, variable or dice roll: no nested markup, no pipe.
    final close = src.indexOf('}', pos);
    if (close < 0) throw GrammarException('Unclosed "{" in "$src"');
    final inner = src.substring(start, close);
    if (!inner.contains('{') && !inner.contains('|') && !inner.contains('[')) {
      pos = close + 1;
      return _simple(inner);
    }
    final options = <_Seq>[];
    while (true) {
      options.add(_sequence(const {'|', '}'}));
      if (pos >= src.length) throw GrammarException('Unclosed "{" in "$src"');
      if (src[pos] == '}') {
        pos++;
        break;
      }
      pos++; // '|'
    }
    if (options.length == 1) {
      throw GrammarException('Invalid slot "{$inner}" in "$src"');
    }
    return _Choice(options);
  }

  _Node _simple(String inner) {
    if (inner.startsWith('#')) {
      try {
        return _Dice(inner.substring(1));
      } on DiceParseException {
        throw GrammarException('Invalid dice "$inner" in "$src"');
      }
    }
    final isVar = inner.startsWith('=');
    final body = isVar ? inner.substring(1) : inner;
    final colon = body.indexOf(':');
    final name = (colon < 0 ? body : body.substring(0, colon)).trim();
    final modifier = colon < 0 ? null : body.substring(colon + 1).trim();
    if (name.isEmpty || name.contains(' ')) {
      throw GrammarException('Invalid slot "{$inner}" in "$src"');
    }
    Grammar.applyModifier('', modifier); // validate
    return isVar ? _Var(name, modifier) : _Slot(name, modifier);
  }

  void _expect(String ch) {
    if (pos >= src.length || src[pos] != ch) {
      throw GrammarException('Expected "$ch" at $pos in "$src"');
    }
    pos++;
  }
}
