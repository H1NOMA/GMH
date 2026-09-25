import 'dart:math';

import 'dice_models.dart';

export 'dice_models.dart';

/// Roll20-style dice notation: parser, AST and evaluator.
///
/// Grammar (whitespace between tokens and letter case are ignored):
///
///     sum     := product (('+' | '-') product)*
///     product := unary (('*' | '/') integer)*        -- floor division
///     unary   := ('-' | '+') unary | primary
///     primary := '(' sum ')' label? | integer label? | dice
///     dice    := integer? 'd' (integer | '%' | 'F') modifier* label?
///     label   := '[' text ']'
///
/// Modifiers attach directly to the dice (no spaces):
///  * `kh[n]` / `k[n]` keep highest, `kl[n]` keep lowest, `dh[n]` / `dl[n]`
///    (or `d[n]`) drop — n defaults to 1;
///  * `!` explode on the maximum, `!>N` / `!<N` / `!=N` on a threshold,
///    `!!` compounding;
///  * `r[n]`, `r<n`, `r>n` reroll while matching, `ro…` reroll once;
///  * `>=N`, `>N`, `<=N`, `<N`, `=N` count successes (the term's value
///    becomes the number of successes), `f…` failures subtract.
///
/// As in Roll20, `<` and `>` in explode/reroll thresholds are inclusive;
/// in success/failure counting they are strict (`>=` / `<=` for inclusive).
class DiceEngine {
  static const maxDicePerTerm = 1000;
  static const maxSides = 10000;
  static const maxExtraDice = 100;
  static const maxRerolls = 100;
  static const maxLength = 500;
  static const maxNumber = 1000000000;
  static const _maxMagnitude = 1000000000000000;

  final Random random;

  DiceEngine({Random? random}) : random = random ?? Random();

  /// Throws [DiceParseException] on invalid input.
  static DiceExpression parse(String input) => _Parser(input).parse();

  /// True when [input] parses.
  static bool isValid(String input) {
    try {
      parse(input);
      return true;
    } on DiceParseException {
      return false;
    }
  }

  DiceRollResult roll(String input) => parse(input).evaluate(random);
}

/// How [DiceExpression.withOptions] rewrites the first single die.
enum RollMode { normal, advantage, disadvantage }

enum CompareOp { eq, lt, le, gt, ge }

class DiceCompare {
  final CompareOp op;
  final int value;
  const DiceCompare(this.op, this.value);

  bool matches(int v) => switch (op) {
        CompareOp.eq => v == value,
        CompareOp.lt => v < value,
        CompareOp.le => v <= value,
        CompareOp.gt => v > value,
        CompareOp.ge => v >= value,
      };

  /// Notation for success/failure counting (strict `<`/`>`).
  String get strictText => switch (op) {
        CompareOp.eq => '=$value',
        CompareOp.lt => '<$value',
        CompareOp.le => '<=$value',
        CompareOp.gt => '>$value',
        CompareOp.ge => '>=$value',
      };

  /// Notation for explode/reroll thresholds (inclusive `<`/`>`).
  String get thresholdText => switch (op) {
        CompareOp.eq => '$value',
        CompareOp.le || CompareOp.lt => '<$value',
        CompareOp.ge || CompareOp.gt => '>$value',
      };
}

enum KeepMode { keepHighest, keepLowest, dropHighest, dropLowest }

class KeepDrop {
  final KeepMode mode;
  final int count;
  const KeepDrop(this.mode, this.count);

  String get text => switch (mode) {
        KeepMode.keepHighest => 'kh$count',
        KeepMode.keepLowest => 'kl$count',
        KeepMode.dropHighest => 'dh$count',
        KeepMode.dropLowest => 'dl$count',
      };
}

class Explode {
  final bool compound;

  /// null = explode on the maximum face.
  final DiceCompare? threshold;
  const Explode({this.compound = false, this.threshold});

