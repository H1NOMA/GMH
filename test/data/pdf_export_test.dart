import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/data/backup/pdf_exporter.dart';
import 'package:gmh/data/backup/pdf_fonts.dart';
import 'package:gmh/data/repositories/category_repository_impl.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/services/templates/entity_templates.dart';
import 'package:gmh/features/settings/settings_screen.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

/// Loads fonts straight from the repo (rootBundle needs a Flutter binding).
class _DiskBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(await File(key).readAsBytes());
}

void main() {
  late TestHarness h;
  setUp(() async => h = await TestHarness.create());
  tearDown(() async => h.dispose());

  test('a huge multilingual world book exports without error', () async {
    final world = await h.worlds.createWorld(name: 'Мир 世界');
    final hero = (await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.character,
      name: 'Капитан Мира',
      summary: '港口的守护者',
      attributes: {'secrets': 'Sold the harbor', 'race': 'Human'},
    ))
        .value;
    final longParagraph = List.filled(2500, 'слово 词语 word').join(' ');
    final manyParagraphs = List.filled(300, 'Строка лора. 传说之行。').join('\n');
    await h.documentService.save(
        entityId: hero.id,
        contentJson: jsonEncode([
          {'insert': '$longParagraph\n$manyParagraphs\n'}
        ]));
    final exporter = PdfExporter(
        h.entities, h.documents, CategoryRepositoryImpl(h.db));
    final out = p.join(h.tempDir.path, 'book.pdf');
    final result = await exporter.exportWorldBook(
      worldId: world.id,
      worldName: world.name,
      outputPath: out,
      fonts: await PdfFonts.load(_DiskBundle()),
    );
    expect(result.isOk, isTrue, reason: result.isErr ? '${result.error}' : '');
    expect(File(out).lengthSync(), greaterThan(10000));
    expect(File('$out.part').existsSync(), isFalse);
  });

  test('attribute lines resolve refs and drop GM-only fields', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final home = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.location, name: 'Ravenport'))
        .value;
    final mira = (await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.character,
      name: 'Mira',
      attributes: {
        'homeLocation': entityRefValue(home.id),
        'secrets': 'Traitor',
        'status': 'Alive',
      },
    ))
        .value;
    final sections = EntityTemplates.of(EntityKind.character).sections;
    List<String> render({required bool gm}) => [
          for (final line in PdfExporter.attributeLines(mira,
              sections: sections,
              namesById: {home.id: home.name},
              term: (t) => t == 'Alive' ? 'Жив' : t,
              includeGmOnly: gm))
            '${line.label}: ${line.value}'
        ];
    final safe = render(gm: false);
    expect(safe, contains('Status: Жив'));
    expect(safe.any((l) => l.contains('Ravenport')), isTrue);
    expect(safe.any((l) => l.contains('Traitor')), isFalse);
    expect(render(gm: true).any((l) => l.contains('Traitor')), isTrue);
  });

  test('long paragraphs split at word boundaries', () {
    final text = List.filled(700, 'word').join(' ');
    final parts = PdfExporter.splitParagraphs(text);
    expect(parts.length, greaterThan(1));
    expect(parts.every((p) => p.length <= 1200), isTrue);
    expect(parts.join(' ').split(' ').length, 700);
  });

  test('export file names are valid everywhere', () {
    expect(exportFileStem('CON'), 'con-world');
    expect(exportFileStem('  My: World?  '), 'my-world');
    expect(exportFileStem('...'), 'world');
    expect(exportFileStem('Мир'), 'мир');
  });
}
