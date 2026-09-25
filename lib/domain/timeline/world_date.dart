import 'package:flutter/foundation.dart';

/// A point in a world's history. Only [year] is required; month and day
/// refine the order when the text gives them. Years may be negative
/// ("300 BC").
@immutable
class WorldDate implements Comparable<WorldDate> {
  final int year;
  final int? month; // 1-based
  final int? day;

  const WorldDate(this.year, [this.month, this.day]);

  @override
  int compareTo(WorldDate other) {
    if (year != other.year) return year.compareTo(other.year);
    final m = (month ?? 0).compareTo(other.month ?? 0);
    if (m != 0) return m;
    return (day ?? 0).compareTo(other.day ?? 0);
  }

  bool operator <(WorldDate other) => compareTo(other) < 0;
  bool operator <=(WorldDate other) => compareTo(other) <= 0;

  @override
  bool operator ==(Object other) =>
      other is WorldDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'WorldDate($year, $month, $day)';
}

/// A world's calendar: month names (with lengths) and an optional year
/// suffix ("DR", "AR"…). The default is the Gregorian calendar.
@immutable
class WorldCalendar {
  final List<({String name, int days})> months;
  final String yearSuffix;

  const WorldCalendar({required this.months, this.yearSuffix = ''});

  bool get isGregorian => identical(months, _gregorianMonths);

  static const gregorian = WorldCalendar(months: _gregorianMonths);

  static const _gregorianMonths = <({String name, int days})>[
    (name: 'January', days: 31),
    (name: 'February', days: 29),
    (name: 'March', days: 31),
    (name: 'April', days: 30),
    (name: 'May', days: 31),
    (name: 'June', days: 30),
    (name: 'July', days: 31),
    (name: 'August', days: 31),
    (name: 'September', days: 30),
    (name: 'October', days: 31),
    (name: 'November', days: 30),
    (name: 'December', days: 31),
  ];

  Map<String, Object?> toData() => {
        'months': [
          for (final m in months) {'name': m.name, 'days': m.days}
        ],
        'yearSuffix': yearSuffix,
      };

  /// Tolerant decoding; anything unusable falls back to [gregorian].
  static WorldCalendar fromData(Map<String, Object?>? data) {
    final raw = data?['months'];
    final months = <({String name, int days})>[
      if (raw is List)
        for (final m in raw)
          if (m is Map &&
              m['name'] is String &&
              (m['name'] as String).trim().isNotEmpty)
            (
              name: (m['name'] as String).trim(),
              days: switch (m['days']) {
                final num n when n >= 1 && n <= 400 => n.toInt(),
                _ => 30,
              },
            ),
    ];
    final suffix = data?['yearSuffix'];
    if (months.isEmpty) {
      return suffix is String && suffix.trim().isNotEmpty
          ? WorldCalendar(
              months: _gregorianMonths, yearSuffix: suffix.trim())
          : gregorian;
    }
    return WorldCalendar(
        months: months, yearSuffix: suffix is String ? suffix.trim() : '');
  }
}

/// Gregorian month names in the app's languages (nominative and, for
/// Russian, genitive — "12 марта"), for parsing. Index = month - 1.
const _gregorianNames = <List<String>>[
  ['january', 'jan', 'январь', 'января', 'januar', 'janvier', '一月'],
  ['february', 'feb', 'февраль', 'февраля', 'februar', 'février', 'fevrier', '二月'],
  ['march', 'mar', 'март', 'марта', 'märz', 'maerz', 'mars', '三月'],
  ['april', 'apr', 'апрель', 'апреля', 'avril', '四月'],
  ['may', 'май', 'мая', 'mai', '五月'],
  ['june', 'jun', 'июнь', 'июня', 'juni', 'juin', '六月'],
  ['july', 'jul', 'июль', 'июля', 'juli', 'juillet', '七月'],
  ['august', 'aug', 'август', 'августа', 'août', 'aout', '八月'],
  ['september', 'sep', 'sept', 'сентябрь', 'сентября', 'septembre', '九月'],
  ['october', 'oct', 'октябрь', 'октября', 'oktober', 'octobre', '十月'],
  ['november', 'nov', 'ноябрь', 'ноября', 'novembre', '十一月'],
  ['december', 'dec', 'декабрь', 'декабря', 'dezember', 'décembre', 'decembre', '十二月'],
];

/// Markers of years before the calendar's epoch, in the app's languages.
final _beforeEpoch = RegExp(
    r'\b(b\.?\s?c\.?e?\.?|bce)\b|до\s*н\.?\s*э\.?|v\.\s?chr\.?|av\.\s?j\.?-?c\.?|公元前',
    caseSensitive: false);

/// Words that announce the year number ("Year 412", "год 412"…).
final _yearWord = RegExp(
    r'(?<!\p{L})(year|год|jahr|an|année|annee|年)\s*(-?\d{1,7})',
    caseSensitive: false,
    unicode: true);

