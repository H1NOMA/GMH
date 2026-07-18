import 'dart:convert';

/// Converts TTG rich text (markdown, simple HTML, an existing Quill delta,
/// or plain text) into the Quill delta ops GMH documents store.
///
/// Preserved: headers, bold, italic, underline, strikethrough, inline code,
/// links, ordered/unordered lists, blockquotes, code blocks. Markdown tables
/// keep their layout inside a code block (Quill has no table model, and a
/// monospaced block is the only lossless rendering). Image references are
/// collected into [RichTextConversion.imageRefs] so the importer can pull
/// them into the media vault and the entity gallery.
class RichTextConversion {
  final List<Map<String, Object?>> ops;
  final String plainText;
  final List<String> imageRefs;

  const RichTextConversion({
    required this.ops,
    required this.plainText,
    required this.imageRefs,
  });

  String get contentJson => jsonEncode(ops);
}

RichTextConversion convertRichText(String source) {
  final text = source.trim();
  if (text.isEmpty) {
    return const RichTextConversion(
        ops: [{'insert': '\n'}], plainText: '', imageRefs: []);
  }

  // Already a Quill delta? Use it untouched (lossless round-trip).
  if (text.startsWith('[') || text.startsWith('{"ops"')) {
    final delta = _tryParseDelta(text);
    if (delta != null) {
      return RichTextConversion(
        ops: delta,
        plainText: _plainTextOf(delta),
        imageRefs: const [],
      );
    }
  }

  final markdown =
      _looksLikeHtml(text) ? _htmlToMarkdown(text) : text;
  return _markdownToDelta(markdown);
}

List<Map<String, Object?>>? _tryParseDelta(String text) {
  try {
    Object? parsed = jsonDecode(text);
    if (parsed is Map && parsed['ops'] is List) parsed = parsed['ops'];
    if (parsed is! List || parsed.isEmpty) return null;
    final ops = <Map<String, Object?>>[];
    for (final op in parsed) {
      if (op is! Map || !op.containsKey('insert')) return null;
      ops.add(op.cast<String, Object?>());
    }
    final last = ops.last['insert'];
    if (last is! String || !last.endsWith('\n')) {
      ops.add({'insert': '\n'});
    }
    return ops;
  } catch (_) {
    return null;
  }
}

String _plainTextOf(List<Map<String, Object?>> ops) {
  final buffer = StringBuffer();
  for (final op in ops) {
    final insert = op['insert'];
    if (insert is String) buffer.write(insert);
  }
  return buffer.toString().trim();
}

// ------------------------------------------------------------------- HTML

bool _looksLikeHtml(String text) =>
    RegExp(r'<\s*(p|div|br|h[1-6]|b|i|em|strong|u|ul|ol|li|a|img|table|span|blockquote|pre|code)[\s>/]',
            caseSensitive: false)
        .hasMatch(text);

