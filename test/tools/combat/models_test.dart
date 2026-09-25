import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/combat/combatant.dart';
import 'package:gmh/domain/combat/encounter.dart';
import 'package:gmh/domain/models/world_object.dart';

WorldObject _object(String type, Map<String, Object?> data,
        {String name = 'X', String? parentId}) =>
    WorldObject(
      id: 'id1',
      worldId: 'w1',
      type: type,
      parentId: parentId,
      name: name,
      data: data,
      sortOrder: 3,
      createdAt: 10,
      updatedAt: 20,
    );

void main() {
  group('Encounter codec', () {
    test('round trip', () {
      const e = Encounter(
        id: 'id1',
        worldId: 'w1',
        name: 'Ambush',
        status: EncounterStatus.active,
        round: 3,
        turnIndex: 2,
        activeId: 'c9',
        partyLevels: [3, 4, 4],
        rulesVersion: RulesVersion.v2014,
        notes: 'Bridge collapses in round 4',
      );
      final back = Encounter.fromObject(
          _object(WorldObjectTypes.encounter, e.toData(), name: 'Ambush'));
      expect(back.status, EncounterStatus.active);
      expect(back.round, 3);
      expect(back.turnIndex, 2);
      expect(back.activeId, 'c9');
      expect(back.partyLevels, [3, 4, 4]);
      expect(back.rulesVersion, RulesVersion.v2014);
      expect(back.notes, 'Bridge collapses in round 4');
      expect(back.toObject().type, WorldObjectTypes.encounter);
      expect(back.toObject().sortOrder, 3);
    });

    test('defaults for missing and garbled keys', () {
      final e = Encounter.fromObject(_object(WorldObjectTypes.encounter, {
        'status': 'exploded',
        'round': 'many',
        'turnIndex': -4,
        'activeId': 7,
        'partyLevels': ['5', 'x', 40, null, 0],
        'rulesVersion': 1999,
        'notes': ['n'],
      }));
      expect(e.status, EncounterStatus.planning);
      expect(e.round, 0);
      expect(e.turnIndex, 0);
      expect(e.activeId, isNull);
      expect(e.partyLevels, [5, 20, 1]);
      expect(e.rulesVersion, RulesVersion.v2024);
      expect(e.notes, '');

      final empty =
          Encounter.fromObject(_object(WorldObjectTypes.encounter, const {}));
      expect(empty.status, EncounterStatus.planning);
      expect(empty.partyLevels, isEmpty);
      expect(RulesVersion.parse(2014), RulesVersion.v2014);
    });
  });

  group('Combatant codec', () {
    test('round trip', () {
      const c = Combatant(
        name: 'Goblin 2',
        entityId: 'e7',
        isPlayer: false,
        initiative: 14,
        initiativeBonus: 2,
        hpMax: 7,
        hpCurrent: 3,
        hpTemp: 4,
        ac: 15,
        conditions: [
          CombatCondition('poisoned', rounds: 2),
          CombatCondition('prone'),
        ],
        concentration: true,
        defeated: false,
        xp: 50,
        cr: '1/4',
        notes: 'Scimitar',
      );
      final back = Combatant.fromObject(_object(
          WorldObjectTypes.combatant, c.toData(),
          name: 'Goblin 2', parentId: 'enc'));
      expect(back.encounterId, 'enc');
      expect(back.name, 'Goblin 2');
      expect(back.entityId, 'e7');
      expect(back.initiative, 14);
      expect(back.initiativeBonus, 2);
      expect((back.hpMax, back.hpCurrent, back.hpTemp), (7, 3, 4));
      expect(back.ac, 15);
      expect(back.conditions, c.conditions);
      expect(back.concentration, isTrue);
      expect(back.xp, 50);
      expect(back.cr, '1/4');
      expect(back.notes, 'Scimitar');
      final object = back.toObject();
      expect(object.parentId, 'enc');
      expect(object.type, WorldObjectTypes.combatant);
    });

    test('defaults for missing and garbled keys', () {
      final c = Combatant.fromObject(_object(
        WorldObjectTypes.combatant,
        {
          'name': 'From data',
          'entityId': '',
          'isPlayer': 'true',
          'initiative': 'fast',
          'initiativeBonus': '3',
          'hpMax': 12.4,
          'hpTemp': -5,
          'ac': 'high',
          'conditions': [
            'prone',
            {'id': 'poisoned', 'rounds': 0},
            {'id': 'prone', 'rounds': 3},
            {'rounds': 2},
            42,
          ],
          'concentration': 1,
          'defeated': 'nope',
          'xp': null,
          'cr': 5,
        },
        name: '',
      ));
      expect(c.name, 'From data');
      expect(c.entityId, isNull);
      expect(c.isPlayer, isTrue);
      expect(c.initiative, isNull);
      expect(c.initiativeBonus, 3);
      expect(c.hpMax, 12);
      // Missing current HP defaults to the maximum.
      expect(c.hpCurrent, 12);
      expect(c.hpTemp, 0);
      expect(c.ac, isNull);
      expect(c.conditions, const [
        CombatCondition('prone'),
        CombatCondition('poisoned'),
      ]);
      expect(c.concentration, isTrue);
      expect(c.defeated, isFalse);
      expect(c.xp, 0);
      expect(c.cr, '5');

      final empty =
          Combatant.fromObject(_object(WorldObjectTypes.combatant, const {}));
      expect(empty.name, 'X');
      expect(empty.encounterId, '');
      expect(empty.conditions, isEmpty);
    });

    test('condition helpers', () {
      const c = Combatant(
          name: 'a', conditions: [CombatCondition('prone', rounds: 2)]);
      expect(c.hasCondition('prone'), isTrue);
      expect(c.hasCondition('blinded'), isFalse);
      expect(c.conditions.first.withRounds(0).rounds, isNull);
      expect(c.conditions.first.withRounds(5).rounds, 5);
      expect(CombatCondition.fromJson(null), isNull);
    });
  });
}