  String get text {
    final bang = compound ? '!!' : '!';
    final t = threshold;
    if (t == null) return bang;
    return t.op == CompareOp.eq ? '$bang=${t.value}' : '$bang${t.thresholdText}';
  }
}

class Reroll {
  final bool once;
  final DiceCompare condition;
  const Reroll(this.condition, {this.once = false});

  String get text => '${once ? 'ro' : 'r'}${condition.thresholdText}';
}

sealed class DiceNode {
  const DiceNode();
  String get canonical;
}

final class ConstantNode extends DiceNode {
  final int value;
  final String? label;
  const ConstantNode(this.value, {this.label});

  @override
  String get canonical => '$value${_labelText(label)}';
}

final class DiceTermNode extends DiceNode {
  final int count;
  final int sides;
  final bool fate;
  final KeepDrop? keep;
  final Explode? explode;
  final List<Reroll> rerolls;
  final DiceCompare? success;
  final DiceCompare? failure;
  final String? label;

  const DiceTermNode({
    required this.count,
    required this.sides,
    this.fate = false,
    this.keep,
    this.explode,
    this.rerolls = const [],
    this.success,
    this.failure,
    this.label,
  });

  int get minFace => fate ? -1 : 1;
  int get maxFace => fate ? 1 : sides;
  bool get countsSuccesses => success != null || failure != null;

  /// Canonical notation without the label.
  String get notation {
    final b = StringBuffer('${count}d${fate ? 'F' : sides}');
    for (final r in rerolls) {
      b.write(r.text);
    }
    if (explode != null) b.write(explode!.text);
    if (keep != null) b.write(keep!.text);
    if (success != null) b.write(success!.strictText);
    if (failure != null) b.write('f${failure!.strictText}');
    return b.toString();
  }

  @override
  String get canonical => '$notation${_labelText(label)}';

  DiceTermNode copyWith({int? count, KeepDrop? keep}) => DiceTermNode(
        count: count ?? this.count,
        sides: sides,
        fate: fate,
        keep: keep ?? this.keep,
        explode: explode,
        rerolls: rerolls,
        success: success,
        failure: failure,
        label: label,
      );
}

final class BinaryNode extends DiceNode {
  /// One of `+ - * /`.
  final String op;
  final DiceNode left;
  final DiceNode right;
  const BinaryNode(this.op, this.left, this.right);

  @override
  String get canonical => '${left.canonical} $op ${right.canonical}';
}

final class NegateNode extends DiceNode {
  final DiceNode child;
  const NegateNode(this.child);

  @override
  String get canonical => '-${child.canonical}';
}

final class GroupNode extends DiceNode {
  final DiceNode child;
  final String? label;
  const GroupNode(this.child, {this.label});

  @override
  String get canonical => '(${child.canonical})${_labelText(label)}';
}

String _labelText(String? label) =>
    label == null || label.isEmpty ? '' : '[$label]';

/// A parsed, reusable expression.
class DiceExpression {
  final DiceNode root;
  final String source;

  const DiceExpression(this.root, this.source);

  String get canonical => root.canonical;

  /// Every dice term in reading order.
  List<DiceTermNode> get diceTerms {
    final out = <DiceTermNode>[];
    void walk(DiceNode n) {
      switch (n) {
        case DiceTermNode():
          out.add(n);
        case BinaryNode(:final left, :final right):
          walk(left);
          walk(right);
        case NegateNode(:final child) || GroupNode(:final child):
          walk(child);
        case ConstantNode():
          break;
      }
    }

    walk(root);
    return out;
  }

