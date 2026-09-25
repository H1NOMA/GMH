import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/combat/creature_stats.dart';

void main() {
  group('hit points', () {
    test('stat block text: average first', () {
      expect(parseHitPoints('45 (6d10 + 12)'), const HitPoints(45, 45));
      expect(parseHitPoints('142 (15d12 + 45)'), const HitPoints(142, 142));
    });

    test('current / max', () {
      expect(parseHitPoints('34 / 40'), const HitPoints(34, 40));
      expect(parseHitPoints('34/40'), const HitPoints(34, 40));
      // Current above max is clamped.
      expect(parseHitPoints('50 / 40'), const HitPoints(40, 40));
    });

    test('numbers and bare dice formulas', () {
      expect(parseHitPoints(22), const HitPoints(22, 22));
      expect(parseHitPoints(7.6), const HitPoints(8, 8));
      expect(parseHitPoints('2d6'), const HitPoints(7, 7));
      expect(parseHitPoints('6d10+12'), const HitPoints(45, 45));
      expect(parseHitPoints('1d4 - 5'), const HitPoints(1, 1));
    });

    test('garbage gives null', () {
      expect(parseHitPoints(null), isNull);
      expect(parseHitPoints(''), isNull);
      expect(parseHitPoints('lots'), isNull);
      expect(parseHitPoints(-3), isNull);
      expect(parseHitPoints(double.nan), isNull);
      expect(parseHitPoints(const ['x']), isNull);
    });
  });

  test('armor class', () {
    expect(parseArmorClass(15), 15);
    expect(parseArmorClass(15.0), 15);
    expect(parseArmorClass('17 (natural armor)'), 17);
    expect(parseArmorClass('none'), isNull);
    expect(parseArmorClass(null), isNull);
  });

  test('ability modifier', () {
    expect(abilityModifier(10), 0);
    expect(abilityModifier(11), 0);
    expect(abilityModifier(12), 1);
    expect(abilityModifier(14), 2);
    expect(abilityModifier(9), -1);
    expect(abilityModifier(7), -2);
    expect(abilityModifier(1), -5);
    expect(abilityModifier(30), 10);
  });

  group('challenge rating', () {
    test('fractions, unicode and decimals', () {
      expect(parseChallengeRating('1/4'), '1/4');
      expect(parseChallengeRating(' 1 / 8 '), '1/8');
      expect(parseChallengeRating('½'), '1/2');
      expect(parseChallengeRating('0.25'), '1/4');
      expect(parseChallengeRating('0,5'), '1/2');
      expect(parseChallengeRating('0'), '0');
    });

    test('with XP text and prefixes', () {
      expect(parseChallengeRating('5 (1,800 XP)'), '5');
      expect(parseChallengeRating('CR 10'), '10');
      expect(parseChallengeRating('10'), '10');
      expect(parseChallengeRating('30'), '30');
    });

    test('out of range or garbage', () {
      expect(parseChallengeRating('31'), isNull);
      expect(parseChallengeRating('1/3'), isNull);
      expect(parseChallengeRating('1/0'), isNull);
      expect(parseChallengeRating('dragon'), isNull);
      expect(parseChallengeRating(''), isNull);
    });

    test('XP table', () {
      expect(xpForChallenge('0'), 10);
      expect(xpForChallenge('1/8'), 25);
      expect(xpForChallenge('1/4'), 50);
      expect(xpForChallenge('1/2'), 100);
      expect(xpForChallenge('1'), 200);
      expect(xpForChallenge('5'), 1800);
      expect(xpForChallenge('10'), 5900);
      expect(xpForChallenge('17'), 18000);
      expect(xpForChallenge('24'), 62000);
      expect(xpForChallenge('30'), 155000);
      expect(xpForChallenge('x'), isNull);
      expect(crXp, hasLength(34));
    });

    test('explicit XP', () {
      expect(parseExplicitXp('5 (1,800 XP)'), 1800);
      expect(parseExplicitXp('8 (3.900 EP)'), isNull);
      expect(parseExplicitXp('2 (450 xp)'), 450);
      expect(parseExplicitXp('3'), isNull);
    });
  });

  group('CreatureStats.fromAttributes', () {
    test('creature template', () {
      final s = CreatureStats.fromAttributes({
        'hp': '142 (15d12 + 45)',
        'ac': 17,
        'dexterity': 12,
        'challenge': '7',
      });
      expect((s.hpMax, s.hpCurrent, s.ac), (142, 142, 17));
      expect(s.initiativeBonus, 1);
      expect(s.cr, '7');
      expect(s.xp, 2900);
    });

    test('explicit XP in the challenge text wins', () {
      final s = CreatureStats.fromAttributes({'challenge': '5 (2,300 XP)'});
      expect(s.cr, '5');
      expect(s.xp, 2300);
    });

    test('character: current/max HP, initiative field fallback, no XP', () {
      final s = CreatureStats.fromAttributes({
        'hp': '34 / 40',
        'ac': '16',
        'initiative': 3,
        'challenge': '3',
      }, isPlayer: true);
      expect((s.hpCurrent, s.hpMax, s.ac), (34, 40, 16));
      expect(s.initiativeBonus, 3);
      expect(s.xp, 0);
    });

    test('dexterity as text, garbled values and empty maps', () {
      expect(CreatureStats.fromAttributes({'dexterity': '16 (+3)'})
          .initiativeBonus, 3);
      final s = CreatureStats.fromAttributes({
        'hp': {'broken': true},
        'ac': [1],
        'dexterity': 'quick',
        'challenge': 'boss',
      });
      expect(s.hpMax, isNull);
      expect(s.ac, isNull);
      expect(s.initiativeBonus, 0);
      expect(s.cr, 'boss');
      expect(s.xp, 0);
      final empty = CreatureStats.fromAttributes(const {});
      expect((empty.hpMax, empty.ac, empty.xp, empty.cr), (null, null, 0, ''));
    });
  });
}
