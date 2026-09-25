import 'package:flutter/foundation.dart';

import 'combatant.dart';

@immutable
class DamageResult {
  final Combatant combatant;

  /// A monster dropped to 0 HP by this hit and was marked defeated (players
  /// at 0 HP are dying, not defeated, so they are never marked).
  final bool becameDefeated;

  /// DC of the concentration save the hit calls for, or null when the
  /// combatant was not concentrating or took no damage.
  final int? concentrationDc;

  const DamageResult(this.combatant,
      {this.becameDefeated = false, this.concentrationDc});
}

/// Concentration save DC for [damage]: half the damage, at least 10, at
/// most 30 (SRD 5.2.1).
int concentrationDc(int damage) => (damage ~/ 2).clamp(10, 30);

/// Temporary hit points absorb damage first; hit points never drop below 0.
DamageResult applyDamage(Combatant c, int amount) {
  if (amount <= 0) return DamageResult(c);
  final absorbed = amount < c.hpTemp ? amount : c.hpTemp;
  final rest = amount - absorbed;
  final hp = c.hpCurrent - rest < 0 ? 0 : c.hpCurrent - rest;
  // Without any hit points on record (a manual entry with unknown HP) a
  // hit cannot mean the creature is down.
  final tracked = c.hpMax > 0 || c.hpCurrent > 0;
  final becameDefeated =
      tracked && !c.isPlayer && !c.defeated && hp == 0 && rest > 0;
  return DamageResult(
    c.copyWith(
      hpTemp: c.hpTemp - absorbed,
      hpCurrent: hp,
      defeated: becameDefeated ? true : null,
    ),
    becameDefeated: becameDefeated,
    concentrationDc: c.concentration ? concentrationDc(amount) : null,
  );
}

/// Heals up to the maximum (uncapped when the maximum is unknown, i.e. 0)
/// and brings a defeated combatant back.
Combatant applyHeal(Combatant c, int amount) {
  if (amount <= 0) return c;
  final raw = c.hpCurrent + amount;
  final hp = c.hpMax > 0 && raw > c.hpMax ? c.hpMax : raw;
  return c.copyWith(hpCurrent: hp, defeated: hp > 0 ? false : null);
}

/// Temporary hit points do not stack: the higher value is kept.
Combatant applyTempHp(Combatant c, int amount) {
  if (amount <= c.hpTemp) return c;
  return c.copyWith(hpTemp: amount);
}
