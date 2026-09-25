import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/services/starter_kit.dart';
import 'package:gmh/domain/tables/content/table_library.dart';

import '../helpers.dart';

void main() {
  late TestHarness h;
  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  const labels = StarterKitLabels(
    campaignName: 'The First Adventure',
    sessionName: 'Session 1',
    fieldLabel: _label,
  );

  for (final style in WorldStyle.values) {
    for (final lang in ['en', 'ru', 'zh']) {
      test('seeds a linked starter world: ${style.name} / $lang', () async {
        final world = await h.worlds.createWorld(name: 'W', style: style);
        final created = await StarterKit(h.entityService, h.objects,
                random: Random(style.index * 7 + lang.length))
            .seed(
                worldId: world.id,
                style: style,
                language: lang,
                labels: labels);

        int count(EntityKind k) => created.where((e) => e.kind == k).length;
        expect(count(EntityKind.location), 1);
        expect(count(EntityKind.character), 3);
        expect(count(EntityKind.faction), 1);
        expect(count(EntityKind.campaign), 1);
        expect(count(EntityKind.quest), 2);
        expect(count(EntityKind.session), 1);
        for (final e in created) {
          expect(e.name.trim(), isNotEmpty, reason: '${e.kind}');
          expect(e.name, isNot(contains('{')), reason: e.name);
        }

        final links = await h.links.allForWorld(world.id);
        final town = created.firstWhere((e) => e.kind == EntityKind.location);
        final campaign =
            created.firstWhere((e) => e.kind == EntityKind.campaign);
        expect(links.where((l) => l.targetId == town.id), hasLength(3),
            reason: 'the three NPCs live in the settlement');
        expect(links.where((l) => l.targetId == campaign.id), hasLength(3),
            reason: 'two quests and the session belong to the campaign');

        final tables =
            await h.objects.list(world.id, WorldObjectTypes.randomTable);
        expect(tables, hasLength(TableLibrary.forStyle(style).length));
      });
    }
  }
}

String _label(String key) => key;
