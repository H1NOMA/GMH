import 'package:flutter/foundation.dart';

import 'json_read.dart';

/// Experience points per challenge rating (SRD 5.2.1). Keys are normalized
/// CR texts as produced by [parseChallengeRating].
const crXp = <String, int>{
  '0': 10, '1/8': 25, '1/4': 50, '1/2': 100,
  '1': 200, '2': 450, '3': 700, '4': 1100, '5': 1800,
  '6': 2300, '7': 2900, '8': 3900, '9': 5000, '10': 5900,
  '11': 7200, '12': 8400, '13': 10000, '14': 11500, '15': 13000,
  '16': 15000, '17': 18000, '18': 20000, '19': 22000, '20': 25000,
  '21': 33000, '22': 41000, '23': 50000, '24': 62000, '25': 75000,
  '26': 90000, '27': 105000, '28': 120000, '29': 135000, '30': 155000,
};

/// XP for a CR given as free text ('1/4', '5 (1,800 XP)', 'CR 10'), or null
/// when it is not a known challenge rating.
int? xpForChallenge(String text) {
  final cr = parseChallengeRating(text);
  return cr == null ? null : crXp[cr];
}

final _firstInt = RegExp(r'-?\d+');

int? _firstInteger(String text) {
  final match = _firstInt.firstMatch(text);
  return match == null ? null : int.tryParse(match.group(0)!);
}

/// Normalizes a challenge rating text to a [crXp] key: '1/4', '¼', '0.25'
/// and 'CR 1/4' all give '1/4'; '5 (1,800 XP)' gives '5'. Null when the
/// text holds no CR between 0 and 30.
String? parseChallengeRating(String text) {
  var t = text.trim().toLowerCase();
  if (t.startsWith('cr')) t = t.substring(2).trim();
  t = t
      .replaceAll('½', '1/2')
      .replaceAll('¼', '1/4')
      .replaceAll('⅛', '1/8')
      .replaceAll(',', '.');
  final fraction = RegExp(r'^(\d+)\s*/\s*(\d+)').firstMatch(t);
  num? value;
  if (fraction != null) {
    final numerator = int.parse(fraction.group(1)!);
    final denominator = int.parse(fraction.group(2)!);
    if (denominator == 0) return null;
    value = numerator / denominator;
  } else {
    final decimal = RegExp(r'^\d+(\.\d+)?').firstMatch(t);
    if (decimal == null) return null;
    value = num.tryParse(decimal.group(0)!);
  }
  if (value == null) return null;
  if (value == 0) return '0';
  if (value == 0.125) return '1/8';
  if (value == 0.25) return '1/4';
  if (value == 0.5) return '1/2';
  if (value == value.roundToDouble() && value >= 1 && value <= 30) {
    return '${value.round()}';
  }
  return null;
}

/// An explicit XP figure in a CR text such as '5 (1,800 XP)'.
int? parseExplicitXp(String text) {
  final match =
      RegExp(r'(\d[\d,.  ]*)\s*xp', caseSensitive: false).firstMatch(text);
  if (match == null) return null;
  return int.tryParse(match.group(1)!.replaceAll(RegExp(r'[^\d]'), ''));
}

@immutable
class HitPoints {
  final int current;
  final int max;
  const HitPoints(this.current, this.max);

  @override
  bool operator ==(Object other) =>
      other is HitPoints && other.current == current && other.max == max;

  @override
  int get hashCode => Object.hash(current, max);

  @override
  String toString() => 'HitPoints($current/$max)';
}

/// Hit points from an attribute: 45, '45 (6d10 + 12)' (the average comes
/// first in a stat block), '34 / 40' (current / max) or a bare dice
/// formula '6d10+12' (its average).
HitPoints? parseHitPoints(Object? value) {
  if (value is num) {
    if (!value.isFinite || value < 0) return null;
    return HitPoints(value.round(), value.round());
  }
  if (value is! String) return null;
  final text = value.trim();
  final pair = RegExp(r'^(\d+)\s*/\s*(\d+)').firstMatch(text);
  if (pair != null) {
    final current = int.parse(pair.group(1)!);
    final max = int.parse(pair.group(2)!);
    return HitPoints(current > max ? max : current, max);
  }
  final dice = RegExp(r'^(\d+)\s*d\s*(\d+)\s*(?:([+-])\s*(\d+))?',
          caseSensitive: false)
      .firstMatch(text);
  if (dice != null) {
    final count = int.parse(dice.group(1)!);
    final sides = int.parse(dice.group(2)!);
    var average = count * (sides + 1) / 2;
    if (dice.group(4) != null) {
      final modifier = int.parse(dice.group(4)!);
      average += dice.group(3) == '-' ? -modifier : modifier;
    }
    final hp = average.floor() < 1 ? 1 : average.floor();
    return HitPoints(hp, hp);
  }
  final match = RegExp(r'^\d+').firstMatch(text);
  if (match == null) return null;
  final hp = int.parse(match.group(0)!);
  return HitPoints(hp, hp);
}

/// Armor class from a number or a text like '15 (natural armor)'.
int? parseArmorClass(Object? value) {
  if (value is num) return value.isFinite ? value.round() : null;
  if (value is String) return _firstInteger(value);
  return null;
}

/// Ability modifier of a score: 10–11 → +0, 14 → +2, 7 → −2.
int abilityModifier(int score) => ((score - 10) / 2).floor();

/// Combat numbers pre-filled from an entity's template attributes.
@immutable
class CreatureStats {
  final int? hpMax;
  final int? hpCurrent;
  final int? ac;
  final int initiativeBonus;
  final String cr;
  final int xp;

  const CreatureStats({
    this.hpMax,
    this.hpCurrent,
    this.ac,
    this.initiativeBonus = 0,
    this.cr = '',
    this.xp = 0,
  });

  /// Reads the shared character/creature template keys: `hp`, `ac`,
  /// `dexterity` (its modifier is the initiative bonus; a character's
  /// `initiative` field is the fallback) and `challenge`. Player characters
  /// give no XP.
  factory CreatureStats.fromAttributes(Map<String, Object?> attributes,
      {bool isPlayer = false}) {
    final hp = parseHitPoints(attributes['hp']);
    final dexterity = readNum(attributes['dexterity']) ??
        (attributes['dexterity'] is String
            ? _firstInteger(attributes['dexterity'] as String)
            : null);
    var bonus = 0;
    if (dexterity != null) {
      bonus = abilityModifier(dexterity.round());
    } else if (readNum(attributes['initiative']) case final value?) {
      bonus = value.round();
    }
    final challengeText = readString(attributes['challenge']).trim();
    final cr = parseChallengeRating(challengeText);
    final xp = isPlayer
        ? 0
        : parseExplicitXp(challengeText) ?? (cr == null ? 0 : crXp[cr]!);
    return CreatureStats(
      hpMax: hp?.max,
      hpCurrent: hp?.current,
      ac: parseArmorClass(attributes['ac']),
      initiativeBonus: bonus,
      cr: cr ?? challengeText,
      xp: xp,
    );
  }
}
