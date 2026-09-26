import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/data/repositories/world_object_repository_impl.dart';
import 'package:gmh/domain/maps/game_map.dart';
import 'package:gmh/domain/maps/map_pin.dart';
import 'package:gmh/domain/models/world_object.dart';

import '../../support/demo_world.dart';
import '../../support/visual_routes.dart';
import 'scenario.dart';

String _map(DemoWorld d) => Routes.tool(d.worldId, 'maps', d.mapId);
String _gm(DemoWorld d) => Routes.tool(d.worldId, 'reference');
String _timeline(DemoWorld d) => Routes.tool(d.worldId, 'timeline');

Future<void> _tap(WidgetTester tester, Finder finder, [int settle = 4]) async {
  await tester.ensureVisible(finder.first);
  await settleVisual(tester, 2);
  await tester.tap(finder.first);
  await settleVisual(tester, settle);
}

Future<void> _tapKey(WidgetTester tester, String key, [int settle = 4]) =>
    _tap(tester, find.byKey(ValueKey(key)), settle);

/// Taps the map at [fraction] of the visible canvas.
Future<void> _tapCanvas(WidgetTester tester, Offset fraction) async {
  final rect = tester.getRect(find.byKey(const ValueKey('maps-viewer')));
  await tester.tapAt(Offset(
    rect.left + rect.width * fraction.dx,
    rect.top + rect.height * fraction.dy,
  ));
  await settleVisual(tester, 4);
}

/// The first map pin that links an entry (its card offers "open entry").
Future<void> _selectLinkedPin(WidgetTester tester) async {
  final pins = find.byWidgetPredicate((w) =>
      w is GestureDetector &&
      w.key is ValueKey<String> &&
      (w.key! as ValueKey<String>).value.startsWith('maps-pin-'));
  for (var i = 0; i < pins.evaluate().length; i++) {
    await tester.tap(pins.at(i));
    await settleVisual(tester, 3);
    if (find.byKey(const ValueKey('maps-pin-card-open')).evaluate().isNotEmpty) {
      return;
    }
  }
}

Future<void> _openMapMenu(WidgetTester tester, DemoWorld d, String item) async {
  await _tapKey(tester, 'maps-menu-${d.mapId}');
  await _tapKey(tester, item);
}

/// The side panel: docked on wide windows, a bottom sheet otherwise.
Future<void> _openPanel(WidgetTester tester) async {
  if (find.byKey(const ValueKey('maps-tab-pins')).evaluate().isEmpty) {
    await _tapKey(tester, 'maps-panel-toggle');
  }
}

Future<void> _gmDice(WidgetTester tester, String expression) async {
  final field = find.byKey(const ValueKey('gm-dice-expression'));
  await tester.ensureVisible(field);
  await settleVisual(tester, 2);
  await tester.enterText(field, expression);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await settleVisual(tester, 4);
}

Future<void> _gmPinTable(WidgetTester tester, DemoWorld d) async {
  await _tapKey(tester, 'gm-add-table');
  await _tapKey(tester, 'gm-add-table-${d.tableId}');
}

Future<void> _gmPinEntry(WidgetTester tester) async {
  await _tapKey(tester, 'gm-add-pin');
  await _tap(
    tester,
    find.descendant(
        of: find.byType(AlertDialog), matching: find.byType(ListTile)),
  );
}

/// Maps added on the fly to a setting-pack world (never audited by
/// route), so the demo world keeps its data for every other screen:
/// one whose image file is gone (with a pin) and a blank one without a
/// scale. Created once per seeded world.
class _ExtraMaps {
  final String brokenId;
  final String brokenPinId;
  final String unscaledId;
  const _ExtraMaps(this.brokenId, this.brokenPinId, this.unscaledId);
}

final _extraMaps = Expando<_ExtraMaps>();

String _extraWorld(DemoWorld d) => d.packWorldIds.values.first;

