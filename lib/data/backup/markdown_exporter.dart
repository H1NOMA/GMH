import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

import '../../core/result.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/entity_template.dart';
import '../../domain/models/link.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/templates/entity_templates.dart';
import 'delta_markdown.dart';
import 'pdf_exporter.dart';

/// Exports a world as a folder of Markdown notes, zipped — ready to open
/// as an Obsidian vault (or read in any editor):
///
/// ```
/// <World>/<World>.md            index: summary + a link to every entry
/// <World>/<Chapter>/<Entry>.md  front matter, fields, lore, relations
/// <World>/attachments/<file>    images and files used by the notes
/// ```
/// Mentions become `[[wiki links]]`, images `![[embeds]]`.
class MarkdownExporter {
  final EntityRepository _entities;
  final DocumentRepository _documents;
  final CategoryRepository _categories;
  final LinkRepository _links;
  final MediaRepository _media;
  final TagRepository _tags;

  MarkdownExporter(this._entities, this._documents, this._categories,
      this._links, this._media, this._tags);

  Future<Result<String>> exportVault({
    required String worldId,
    required String worldName,
    required String outputPath,
    PdfBookLabels? labels,
    bool includeGmOnly = false,
    String relationsTitle = 'Relations',
    String Function(String role)? roleLabel,
  }) {
    final l = labels ?? PdfBookLabels.english;
    return guard(() async {
      final all = (await _entities.getAllEntities(worldId))
          .where((e) => !e.isDeleted)
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      final categories = {
        for (final c in await _categories.categories(worldId)) c.id: c
      };
      final namesById = {for (final e in all) e.id: e.name};
      final root = noteFileName(worldName, fallback: 'World');

      String chapterOf(Entity e) => noteFileName(
          e.kind == EntityKind.custom
              ? categories[e.customCategoryId]?.name ?? l.chapterTitle(e.kind)
              : l.chapterTitle(e.kind),
          fallback: 'Notes');

      // Unique note names across the vault: wiki links resolve by name.
      final noteNames = <String, String>{};
      final taken = <String>{root.toLowerCase()};
      for (final e in all) {
        var name = noteFileName(e.name);
        for (var n = 2; !taken.add(name.toLowerCase()); n++) {
          name = '${noteFileName(e.name)} ($n)';
        }
        noteNames[e.id] = name;
      }

      final files = <String, Uint8List>{};
      final attachmentNames = <String, String>{}; // mediaId -> file name
      final takenAttachments = <String>{};

      Future<String?> attach(String mediaId, [String? preferred]) async {
        if (attachmentNames[mediaId] case final String known) return known;
        final item = await _media.get(mediaId);
        if (item == null) return null;
        final path = await _media.absolutePath(item);
        final file = File(path);
        if (!await file.exists()) return null;
        final ext = p.extension(item.fileName);
        final stem = noteFileName(
            p.basenameWithoutExtension(preferred ?? item.fileName),
            fallback: 'file');
        var name = '$stem$ext';
        for (var n = 2; !takenAttachments.add(name.toLowerCase()); n++) {
          name = '$stem ($n)$ext';
        }
        files['$root/attachments/$name'] = await file.readAsBytes();
        return attachmentNames[mediaId] = name;
      }

      final outgoing = <String, List<Link>>{};
      for (final link in await _links.allForWorld(worldId)) {
        if (namesById.containsKey(link.targetId) &&
            link.role != LinkRoles.mention) {
          (outgoing[link.sourceId] ??= []).add(link);
        }
      }

      for (final entity in all) {
        final sections = entity.kind == EntityKind.custom
            ? categories[entity.customCategoryId]
                    ?.blueprint
                    .toSections(l.fieldsSection) ??
                const <FieldSection>[]
            : EntityTemplates.of(entity.kind).sections;
        final fields = PdfExporter.attributeLines(entity,
            sections: sections,
            namesById: namesById,
            term: l.term,
            includeGmOnly: includeGmOnly);

        // Pre-resolve embeds (async) before the synchronous conversion.
        final doc = await _documents.getByEntity(entity.id);
        final json = doc?.contentJson ?? '[]';
        for (final id in RegExp(r'media:([A-Za-z0-9_-]+)')
            .allMatches(json)
            .map((m) => m[1]!)) {
          await attach(id);
        }
        for (final m in RegExp(r'mediaId\\?"\s*:\s*\\?"([A-Za-z0-9_-]+)')
            .allMatches(json)) {
          await attach(m[1]!);
        }
        final cover = entity.coverMediaId == null
            ? null
            : await attach(entity.coverMediaId!);

        final lore = deltaToMarkdown(json,
            embeds: MarkdownEmbeds(
              mention: (id, label) => switch (noteNames[id]) {
                null => label,
                final note when note == label => '[[$note]]',
                final note => '[[$note|$label]]',
              },
              image: (id) => switch (attachmentNames[id]) {
                null => null,
                final name => '![[$name]]',
              },
              attachment: (id, name) => switch (attachmentNames[id]) {
                null => name,
                final file => '[[$file]]',
              },
            ));

        final tags = [
          for (final tag in await _tags.watchEntityTags(entity.id).first)
            tag.name
        ];
        // Front matter is data for tools (Dataview, search): a stable
        // kind id, or the custom category's name.
        final kindLabel = entity.kind == EntityKind.custom
            ? categories[entity.customCategoryId]?.name ?? entity.kind.name
            : entity.kind.name;
        final note = StringBuffer()
          ..writeln('---')
          ..writeln('kind: ${_yaml(kindLabel)}');
        if (entity.summary.isNotEmpty) {
          note.writeln('summary: ${_yaml(entity.summary)}');
        }
        if (tags.isNotEmpty) {
          note.writeln('tags: [${tags.map(_yamlTag).join(', ')}]');
        }
        note
          ..writeln('---')
          ..writeln()
          ..writeln('# ${entity.name}')
          ..writeln();
        if (cover != null) note..writeln('![[$cover]]')..writeln();
        if (entity.summary.isNotEmpty) {
          note..writeln('> ${entity.summary}')..writeln();
        }
        for (final line in fields) {
          note.writeln('- **${line.label}:** ${line.value}');
        }
        if (fields.isNotEmpty) note.writeln();
        if (lore.isNotEmpty) note..writeln(lore)..writeln();
        final relations = outgoing[entity.id] ?? const [];
        if (relations.isNotEmpty) {
          note
            ..writeln('## $relationsTitle')
            ..writeln();
          for (final link in relations) {
            note.writeln(
                '- ${roleLabel?.call(link.role) ?? link.role}: '
                '[[${noteNames[link.targetId]}]]');
          }
          note.writeln();
        }
        files['$root/${chapterOf(entity)}/${noteNames[entity.id]}.md'] =
            utf8.encode('${note.toString().trimRight()}\n');
      }

      // Index note: every entry by chapter.
      final byChapter = <String, List<Entity>>{};
      for (final e in all) {
        (byChapter[chapterOf(e)] ??= []).add(e);
      }
      final index = StringBuffer('# $worldName\n\n');
      for (final chapter in byChapter.keys.toList()..sort()) {
        index.writeln('## $chapter\n');
        for (final e in byChapter[chapter]!) {
          index.writeln('- [[${noteNames[e.id]}]]'
              '${e.summary.isEmpty ? '' : ' — ${e.summary}'}');
        }
        index.writeln();
      }
      files['$root/$root.md'] = utf8.encode('${index.toString().trimRight()}\n');

      final out = File(outputPath);
      await out.parent.create(recursive: true);
      final bytes = await _zipInBackground(files);
      final partial = File('$outputPath.part');
      await partial.writeAsBytes(bytes, flush: true);
      if (await out.exists()) await out.delete();
      await partial.rename(outputPath);
      return outputPath;
    });
  }