  /// Applies roller options: advantage/disadvantage turn the first single
  /// plain die (`1d20`) into `2d20kh1` / `2d20kl1`; a non-zero [modifier]
  /// is appended as `+ n` / `- n`.
  DiceExpression withOptions({RollMode mode = RollMode.normal, int modifier = 0}) {
    var root = this.root;
    if (mode != RollMode.normal) {
      var done = false;
      DiceNode rewrite(DiceNode n) {
        if (done) return n;
        switch (n) {
          case DiceTermNode():
            if (n.count == 1 && !n.fate && n.keep == null && !n.countsSuccesses) {
              done = true;
              return n.copyWith(
                count: 2,
                keep: KeepDrop(
                    mode == RollMode.advantage
                        ? KeepMode.keepHighest
                        : KeepMode.keepLowest,
                    1),
              );
            }
            return n;
          case BinaryNode():
            return BinaryNode(n.op, rewrite(n.left), rewrite(n.right));
          case NegateNode():
            return NegateNode(rewrite(n.child));
          case GroupNode():
            return GroupNode(rewrite(n.child), label: n.label);
          case ConstantNode():
            return n;
        }
      }

      root = rewrite(root);
    }
    if (modifier != 0) {
      root = BinaryNode(
          modifier > 0 ? '+' : '-', root, ConstantNode(modifier.abs()));
    }
    return DiceExpression(root, source);
  }

  DiceRollResult evaluate(Random random) {
    final terms = <DiceTermResult>[];
    final (total, breakdown) = _Evaluator(random, terms, source).eval(root);
    return DiceRollResult(
      expression: canonical,
      total: total,
      terms: terms,
      breakdown: breakdown,
    );
  }
}

// ------------------------------------------------------------------ parser

class _Parser {
  final String source;

  /// ASCII-lowercased copy with identical offsets (labels are read from
  /// [source] so they keep their case).
  final String lc;
  int i = 0;

  _Parser(this.source)
      : lc = String.fromCharCodes(source.codeUnits
            .map((c) => c >= 65 && c <= 90 ? c + 32 : c));

  DiceParseException _err(DiceErrorCode code, [int? at]) =>
      DiceParseException(code, at ?? i, source);

  bool get _end => i >= lc.length;
  String get _c => lc[i];

  bool _isDigit(String c) {
    final u = c.codeUnitAt(0);
    return u >= 48 && u <= 57;
  }

  void _ws() {
    while (!_end && (_c == ' ' || _c == '\t' || _c == '\n' || _c == '\r')) {
      i++;
    }
  }

  DiceExpression parse() {
    if (source.trim().isEmpty) throw _err(DiceErrorCode.empty, 0);
    if (source.length > DiceEngine.maxLength) {
      throw _err(DiceErrorCode.tooLong, DiceEngine.maxLength);
    }
    final root = _sum();
    _ws();
    if (!_end) {
      throw _err(_c == ')'
          ? DiceErrorCode.unbalancedParen
          : DiceErrorCode.unexpectedChar);
    }
    return DiceExpression(root, source);
  }

  DiceNode _sum() {
    var node = _product();
    while (true) {
      _ws();
      if (_end || (_c != '+' && _c != '-')) return node;
      final op = _c;
      i++;
      node = BinaryNode(op, node, _product());
    }
  }

  DiceNode _product() {
    var node = _unary();
    while (true) {
      _ws();
      if (_end || (_c != '*' && _c != '/')) return node;
      final op = _c;
      i++;
      _ws();
      if (_end) throw _err(DiceErrorCode.unexpectedEnd);
      if (!_isDigit(_c)) throw _err(DiceErrorCode.expectedNumber);
      final at = i;
      final n = _int();
      if (op == '/' && n == 0) throw _err(DiceErrorCode.divisionByZero, at);
      node = BinaryNode(op, node, ConstantNode(n));
    }
  }

  DiceNode _unary() {
    _ws();
    if (!_end && _c == '-') {
      i++;
      return NegateNode(_unary());
    }
    if (!_end && _c == '+') {
      i++;
      return _unary();
    }
    return _primary();
  }

