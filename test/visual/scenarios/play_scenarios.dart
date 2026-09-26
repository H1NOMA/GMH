import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/features/tools/dice/dice_inline.dart';
import 'package:gmh/features/tools/dice/dice_widgets.dart';

import '../../support/demo_world.dart';
import '../../support/visual_routes.dart';
import 'scenario.dart';

String _dice(DemoWorld d) => Routes.tool(d.worldId, 'dice');
String _encounters(DemoWorld d) => Routes.tool(d.worldId, 'combat');
String _tracker(DemoWorld d) => Routes.tool(d.worldId, 'combat', d.encounterId);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await settleVisual(tester, 2);
  await tester.tap(finder);
  await settleVisual(tester, 4);
}

Future<void> _roll(WidgetTester tester, String expression) async {
  final field = find.byKey(const ValueKey('dice-expression'));
  await tester.ensureVisible(field);
  await tester.pump();
  await tester.enterText(field, expression);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await settleVisual(tester, 4);
}

Future<void> _preset(WidgetTester tester, String kind) =>
    _tap(tester, find.byKey(ValueKey('dice-preset-$kind')));

Future<void> _openQuickRoll(WidgetTester tester) async {
  final chip = find.byType(DiceInlineChip).first;
  await tester.ensureVisible(chip);
  await settleVisual(tester, 2);
  await tester.longPress(chip);
  await settleVisual(tester, 4);
}

Finder _keyed(String prefix) => find.byWidgetPredicate((w) {
  final key = w.key;
  return key is ValueKey<String> && key.value.startsWith(prefix);
});

Finder _menuItem(String value) => find.byWidgetPredicate(
  (w) => w is PopupMenuItem<String> && w.value == value,
);

/// The dialog's filled (confirming) action; `FilledButton.icon` is a
/// subclass, so match by `is`.
Finder _confirm() => find.descendant(
  of: find.byType(AlertDialog),
  matching: find.byWidgetPredicate((w) => w is FilledButton),
);

/// Combatants sort by initiative: 0 Mira (player), 1 Fog Hound 1
/// (frightened), 2 Fog Hound 2.
Future<void> _rowMenu(WidgetTester tester, int index, [String? item]) async {
  await _tap(tester, _keyed('combat-menu-').at(index));
  if (item != null) await _tap(tester, _menuItem(item));
}