  static String _yaml(String s) => jsonEncode(s);

  static String _yamlTag(String tag) =>
      jsonEncode(tag.trim().replaceAll(RegExp(r'\s+'), '-'));
}

/// Top-level on purpose: a closure created inside a method would capture
/// the exporter (and through it the database) into the isolate message.
Future<List<int>> _zipInBackground(Map<String, Uint8List> files) =>
    Isolate.run(() {
      final archive = Archive();
      for (final MapEntry(key: name, value: data) in files.entries) {
        archive.addFile(ArchiveFile(name, data.length, data));
      }
      return ZipEncoder().encode(archive);
    });

const _reservedWindowsNames = {
  'con', 'prn', 'aux', 'nul', //
  'com1', 'com2', 'com3', 'com4', 'com5', 'com6', 'com7', 'com8', 'com9',
  'lpt1', 'lpt2', 'lpt3', 'lpt4', 'lpt5', 'lpt6', 'lpt7', 'lpt8', 'lpt9',
};

/// A note or folder name that is valid on Windows, macOS and Linux and
/// usable inside an Obsidian `[[link]]` (no `# ^ [ ] |`). Keeps spaces,
/// case and non-Latin letters: "Лес Теней" stays readable.
String noteFileName(String name, {String fallback = 'Untitled'}) {
  var cleaned = name
      .replaceAll(RegExp(r'[<>:"/\\|?*#^\[\]\x00-\x1F]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceAll(RegExp(r'[. ]+$'), '');
  if (cleaned.length > 120) cleaned = cleaned.substring(0, 120).trim();
  if (cleaned.isEmpty) cleaned = fallback;
  if (_reservedWindowsNames.contains(cleaned.toLowerCase())) {
    cleaned = '$cleaned _';
  }
  return cleaned;
}