  DiceNode _primary() {
    _ws();
    if (_end) throw _err(DiceErrorCode.unexpectedEnd);
    final start = i;
    if (_c == '(') {
      i++;
      final inner = _sum();
      _ws();
      if (_end || _c != ')') {
        throw _err(DiceErrorCode.unbalancedParen, start);
      }
      i++;
      return GroupNode(inner, label: _label());
    }
    if (_isDigit(_c)) {
      final n = _int();
      if (!_end && _c == 'd') return _dice(n, start);
      return ConstantNode(n, label: _label());
    }
    if (_c == 'd') return _dice(1, start);
    throw _err(DiceErrorCode.unexpectedChar);
  }

  int _int() {
    final start = i;
    while (!_end && _isDigit(_c)) {
      i++;
    }
    final digits = lc.substring(start, i);
    if (digits.length > 10) throw _err(DiceErrorCode.numberTooLarge, start);
    final n = int.parse(digits);
    if (n > DiceEngine.maxNumber) {
      throw _err(DiceErrorCode.numberTooLarge, start);
    }
    return n;
  }

  int? _optInt() => !_end && _isDigit(_c) ? _int() : null;

  /// Comparison after `!`, `r`, `ro` (inclusive `<`/`>`); null if none.
  DiceCompare? _threshold() {
    if (_end) return null;
    final CompareOp op;
    switch (_c) {
      case '>':
        op = CompareOp.ge;
      case '<':
        op = CompareOp.le;
      case '=':
        op = CompareOp.eq;
      default:
        return null;
    }
    i++;
    if (!_end && _c == '=' && op != CompareOp.eq) i++;
    return DiceCompare(op, _requireInt());
  }

  /// Comparison for success/failure counting (strict `<`/`>`).
  DiceCompare? _strictCompare() {
    if (_end) return null;
    CompareOp op;
    switch (_c) {
      case '>':
        op = CompareOp.gt;
      case '<':
        op = CompareOp.lt;
      case '=':
        op = CompareOp.eq;
      default:
        return null;
    }
    i++;
    if (!_end && _c == '=' && op != CompareOp.eq) {
      i++;
      op = op == CompareOp.gt ? CompareOp.ge : CompareOp.le;
    }
    return DiceCompare(op, _requireInt());
  }

  int _requireInt() {
    if (_end) throw _err(DiceErrorCode.unexpectedEnd);
    if (!_isDigit(_c)) throw _err(DiceErrorCode.expectedNumber);
    return _int();
  }