/// Reduces simple HTML to the markdown subset the markdown pass handles.
/// Unknown tags are stripped; entities are unescaped.
String _htmlToMarkdown(String html) {
  var s = html.replaceAll(RegExp(r'[\r]'), '');

  String repl(String pattern, String Function(Match) f) =>
      s = s.replaceAllMapped(
          RegExp(pattern, caseSensitive: false, dotAll: true), f);

  repl(r'<\s*br\s*/?\s*>', (_) => '\n');
  repl(r'<\s*/\s*(p|div|tr)\s*>', (_) => '\n');
  repl(r'<\s*(td|th)[^>]*>', (_) => '| ');
  repl(r'<\s*h([1-6])[^>]*>(.*?)<\s*/\s*h\1\s*>',
      (m) => '\n${'#' * int.parse(m[1]!)} ${m[2]!.trim()}\n');
  repl(r'<\s*(b|strong)[^>]*>(.*?)<\s*/\s*\1\s*>', (m) => '**${m[2]}**');
  repl(r'<\s*(i|em)[^>]*>(.*?)<\s*/\s*\1\s*>', (m) => '*${m[2]}*');
  repl(r'<\s*u[^>]*>(.*?)<\s*/\s*u\s*>', (m) => '⟦u⟧${m[1]}⟦/u⟧');
  repl(r'<\s*(s|strike|del)[^>]*>(.*?)<\s*/\s*\1\s*>', (m) => '~~${m[2]}~~');
  repl(r'<\s*code[^>]*>(.*?)<\s*/\s*code\s*>', (m) => '`${m[1]}`');
  repl(r'<\s*pre[^>]*>(.*?)<\s*/\s*pre\s*>',
      (m) => '\n```\n${m[1]!.trim()}\n```\n');
  repl(r'<\s*blockquote[^>]*>(.*?)<\s*/\s*blockquote\s*>',
      (m) => '\n> ${m[1]!.trim().replaceAll('\n', '\n> ')}\n');
  repl(r'<\s*li[^>]*>(.*?)<\s*/\s*li\s*>', (m) => '\n- ${m[1]!.trim()}');
  repl(r'''<\s*a\s[^>]*href\s*=\s*["']([^"']*)["'][^>]*>(.*?)<\s*/\s*a\s*>''',
      (m) => '[${m[2]}](${m[1]})');
  repl(r'''<\s*img\s[^>]*src\s*=\s*["']([^"']*)["'][^>]*/?\s*>''',
      (m) => '\n![](${m[1]})\n');
  // Strip everything else.
  s = s.replaceAll(RegExp(r'<[^>]+>'), '');

  const entities = {
    '&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"',
    '&#39;': "'", '&apos;': "'", '&nbsp;': ' ', '&mdash;': '—',
    '&ndash;': '–', '&hellip;': '…',
  };
  entities.forEach((k, v) => s = s.replaceAll(k, v));
  s = s.replaceAllMapped(RegExp(r'&#(\d+);'),
      (m) => String.fromCharCode(int.parse(m[1]!)));
  return s;
}

// --------------------------------------------------------------- markdown

class _Span {
  final String text;
  final Map<String, Object?> attributes;
  const _Span(this.text, this.attributes);
}

RichTextConversion _markdownToDelta(String markdown) {
  final ops = <Map<String, Object?>>[];
  final imageRefs = <String>[];
  final lines = markdown.replaceAll('\r\n', '\n').split('\n');

  void addLine(List<_Span> spans, Map<String, Object?> lineAttrs) {
    for (final span in spans) {
      if (span.text.isEmpty) continue;
      ops.add({
        'insert': span.text,
        if (span.attributes.isNotEmpty) 'attributes': span.attributes,
      });
    }
    ops.add({
      'insert': '\n',
      if (lineAttrs.isNotEmpty) 'attributes': lineAttrs,
    });
  }

  var inCodeBlock = false;
  var i = 0;
  while (i < lines.length) {
    final raw = lines[i];
    final line = raw.trimRight();

    if (line.trim().startsWith('```')) {
      inCodeBlock = !inCodeBlock;
      i++;
      continue;
    }
    if (inCodeBlock) {
      addLine([_Span(raw, const {})], const {'code-block': true});
      i++;
      continue;
    }

    // Markdown table: emit the whole block as a monospaced code block so
    // columns stay aligned (Quill has no native tables).
    if (line.contains('|') &&
        i + 1 < lines.length &&
        RegExp(r'^\s*\|?[\s:|-]+\|[\s:|-]*$').hasMatch(lines[i + 1])) {
      while (i < lines.length && lines[i].contains('|')) {
        addLine([_Span(lines[i].trimRight(), const {})],
            const {'code-block': true});
        i++;
      }
      continue;
    }

    final header = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(line);
    if (header != null) {
      final level = header[1]!.length.clamp(1, 3);
      addLine(_inlineSpans(header[2]!, imageRefs), {'header': level});
      i++;
      continue;
    }

    final bullet = RegExp(r'^\s*[-*+]\s+(.*)$').firstMatch(line);
    if (bullet != null) {
      addLine(_inlineSpans(bullet[1]!, imageRefs), const {'list': 'bullet'});
      i++;
      continue;
    }

    final ordered = RegExp(r'^\s*\d+[.)]\s+(.*)$').firstMatch(line);
    if (ordered != null) {
      addLine(_inlineSpans(ordered[1]!, imageRefs), const {'list': 'ordered'});
      i++;
      continue;
    }

    final quote = RegExp(r'^\s*>\s?(.*)$').firstMatch(line);
    if (quote != null) {
      addLine(_inlineSpans(quote[1]!, imageRefs), const {'blockquote': true});
      i++;
      continue;
    }

    // Standalone image line: collect the ref; the importer attaches it to
    // the gallery. A textual marker keeps the reading order visible.
    final image = RegExp(r'^\s*!\[([^\]]*)\]\(([^)]+)\)\s*$').firstMatch(line);
    if (image != null) {
      imageRefs.add(image[2]!.trim());
      final alt = image[1]!.trim();
      if (alt.isNotEmpty) {
        addLine([_Span('🖼 $alt', const {'italic': true})], const {});
      }
      i++;
      continue;
    }

    addLine(_inlineSpans(line, imageRefs), const {});
    i++;
  }

  if (ops.isEmpty) ops.add({'insert': '\n'});
  return RichTextConversion(
    ops: ops,
    plainText: _plainTextOf(ops),
    imageRefs: imageRefs,
  );
}

/// Inline markdown: **bold**, *italic*/_italic_, ~~strike~~, `code`,
/// ⟦u⟧underline⟦/u⟧ (from the HTML pass), [text](url), inline images.
List<_Span> _inlineSpans(String text, List<String> imageRefs) {
  final spans = <_Span>[];
  final pattern = RegExp(
    r'(\*\*(.+?)\*\*)|(\*(.+?)\*)|(__(.+?)__)|(_(.+?)_)|(~~(.+?)~~)|(`([^`]+)`)|(⟦u⟧(.*?)⟦/u⟧)|(!\[([^\]]*)\]\(([^)]+)\))|(\[([^\]]+)\]\(([^)]+)\))',
  );
  var index = 0;
  for (final m in pattern.allMatches(text)) {
    if (m.start > index) {
      spans.add(_Span(text.substring(index, m.start), const {}));
    }
    if (m[2] != null) {
      spans.add(_Span(m[2]!, const {'bold': true}));
    } else if (m[4] != null) {
      spans.add(_Span(m[4]!, const {'italic': true}));
    } else if (m[6] != null) {
      spans.add(_Span(m[6]!, const {'bold': true}));
    } else if (m[8] != null) {
      spans.add(_Span(m[8]!, const {'italic': true}));
    } else if (m[10] != null) {
      spans.add(_Span(m[10]!, const {'strike': true}));
    } else if (m[12] != null) {
      spans.add(_Span(m[12]!, const {'code': true}));
    } else if (m[14] != null) {
      spans.add(_Span(m[14]!, const {'underline': true}));
    } else if (m[16] != null) {
      // Inline image: collect ref, keep a marker in the text flow.
      imageRefs.add(m[17]!.trim());
      if (m[16]!.isNotEmpty) {
        spans.add(_Span('🖼 ${m[16]!}', const {'italic': true}));
      }
    } else if (m[19] != null) {
      spans.add(_Span(m[19]!, {'link': m[20]!}));
    }
    index = m.end;
  }
  if (index < text.length) {
    spans.add(_Span(text.substring(index), const {}));
  }
  return spans;
}
