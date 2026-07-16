import 'package:intl/intl.dart';

int nowMs() => DateTime.now().toUtc().millisecondsSinceEpoch;

DateTime fromMs(int ms) =>
    DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();

final _dateFormat = DateFormat.yMMMd();
final _dateTimeFormat = DateFormat.yMMMd().add_Hm();

String formatDate(int ms) => _dateFormat.format(fromMs(ms));
String formatDateTime(int ms) => _dateTimeFormat.format(fromMs(ms));

/// Compact "time ago" used in recents and version lists.
String timeAgo(int ms) {
  final diff = DateTime.now().difference(fromMs(ms));
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 30) return '${diff.inDays}d ago';
  return formatDate(ms);
}