final _iso = RegExp(r'^\s*(-?\d{1,7})-(\d{1,2})(?:-(\d{1,2}))?\s*$');
final _dmy = RegExp(r'^\s*(\d{1,2})[./](\d{1,2})[./](-?\d{1,7})\s*$');
final _number = RegExp(r'-?\d{1,7}');

/// Reads a free-text in-world date: "1492", "1492 DR", "Year 412, 3rd
/// Age", "12 Frostmoon 1492", "Frostmoon 12, 1492", "1492-03-12",
/// "12.03.1492", "300 BC", "300 до н. э."… Month names come from
/// [calendar] (and Gregorian names in every app language). Returns null
/// when the text has no year.
WorldDate? parseWorldDate(String? raw,
    {WorldCalendar calendar = WorldCalendar.gregorian}) {
  if (raw == null) return null;
  final text = raw.trim();
  if (text.isEmpty) return null;
  final negative = _beforeEpoch.hasMatch(text);
  int sign(int year) => negative && year > 0 ? -year : year;

  if (_iso.firstMatch(text) case final m?) {
    final month = int.parse(m[2]!);
    if (month >= 1 && month <= 12) {
      return WorldDate(sign(int.parse(m[1]!)), month,
          m[3] == null ? null : int.parse(m[3]!));
    }
  }
  if (_dmy.firstMatch(text) case final m?) {
    final day = int.parse(m[1]!), month = int.parse(m[2]!);
    if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
      return WorldDate(sign(int.parse(m[3]!)), month, day);
    }
  }

  final lower = text.toLowerCase();
  int? month;
  // Longest name first so "Deepwinter" isn't read as "Winter".
  final candidates = <(String, int)>[
    if (calendar.isGregorian)
      for (var i = 0; i < _gregorianNames.length; i++)
        for (final name in _gregorianNames[i]) (name, i + 1)
    else
      for (var i = 0; i < calendar.months.length; i++)
        (calendar.months[i].name.toLowerCase(), i + 1),
  ]..sort((a, b) => b.$1.length.compareTo(a.$1.length));
  var rest = lower;
  for (final (name, index) in candidates) {
    final at = _wordIndex(lower, name);
    if (at >= 0) {
      month = index;
      rest = lower.replaceRange(at, at + name.length, ' ');
      break;
    }
  }

  // The year: the number after a year word, else — with a month — the
  // number that isn't a plausible day, else the last number.
  final numbers = [
    for (final m in _number.allMatches(rest.replaceAll(RegExp(r'(?<=\d)-'), ' ')))
      int.parse(m[0]!)
  ];
  if (numbers.isEmpty) return null;
  int? year;
  if (_yearWord.firstMatch(rest) case final m?) year = int.parse(m[2]!);
  int? day;
  if (month != null) {
    final days = month <= calendar.months.length
        ? calendar.months[month - 1].days
        : 31;
    final others = [...numbers];
    if (year != null) {
      others.remove(year);
    } else if (numbers.length >= 2) {
      // "12 Frostmoon 1492" / "Frostmoon 12, 1492": the day is the one
      // that fits in the month.
      final dayIndex = numbers.indexWhere((n) => n >= 1 && n <= days);
      if (dayIndex >= 0) {
        day = numbers[dayIndex];
        others.removeAt(dayIndex);
      }
      year = others.isEmpty ? null : others.last;
    } else {
      year = numbers.single;
    }
    if (day == null && year != null) {
      final left = others.where((n) => n != year && n >= 1 && n <= days);
      if (left.isNotEmpty) day = left.first;
    }
  }
  year ??= numbers.last;
  return WorldDate(sign(year), month, day);
}

/// Index of [word] in [text] as a whole word (letters on either side
/// don't count), or -1. CJK names match anywhere.
int _wordIndex(String text, String word) {
  if (word.isEmpty) return -1;
  final cjk = RegExp(r'[぀-鿿]').hasMatch(word);
  var from = 0;
  while (true) {
    final at = text.indexOf(word, from);
    if (at < 0) return -1;
    if (cjk) return at;
    final before = at == 0 ? '' : text[at - 1];
    final after =
        at + word.length >= text.length ? '' : text[at + word.length];
    bool isLetter(String c) =>
        c.isNotEmpty && RegExp(r'\p{L}', unicode: true).hasMatch(c);
    if (!isLetter(before) && !isLetter(after)) return at;
    from = at + 1;
  }
}

/// "12 Frostmoon 1492 DR" in the calendar's own terms.
String formatWorldDate(WorldDate date, WorldCalendar calendar,
    {String Function(int month)? monthName}) {
  final parts = <String>[
    if (date.day != null) '${date.day}',
    if (date.month != null)
      monthName?.call(date.month!) ??
          (date.month! <= calendar.months.length
              ? calendar.months[date.month! - 1].name
              : '${date.month}'),
    '${date.year}',
    if (calendar.yearSuffix.isNotEmpty) calendar.yearSuffix,
  ];
  return parts.join(' ');
}
