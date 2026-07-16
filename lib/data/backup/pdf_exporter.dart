import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/result.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';

/// Renders a world book PDF: a cover, then one chapter per entity kind with
/// each entity's summary, structured attributes and document text.
class PdfExporter {
  final EntityRepository _entities;
  final DocumentRepository _documents;

  PdfExporter(this._entities, this._documents);

  Future<Result<String>> exportWorldBook({
    required String worldId,
    required String worldName,
    required String outputPath,
    List<EntityKind>? kinds,
  }) {
    return guard(() async {
      final selectedKinds = kinds ??
          [...EntityKind.worldKinds, ...EntityKind.libraryKinds];
      final all = await _entities.getAllEntities(worldId);

      final pdf = pw.Document();
      final theme = pw.ThemeData.withFont(
        base: pw.Font.times(),
        bold: pw.Font.timesBold(),
        italic: pw.Font.timesItalic(),
      );

      pdf.addPage(pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(worldName,
                  style: pw.TextStyle(
                      fontSize: 42, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('A World Book',
                  style: const pw.TextStyle(
                      fontSize: 18, color: PdfColors.grey700)),
            ],
          ),
        ),
      ));

      for (final kind in selectedKinds) {
        final entities = all.where((e) => e.kind == kind).toList()
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        if (entities.isEmpty) continue;

        final sections = <pw.Widget>[
          pw.Header(level: 0, text: kind.pluralLabel),
        ];
        for (final entity in entities) {
          sections.add(await _entitySection(entity));
        }

        pdf.addPage(pw.MultiPage(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          build: (context) => sections,
        ));
      }

      final file = File(outputPath);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(await pdf.save(), flush: true);
      return outputPath;
    });
  }

  Future<pw.Widget> _entitySection(Entity entity) async {
    final doc = await _documents.getOrCreate(entity.id);
    final attributeLines = <String>[];
    entity.attributes.forEach((key, value) {
      if (value == null) return;
      final rendered = _renderAttribute(value);
      if (rendered.isNotEmpty) attributeLines.add('$key: $rendered');
    });

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 18),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Header(level: 1, text: entity.name),
          if (entity.summary.isNotEmpty)
            pw.Paragraph(
                text: entity.summary,
                style: pw.TextStyle(
                    fontSize: 11, fontStyle: pw.FontStyle.italic)),
          if (attributeLines.isNotEmpty)
            pw.Bullet(
                text: attributeLines.join('\n'),
                style: const pw.TextStyle(fontSize: 10)),
          if (doc.plainText.trim().isNotEmpty)
            pw.Paragraph(
                text: doc.plainText.trim(),
                style: const pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  String _renderAttribute(Object value) {
    if (value is List) {
      return value
          .map((v) => v is Map ? (v['text']?.toString() ?? '') : v.toString())
          .where((s) => s.isNotEmpty && !s.startsWith('entity:'))
          .join(', ');
    }
    final s = value.toString();
    return s.startsWith('entity:') ? '' : s;
  }
}