Future<_ExtraMaps> _ensureExtraMaps(WidgetTester tester, DemoWorld d) async {
  final existing = _extraMaps[d];
  if (existing != null) return existing;
  final worldId = _extraWorld(d);
  Future<_ExtraMaps> create() async {
    final objects = WorldObjectRepositoryImpl(d.db);
    final broken = await objects.create(
      worldId: worldId,
      type: WorldObjectTypes.map,
      name: 'Lost Chart',
      data: const GameMap(
        name: 'Lost Chart',
        mediaId: 'missing-media',
        width: 880,
        height: 560,
      ).toData(),
    );
    final pin = await objects.create(
      worldId: worldId,
      type: WorldObjectTypes.mapPin,
      parentId: broken.id,
      data: const MapPin(x: 0.5, y: 0.45, label: 'Old Lighthouse').toData(),
    );
    final unscaled = await objects.create(
      worldId: worldId,
      type: WorldObjectTypes.map,
      name: 'Sketch',
      data: const GameMap(name: 'Sketch', width: 880, height: 560).toData(),
    );
    return _ExtraMaps(broken.id, pin.id, unscaled.id);
  }

  // Created in the app's zone and pumped until done: awaited inside
  // runAsync it stalls behind the app's pending database queries.
  _ExtraMaps? created;
  create().then((m) => created = m);
  for (var i = 0; created == null && i < 50; i++) {
    await settleVisual(tester, 1);
  }
  if (created == null) fail('extra maps were not created');
  _extraMaps[d] = created;
  await settleVisual(tester, 3);
  return created!;
}

/// Opens one of the extra maps from its world's map list.
Future<void> _openExtraMap(WidgetTester tester, String mapId) =>
    _tapKey(tester, 'maps-card-$mapId');

Future<void> _measure(WidgetTester tester) async {
  await _tapKey(tester, 'maps-mode-measure');
  await _tapCanvas(tester, const Offset(0.2, 0.55));
  await _tapCanvas(tester, const Offset(0.85, 0.6));
}

Future<void> _newEvent(WidgetTester tester) =>
    _tapKey(tester, 'timeline-new-event');