  DiceNode _dice(int count, int start) {
    if (count > DiceEngine.maxDicePerTerm) {
      throw _err(DiceErrorCode.tooManyDice, start);
    }
    i++; // 'd'
    if (_end) throw _err(DiceErrorCode.unexpectedEnd);
    var sides = 0;
    var fate = false;
    final sidesAt = i;
    if (_c == '%') {
      sides = 100;
      i++;
    } else if (_c == 'f') {
      fate = true;
      sides = 3;
      i++;
    } else if (_isDigit(_c)) {
      sides = _int();
      if (sides < 1 || sides > DiceEngine.maxSides) {
        throw _err(DiceErrorCode.badSides, sidesAt);
      }
    } else {
      throw _err(DiceErrorCode.expectedNumber);
    }

    KeepDrop? keep;
    Explode? explode;
    final rerolls = <Reroll>[];
    DiceCompare? success;
    DiceCompare? failure;
    int? firstRepeatReroll;

    void once(Object? existing, int at) {
      if (existing != null) throw _err(DiceErrorCode.duplicateModifier, at);
    }

    while (!_end) {
      final at = i;
      final c = _c;
      if (c == 'k') {
        once(keep, at);
        i++;
        var mode = KeepMode.keepHighest;
        if (!_end && _c == 'h') {
          i++;
        } else if (!_end && _c == 'l') {
          mode = KeepMode.keepLowest;
          i++;
        }
        keep = KeepDrop(mode, _optInt() ?? 1);
      } else if (c == 'd') {
        once(keep, at);
        i++;
        var mode = KeepMode.dropLowest;
        if (!_end && _c == 'h') {
          mode = KeepMode.dropHighest;
          i++;
        } else if (!_end && _c == 'l') {
          i++;
        } else if (_end || !_isDigit(_c)) {
          throw _err(_end ? DiceErrorCode.unexpectedEnd
              : DiceErrorCode.unexpectedChar);
        }
        keep = KeepDrop(mode, _optInt() ?? 1);
      } else if (c == '!') {
        once(explode, at);
        i++;
        var compound = false;
        if (!_end && _c == '!') {
          compound = true;
          i++;
        }
        explode = Explode(compound: compound, threshold: _threshold());
      } else if (c == 'r') {
        i++;
        var isOnce = false;
        if (!_end && _c == 'o') {
          isOnce = true;
          i++;
        }
        final cond = _threshold() ??
            DiceCompare(CompareOp.eq, _optInt() ?? (fate ? -1 : 1));
        rerolls.add(Reroll(cond, once: isOnce));
        if (!isOnce) firstRepeatReroll ??= at;
      } else if (c == '>' || c == '<' || c == '=') {
        once(success, at);
        success = _strictCompare();
      } else if (c == 'f') {
        once(failure, at);
        i++;
        failure = _strictCompare() ??
            (!_end && _isDigit(_c)
                ? DiceCompare(CompareOp.eq, _int())
                : throw _err(_end
                    ? DiceErrorCode.unexpectedEnd
                    : DiceErrorCode.expectedNumber));
      } else {
        break;
      }
    }

    final node = DiceTermNode(
      count: count,
      sides: sides,
      fate: fate,
      keep: keep,
      explode: explode,
      rerolls: rerolls,
      success: success,
      failure: failure,
      label: _label(),
    );
    if (firstRepeatReroll != null) {
      final repeat = rerolls.where((r) => !r.once).toList();
      var all = true;
      for (var f = node.minFace; f <= node.maxFace; f++) {
        if (!repeat.any((r) => r.condition.matches(f))) {
          all = false;
          break;
        }
      }
      if (all) throw _err(DiceErrorCode.impossibleReroll, firstRepeatReroll);
    }
    return node;
  }

  String? _label() {
    final save = i;
    _ws();
    if (_end || _c != '[') {
      i = save;
      return null;
    }
    final start = i;
    final close = source.indexOf(']', start + 1);
    if (close < 0) throw _err(DiceErrorCode.unterminatedLabel, start);
    i = close + 1;
    final text = source.substring(start + 1, close).trim();
    return text.isEmpty ? null : text;
  }
}

// --------------------------------------------------------------- evaluator

class _Evaluator {
  final Random random;
  final List<DiceTermResult> terms;
  final String source;

  _Evaluator(this.random, this.terms, this.source);

  int _check(int v) {
    if (v.abs() > DiceEngine._maxMagnitude) {
      throw DiceParseException(DiceErrorCode.numberTooLarge, 0, source);
    }
    return v;
  }

  (int, String) eval(DiceNode node) {
    switch (node) {
      case ConstantNode():
        terms.add(DiceTermResult(
          notation: '${node.value}',
          label: node.label,
          value: node.value,
          isConstant: true,
        ));
        return (node.value, node.canonical);
      case DiceTermNode():
        final term = _rollTerm(node);
        terms.add(term);
        final faces = term.dice.map((d) => d.display).join(', ');
        return (term.value, '${node.canonical} ($faces)');
      case NegateNode():
        final (v, t) = eval(node.child);
        return (-v, '-$t');
      case GroupNode():
        final (v, t) = eval(node.child);
        return (v, '($t)${_labelText(node.label)}');
      case BinaryNode():
        final (a, ta) = eval(node.left);
        final (b, tb) = eval(node.right);
        final v = switch (node.op) {
          '+' => a + b,
          '-' => a - b,
          '*' => a * b,
          _ => _floorDiv(a, b),
        };
        return (_check(v), '$ta ${node.op} $tb');
    }
  }

