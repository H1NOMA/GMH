import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/combat/combatant.dart';
import 'package:gmh/domain/combat/hit_points.dart';

const _goblin = Combatant(id: 'g', name: 'Goblin', hpMax: 7, hpCurrent: 7);

void main() {
  group('damage', () {
    test('temporary hit points absorb first', () {
      final c = _goblin.copyWith(hpTemp: 5);
      final r = applyDamage(c, 3);
      expect((r.combatant.hpTemp, r.combatant.hpCurrent), (2, 7));
      final r2 = applyDamage(c, 9);
      expect((r2.combatant.hpTemp, r2.combatant.hpCurrent), (0, 3));
    });

    test('never below 0; a monster at 0 becomes defeated', () {
      final r = applyDamage(_goblin, 30);
      expect(r.combatant.hpCurrent, 0);
      expect(r.combatant.defeated, isTrue);
      expect(r.becameDefeated, isTrue);
    });

    test('players at 0 are not marked defeated', () {
      final pc = _goblin.copyWith(isPlayer: true);
      final r = applyDamage(pc, 30);
      expect(r.combatant.hpCurrent, 0);
      expect(r.combatant.defeated, isFalse);
      expect(r.becameDefeated, isFalse);
    });

    test('already defeated or unknown HP: no new defeat', () {
      final down = _goblin.copyWith(hpCurrent: 0, defeated: true);
      expect(applyDamage(down, 5).becameDefeated, isFalse);
      const unknown = Combatant(name: 'Shade');
      final r = applyDamage(unknown, 5);
      expect(r.combatant.hpCurrent, 0);
      expect(r.becameDefeated, isFalse);
    });

    test('a hit fully absorbed by temp HP does not defeat', () {
      final c = _goblin.copyWith(hpCurrent: 0, hpTemp: 10);
      final r = applyDamage(c, 4);
      expect(r.becameDefeated, isFalse);
      expect(r.combatant.hpTemp, 6);
    });

    test('zero or negative amounts change nothing', () {
      expect(applyDamage(_goblin, 0).combatant, same(_goblin));
      expect(applyDamage(_goblin, -4).combatant, same(_goblin));
    });

    test('concentration DC: half the damage, min 10, max 30', () {
      final c = _goblin.copyWith(concentration: true, hpMax: 200, hpCurrent: 200);
      expect(applyDamage(c, 7).concentrationDc, 10);
      expect(applyDamage(c, 25).concentrationDc, 12);
      expect(applyDamage(c, 100).concentrationDc, 30);
      expect(applyDamage(_goblin, 7).concentrationDc, isNull);
      expect(concentrationDc(21), 10);
      expect(concentrationDc(22), 11);
    });
  });

  group('heal', () {
    test('capped at max and clears defeated', () {
      final down = _goblin.copyWith(hpCurrent: 0, defeated: true);
      final healed = applyHeal(down, 20);
      expect(healed.hpCurrent, 7);
      expect(healed.defeated, isFalse);
      expect(applyHeal(_goblin.copyWith(hpCurrent: 2), 3).hpCurrent, 5);
    });

    test('unknown maximum: uncapped', () {
      const c = Combatant(name: 'x', hpCurrent: 3);
      expect(applyHeal(c, 10).hpCurrent, 13);
    });

    test('non-positive heal is a no-op', () {
      expect(applyHeal(_goblin, 0), same(_goblin));
    });
  });

  group('temporary hit points', () {
    test('keep the higher value', () {
      final c = _goblin.copyWith(hpTemp: 5);
      expect(applyTempHp(c, 3).hpTemp, 5);
      expect(applyTempHp(c, 8).hpTemp, 8);
      expect(applyTempHp(_goblin, 4).hpTemp, 4);
    });
  });
}