final atlasScenarios = <AlignScenario>[
  // Maps list and its dialogs.
  AlignScenario('maps:new-blank', (d) => Routes.tool(d.worldId, 'maps'),
      (tester, d) => _tapKey(tester, 'maps-new-blank')),
  AlignScenario('maps:rename', (d) => Routes.tool(d.worldId, 'maps'),
      (tester, d) => _openMapMenu(tester, d, 'maps-menu-rename')),
  AlignScenario('maps:delete', (d) => Routes.tool(d.worldId, 'maps'),
      (tester, d) => _openMapMenu(tester, d, 'maps-menu-delete')),
  AlignScenario('maps:menu', (d) => Routes.tool(d.worldId, 'maps'),
      (tester, d) => _tapKey(tester, 'maps-menu-${d.mapId}')),

  // One map: modes, pin card, editors, panel, player view.
  AlignScenario('maps:details', _map,
      (tester, d) => _openMapMenu(tester, d, 'maps-menu-details')),
  AlignScenario('maps:details-invalid', _map, (tester, d) async {
    await _openMapMenu(tester, d, 'maps-menu-details');
    await tester.enterText(
        find.byKey(const ValueKey('maps-scale-units')), '');
    await settleVisual(tester, 3);
  }),
  AlignScenario('maps:add-mode', _map,
      (tester, d) => _tapKey(tester, 'maps-mode-add')),
  AlignScenario('maps:new-pin', _map, (tester, d) async {
    await _tapKey(tester, 'maps-mode-add');
    await _tapCanvas(tester, const Offset(0.2, 0.55));
  }),
  AlignScenario('maps:measure', _map, (tester, d) => _measure(tester)),
  AlignScenario('maps:measure-rule', _map, (tester, d) async {
    await _measure(tester);
    await _tapKey(tester, 'maps-measure-rule');
  }),
  AlignScenario('maps:pin-card', _map,
      (tester, d) => _selectLinkedPin(tester)),
  AlignScenario('maps:pin-editor', _map, (tester, d) async {
    await _selectLinkedPin(tester);
    await _tapKey(tester, 'maps-pin-card-edit');
  }),
  AlignScenario('maps:panel', _map, (tester, d) => _openPanel(tester)),
  AlignScenario('maps:panel-details', _map, (tester, d) async {
    await _openPanel(tester);
    await _tapKey(tester, 'maps-tab-details');
  }),
  AlignScenario('maps:panel-search', _map, (tester, d) async {
    await _openPanel(tester);
    await tester.enterText(
        find.byKey(const ValueKey('maps-pin-search')), 'zzz');
    await settleVisual(tester, 3);
  }),
  AlignScenario('maps:player-view', _map,
      (tester, d) => _tapKey(tester, 'maps-player-view')),

  // Empty and broken states. The cyberpunk world has no maps or events;
  // the empty list must run before the extra maps are added.
  AlignScenario('maps:empty', (d) => Routes.tool(d.cyberWorldId, 'maps'),
      (tester, d) async {}),
  AlignScenario('maps:not-found',
      (d) => Routes.tool(d.worldId, 'maps', 'no-such-map'),
      (tester, d) async {}),
  AlignScenario('maps:image-missing',
      (d) => Routes.tool(_extraWorld(d), 'maps'), (tester, d) async {
    final maps = await _ensureExtraMaps(tester, d);
    await _openExtraMap(tester, maps.brokenId);
  }),
  AlignScenario('maps:image-missing-pin',
      (d) => Routes.tool(_extraWorld(d), 'maps'), (tester, d) async {
    final maps = await _ensureExtraMaps(tester, d);
    await _openExtraMap(tester, maps.brokenId);
    await _tapKey(tester, 'maps-pin-${maps.brokenPinId}');
  }),
  AlignScenario('maps:measure-no-scale',
      (d) => Routes.tool(_extraWorld(d), 'maps'), (tester, d) async {
    final maps = await _ensureExtraMaps(tester, d);
    await _openExtraMap(tester, maps.unscaledId);
    await _measure(tester);
  }),

  // Timeline dialogs.
  AlignScenario('timeline:new-event', _timeline,
      (tester, d) => _newEvent(tester)),
  AlignScenario('timeline:date-unreadable', _timeline, (tester, d) async {
    await _newEvent(tester);
    final fields = find.descendant(
        of: find.byType(AlertDialog), matching: find.byType(TextField));
    await tester.enterText(fields.first, 'The Last Bell');
    await tester.enterText(fields.last, 'long ago');
    await settleVisual(tester, 3);
  }),
  AlignScenario('timeline:set-date', _timeline, (tester, d) => _tapKey(
      tester, 'timeline-set-date-${d.byName['The Bell Falls Silent']!.id}')),
  AlignScenario('timeline:calendar', _timeline,
      (tester, d) => _tapKey(tester, 'timeline-calendar')),
  AlignScenario('timeline:empty',
      (d) => Routes.tool(d.cyberWorldId, 'timeline'), (tester, d) async {}),

  // GM screen panels.
  AlignScenario('reference:dice-error', _gm,
      (tester, d) => _gmDice(tester, '2d6+')),
  AlignScenario('reference:dice-result', _gm,
      (tester, d) => _gmDice(tester, '2d6+3')),
  AlignScenario('reference:panels-menu', _gm,
      (tester, d) => _tapKey(tester, 'gm-panels')),
  AlignScenario('reference:pin-picker', _gm,
      (tester, d) => _tapKey(tester, 'gm-add-pin')),
  AlignScenario('reference:pinned', _gm, (tester, d) => _gmPinEntry(tester)),
  AlignScenario('reference:tables-menu', _gm,
      (tester, d) => _tapKey(tester, 'gm-add-table')),
  AlignScenario('reference:table-rolled', _gm, (tester, d) async {
    await _gmPinTable(tester, d);
    await _tapKey(tester, 'gm-table-roll-${d.tableId}');
  }),
  AlignScenario('reference:condition', _gm,
      (tester, d) => _tap(tester, find.byType(ExpansionTile))),
];
