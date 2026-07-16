import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/services/linking/mention_parser.dart';

void main() {
  group('extractMentionIds', () {
    test('finds entity ids in entityLink embeds (string payload)', () {
      final delta = jsonEncode([
        {'insert': 'King Arden wielded '},
        {
          'insert': {
            'entityLink': jsonEncode({'id': 'sword-1', 'label': "Ashen King's Sword"})
          }
        },
        {'insert': ' at the Battle of '},
        {
          'insert': {
            'entityLink': jsonEncode({'id': 'tower-9', 'label': 'Black Tower'})
          }
        },
        {'insert': '.\n'},
      ]);

      expect(extractMentionIds(delta), {'sword-1', 'tower-9'});
    });

    test('finds entity ids when payload is a map', () {
      final delta = jsonEncode([
        {
          'insert': {
            'entityLink': {'id': 'npc-3', 'label': 'Arden'}
          }
        },
        {'insert': '\n'},
      ]);
      expect(extractMentionIds(delta), {'npc-3'});
    });

    test('deduplicates repeated mentions', () {
      final delta = jsonEncode([
        for (var i = 0; i < 3; i++)
          {
            'insert': {
              'entityLink': jsonEncode({'id': 'same', 'label': 'Same'})
            }
          },
        {'insert': '\n'},
      ]);
      expect(extractMentionIds(delta), {'same'});
    });

    test('tolerates malformed json and foreign embeds', () {
      expect(extractMentionIds('not json'), isEmpty);
      expect(extractMentionIds('{}'), isEmpty);
      final delta = jsonEncode([
        {
          'insert': {'image': 'media:abc'}
        },
        {
          'insert': {'entityLink': 'not-json-payload'}
        },
        {'insert': '\n'},
      ]);
      expect(extractMentionIds(delta), isEmpty);
    });
  });

  group('extractPlainText', () {
    test('joins text and replaces mentions with labels', () {
      final delta = jsonEncode([
        {'insert': 'The sword '},
        {
          'insert': {
            'entityLink': jsonEncode({'id': 'x', 'label': 'Dawnbreaker'})
          }
        },
        {'insert': ' shone.\n'},
      ]);
      expect(extractPlainText(delta), 'The sword Dawnbreaker shone.\n');
    });

    test('word counting handles unicode', () {
      expect(countWords('Пять слов на русском языке'), 5);
      expect(countWords('one  two\nthree'), 3);
      expect(countWords(''), 0);
    });
  });
}
