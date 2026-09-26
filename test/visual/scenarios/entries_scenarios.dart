import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity_kind.dart';

import '../../support/demo_world.dart';
import '../../support/visual_routes.dart';
import 'scenario.dart';

String _entry(DemoWorld d, String name) =>
    Routes.entity(d.worldId, d.byName[name]!.id);

String _ravenport(DemoWorld d) => _entry(d, 'Ravenport');
String _mira(DemoWorld d) => _entry(d, 'Captain Mira Voss');

Finder _ofType(String type) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == type);

Finder _menuItem(Object value) =>
    find.byWidgetPredicate((w) => w is PopupMenuItem && w.value == value);

Finder _inDialog(Finder matching) =>
    find.descendant(of: find.byType(Dialog), matching: matching);

Future<void> _tap(WidgetTester tester, Finder finder, {int settle = 4}) async {
  await tester.ensureVisible(finder.first);
  await settleVisual(tester, 2);
  await tester.tap(finder.first);
  await settleVisual(tester, settle);
}

/// Scrolls the entry page's side panel to [target]. Narrow entry pages
/// split into Document / Details tabs: switches to the details side when
/// the panel isn't built yet.
Future<void> _reveal(WidgetTester tester, Finder target) async {
  final sidePanel = _ofType('_SidePanel');
  final tabs = find.byType(Tab);
  if (sidePanel.evaluate().isEmpty && tabs.evaluate().length == 2) {
    await tester.tap(tabs.last);
    await settleVisual(tester, 4);
  }
  // Jumps instead of drags: a drag can land on a tappable dice chip.
  final position = tester
      .state<ScrollableState>(
        find.descendant(of: sidePanel, matching: find.byType(Scrollable)).first,
      )
      .position;
  while (target.evaluate().isEmpty &&
      position.pixels < position.maxScrollExtent) {
    position.jumpTo((position.pixels + 200).clamp(0, position.maxScrollExtent));
    await tester.pump();
  }
  await tester.ensureVisible(target.first);
  await settleVisual(tester, 2);
}

Future<void> _details(WidgetTester tester) async {
  final tabs = find.byType(Tab);
  if (tabs.evaluate().length == 2) {
    await tester.tap(tabs.last);
    await settleVisual(tester, 4);
  }
}

Future<void> _profileTab(WidgetTester tester, int index) =>
    _tap(tester, find.byType(Tab).at(index));

Future<void> _fieldButton(
  WidgetTester tester,
  DemoWorld d,
  String entry,
  String field,
  Finder button,
) async {
  final editor = find.byKey(ValueKey('${d.byName[entry]!.id}:$field'));
  await _reveal(tester, editor);
  await _tap(tester, find.descendant(of: editor, matching: button));
}

Future<void> _openPicker(WidgetTester tester) async {
  final add = find.byKey(const ValueKey('relations-add'));
  await _reveal(tester, add);
  await _tap(tester, add);
}

Future<void> _openTagManager(WidgetTester tester) =>
    _tap(tester, find.widgetWithIcon(ActionChip, Icons.sell_outlined));

Future<void> _tagRowMenu(WidgetTester tester, String action) async {
  await _openTagManager(tester);
  await _tap(tester, _inDialog(find.byIcon(Icons.more_horiz)));
  await _tap(tester, _menuItem(action));
}

Future<void> _entryMenu(WidgetTester tester, String action) async {
  await _tap(
    tester,
    find.descendant(
      of: find.byType(AppBar),
      matching: find.byWidgetPredicate((w) => w is PopupMenuButton),
    ),
  );
  await _tap(tester, _menuItem(action));
}

Future<void> _attachmentActions(WidgetTester tester) async {
  await _profileTab(tester, 8);
  final tile = _ofType('_ImageTile');
  await tester.ensureVisible(tile.first);
  await settleVisual(tester, 2);
  await tester.longPress(tile.first);
  await settleVisual(tester, 4);
}

const _profileTabs = [
  'biography',
  'statistics',
  'beliefs',
  'relationships',
  'inventory',
  'abilities',
  'timeline',
  'notes',
];

