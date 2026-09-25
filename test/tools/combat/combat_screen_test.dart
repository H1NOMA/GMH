import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/app.dart';
import 'package:gmh/app/locale_provider.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme_provider.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/domain/combat/combatant.dart';
import 'package:gmh/domain/combat/encounter.dart';
import 'package:gmh/domain/combat/turn_order.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/features/tools/combat/combat_actions.dart';

import '../../support/demo_world.dart';

/// Drift streams resolve on real async, so plain pumpAndSettle would spin
/// forever — pump with short real-time gaps instead.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump(const Duration(milliseconds: 60));
  }
}

class _Harness {
  final ProviderContainer container;
  final String worldId;
  _Harness(this.container, this.worldId);

  Future<List<Encounter>> encounters(WidgetTester tester) async =>
      (await tester.runAsync(() => container
              .read(worldObjectRepositoryProvider)
              .list(worldId, WorldObjectTypes.encounter)))!
          .map(Encounter.fromObject)
          .toList();

  Future<List<Combatant>> combatants(WidgetTester tester,
          [String? encounterId]) async =>
      sortCombatants((await tester.runAsync(() => container
              .read(worldObjectRepositoryProvider)
              .list(worldId, WorldObjectTypes.combatant,
                  parentId: encounterId)))!
          .map(Combatant.fromObject));
}

Future<_Harness> _pumpApp(
  WidgetTester tester, {
  required String Function(String worldId) location,
  Future<void> Function(ProviderContainer c, String worldId)? seed,
  Locale locale = const Locale('en'),
  ThemeMode theme = ThemeMode.dark,
}) async {
  final dir = Directory.systemTemp.createTempSync('gmh_combat_');
  final db = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(overrides: [
    appRootDirProvider.overrideWithValue(dir.path),
    databaseProvider.overrideWithValue(db),
    mediaVaultProvider.overrideWithValue(MediaVault(dir.path)),
    combatRandomProvider.overrideWithValue(Random(1)),
  ]);
  container.read(localeControllerProvider.notifier).seed(locale);
  container.read(themeModeProvider.notifier).seed(theme);
  final worldId = (await tester.runAsync(() async {
    final world = await container
        .read(worldRepositoryProvider)
        .createWorld(name: 'Testland', description: '');
    await seed?.call(container, world.id);
    return world.id;
  }))!;
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: GmhApp(initialLocation: location(worldId)),
  ));
  await _settle(tester);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    await tester.runAsync(() async {
      container.dispose();
      await db.close();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });
  });
  return _Harness(container, worldId);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await _settle(tester);
}

Future<void> _enter(WidgetTester tester, String key, String text) async {
  await tester.enterText(find.byKey(ValueKey(key)), text);
  await tester.pump();
}

