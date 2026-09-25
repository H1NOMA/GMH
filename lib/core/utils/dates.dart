import 'package:intl/intl.dart';

int nowMs() => DateTime.now().toUtc().millisecondsSinceEpoch;

DateTime fromMs(int ms) =>
    DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();

final _dateFormats = <String, DateFormat>{};
final _dateTimeFormats = <String, DateFormat>{};

/// A locale's formatter, falling back to English when its date symbols
/// are not loaded (plain Dart tests, an unsupported locale).
DateFormat _cached(Map<String, DateFormat> cache, String? locale,
    DateFormat Function(String? locale) build) {
  final key = locale ?? '';
  return cache[key] ??= () {
    try {
      return build(locale);
    } catch (_) {
      return build('en');
    }
  }();
}

String formatDate(int ms, {String? locale}) =>
    _cached(_dateFormats, locale, (l) => DateFormat.yMMMd(l))
        .format(fromMs(ms));

String formatDateTime(int ms, {String? locale}) =>
    _cached(_dateTimeFormats, locale, (l) => DateFormat.yMMMd(l).add_Hm())
        .format(fromMs(ms));
