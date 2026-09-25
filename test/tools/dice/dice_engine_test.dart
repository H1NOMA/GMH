import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/dice/dice_engine.dart';

import 'scripted_random.dart';

DiceRollResult roll(String expression, List<int> faces) =>
    DiceEngine(random: ScriptedRandom.dice(faces)).roll(expression);

DiceParseException parseError(String expression) {
  try {
    DiceEngine.parse(expression);
  } on DiceParseException catch (e) {
    return e;
  }
  fail('"$expression" should not parse');
}

List<int> values(DiceRollResult r, [int term = 0]) =>
    [for (final d in r.terms[term].dice) d.value];

List<bool> droppedFlags(DiceRollResult r, [int term = 0]) =>
    [for (final d in r.terms[term].dice) d.dropped];

void main() {
  group('basic notation', () {
    test('an integer constant', () {
      final r = roll('5', []);
      expect(r.total, 5);
      expect(r.terms.single.isConstant, isTrue);
      expect(r.terms.single.dice, isEmpty);
    });

    test('NdX sums the dice', () {
      final r = roll('2d6', [3, 4]);
      expect(r.total, 7);
      expect(values(r), [3, 4]);
      expect(r.terms.single.notation, '2d6');
    });

    test('dX means one die', () {
      final r = roll('d20', [17]);
      expect(r.total, 17);
      expect(r.expression, '1d20');
    });

    test('d% is a d100', () {
      final random = ScriptedRandom.dice([42]);
      final r = DiceEngine(random: random).roll('d%');
      expect(r.total, 42);
      expect(random.requested, [100]);
      expect(r.expression, '1d100');
    });

    test('NdF rolls Fate dice from -1 to +1', () {
      final random = ScriptedRandom([0, 1, 2, 2]);
      final r = DiceEngine(random: random).roll('4dF');
      expect(values(r), [-1, 0, 1, 1]);
      expect(r.total, 1);
      expect(random.requested, everyElement(3));
      expect(r.expression, '4dF');
    });

    test('sums and differences of terms', () {
      final r = roll('2d6 + 1d4 - 2', [6, 2, 3]);
      expect(r.total, 9);
      expect(r.terms.length, 3);
      expect(r.terms[2].isConstant, isTrue);
    });

    test('whitespace and letter case are ignored', () {
      final r = roll(' 2D6  +  3 ', [1, 1]);
      expect(r.total, 5);
      expect(r.expression, '2d6 + 3');
    });

    test('multiplication by a constant', () {
      expect(roll('1d6*3', [4]).total, 12);
    });

    test('division by a constant floors', () {
      expect(roll('1d6/4', [5]).total, 1);
      expect(roll('7/2', []).total, 3);
      expect(roll('-7/2', []).total, -4);
    });

    test('parentheses group a sub-expression', () {
      final r = roll('(1d6+2)*2', [3]);
      expect(r.total, 10);
      expect(r.expression, '(1d6 + 2) * 2');
    });

    test('unary minus and plus', () {
      expect(roll('-1d4+10', [3]).total, 7);
      expect(roll('+3', []).total, 3);
      expect(roll('--3', []).total, 3);
    });

    test('* binds tighter than +', () {
      expect(roll('2+3*4', []).total, 14);
      expect(roll('2-3*4', []).total, -10);
    });

    test('subtraction is left-associative', () {
      expect(roll('10-3-2', []).total, 5);
    });

    test('labels in square brackets keep their case', () {
      final r = roll('2d6[fire] + 1d4[Cold]', [1, 2, 3]);
      expect(r.total, 6);
      expect(r.terms[0].label, 'fire');
      expect(r.terms[1].label, 'Cold');
      expect(r.expression, '2d6[fire] + 1d4[Cold]');
    });

    test('a label may follow a space, constants and groups', () {
      expect(roll('1d8 [slashing]', [4]).terms.single.label, 'slashing');
      expect(roll('3[bonus]', []).terms.single.label, 'bonus');
      expect(roll('(1d4+1)[heal]', [2]).expression, '(1d4 + 1)[heal]');
    });

    test('an empty label is ignored', () {
      final r = roll('1d6[ ]', [2]);
      expect(r.terms.single.label, isNull);
      expect(r.expression, '1d6');
    });

    test('breakdown lists every face after its term', () {
      final r = roll('4d6kh3+2', [6, 5, 3, 1]);
      expect(r.breakdown, '4d6kh3 (6, 5, 3, ~1~) + 2');
    });

    test('canonical text round-trips through the parser', () {
      const text = '4d6r1!kh3>=4f<=1[x] + (2d8 - 1) * 2';
      final expression = DiceEngine.parse(text);
      expect(expression.canonical, text);
      expect(DiceEngine.parse(expression.canonical).canonical, text);
    });

    test('zero dice roll nothing', () {
      final r = roll('0d6+1', []);
      expect(r.total, 1);
      expect(r.terms.first.dice, isEmpty);
    });

    test('the default Random produces faces in range', () {
      final engine = DiceEngine(random: Random(7));
      for (var k = 0; k < 50; k++) {
        final r = engine.roll('3d6');
        expect(r.total, inInclusiveRange(3, 18));
      }
    });
  });

  group('keep and drop', () {
    test('kh3 keeps the three highest', () {
      final r = roll('4d6kh3', [6, 5, 3, 1]);
      expect(r.total, 14);
      expect(droppedFlags(r), [false, false, false, true]);
    });

    test('k without a count keeps the highest one', () {
      final r = roll('2d20k', [5, 17]);
      expect(r.total, 17);
      expect(r.expression, '2d20kh1');
    });

    test('kl keeps the lowest', () {
      expect(roll('2d20kl1', [5, 17]).total, 5);
      expect(roll('3d6kl2', [4, 2, 6]).total, 6);
    });

    test('dh drops the highest', () {
      final r = roll('3d6dh1', [4, 2, 6]);
      expect(r.total, 6);
      expect(droppedFlags(r), [false, false, true]);
    });

    test('dl and bare d drop the lowest', () {
      expect(roll('4d6dl1', [2, 3, 4, 5]).total, 12);
      final r = roll('4d6d1', [2, 3, 4, 5]);
      expect(r.total, 12);
      expect(r.expression, '4d6dl1');
    });

    test('ties keep the earlier die', () {
      final r = roll('3d6kh1', [5, 5, 2]);
      expect(r.total, 5);
      expect(droppedFlags(r), [false, true, true]);
    });

    test('keeping more dice than rolled keeps all', () {
      final r = roll('2d6kh5', [1, 2]);
      expect(r.total, 3);
      expect(droppedFlags(r), [false, false]);
    });

    test('dropping more dice than rolled leaves zero', () {
      expect(roll('2d6dl5', [3, 4]).total, 0);
    });
  });

  group('exploding', () {
    test('! adds a die on the maximum', () {
      final r = roll('3d6!', [6, 2, 3, 4]);
      expect(r.total, 15);
      expect(values(r), [6, 2, 3, 4]);
      expect(r.terms.single.dice.first.exploded, isTrue);
      expect(r.terms.single.dice.last.exploded, isFalse);
    });

    test('explosions chain', () {
      final r = roll('1d6!', [6, 6, 2]);
      expect(r.total, 14);
      expect(r.terms.single.dice.length, 3);
    });

    test('!>N explodes at or above the threshold', () {
      final r = roll('2d10!>9', [9, 3, 10, 1]);
      expect(r.total, 23);
      expect(r.expression, '2d10!>9');
    });

    test('!<N explodes at or below the threshold', () {
      expect(roll('2d6!<2', [1, 4, 5]).total, 10);
    });

    test('!=N explodes on exactly N', () {
      final r = roll('1d6!=3', [3, 6]);
      expect(r.total, 9);
      expect(r.expression, '1d6!=3');
    });

    test('explosions are capped at 100 extra dice', () {
      final r = roll('1d1!', List.filled(101, 1));
      expect(r.terms.single.dice.length, 101);
      expect(r.total, 101);
    });

    test('!! compounds into one die', () {
      final r = roll('1d6!!', [6, 6, 3]);
      expect(r.total, 15);
      final die = r.terms.single.dice.single;
      expect(die.value, 15);
      expect(die.exploded, isTrue);
      expect(die.critical, isTrue);
    });

    test('compounding happens before keep', () {
      final r = roll('2d6!!kh1', [6, 2, 4]);
      expect(values(r), [10, 2]);
      expect(r.total, 10);
    });

    test('compounding is capped too', () {
      final r = roll('1d1!!', List.filled(101, 1));
      expect(r.total, 101);
    });
  });

  group('rerolls', () {
    test('rN rerolls repeatedly', () {
      final r = roll('1d6r1', [1, 1, 4]);
      expect(r.total, 4);
      expect(r.terms.single.dice.single.rerolled, isTrue);
    });

    test('r<N rerolls at or below', () {
      expect(roll('1d6r<2', [2, 1, 5]).total, 5);
    });

    test('r>N rerolls at or above', () {
      expect(roll('1d6r>5', [6, 5, 3]).total, 3);
    });

    test('ro rerolls only once', () {
      final r = roll('1d6ro1', [1, 1]);
      expect(r.total, 1);
      expect(r.terms.single.dice.single.rerolled, isTrue);
      expect(r.expression, '1d6ro1');
    });

    test('bare r rerolls ones', () {
      expect(roll('2d6r', [1, 3, 5]).total, 8);
    });

    test('several reroll conditions combine', () {
      expect(roll('1d6r1r2', [2, 1, 6]).total, 6);
    });

    test('a die that never matches is not marked', () {
      final r = roll('1d6r1', [4]);
      expect(r.terms.single.dice.single.rerolled, isFalse);
    });

    test('rerolls are capped', () {
      final r = roll('1d6r1', List.filled(101, 1));
      expect(r.total, 1);
    });

    test('a reroll matching every face is rejected', () {
      expect(parseError('1d6r<6').code, DiceErrorCode.impossibleReroll);
      expect(parseError('1d1r1').code, DiceErrorCode.impossibleReroll);
      expect(parseError('1d6r<3r>4').code, DiceErrorCode.impossibleReroll);
      expect(DiceEngine.isValid('1d6ro<6'), isTrue);
    });
  });

  group('success counting', () {
    test('>=N counts successes', () {
      final r = roll('5d10>=8', [8, 9, 3, 10, 7]);
      expect(r.total, 3);
      expect(r.terms.single.countsSuccesses, isTrue);
      expect([for (final d in r.terms.single.dice) d.success],
          [true, true, false, true, false]);
    });

    test('>N is strict', () {
      expect(roll('5d10>8', [8, 9, 3, 10, 7]).total, 2);
    });

    test('<=N and <N', () {
      expect(roll('4d6<=2', [1, 2, 3, 6]).total, 2);
      expect(roll('4d6<2', [1, 2, 3, 6]).total, 1);
    });

    test('=N counts exact faces', () {
      expect(roll('3d6=6', [6, 6, 1]).total, 2);
    });

    test('failures subtract', () {
      final r = roll('5d10>=8f<=1', [8, 1, 1, 10, 5]);
      expect(r.total, 0);
      expect(r.terms.single.dice[1].failure, isTrue);
      expect(roll('4d10>=8f1', [1, 9, 1, 2]).total, -1);
    });

    test('only kept dice count', () {
      expect(roll('3d10kh2>=8', [9, 8, 10]).total, 2);
    });

    test('a success term adds to other terms', () {
      expect(roll('3d6>=5 + 1', [5, 6, 1]).total, 3);
    });

    test('success dice are marked in the breakdown', () {
      expect(roll('2d6>=5', [5, 2]).breakdown, '2d6>=5 (5*, 2)');
    });
  });

  group('critical and fumble flags', () {
    test('natural max and natural 1', () {
      final r = roll('2d20', [20, 1]);
      expect(r.terms.single.dice[0].critical, isTrue);
      expect(r.terms.single.dice[1].fumble, isTrue);
      expect(r.hasCritical, isTrue);
      expect(r.hasFumble, isTrue);
    });

    test('Fate dice carry no crit flags', () {
      final r = DiceEngine(random: ScriptedRandom([2, 0])).roll('2dF');
      expect(r.hasCritical, isFalse);
      expect(r.hasFumble, isFalse);
    });

    test('a dropped crit does not count', () {
      final r = roll('2d20kl1', [20, 5]);
      expect(r.hasCritical, isFalse);
      expect(r.terms.single.dice.first.critical, isTrue);
    });

    test('exploded and dropped dice render with markers', () {
      final r = roll('2d6!kh1', [6, 1, 3]);
      expect(r.breakdown, '2d6!kh1 (6!, ~1~, ~3~)');
    });
  });

  group('limits and errors', () {
    test('empty input', () {
      expect(parseError('').code, DiceErrorCode.empty);
      expect(parseError('   ').code, DiceErrorCode.empty);
    });

    test('at most 1000 dice per term', () {
      final e = parseError('1001d6');
      expect(e.code, DiceErrorCode.tooManyDice);
      expect(e.position, 0);
      final r = DiceEngine(random: Random(1)).roll('1000d6');
      expect(r.terms.single.dice.length, 1000);
    });

    test('sides between 1 and 10000', () {
      final e = parseError('1d0');
      expect(e.code, DiceErrorCode.badSides);
      expect(e.position, 2);
      expect(parseError('1d10001').code, DiceErrorCode.badSides);
      expect(DiceEngine.isValid('1d10000'), isTrue);
    });

    test('unexpected characters report their position', () {
      final e = parseError('2d6 + x');
      expect(e.code, DiceErrorCode.unexpectedChar);
      expect(e.position, 6);
      expect(parseError('2d6 3').code, DiceErrorCode.unexpectedChar);
      expect(parseError('hello').code, DiceErrorCode.unexpectedChar);
    });

    test('input that stops early', () {
      expect(parseError('2d6 +').code, DiceErrorCode.unexpectedEnd);
      expect(parseError('2d').code, DiceErrorCode.unexpectedEnd);
      expect(parseError('1d6*').code, DiceErrorCode.unexpectedEnd);
      expect(parseError('1d6r<').code, DiceErrorCode.unexpectedEnd);
    });

    test('a number is expected', () {
      final e = parseError('2dx');
      expect(e.code, DiceErrorCode.expectedNumber);
      expect(e.position, 2);
      expect(parseError('1d6*d4').code, DiceErrorCode.expectedNumber);
      expect(parseError('3d6>x').code, DiceErrorCode.expectedNumber);
    });

    test('unbalanced parentheses', () {
      final open = parseError('(1d6+2');
      expect(open.code, DiceErrorCode.unbalancedParen);
      expect(open.position, 0);
      final close = parseError('1d6)');
      expect(close.code, DiceErrorCode.unbalancedParen);
      expect(close.position, 3);
    });

    test('division by zero', () {
      expect(parseError('1d6/0').code, DiceErrorCode.divisionByZero);
    });

    test('numbers too large', () {
      expect(parseError('99999999999').code, DiceErrorCode.numberTooLarge);
      expect(parseError('2000000000').code, DiceErrorCode.numberTooLarge);
    });

    test('results too large for the evaluator', () {
      expect(
        () => DiceEngine().roll('1000000000*1000000000*1000000'),
        throwsA(isA<DiceParseException>().having(
            (e) => e.code, 'code', DiceErrorCode.numberTooLarge)),
      );
    });

    test('repeated modifiers', () {
      final e = parseError('4d6kh3kl1');
      expect(e.code, DiceErrorCode.duplicateModifier);
      expect(e.position, 6);
      expect(parseError('1d6!!!').code, DiceErrorCode.duplicateModifier);
      expect(parseError('3d6>4>5').code, DiceErrorCode.duplicateModifier);
      expect(parseError('3d6>4f1f2').code, DiceErrorCode.duplicateModifier);
    });

    test('unterminated label', () {
      final e = parseError('1d6[fire');
      expect(e.code, DiceErrorCode.unterminatedLabel);
      expect(e.position, 3);
    });

    test('overly long input', () {
      expect(parseError('1d6+' * 200).code, DiceErrorCode.tooLong);
    });

    test('isValid and exception details', () {
      expect(DiceEngine.isValid('2d6+3'), isTrue);
      expect(DiceEngine.isValid('2d6+'), isFalse);
      final e = parseError('2d6 +');
      expect(e.source, '2d6 +');
      expect(e.toString(), contains('unexpectedEnd'));
    });
  });

  group('roller options', () {
    String withOptions(String text,
            {RollMode mode = RollMode.normal, int modifier = 0}) =>
        DiceEngine.parse(text)
            .withOptions(mode: mode, modifier: modifier)
            .canonical;

    test('advantage and disadvantage rewrite a single d20', () {
      expect(withOptions('1d20+5', mode: RollMode.advantage), '2d20kh1 + 5');
      expect(withOptions('d20', mode: RollMode.disadvantage), '2d20kl1');
    });

    test('the modifier is appended', () {
      expect(withOptions('1d20 + 5', modifier: -2), '1d20 + 5 - 2');
      expect(withOptions('2d6', modifier: 3), '2d6 + 3');
      expect(withOptions('2d6'), '2d6');
    });

    test('only the first plain single die is rewritten', () {
      expect(withOptions('2d6+1d4+1d20', mode: RollMode.advantage),
          '2d6 + 2d4kh1 + 1d20');
      expect(withOptions('2d6', mode: RollMode.advantage), '2d6');
      expect(withOptions('1dF+1d4kh1', mode: RollMode.advantage),
          '1dF + 1d4kh1');
    });

    test('the rewritten expression rolls', () {
      final r = DiceEngine.parse('1d20+2')
          .withOptions(mode: RollMode.advantage)
          .evaluate(ScriptedRandom.dice([4, 15]));
      expect(r.total, 17);
    });

    test('diceTerms lists dice terms in order', () {
      final terms = DiceEngine.parse('(1d4+2d6)*2 - 3d8').diceTerms;
      expect([for (final t in terms) t.notation], ['1d4', '2d6', '3d8']);
    });
  });
}