void main() {
  testWidgets('create an encounter, add combatants and run combat',
      (tester) async {
    tester.view.physicalSize = const Size(1500, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final h = await _pumpApp(
      tester,
      location: (w) => Routes.tool(w, 'combat'),
      seed: (c, worldId) async {
        await c.read(entityServiceProvider).create(
          worldId: worldId,
          kind: EntityKind.creature,
          name: 'Goblin',
          attributes: {
            'hp': '7 (2d6)',
            'ac': 15,
            'dexterity': 14,
            'challenge': '1/4',
          },
        );
      },
    );

    // Empty list → create.
    expect(find.text('No encounters yet'), findsOneWidget);
    await _tap(tester, find.text('New encounter'));
    await _enter(tester, 'combat-name-field', 'Goblin ambush');
    await _tap(tester, find.widgetWithText(FilledButton, 'Create'));
    var encounters = await h.encounters(tester);
    expect(encounters.single.name, 'Goblin ambush');
    expect(encounters.single.status, EncounterStatus.planning);
    final encounterId = encounters.single.id;
    expect(find.text('Goblin ambush'), findsWidgets);
    expect(find.text('No combatants yet'), findsOneWidget);

    // Manual combatants: a player and a monster with a CR.
    await _tap(tester, find.byKey(const ValueKey('combat-add-manual')));
    await _enter(tester, 'combatant-name', 'Aria');
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
    await _enter(tester, 'combatant-initiative', '15');
    await _enter(tester, 'combatant-hp', '30');
    await _enter(tester, 'combatant-ac', '16');
    await _tap(tester, find.widgetWithText(FilledButton, 'Add'));

    await _tap(tester, find.byKey(const ValueKey('combat-add-manual')));
    await _enter(tester, 'combatant-name', 'Ogre');
    await _enter(tester, 'combatant-initiative', '10');
    await _enter(tester, 'combatant-hp', '59');
    await _enter(tester, 'combatant-ac', '11');
    await _enter(tester, 'combatant-cr', '2');
    await _tap(tester, find.widgetWithText(FilledButton, 'Add'));

    var combatants = await h.combatants(tester, encounterId);
    expect([for (final c in combatants) c.name], ['Aria', 'Ogre']);
    final aria = combatants[0];
    final ogre = combatants[1];
    expect(aria.isPlayer, isTrue);
    expect((aria.hpMax, aria.hpCurrent, aria.ac), (30, 30, 16));
    expect(ogre.isPlayer, isFalse);
    expect((ogre.cr, ogre.xp), ('2', 450));

    // Two goblins from the world, numbered and pre-filled.
    await _tap(tester, find.byKey(const ValueKey('combat-add-world')));
    await _tap(tester, find.widgetWithText(ListTile, 'Goblin'));
    await _tap(tester, find.byKey(const ValueKey('combat-quantity-plus')));
    expect(find.text('2'), findsWidgets);
    await _tap(tester, find.widgetWithText(FilledButton, 'Add'));
    combatants = await h.combatants(tester, encounterId);
    final goblins = combatants.where((c) => c.name.startsWith('Goblin'));
    expect([for (final g in goblins) g.name]..sort(), ['Goblin 1', 'Goblin 2']);
    for (final g in goblins) {
      expect((g.hpMax, g.ac, g.initiativeBonus, g.xp, g.cr),
          (7, 15, 2, 50, '1/4'));
      expect(g.entityId, isNotNull);
      expect(g.initiative, isNull);
    }
    expect(find.text('Goblin 1'), findsOneWidget);

    // Party level for the difficulty panel.
    await _tap(tester, find.byKey(const ValueKey('combat-add-level')));
    await _enter(tester, 'combat-number-field', '3');
    await _tap(tester, find.widgetWithText(FilledButton, 'Save'));
    expect((await h.encounters(tester)).single.partyLevels, [3]);
    expect(find.text('Lv 3'), findsOneWidget);

    // Start: monsters without initiative roll, round 1 on the top combatant.
    await _tap(tester, find.byKey(const ValueKey('combat-start')));
    combatants = await h.combatants(tester, encounterId);
    expect(combatants.every((c) => c.initiative != null), isTrue);
    var encounter = (await h.encounters(tester)).single;
    expect(encounter.status, EncounterStatus.active);
    expect(encounter.round, 1);
    expect(encounter.activeId, combatants.first.id);
    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Turn: ${combatants.first.name}'), findsOneWidget);

    // Next turn.
    await _tap(tester, find.byKey(const ValueKey('combat-next')));
    encounter = (await h.encounters(tester)).single;
    expect(encounter.activeId, combatants[1].id);
    expect(encounter.round, 1);
    expect(find.text('Turn: ${combatants[1].name}'), findsOneWidget);

    // Damage, heal and temporary hit points on the ogre.
    Future<Combatant> ogreNow() async =>
        (await h.combatants(tester, encounterId))
            .firstWhere((c) => c.id == ogre.id);
    await _enter(tester, 'combat-amount-${ogre.id}', '12');
    await _tap(tester, find.byKey(ValueKey('combat-damage-${ogre.id}')));
    expect((await ogreNow()).hpCurrent, 47);
    expect(find.text('47 / 59'), findsOneWidget);
    await _enter(tester, 'combat-amount-${ogre.id}', '5');
    await _tap(tester, find.byKey(ValueKey('combat-heal-${ogre.id}')));
    expect((await ogreNow()).hpCurrent, 52);
    await _enter(tester, 'combat-amount-${ogre.id}', '4');
    await _tap(tester, find.byKey(ValueKey('combat-temp-${ogre.id}')));
    expect((await ogreNow()).hpTemp, 4);

    // A condition with a duration.
    await _tap(
        tester, find.byKey(ValueKey('combat-add-condition-${ogre.id}')));
    await _tap(tester, find.text('Poisoned').last);
    expect((await ogreNow()).conditions, const [CombatCondition('poisoned')]);
    await _tap(tester,
        find.byKey(ValueKey('combat-condition-${ogre.id}-poisoned')));
    await _enter(tester, 'combat-number-field', '2');
    await _tap(tester, find.widgetWithText(FilledButton, 'Save'));
    expect((await ogreNow()).conditions,
        const [CombatCondition('poisoned', rounds: 2)]);
    expect(find.text('Poisoned · 2'), findsOneWidget);

    // Defeated toggle and concentration toggle persist.
    await _tap(tester, find.byKey(ValueKey('combat-concentration-${ogre.id}')));
    expect((await ogreNow()).concentration, isTrue);

    // Kill a goblin through damage: it is marked defeated.
    final goblin = goblins.first;
    await _enter(tester, 'combat-amount-${goblin.id}', '20');
    await _tap(tester, find.byKey(ValueKey('combat-damage-${goblin.id}')));
    final deadGoblin = (await h.combatants(tester, encounterId))
        .firstWhere((c) => c.id == goblin.id);
    expect((deadGoblin.hpCurrent, deadGoblin.defeated), (0, true));

    // Edit a combatant through the overflow menu.
    await _tap(tester, find.byKey(ValueKey('combat-menu-${aria.id}')));
    await _tap(tester, find.text('Edit'));
    await _enter(tester, 'combatant-name', 'Aria the Bold');
    await _tap(tester, find.widgetWithText(FilledButton, 'Save'));
    expect(
        (await h.combatants(tester, encounterId))
            .any((c) => c.name == 'Aria the Bold'),
        isTrue);

    // Remove the other goblin.
    final other = goblins.last;
    await _tap(tester, find.byKey(ValueKey('combat-menu-${other.id}')));
    await _tap(tester, find.text('Remove'));
    combatants = await h.combatants(tester, encounterId);
    expect(combatants.any((c) => c.id == other.id), isFalse);
    expect(combatants, hasLength(3));

    // End combat.
    await _tap(tester, find.byKey(const ValueKey('combat-end')));
    expect((await h.encounters(tester)).single.status,
        EncounterStatus.finished);

    // Back to the list, duplicate, then delete the original.
    await _tap(tester, find.byTooltip('All encounters'));
    expect(find.byKey(ValueKey('encounter-$encounterId')), findsOneWidget);
    expect(find.text('3 combatants'), findsOneWidget);
    await _tap(tester, find.byKey(ValueKey('encounter-menu-$encounterId')));
    await _tap(tester, find.text('Duplicate'));
    encounters = await h.encounters(tester);
    expect(encounters, hasLength(2));
    final copy = encounters.firstWhere((e) => e.id != encounterId);
    expect(copy.name, 'Goblin ambush (copy)');
    expect(copy.status, EncounterStatus.planning);
    expect(await h.combatants(tester, copy.id), hasLength(3));

    await _tap(tester, find.byTooltip('All encounters'));
    await _tap(tester, find.byKey(ValueKey('encounter-menu-$encounterId')));
    await _tap(tester, find.text('Delete'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Delete'));
    encounters = await h.encounters(tester);
    expect([for (final e in encounters) e.id], [copy.id]);
    expect(await h.combatants(tester, encounterId), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rename an encounter from the list', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final h = await _pumpApp(tester,
        location: (w) => Routes.tool(w, 'combat'),
        seed: (c, worldId) => c
            .read(combatActionsProvider)
            .createEncounter(worldId, 'Bridge fight'));
    final id = (await h.encounters(tester)).single.id;
    await _tap(tester, find.byKey(ValueKey('encounter-menu-$id')));
    await _tap(tester, find.text('Rename'));
    await _enter(tester, 'combat-name-field', 'Troll bridge');
    await _tap(tester, find.widgetWithText(FilledButton, 'Save'));
    expect((await h.encounters(tester)).single.name, 'Troll bridge');
    expect(find.text('Troll bridge'), findsOneWidget);
  });

  testWidgets('a missing encounter shows a way back', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await _pumpApp(tester, location: (w) => Routes.tool(w, 'combat', 'nope'));
    expect(find.text('This encounter no longer exists.'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'All encounters'));
    expect(find.text('No encounters yet'), findsOneWidget);
  });

  // Layout: the running tracker from phone to 1440p, long locales and a
  // raised text scale must render without overflow or framework errors.
  final variants = <(String, Size, Locale, double, ThemeMode)>[
    ('phone de x1.3', const Size(400, 780), const Locale('de'), 1.3,
        ThemeMode.dark),
    ('phone fr light', const Size(400, 600), const Locale('fr'), 1.0,
        ThemeMode.light),
    ('900x600 ru x1.3', const Size(900, 600), const Locale('ru'), 1.3,
        ThemeMode.dark),
    ('1280x720 zh', const Size(1280, 720), const Locale('zh'), 1.0,
        ThemeMode.light),
    ('2560x1440 en', const Size(2560, 1440), const Locale('en'), 1.0,
        ThemeMode.dark),
  ];
  for (final (name, size, locale, scale, theme) in variants) {
    testWidgets('tracker layout · $name', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await loadRealFonts(tester);

      final problems = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (details) =>
          problems.add(details.exceptionAsString().split('\n').first);
      addTearDown(() => FlutterError.onError = previous);

      late String encounterId;
      final h = await _pumpApp(
        tester,
        locale: locale,
        theme: theme,
        location: (w) => Routes.tool(w, 'combat', encounterId),
        seed: (c, worldId) async {
          final actions = c.read(combatActionsProvider);
          var e = await actions.createEncounter(
              worldId, 'The very long encounter at the collapsing bridge');
          encounterId = e.id;
          e = e.copyWith(partyLevels: [5, 5, 6, 7], notes: 'Wind and rain');
          await actions.saveEncounter(e);
          await actions.addCombatants(e, const [
            Combatant(
                name: 'Ser Aldric Vantermoor of the Silver Vale',
                isPlayer: true,
                initiative: 18,
                hpMax: 52,
                hpCurrent: 40,
                hpTemp: 5,
                ac: 18,
                concentration: true),
            Combatant(
                name: 'Ancient Shadow Dragon Wyrmling Matriarch',
                initiative: 12,
                initiativeBonus: 3,
                hpMax: 367,
                hpCurrent: 200,
                ac: 22,
                cr: '20',
                xp: 25000,
                conditions: [
                  CombatCondition('incapacitated', rounds: 10),
                  CombatCondition('frightened'),
                  CombatCondition('restrained', rounds: 3),
                  CombatCondition('exhaustion'),
                ]),
            Combatant(
                name: 'Goblin', initiative: 3, hpMax: 7, defeated: true),
          ]);
          final combatants = [
            for (final o in await c
                .read(worldObjectRepositoryProvider)
                .list(worldId, WorldObjectTypes.combatant, parentId: e.id))
              Combatant.fromObject(o),
          ];
          await actions.beginCombat(e, combatants);
        },
      );
      expect(await h.combatants(tester, encounterId), hasLength(3));
      expect(find.textContaining('Ser Aldric'), findsWidgets);
      // Scroll through the whole page so every section lays out.
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, -2000));
        await _settle(tester);
      }
      expect(tester.takeException(), isNull);
      expect(problems, isEmpty, reason: problems.join('\n'));
    });
  }
}
