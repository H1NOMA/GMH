import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/data/repositories/search_repository_impl.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/search_result.dart';

import '../helpers.dart';

void main() {
  late TestHarness h;

  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  Future<List<String>> find(String worldId, String q) async =>
      [for (final r in await h.search.search(worldId, q)) r.name];

  Future<int> indexRows() async => (await h.db
          .customSelect('SELECT COUNT(*) AS n FROM entity_search')
          .getSingle())
      .read<int>('n');

  test('Chinese words are found inside longer runs of text', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final keep = (await h.entityService.create(
            worldId: world.id,
            kind: EntityKind.location,
            name: '龙之谷城堡',
            summary: '北方的古老要塞'))
        .value;
    await h.documentService.save(
        entityId: keep.id,
        contentJson: jsonEncode([
          {'insert': '传说中巨龙守护着地下宝库。\n'}
        ]));

    expect(await find(world.id, '城堡'), ['龙之谷城堡']);
    expect(await find(world.id, '要塞'), ['龙之谷城堡']);
    expect(await find(world.id, '巨龙'), ['龙之谷城堡']);
    expect(await find(world.id, '宝库 巨龙'), ['龙之谷城堡']);
    expect(await find(world.id, '城龙'), isEmpty,
        reason: 'characters must be adjacent, as in the text');

    final hit = (await h.search.search(world.id, '巨龙')).single;
    expect(hit.snippet, contains('${SearchResult.snippetMarkerStart}巨'));
    expect(hit.snippet, isNot(contains('巨 ')),
        reason: 'snippets read like the original text');
  });

  test('Latin search is unchanged', () async {
    final world = await h.worlds.createWorld(name: 'W');
    await h.entityService.create(
        worldId: world.id, kind: EntityKind.character, name: 'Ashen Vey');
    expect(await find(world.id, 'ash'), ['Ashen Vey']);
    expect(SearchRepositoryImpl.buildMatchQuery('ash  vey'), '"ash"* "vey"*');
    expect(SearchRepositoryImpl.buildMatchQuery('城堡'), '"城 堡"*');
  });

  test('reindexing keeps exactly one row per entry', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final e = (await h.entityService.create(
            worldId: world.id, kind: EntityKind.item, name: 'Lamp'))
        .value;
    await Future.wait([
      for (var i = 0; i < 5; i++) h.search.reindexEntity(e.id),
    ]);
    expect(await indexRows(), 1);
  });

  test('an index from an older version is rebuilt on first use', () async {
    final world = await h.worlds.createWorld(name: 'W');
    final e = await h.entities.createEntity(
        worldId: world.id, kind: EntityKind.location, name: '雪山神殿');
    // As an old build left it: unspaced CJK, rowid unrelated to the entry,
    // no version marker.
    await h.db.customStatement(
        'INSERT INTO entity_search (rowid, entity_id, name, summary, body, '
        "tags) VALUES (9999, ?, '雪山神殿', '', '', '')",
        [e.id]);
    await h.db.customStatement(
        "DELETE FROM settings WHERE key = 'searchIndexVersion'");

    final fresh = SearchRepositoryImpl(h.db, h.entities);
    expect([for (final r in await fresh.search(world.id, '神殿')) r.name],
        ['雪山神殿']);
    expect(await indexRows(), 1);
  });
}
