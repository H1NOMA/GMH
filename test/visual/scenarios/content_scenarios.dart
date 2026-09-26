import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/router.dart';

import '../../support/demo_world.dart';
import '../../support/visual_routes.dart';
import 'scenario.dart';

String _tables(DemoWorld d) => Routes.tool(d.worldId, 'tables');
String _table(DemoWorld d) => Routes.tool(d.worldId, 'tables', d.tableId);
String _library(DemoWorld d) => Routes.tool(d.worldId, 'tables', 'library');
String _generators(DemoWorld d) => Routes.tool(d.worldId, 'generators');

Finder _keyed(String prefix) => find.byWidgetPredicate((w) {
  final key = w.key;
  return key is ValueKey<String> && key.value.startsWith(prefix);
});

Future<void> _tap(WidgetTester tester, Finder finder, [int settle = 3]) async {
  await tester.ensureVisible(finder.first);
  await settleVisual(tester, 2);
  await tester.tap(finder.first);
  await settleVisual(tester, settle);
}

Future<void> _type(WidgetTester tester, Finder field, String text) async {
  await tester.ensureVisible(field.first);
  await settleVisual(tester, 2);
  await tester.enterText(field.first, text);
  await settleVisual(tester, 3);
}

/// Scrolls the library list until [finder] is built and on screen.
Future<void> _reveal(WidgetTester tester, Finder finder) async {
  // Resolved once: the search field it is found by scrolls out of the list.
  final list = tester.element(
    find
        .ancestor(
          of: find.byKey(const ValueKey('tables-library-search')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byElementPredicate((e) => e == list),
  );
  await settleVisual(tester, 2);
}

Finder _dialogButton<T>() =>
    find.descendant(of: find.byType(AlertDialog), matching: find.byType(T));

Future<void> _generate(WidgetTester tester) async {
  final button = find.byKey(const ValueKey('gen-generate'));
  if (button.evaluate().isEmpty) {
    // Scrolled out of its lazy list: below the wide picker, above the
    // phone results.
    final wide = find.byKey(const ValueKey('gen-picker')).evaluate().isNotEmpty;
    await tester.scrollUntilVisible(
      button,
      wide ? 200 : -200,
      scrollable: find
          .descendant(
            of: find.byKey(ValueKey(wide ? 'gen-picker' : 'gen-results')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await settleVisual(tester, 2);
  }
  await _tap(tester, button);
}

Future<void> _pickKind(WidgetTester tester, String kind) =>
    _tap(tester, find.byKey(ValueKey('gen-kind-$kind')), 2);

/// Scrolls the generator results down to [finder].
Future<void> _revealResult(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find
        .descendant(
          of: find.byKey(const ValueKey('gen-results')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await settleVisual(tester, 3);
}

final contentScenarios = <AlignScenario>[
  // Table list.
  AlignScenario('tables:new', _tables, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('tables-new')), 4);
  }),
  AlignScenario('tables:new-error', _tables, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('tables-new')), 4);
    await _type(
      tester,
      find.byKey(const ValueKey('tables-formula-field')),
      '2d+',
    );
  }),
  AlignScenario('tables:import', _tables, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('tables-import')), 4);
    await _type(
      tester,
      find.byKey(const ValueKey('tables-text-field')),
      '1 | Rain\n2-3 | Fog\n4 | Sun',
    );
  }),
  AlignScenario('tables:search-empty', _tables, (tester, d) async {
    await _type(tester, find.byKey(const ValueKey('tables-search')), 'zzzz');
  }),
  AlignScenario('tables:menu', _tables, (tester, d) async {
    await _tap(tester, _keyed('tables-menu-'), 4);
  }),
  AlignScenario('tables:delete', _tables, (tester, d) async {
    await _tap(tester, _keyed('tables-menu-'), 4);
    await _tap(tester, find.byKey(const ValueKey('tables-menu-delete')), 4);
  }),

  // One table.
  AlignScenario('tables:edit-details', _table, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('tables-edit-details')), 4);
  }),
  AlignScenario('tables:page-menu', _table, (tester, d) async {
    await _tap(tester, find.byKey(ValueKey('tables-menu-${d.tableId}')), 4);
  }),
  AlignScenario('tables:bulk-edit', _table, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('tables-bulk-edit')), 4);
  }),
  AlignScenario('tables:rolled', _table, (tester, d) async {
    for (var i = 0; i < 3; i++) {
      await _tap(tester, find.byKey(const ValueKey('tables-roll')));
    }
    await tester.ensureVisible(find.byKey(const ValueKey('tables-clear-log')));
    await settleVisual(tester, 3);
  }),
  AlignScenario('tables:issues', _table, (tester, d) async {
    await _type(tester, find.byKey(const ValueKey('tables-row-to-0')), '4');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.ensureVisible(find.byKey(const ValueKey('tables-issues')));
    await settleVisual(tester, 3);
  }),
  AlignScenario('tables:weighted', _table, (tester, d) async {
    await _tap(tester, find.byKey(const ValueKey('tables-edit-details')), 4);
    await _type(tester, find.byKey(const ValueKey('tables-formula-field')), '');
    await _tap(tester, _dialogButton<FilledButton>(), 4);
    await tester.ensureVisible(
      find.byKey(const ValueKey('tables-row-weight-0')),
    );
    await settleVisual(tester, 3);
  }),

  // Library.
  AlignScenario('tables:preview', _library, (tester, d) async {
    await _tap(tester, _keyed('tables-lib-preview-'), 4);
  }),
  AlignScenario('tables:preview-rolled', _library, (tester, d) async {
    await _tap(tester, _keyed('tables-lib-preview-'), 4);
    await _tap(tester, find.byKey(const ValueKey('tables-preview-roll')));
    await tester.ensureVisible(find.byKey(const ValueKey('tables-roll-again')));
    await settleVisual(tester, 3);
  }),
  AlignScenario('tables:deps', _library, (tester, d) async {
    final add = find.byKey(const ValueKey('tables-lib-add-fantasy.weather'));
    await _reveal(tester, add);
    await _tap(tester, add, 4);
  }),
  AlignScenario('tables:library-other', _library, (tester, d) async {
    final pack = find.byKey(const ValueKey('tables-pack-cyberpunk-false'));
    await _reveal(tester, pack);
    await _tap(tester, pack, 4);
  }),
  AlignScenario('tables:library-search', _library, (tester, d) async {
    await _type(
      tester,
      find.byKey(const ValueKey('tables-library-search')),
      'road',
    );
  }),

  // Generators.
  AlignScenario('generators:npc', _generators, (tester, d) async {
    await _generate(tester);
  }),
  AlignScenario('generators:names-options', _generators, (tester, d) async {
    await _pickKind(tester, 'names');
  }),
  AlignScenario('generators:pack-menu', _generators, (tester, d) async {
    await _tap(tester, _keyed('gen-pack-'), 4);
  }),
  AlignScenario('generators:culture-menu', _generators, (tester, d) async {
    await _pickKind(tester, 'names');
    await _tap(tester, _keyed('gen-culture-'), 4);
  }),
  AlignScenario('generators:names', _generators, (tester, d) async {
    await _pickKind(tester, 'names');
    await _generate(tester);
    await _tap(tester, find.byKey(const ValueKey('gen-name-save-0')), 4);
    await tester.ensureVisible(find.byKey(const ValueKey('gen-name-0')));
    await settleVisual(tester, 3);
  }),
  AlignScenario('generators:settlement', _generators, (tester, d) async {
    await _pickKind(tester, 'settlement');
    await _generate(tester);
  }),
  AlignScenario('generators:loot', _generators, (tester, d) async {
    await _pickKind(tester, 'loot');
    await _generate(tester);
  }),
  AlignScenario('generators:weather', _generators, (tester, d) async {
    await _pickKind(tester, 'weather');
    await _generate(tester);
  }),
  AlignScenario('generators:saved', _generators, (tester, d) async {
    await _generate(tester);
    await _tap(tester, _keyed('gen-save-'), 6);
  }),
  AlignScenario('generators:kept', _generators, (tester, d) async {
    await _generate(tester);
    await _tap(tester, _keyed('gen-keep-'));
    await _generate(tester);
    await _generate(tester);
    await _revealResult(tester, _keyed('gen-dismiss-'));
  }),
  AlignScenario('generators:history', _generators, (tester, d) async {
    await _generate(tester);
    await _generate(tester);
    await _generate(tester);
    await _revealResult(
      tester,
      find.byKey(const ValueKey('gen-history-clear')),
    );
  }),
];
