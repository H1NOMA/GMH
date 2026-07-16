import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/link.dart';
import 'package:gmh/domain/services/templates/entity_templates.dart';

void main() {
  test('every entity kind has a template', () {
    for (final kind in EntityKind.values) {
      expect(() => EntityTemplates.of(kind), returnsNormally,
          reason: 'missing template for $kind');
    }
  });

  test('extractEntityRefs mirrors ref and refList fields with roles', () {
    final template = EntityTemplates.of(EntityKind.item);
    final refs = template.extractEntityRefs({
      'currentOwner': entityRefValue('owner-1'),
      'forgedAt': entityRefValue('forge-2'),
      'relatedEvents': [entityRefValue('war-3'), entityRefValue('war-4')],
      'rarity': 'Legendary', // not a ref — ignored
    });

    expect(refs, {
      'owner-1': LinkRoles.owner,
      'forge-2': LinkRoles.createdAt,
      'war-3': LinkRoles.participatedIn,
      'war-4': LinkRoles.participatedIn,
    });
  });

  test('sanitize coerces types and preserves unknown keys', () {
    final template = EntityTemplates.of(EntityKind.quest);
    final sanitized = template.sanitize({
      'status': 'NotARealStatus', // invalid select value → dropped
      'objectives': [
        {'text': 'Find it', 'done': true},
        {'text': 42, 'done': 'yes'}, // coerced
      ],
      'rewards': 123, // coerced to string
      'futureField': 'kept', // unknown → preserved
    });

    expect(sanitized.containsKey('status'), isFalse);
    expect(sanitized['objectives'], [
      {'text': 'Find it', 'done': true},
      {'text': '42', 'done': false},
    ]);
    expect(sanitized['rewards'], '123');
    expect(sanitized['futureField'], 'kept');
  });

  test('entity ref helpers round-trip', () {
    expect(parseEntityRef(entityRefValue('abc')), 'abc');
    expect(parseEntityRef('not-a-ref'), isNull);
    expect(parseEntityRef(null), isNull);
    expect(parseEntityRef('entity:'), isNull);
  });
}
