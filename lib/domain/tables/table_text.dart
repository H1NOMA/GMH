import 'random_table.dart';

// Plain-text form of a table's rows, for bulk editing and pasting tables
// from PDFs or forums. One row per line:
//
//     # comment (ignored), blank lines ignored
//     1-3 | Ranged row           (also "1–3 text", "96-00: text")
//     4: Single value            (also "4 | text", "4. text", "4) text")
//     x3 Weighted row            (also "x3 | text", "×3 text")
//     Plain row                  (weight 1)
//
// `00` as the upper end of a range means 100 (percentile tables).

final _range = RegExp(
    r'^(\d{1,6})\s*[-–—]\s*(\d{1,6})(?:\s*[|:]\s*|\s*[.)]\s+|\s+)(.*)$');
final _single = RegExp(r'^(\d{1,6})(?:\s*[|:]\s*|\s*[.)]\s+)(.*)$');
final _weight = RegExp(r'^[xX×](\d{1,6})(?:\s*[|:]\s*|\s+)(.*)$');

int _value(String digits, {int? lower}) {
  final v = int.parse(digits);
  // Percentile tables write 100 as "00".
  if (v == 0 && digits.length >= 2 && (lower == null || lower > 0)) return 100;
  return v;
}

/// The row [line] describes, or null for blank lines, comments and lines
/// without text.
RandomTableRow? parseTableLine(String line) {
  final t = line.trim();
  if (t.isEmpty || t.startsWith('#')) return null;
  var m = _range.firstMatch(t);
  if (m != null) {
    final text = m[3]!.trim();
    if (text.isEmpty) return null;
    final from = _value(m[1]!);
    final to = _value(m[2]!, lower: from);
    return RandomTableRow(text, from: from, to: to);
  }
  m = _single.firstMatch(t);
  if (m != null) {
    final text = m[2]!.trim();
    if (text.isEmpty) return null;
    final v = _value(m[1]!);
    return RandomTableRow(text, from: v, to: v);
  }
  m = _weight.firstMatch(t);
  if (m != null) {
    final text = m[2]!.trim();
    if (text.isEmpty) return null;
    final w = int.parse(m[1]!);
    return RandomTableRow(text, weight: w < 1 ? 1 : w);
  }
  return RandomTableRow(t);
}

/// Every row in [text], in order.
List<RandomTableRow> parseTableText(String text) => [
      for (final line in text.split(RegExp(r'\r\n|\r|\n')))
        ?parseTableLine(line),
    ];

/// [rows] in the format [parseTableText] reads back. Ranged rows are
/// written with their range; the others with their weight. Rows whose text
/// would read as something else (a comment, a range) get an explicit
/// `x1` prefix so the round trip is exact. Empty rows are left out.
String exportTableText(List<RandomTableRow> rows) {
  final lines = <String>[];
  for (final r in rows) {
    final text = r.text.replaceAll(RegExp(r'\s*[\r\n]+\s*'), ' ').trim();
    if (text.isEmpty) continue;
    if (r.hasRange) {
      final range = r.from == r.to ? '${r.from}' : '${r.from}-${r.to}';
      lines.add('$range | $text');
    } else if (r.weight != 1) {
      lines.add('x${r.weight} $text');
    } else {
      final plain = parseTableLine(text);
      final ambiguous = plain == null || plain.hasRange || plain.weight != 1 ||
          plain.text != text;
      lines.add(ambiguous ? 'x1 $text' : text);
    }
  }
  return lines.join('\n');
}
