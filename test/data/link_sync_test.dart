import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/link.dart';

import '../helpers.dart';

String _deltaWithMentions(List<({String id, String label})> mentions) {
  return jsonEncode([
    {'insert': 'Story about '},
    for (final m in mentions)
      {
        'insert': {
          'entityLink': jsonEncode({'id': m.id, 'label': m.label})
        }
      },
    {'insert': '\n'},
  ]);
}

void main() {
  late TestHarness h;

  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  test('document save creates mention links; removing mention removes link',
      () async {
    final world = await h.worlds.createWorld(name: 'W');
    final chronicle = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.loreDocument, name: 'Chronicle');
    final arden = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'Arden');
    final sword = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.item, name: 'Sword');

    await h.documentService.save(
      entityId: chronicle.id,
      contentJson: _deltaWithMentions([
        (id: arden.id, label: 'Arden'),
        (id: sword.id, label: 'Sword'),
      ]),
    );

    var outgoing = await h.links.outgoing(chronicle.id);
    expect(outgoing, hasLength(2));
    expect(outgoing.every((l) => l.origin == LinkOrigin.document), isTrue);
    expect(outgoing.every((l) => l.role == LinkRoles.mention), isTrue);

    // Backlink visible from the target side.
    final backlinks = await h.links
        .watchIncoming(arden.id)
        .first;
    expect(backlinks.single.sourceId, chronicle.id);

    // Remove one mention → its link is dropped, the other kept.
    await h.documentService.save(
      entityId: chronicle.id,
      contentJson: _deltaWithMentions([(id: arden.id, label: 'Arden')]),
    );
    outgoing = await h.links.outgoing(chronicle.id);
    expect(outgoing.single.targetId, arden.id);
  });

  test('mention sync never touches manual links', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final a = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'A');
    final b = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.character, name: 'B');

    await h.links.create(
      worldId: world.id,
      sourceId: a.id,
      targetId: b.id,
      role: 'ally',
      origin: LinkOrigin.manual,
    );

    // Save a document with no mentions — manual link must survive.
    await h.documentService.save(
      entityId: a.id,
      contentJson: _deltaWithMentions([]),
    );
    final outgoing = await h.links.outgoing(a.id);
    expect(outgoing, hasLength(1));
    expect(outgoing.single.origin, LinkOrigin.manual);
  });

  test('attribute refs update links when fields change', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final forge = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.location, name: 'Dragon Forge');
    final altar = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.location, name: 'Altar');
    final sword = (await h.entityService.create(
      worldId: world.id,
      kind: EntityKind.item,
      name: 'Sword',
      attributes: {'forgedAt': entityRefValue(forge.id)},
    ))
        .value;

    var outgoing = await h.links.outgoing(sword.id);
    expect(outgoing.single.targetId, forge.id);

    // Change the ref → link follows.
    final updated = (await h.entityService.update(sword.copyWith(
      attributes: {'forgedAt': entityRefValue(altar.id)},
    )))
        .value;
    outgoing = await h.links.outgoing(updated.id);
    expect(outgoing.single.targetId, altar.id);

    // Clear the ref → link removed.
    await h.entityService.update(updated.copyWith(attributes: {}));
    expect(await h.links.outgoing(updated.id), isEmpty);
  });

  test('self-references are ignored; dangling targets skipped', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final doc = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.loreDocument, name: 'Doc');

    await h.documentService.save(
      entityId: doc.id,
      contentJson: _deltaWithMentions([
        (id: doc.id, label: 'self'),
        (id: 'does-not-exist', label: 'ghost'),
      ]),
    );
    expect(await h.links.outgoing(doc.id), isEmpty);
  });
}
