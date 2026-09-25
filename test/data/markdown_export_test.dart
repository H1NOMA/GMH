import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/data/backup/delta_markdown.dart';
import 'package:gmh/data/backup/markdown_exporter.dart';
import 'package:gmh/data/repositories/category_repository_impl.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:path/path.dart' as p;

import '../helpers.dart';

String _delta(List<Map<String, Object?>> ops) => jsonEncode(ops);

void main() {
  group('deltaToMarkdown', () {
    test('inline styles, headings and paragraphs', () {
      final md = deltaToMarkdown(_delta([
        {'insert': 'The Keep'},
        {
          'insert': '\n',
          'attributes': {'header': 2}
        },
        {'insert': 'A '},
        {
          'insert': 'grim',
          'attributes': {'bold': true}
        },
        {'insert': ' and '},
        {
          'insert': 'old ',
          'attributes': {'italic': true}
        },
        {'insert': 'place with '},
        {
          'insert': 'a map',
          'attributes': {'link': 'https://example.com/map'}
        },
        {'insert': '.\nSecond * line\n'},
      ]));
      expect(
          md,
          '## The Keep\n\n'
          'A **grim** and *old* place with [a map](<https://example.com/map>).\n\n'
          'Second \\* line');
    });

    test('lists, checklists, quotes and code blocks', () {
      final md = deltaToMarkdown(_delta([
        {'insert': 'one'},
        {
          'insert': '\n',
          'attributes': {'list': 'bullet'}
        },
        {'insert': 'nested'},
        {
          'insert': '\n',
          'attributes': {'list': 'bullet', 'indent': 1}
        },
        {'insert': 'first'},
        {
          'insert': '\n',
          'attributes': {'list': 'ordered'}
        },
        {'insert': 'second'},
        {
          'insert': '\n',
          'attributes': {'list': 'ordered'}
        },
        {'insert': 'done'},
        {
          'insert': '\n',
          'attributes': {'list': 'checked'}
        },
        {'insert': 'said the owl'},
        {
          'insert': '\n',
          'attributes': {'blockquote': true}
        },
        {'insert': 'roll 2d6'},
        {
          'insert': '\n',
          'attributes': {'code-block': true}
        },
      ]));
      expect(
          md,
          '- one\n'
          '  - nested\n'
          '1. first\n'
          '2. second\n'
          '- [x] done\n\n'
          '> said the owl\n\n'
          '```\nroll 2d6\n```');
    });

    test('embeds use the resolvers', () {
      final md = deltaToMarkdown(
        _delta([
          {'insert': 'Meet '},
          {
            'insert': {
              'entityLink': jsonEncode({'id': 'e1', 'label': 'Mira'})
            }
          },
          {'insert': '\n'},
          {
            'insert': {'image': 'media:m1'}
          },
          {'insert': '\n'},
        ]),
        embeds: MarkdownEmbeds(
          mention: (id, label) => '[[$label]]',
          image: (id) => '![[$id.png]]',
          attachment: (_, name) => name,
        ),
      );
      expect(md, 'Meet [[Mira]]\n\n![[m1.png]]');
    });

    test('unreadable input is empty', () {
      expect(deltaToMarkdown('nope'), '');
    });
  });

  test('noteFileName keeps readable names and avoids reserved ones', () {
    expect(noteFileName('Лес Теней'), 'Лес Теней');
    expect(noteFileName('What? #1 [draft]'), 'What 1 draft');
    expect(noteFileName('CON'), 'CON _');
    expect(noteFileName('  ...  '), 'Untitled');
  });

  group('vault export', () {
    late TestHarness h;
    setUp(() async => h = await TestHarness.create());
    tearDown(() => h.dispose());

    test('writes linked notes, attachments and an index', () async {
      final world = await h.worlds.createWorld(name: 'Aldenmark');
      final keep = (await h.entityService.create(
              worldId: world.id,
              kind: EntityKind.location,
              name: 'Ravenport',
              summary: 'A grim harbor.'))
          .value;
      final mira = (await h.entityService.create(
        worldId: world.id,
        kind: EntityKind.character,
        name: 'Mira',
        attributes: {'homeLocation': entityRefValue(keep.id)},
      ))
          .value;
      await h.entityService.addTag(mira.id, world.id, 'harbor folk');
      final image = await h.media.import(
          worldId: world.id, fileName: 'map.png', bytes: utf8.encode('png'));
      await h.documentService.save(
          entityId: keep.id,
          contentJson: _delta([
            {'insert': 'Home of '},
            {
              'insert': {
                'entityLink': jsonEncode({'id': mira.id, 'label': 'Mira'})
              }
            },
            {'insert': '\n'},
            {
              'insert': {'image': 'media:${image.id}'}
            },
            {'insert': '\n'},
          ]));

      final out = p.join(h.tempDir.path, 'vault.zip');
      final exporter = MarkdownExporter(h.entities, h.documents,
          CategoryRepositoryImpl(h.db), h.links, h.media, h.tags);
      final result = await exporter.exportVault(
          worldId: world.id, worldName: 'Aldenmark', outputPath: out);
      expect(result.isOk, isTrue, reason: result.isErr ? '${result.error}' : null);

      final archive = ZipDecoder().decodeBytes(File(out).readAsBytesSync());
      String read(String name) =>
          utf8.decode(archive.findFile(name)!.content as List<int>);
      final names = [for (final f in archive.files) f.name];
      expect(names, contains('Aldenmark/Aldenmark.md'));
      expect(names, contains('Aldenmark/attachments/map.png'));

      final ravenport = read('Aldenmark/Locations/Ravenport.md');
      expect(ravenport, contains('kind: "location"'));
      expect(ravenport, contains('# Ravenport'));
      expect(ravenport, contains('Home of [[Mira]]'));
      expect(ravenport, contains('![[map.png]]'));

      final miraNote = read('Aldenmark/Characters/Mira.md');
      expect(miraNote, contains('tags: ["harbor-folk"]'));
      expect(miraNote, contains('Ravenport'));
      expect(read('Aldenmark/Aldenmark.md'), contains('[[Ravenport]]'));
    });
  });
}