final playScenarios = <AlignScenario>[
  // Dice roller.
  AlignScenario('dice:error', _dice, (tester, d) => _roll(tester, '2d6+')),
  AlignScenario('dice:result', _dice, (tester, d) => _roll(tester, '2d6+3')),
  AlignScenario('dice:options', _dice, (tester, d) async {
    await _tap(tester, find.byType(FilterChip).first);
    final plus = find.descendant(
      of: find.byType(DiceStepper),
      matching: find.byIcon(Icons.add),
    );
    for (var i = 0; i < 3; i++) {
      await _tap(tester, plus);
    }
    await _roll(tester, '1d20');
  }),
  AlignScenario(
    'dice:ability-scores',
    _dice,
    (tester, d) => _preset(tester, 'abilityScore'),
  ),
  AlignScenario(
    'dice:preset-d20',
    _dice,
    (tester, d) => _preset(tester, 'd20Check'),
  ),
  AlignScenario(
    'dice:preset-coc',
    _dice,
    (tester, d) => _preset(tester, 'callOfCthulhu'),
  ),
  AlignScenario(
    'dice:preset-pbta',
    _dice,
    (tester, d) => _preset(tester, 'pbta'),
  ),
  AlignScenario(
    'dice:preset-savage',
    _dice,
    (tester, d) => _preset(tester, 'savageWorlds'),
  ),
  AlignScenario(
    'dice:preset-cyberpunk',
    _dice,
    (tester, d) => _preset(tester, 'cyberpunkRed'),
  ),
  AlignScenario('dice:preset-result', _dice, (tester, d) async {
    await _preset(tester, 'savageWorlds');
    await _tap(tester, _confirm());
  }),
  AlignScenario('dice:clear-history', _dice, (tester, d) async {
    await _roll(tester, '1d6');
    await _tap(tester, find.byIcon(Icons.delete_sweep_outlined));
  }),
  AlignScenario(
    'dice:quick-roll',
    (d) => Routes.entity(d.worldId, d.byName['Harbor Wyrm']!.id),
    (tester, d) => _openQuickRoll(tester),
  ),
  AlignScenario(
    'dice:quick-roll-result',
    (d) => Routes.entity(d.worldId, d.byName['Harbor Wyrm']!.id),
    (tester, d) async {
      await _openQuickRoll(tester);
      await _tap(tester, find.byKey(const ValueKey('quick-roll-roll')));
    },
  ),
  AlignScenario(
    'dice:quick-roll-error',
    (d) => Routes.entity(d.worldId, d.byName['Harbor Wyrm']!.id),
    (tester, d) async {
      await _openQuickRoll(tester);
      await tester.enterText(
        find.byKey(const ValueKey('quick-roll-expression')),
        '2d6+',
      );
      await settleVisual(tester, 3);
      await _tap(tester, find.byKey(const ValueKey('quick-roll-roll')));
    },
  ),

  // Encounter list.
  AlignScenario(
    'combat:new-encounter',
    _encounters,
    (tester, d) =>
        _tap(tester, find.byKey(const ValueKey('combat-new-encounter'))),
  ),
  AlignScenario(
    'combat:encounter-menu',
    _encounters,
    (tester, d) => _tap(tester, _keyed('encounter-menu-').first),
  ),
  AlignScenario('combat:delete-encounter', _encounters, (tester, d) async {
    await _tap(tester, _keyed('encounter-menu-').first);
    await _tap(tester, _menuItem('delete'));
  }),

  // Encounter tracker. The world is shared by all scenarios of a variant:
  // the ones changing the fight come last.
  AlignScenario('combat:rename', _tracker, (tester, d) async {
    await _tap(tester, _keyed('encounter-menu-').first);
    await _tap(tester, _menuItem('rename'));
  }),
  AlignScenario(
    'combat:add-manual',
    _tracker,
    (tester, d) =>
        _tap(tester, find.byKey(const ValueKey('combat-add-manual'))),
  ),
  AlignScenario(
    'combat:add-world',
    _tracker,
    (tester, d) => _tap(tester, find.byKey(const ValueKey('combat-add-world'))),
  ),
  AlignScenario('combat:quantity', _tracker, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('combat-add-world')));
    await _tap(tester, find.text('Fog Hounds').last);
  }),
  AlignScenario(
    'combat:row-menu',
    _tracker,
    (tester, d) => _rowMenu(tester, 1),
  ),
  AlignScenario(
    'combat:edit-monster',
    _tracker,
    (tester, d) => _rowMenu(tester, 1, 'edit'),
  ),
  AlignScenario(
    'combat:edit-player',
    _tracker,
    (tester, d) => _rowMenu(tester, 0, 'edit'),
  ),
  AlignScenario('combat:amount', _tracker, (tester, d) async {
    final field = _keyed('combat-amount-').at(1);
    await tester.ensureVisible(field);
    await tester.pump();
    await tester.enterText(field, '5');
    await settleVisual(tester, 3);
  }),
  AlignScenario(
    'combat:add-condition',
    _tracker,
    (tester, d) => _tap(tester, _keyed('combat-add-condition-').at(1)),
  ),
  AlignScenario(
    'combat:condition-rounds',
    _tracker,
    (tester, d) => _tap(tester, _keyed('combat-condition-').first),
  ),
  AlignScenario('combat:add-level', _tracker, (tester, d) async {
    final add = find.byKey(const ValueKey('combat-add-level'));
    await tester.dragUntilVisible(
      add,
      find
          .ancestor(
            of: _keyed('combatant-').first,
            matching: find.byType(ListView),
          )
          .first,
      const Offset(0, -300),
    );
    await settleVisual(tester, 2);
    await _tap(tester, add);
  }),
  AlignScenario('combat:toggles', _tracker, (tester, d) async {
    await _tap(tester, _keyed('combat-concentration-').first);
    await _tap(tester, _keyed('combat-defeated-').at(1));
  }),
  AlignScenario(
    'combat:planning',
    _tracker,
    (tester, d) => _tap(tester, find.byKey(const ValueKey('combat-end'))),
  ),
  AlignScenario('combat:empty-encounter', _encounters, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('combat-new-encounter')));
    await _tap(tester, _confirm());
    await settleVisual(tester, 4);
  }),
];