  static int _floorDiv(int a, int b) {
    var q = a ~/ b;
    final r = a.remainder(b);
    if (r != 0 && (r < 0) != (b < 0)) q--;
    return q;
  }

  int _face(DiceTermNode n) =>
      n.fate ? random.nextInt(3) - 1 : random.nextInt(n.sides) + 1;

  (int, bool) _rollWithRerolls(DiceTermNode n) {
    var v = _face(n);
    var rerolled = false;
    if (n.rerolls.isEmpty) return (v, false);
    var attempts = 0;
    while (attempts < DiceEngine.maxRerolls &&
        n.rerolls.any((r) => !r.once && r.condition.matches(v))) {
      v = _face(n);
      rerolled = true;
      attempts++;
    }
    if (n.rerolls.any((r) => r.once && r.condition.matches(v))) {
      v = _face(n);
      rerolled = true;
    }
    return (v, rerolled);
  }

  bool _explodes(DiceTermNode n, int face) {
    final t = n.explode!.threshold;
    return t == null ? face == n.maxFace : t.matches(face);
  }

  DiceTermResult _rollTerm(DiceTermNode n) {
    final values = <int>[];
    final rerolled = <bool>[];
    final exploded = <bool>[];
    for (var k = 0; k < n.count; k++) {
      final (v, r) = _rollWithRerolls(n);
      values.add(v);
      rerolled.add(r);
      exploded.add(false);
    }

    final explode = n.explode;
    if (explode != null) {
      var extra = 0;
      if (explode.compound) {
        for (var k = 0; k < values.length; k++) {
          var last = values[k];
          while (extra < DiceEngine.maxExtraDice && _explodes(n, last)) {
            last = _face(n);
            values[k] += last;
            exploded[k] = true;
            extra++;
          }
        }
      } else {
        for (var k = 0; k < values.length; k++) {
          if (extra >= DiceEngine.maxExtraDice) break;
          if (_explodes(n, values[k])) {
            exploded[k] = true;
            values.add(_face(n));
            rerolled.add(false);
            exploded.add(false);
            extra++;
          }
        }
      }
    }

    final dropped = List<bool>.filled(values.length, false);
    final keep = n.keep;
    if (keep != null) {
      final order = List<int>.generate(values.length, (k) => k);
      final highFirst =
          keep.mode == KeepMode.keepHighest || keep.mode == KeepMode.dropHighest;
      order.sort((a, b) {
        final c = highFirst
            ? values[b].compareTo(values[a])
            : values[a].compareTo(values[b]);
        return c != 0 ? c : a.compareTo(b);
      });
      final isKeep =
          keep.mode == KeepMode.keepHighest || keep.mode == KeepMode.keepLowest;
      for (var pos = 0; pos < order.length; pos++) {
        final inFront = pos < keep.count;
        dropped[order[pos]] = isKeep ? !inFront : inFront;
      }
    }

    final flagFaces = !n.fate && n.sides >= 2;
    var sum = 0;
    var successes = 0;
    final dice = <RolledDie>[];
    for (var k = 0; k < values.length; k++) {
      final v = values[k];
      final isKept = !dropped[k];
      final ok = isKept && (n.success?.matches(v) ?? false);
      final bad = isKept && (n.failure?.matches(v) ?? false);
      if (isKept) {
        sum += v;
        if (ok) successes++;
        if (bad) successes--;
      }
      dice.add(RolledDie(
        v,
        dropped: !isKept,
        exploded: exploded[k],
        rerolled: rerolled[k],
        critical: flagFaces && v >= n.sides,
        fumble: flagFaces && v == 1,
        success: ok,
        failure: bad,
      ));
    }

    return DiceTermResult(
      notation: n.notation,
      label: n.label,
      value: n.countsSuccesses ? successes : sum,
      dice: dice,
      countsSuccesses: n.countsSuccesses,
    );
  }
}
