import 'dart:convert';

import '../../domain/services/linking/mention_parser.dart';

/// Resolves embeds while converting lore to Markdown. Each returns the
/// Markdown to insert, or null to drop the embed.
class MarkdownEmbeds {
  /// An @-mention of another entry (Obsidian: `[[Note]]`).
  final String? Function(String entityId, String label) mention;

  /// A vault image by media id (Obsidian: `![[file.png]]`).
  final String? Function(String mediaId) image;

  /// A file attachment chip.
  final String? Function(String mediaId, String name) attachment;

  const MarkdownEmbeds({
    required this.mention,
    required this.image,
    required this.attachment,
  });

  /// Plain text fallbacks (labels and names only).
  static final plain = MarkdownEmbeds(
    mention: (_, label) => label,
    image: (_) => null,
    attachment: (_, name) => name,
  );
}

enum _Block { paragraph, heading, bullet, ordered, check, quote, code }

/// Converts Quill Delta JSON to CommonMark (+ task lists and Obsidian
/// embeds): headings, bold/italic/strike/inline code/links, bullet,
/// numbered and check lists with nesting, quotes and code blocks.
/// Unreadable input yields an empty string.
String deltaToMarkdown(String deltaJson, {MarkdownEmbeds? embeds}) {
  final resolve = embeds ?? MarkdownEmbeds.plain;
  final Object? decoded;
  try {
    decoded = jsonDecode(deltaJson);
  } catch (_) {
    return '';
  }
  if (decoded is! List) return '';

  final lines = <(_Block, String, int)>[]; // block, text, indent
  final line = StringBuffer();

  void endLine(Map<Object?, Object?>? attrs) {
    final a = attrs ?? const {};
    final indent = (a['indent'] as num?)?.toInt() ?? 0;
    final header = (a['header'] as num?)?.toInt();
    final list = a['list'];
    final block = header != null
        ? _Block.heading
        : a['code-block'] != null
            ? _Block.code
            : a['blockquote'] == true
                ? _Block.quote
                : switch (list) {
                    'bullet' => _Block.bullet,
                    'ordered' => _Block.ordered,
                    'checked' || 'unchecked' => _Block.check,
                    _ => _Block.paragraph,
                  };
    var text = line.toString();
    line.clear();
    text = switch (block) {
      _Block.heading => '${'#' * header!.clamp(1, 6)} $text',
      _Block.check => '[${list == 'checked' ? 'x' : ' '}] $text',
      _ => text,
    };
    lines.add((block, text, indent));
  }

  for (final op in decoded) {
    if (op is! Map) continue;
    final insert = op['insert'];
    final attrs = op['attributes'] as Map?;
    if (insert is String) {
      final parts = insert.split('\n');
      for (var i = 0; i < parts.length; i++) {
        if (parts[i].isNotEmpty) line.write(_inline(parts[i], attrs));
        // Line attributes ride on the newline that ends the line.
        if (i < parts.length - 1) endLine(attrs);
      }
    } else if (insert is Map) {
      final String? md;
      if (insert[entityLinkEmbedKey] case final Object raw) {
        final p = _payload(raw);
        md = p == null
            ? null
            : resolve.mention(p['id'] as String? ?? '',
                p['label'] as String? ?? '');
      } else if (insert['image'] case final String source) {
        md = source.startsWith('media:')
            ? resolve.image(source.substring('media:'.length))
            : source.startsWith('http')
                ? '![]($source)'
                : null;
      } else if (insert[fileAttachmentEmbedKey] case final Object raw) {
        final p = _payload(raw);
        md = p == null
            ? null
            : resolve.attachment(
                p['mediaId'] as String? ?? '', p['name'] as String? ?? '');
      } else {
        md = null;
      }
      if (md != null) line.write(md);
    }
  }
  if (line.isNotEmpty) endLine(null);

  // Join: runs of list items, quotes and code lines stay together; other
  // blocks are separated by a blank line.
  final out = StringBuffer();
  _Block? previous;
  var ordinal = 0;
  for (final (block, text, indent) in lines) {
    final sameRun = previous == block &&
        block != _Block.paragraph &&
        block != _Block.heading;
    final listRun = {_Block.bullet, _Block.ordered, _Block.check};
    final continuesList =
        listRun.contains(previous) && listRun.contains(block);
    if (previous == _Block.code && block != _Block.code) out.write('```\n');
    if (out.isNotEmpty && !(sameRun || continuesList)) out.write('\n');
    if (block == _Block.code && previous != _Block.code) out.write('```\n');
    if (block == _Block.ordered && previous != _Block.ordered) ordinal = 0;
    final pad = '  ' * indent;
    switch (block) {
      case _Block.paragraph:
        if (text.isNotEmpty) out.write('$text\n');
      case _Block.heading:
        out.write('$text\n');
      case _Block.bullet:
      case _Block.check:
        out.write('$pad- $text\n');
      case _Block.ordered:
        ordinal++;
        out.write('$pad$ordinal. $text\n');
      case _Block.quote:
        out.write('> $text\n');
      case _Block.code:
        out.write('$text\n');
    }
    previous = block;
  }
  if (previous == _Block.code) out.write('```\n');
  return out.toString().replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}

Map<Object?, Object?>? _payload(Object? raw) {
  Object? payload = raw;
  if (payload is String) {
    try {
      payload = jsonDecode(payload);
    } catch (_) {
      return null;
    }
  }
  return payload is Map ? payload : null;
}

/// Characters that would start Markdown formatting inside plain text.
final _special = RegExp(r'([\\`*_\[\]<>])');

String _inline(String text, Map<Object?, Object?>? attrs) {
  if (attrs?['code'] == true) return '`${text.replaceAll('`', 'ˋ')}`';
  var t = text.replaceAllMapped(_special, (m) => '\\${m[1]}');
  if (t.trim().isEmpty) return t;
  // Markers must hug the text: "** bold**" is not bold in CommonMark.
  final lead = RegExp(r'^\s*').stringMatch(t)!;
  final trail = RegExp(r'\s*$').stringMatch(t)!;
  var core = t.substring(lead.length, t.length - trail.length);
  if (attrs?['bold'] == true) core = '**$core**';
  if (attrs?['italic'] == true) core = '*$core*';
  if (attrs?['strike'] == true) core = '~~$core~~';
  if (attrs?['link'] case final String url) core = '[$core](<$url>)';
  return '$lead$core$trail';
}
