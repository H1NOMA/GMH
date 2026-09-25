import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/result.dart';
import '../../core/utils/ids.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/entity_template.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/templates/entity_templates.dart';
import 'pdf_fonts.dart';

/// Localized strings the exporter needs; built by the UI so the data layer
/// stays free of BuildContext.
class PdfBookLabels {
  final String subtitle;
  final String Function(EntityKind kind) chapterTitle;

  /// Translates (and pack-skins) a template term or select option.
  final String Function(String term) term;

  /// Title for custom-category fields without their own section.
  final String fieldsSection;

  const PdfBookLabels({
    required this.subtitle,
    required this.chapterTitle,
    required this.term,
    required this.fieldsSection,
  });

  /// English labels (tests, fallback).
  static final english = PdfBookLabels(
    subtitle: 'A World Book',
    chapterTitle: (kind) => kind.pluralLabel,
    term: (t) => t,
    fieldsSection: 'Fields',
  );
}

/// One "Label: value" line of an entity's structured data.
typedef PdfAttributeLine = ({String label, String value});

/// Renders a world book PDF: a cover, then one chapter per entity kind and
/// custom category with each entry's summary, structured fields (in
/// template order, with localized labels) and lore text.
class PdfExporter {
  final EntityRepository _entities;
  final DocumentRepository _documents;
  final CategoryRepository _categories;

  PdfExporter(this._entities, this._documents, this._categories);

  /// Paragraphs longer than this are split so no single widget can exceed
  /// a page (MultiPage cannot break one oversized block).
  static const _maxChunk = 1200;

  Future<Result<String>> exportWorldBook({
    required String worldId,
    required String worldName,
    required String outputPath,
    required PdfFonts fonts,
    PdfBookLabels? labels,
    bool includeGmOnly = false,
    List<EntityKind>? kinds,
  }) {
    final l = labels ?? PdfBookLabels.english;
    return guard(() async {
      final selectedKinds = kinds ??
          [...EntityKind.worldKinds, ...EntityKind.libraryKinds];
      final all = (await _entities.getAllEntities(worldId))
          .where((e) => !e.isDeleted)
          .toList();
      final namesById = {for (final e in all) e.id: e.name};
      final theme = fonts.theme;

      final pdf = pw.Document(title: worldName);
      pdf.addPage(pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(worldName,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 38, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text(l.subtitle,
                  style: const pw.TextStyle(
                      fontSize: 16, color: PdfColors.grey700)),
            ],
          ),
        ),
      ));

      final customCategories = await _categories.categories(worldId);
      final chapters = <(String, List<Entity>, List<FieldSection>? Function(Entity))>[
        for (final kind in selectedKinds)
          (
            l.chapterTitle(kind),
            all.where((e) => e.kind == kind).toList(),
            (_) => null,
          ),
        for (final category in customCategories)
          (
            category.name,
            all
                .where((e) =>
                    e.kind == EntityKind.custom &&
                    e.customCategoryId == category.id)
                .toList(),
            (_) => category.blueprint.toSections(l.fieldsSection),
          ),
      ];

      for (final (title, group, sectionsFor) in chapters) {
        if (group.isEmpty) continue;
        group.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        final flow = <pw.Widget>[pw.Header(level: 0, text: title)];
        for (final entity in group) {
          final doc = await _documents.getOrCreate(entity.id);
          flow.addAll(_entityFlow(
            entity,
            lore: doc.plainText,
            lines: attributeLines(
              entity,
              sections: sectionsFor(entity) ??
                  EntityTemplates.of(entity.kind).sections,
              namesById: namesById,
              term: l.term,
              includeGmOnly: includeGmOnly,
            ),
          ));
        }
        pdf.addPage(pw.MultiPage(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          build: (context) => flow,
        ));
      }

      final file = File(outputPath);
      await file.parent.create(recursive: true);
      final partial = File('$outputPath.part');
      await partial.writeAsBytes(await pdf.save(), flush: true);
      if (await file.exists()) await file.delete();
      await partial.rename(outputPath);
      return outputPath;
    });
  }

  /// A flat list of widgets for one entry — never one tall column, so a
  /// long entry flows across as many pages as it needs.
  List<pw.Widget> _entityFlow(Entity entity,
      {required String lore, required List<PdfAttributeLine> lines}) {
    return [
      pw.Header(level: 1, text: entity.name),
      if (entity.summary.isNotEmpty)
        pw.Paragraph(
            text: entity.summary,
            style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
      for (final line in lines)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: pw.RichText(
            text: pw.TextSpan(children: [
              pw.TextSpan(
                  text: '${line.label}: ',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(
                  text: line.value, style: const pw.TextStyle(fontSize: 10)),
            ]),
          ),
        ),
      if (lines.isNotEmpty) pw.SizedBox(height: 6),
      for (final paragraph in splitParagraphs(lore))
        pw.Paragraph(text: paragraph, style: const pw.TextStyle(fontSize: 11)),
      pw.SizedBox(height: 14),
    ];
  }

  /// Structured fields in template order with translated labels; entity
  /// references resolved to names; GM-only fields dropped unless
  /// [includeGmOnly].
  @visibleForTesting
  static List<PdfAttributeLine> attributeLines(
    Entity entity, {
    required List<FieldSection> sections,
    required Map<String, String> namesById,
    required String Function(String) term,
    bool includeGmOnly = false,
  }) {
    String render(FieldDef field, Object value) {
      String one(Object? v) {
        if (v == null) return '';
        if (v is Map) {
          final text = v['text']?.toString() ?? '';
          if (text.isEmpty) return '';
          return '${v['done'] == true ? '[x]' : '[ ]'} $text';
        }
        final s = v.toString();
        if (s.startsWith(entityRefPrefix)) {
          return namesById[s.substring(entityRefPrefix.length)] ?? '';
        }
        return field.type == FieldType.select ? term(s) : s;
      }

      if (value is List) {
        return value.map(one).where((s) => s.isNotEmpty).join(', ');
      }
      return one(value);
    }

    return [
      for (final section in sections)
        for (final field in section.fields)
          if (includeGmOnly || !field.gmOnly)
            if (entity.attributes[field.key] case final Object value)
              if (render(field, value) case final String text
                  when text.trim().isNotEmpty)
                (label: term(field.label), value: text.trim()),
    ];
  }

  /// Splits lore into paragraphs, and very long paragraphs into chunks at
  /// word boundaries.
  @visibleForTesting
  static List<String> splitParagraphs(String text) {
    final out = <String>[];
    for (final raw in text.split('\n')) {
      var p = raw.trim();
      while (p.length > _maxChunk) {
        var cut = p.lastIndexOf(' ', _maxChunk);
        if (cut < _maxChunk ~/ 2) cut = _maxChunk;
        out.add(p.substring(0, cut).trim());
        p = p.substring(cut).trim();
      }
      if (p.isNotEmpty) out.add(p);
    }
    return out;
  }
}