final entriesScenarios = <AlignScenario>[
  // ------------------------------------------------------------ browse
  AlignScenario(
    'entries:new-entry',
    (d) => Routes.browse(d.worldId, EntityKind.character),
    (tester, d) => _tap(tester, find.byType(FloatingActionButton)),
  ),
  AlignScenario(
    'entries:grid',
    (d) => Routes.browse(d.worldId, EntityKind.location),
    (tester, d) => _tap(tester, find.byIcon(Icons.grid_view)),
  ),
  AlignScenario(
    'entries:sort-menu',
    (d) => Routes.browse(d.worldId, EntityKind.location),
    (tester, d) => _tap(tester, find.byIcon(Icons.sort)),
  ),
  AlignScenario(
    'entries:filter-empty',
    (d) => Routes.browse(d.worldId, EntityKind.location),
    (tester, d) async {
      await tester.enterText(find.byType(TextField).first, 'zzzz');
      await settleVisual(tester, 3);
    },
  ),

  // ------------------------------------------------------- entry pages
  for (final (kind, name) in [
    ('location', 'Ravenport'),
    ('faction', 'Harbor Council'),
    ('event', 'The Night of Amber Rain'),
    ('campaign', 'Curse of the Amber Throne'),
    ('custom', 'The Lantern Wrights'),
    ('quest', 'Crown in the Deep'),
  ])
    AlignScenario(
      'entries:details-$kind',
      (d) => _entry(d, name),
      (tester, d) => _details(tester),
    ),
  AlignScenario('entries:details-location-lower', _ravenport, (
    tester,
    d,
  ) async {
    final attachments = find.byKey(const ValueKey('attachments-add-files'));
    await _reveal(tester, attachments);
  }),
  AlignScenario(
    'entries:details-creature-lower',
    (d) => _entry(d, 'Harbor Wyrm'),
    (tester, d) async {
      await _reveal(tester, find.byKey(const ValueKey('relations-add')));
    },
  ),
  AlignScenario(
    'entries:rename',
    _ravenport,
    (tester, d) => _entryMenu(tester, 'edit'),
  ),
  AlignScenario(
    'entries:delete',
    _ravenport,
    (tester, d) => _entryMenu(tester, 'delete'),
  ),
  AlignScenario(
    'entries:version-history',
    _ravenport,
    (tester, d) => _tap(tester, find.byIcon(Icons.history)),
  ),
  AlignScenario(
    'entries:link-picker',
    _ravenport,
    (tester, d) => _tap(tester, find.byIcon(Icons.alternate_email)),
  ),

  // ------------------------------------------------- relations, pickers
  AlignScenario(
    'entries:picker',
    _ravenport,
    (tester, d) => _openPicker(tester),
  ),
  AlignScenario('entries:picker-empty', _ravenport, (tester, d) async {
    await _openPicker(tester);
    await tester.enterText(_inDialog(find.byType(TextField)), 'zzzz');
    await settleVisual(tester, 4);
  }),
  AlignScenario('entries:relation-role', _ravenport, (tester, d) async {
    await _openPicker(tester);
    await _tap(tester, _inDialog(find.byType(ListTile)));
  }),
  AlignScenario(
    'entries:ref-picker',
    _ravenport,
    (tester, d) => _fieldButton(
      tester,
      d,
      'Ravenport',
      'parentLocation',
      find.byWidgetPredicate((w) => w is OutlinedButton),
    ),
  ),

  // ------------------------------------------------------ field editors
  AlignScenario('entries:number-error', (d) => _entry(d, 'Harbor Wyrm'), (
    tester,
    d,
  ) async {
    final field = find.descendant(
      of: find.byKey(ValueKey('${d.byName['Harbor Wyrm']!.id}:ac')),
      matching: find.byType(TextField),
    );
    await _reveal(tester, field);
    await tester.enterText(field, 'abc');
    await settleVisual(tester, 3);
  }),
  AlignScenario(
    'entries:list-add',
    (d) => _entry(d, 'Curse of the Amber Throne'),
    (tester, d) => _fieldButton(
      tester,
      d,
      'Curse of the Amber Throne',
      'players',
      find.byIcon(Icons.add),
    ),
  ),
  AlignScenario('entries:checklist', (d) => _entry(d, 'Crown in the Deep'), (
    tester,
    d,
  ) async {
    for (final text in ['Find the wreck', 'Bring back the crown']) {
      await _fieldButton(
        tester,
        d,
        'Crown in the Deep',
        'objectives',
        find.byIcon(Icons.add),
      );
      await tester.enterText(_inDialog(find.byType(TextField)), text);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await settleVisual(tester, 4);
    }
    await tester.ensureVisible(
      find.byKey(ValueKey('${d.byName['Crown in the Deep']!.id}:objectives')),
    );
    await settleVisual(tester, 2);
  }),

  // --------------------------------------------------------------- tags
  AlignScenario('entries:tag-add', _ravenport, (tester, d) async {
    final add = find.byKey(const ValueKey('tag-add'));
    await _reveal(tester, add);
    await _tap(tester, add);
  }),
  AlignScenario(
    'entries:tag-manager',
    (d) => Routes.search(d.worldId),
    (tester, d) => _openTagManager(tester),
  ),
  AlignScenario(
    'entries:tag-rename',
    (d) => Routes.search(d.worldId),
    (tester, d) => _tagRowMenu(tester, 'rename'),
  ),
  AlignScenario(
    'entries:tag-color',
    (d) => Routes.search(d.worldId),
    (tester, d) => _tagRowMenu(tester, 'color'),
  ),
  AlignScenario(
    'entries:tag-merge',
    (d) => Routes.search(d.worldId),
    (tester, d) => _tagRowMenu(tester, 'merge'),
  ),
  AlignScenario(
    'entries:tag-delete',
    (d) => Routes.search(d.worldId),
    (tester, d) => _tagRowMenu(tester, 'delete'),
  ),

  // -------------------------------------------------- character profile
  for (final (i, tab) in _profileTabs.indexed)
    AlignScenario(
      'entries:profile-$tab',
      _mira,
      (tester, d) => _profileTab(tester, i + 1),
    ),
  AlignScenario('entries:ability-edit', _mira, (tester, d) async {
    await _profileTab(tester, 2);
    await _tap(tester, _ofType('_AbilityBox'));
  }),

  // -------------------------------------------------------- attachments
  AlignScenario(
    'entries:attachment-actions',
    _mira,
    (tester, d) => _attachmentActions(tester),
  ),
  AlignScenario('entries:attachment-rename', _mira, (tester, d) async {
    await _attachmentActions(tester);
    await _tap(
      tester,
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byIcon(Icons.edit_outlined),
      ),
    );
  }),
  AlignScenario('entries:image-viewer', _mira, (tester, d) async {
    await _profileTab(tester, 8);
    await _tap(tester, _ofType('_ImageTile'));
  }),
];
