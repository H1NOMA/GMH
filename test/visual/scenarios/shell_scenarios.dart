import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/nav_state.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/features/search/search_screen.dart';
import 'package:gmh/features/shell/tab_strip.dart';
import 'package:gmh/features/shell/workspace_tabs.dart';

import '../../support/demo_world.dart';
import '../../support/visual_routes.dart';
import 'scenario.dart';

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await settleVisual(tester, 2);
  await tester.tap(finder);
  await settleVisual(tester, 4);
}

Future<void> _shortcut(WidgetTester tester, LogicalKeyboardKey key,
    {bool control = false}) async {
  if (control) await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyEvent(key);
  if (control) await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await settleVisual(tester, 4);
}

Future<void> _openPalette(WidgetTester tester, [String? query]) async {
  await _shortcut(tester, LogicalKeyboardKey.keyP, control: true);
  if (query == null) return;
  // The palette sits on the overlay, above every field of the page.
  await tester.enterText(find.byType(TextField).last, query);
  await settleVisual(tester, 4);
}

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));

WorkspaceTabs _tabs(WidgetTester tester) =>
    _container(tester).read(workspaceTabsProvider.notifier);

/// Waits out real I/O (a backup, a restore) until its snackbar shows, then
/// lets the snackbar slide in.
Future<void> _awaitSnackBar(WidgetTester tester) async {
  for (var i = 0; i < 100 && find.byType(SnackBar).evaluate().isEmpty; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
  }
  await settleVisual(tester, 4);
}

/// Scrolls the desktop sidebar to its end; false on phones (no sidebar).
Future<bool> _sidebarToEnd(WidgetTester tester) async {
  final list = find.ancestor(
      of: find.byIcon(Icons.dashboard_outlined).first,
      matching: find.byType(ListView));
  if (list.evaluate().isEmpty) return false;
  await tester.drag(list.first, const Offset(0, -2000));
  await settleVisual(tester, 3);
  return true;
}

/// Several tabs: short and long entry names, a tool and a section page.
Future<void> _openTabs(WidgetTester tester, DemoWorld d) async {
  final tabs = _tabs(tester);
  for (final location in [
    Routes.entity(d.worldId, d.byName['Curse of the Amber Throne']!.id),
    Routes.tool(d.worldId, 'dice'),
    Routes.entity(d.worldId, d.byName['Ravenport']!.id),
    Routes.graph(d.worldId),
  ]) {
    tabs.openInNewTab(location);
    await settleVisual(tester, 3);
  }
  await settleVisual(tester, 4);
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(
      find.descendant(
          of: find.byType(SearchScreen), matching: find.byType(TextField)),
      query);
  await settleVisual(tester, 6);
}

Finder _helpSection(IconData icon) => find.descendant(
    of: find.byType(ExpansionTile), matching: find.byIcon(icon));

Future<void> _expandHelp(WidgetTester tester, IconData icon,
    {required Finder reveal}) async {
  // The guide is a lazy list: lower sections are not built until reached.
  await tester.dragUntilVisible(_helpSection(icon),
      find.byKey(const PageStorageKey('helpScroll')), const Offset(0, -200));
  await settleVisual(tester, 2);
  await _tap(tester, _helpSection(icon));
  final target = reveal.first;
  await tester.ensureVisible(target);
  await settleVisual(tester, 3);
}

Finder _inExpanded(Finder matching) =>
    find.descendant(of: find.byType(ExpansionTile), matching: matching);

final shellScenarios = <AlignScenario>[
  // Command palette (Ctrl+P): idle list, entry + command matches, nothing.
  AlignScenario('shell:palette', (d) => Routes.home(d.worldId),
      (tester, d) => _openPalette(tester)),
  AlignScenario('shell:palette-query', (d) => Routes.home(d.worldId),
      (tester, d) => _openPalette(tester, 'ra')),
  AlignScenario('shell:palette-empty', (d) => Routes.home(d.worldId),
      (tester, d) => _openPalette(tester, 'zzqxw')),
  // Pause menu (Escape).
  AlignScenario('shell:pause', (d) => Routes.home(d.worldId),
      (tester, d) => _shortcut(tester, LogicalKeyboardKey.escape)),
  // Workspace tab strip with several tabs, and its context menu.
  AlignScenario('shell:tabs', (d) => Routes.home(d.worldId), _openTabs),
  AlignScenario('shell:tab-menu', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _openTabs(tester, d);
    final tab = find.descendant(
        of: find.byType(WorkspaceTabStrip),
        matching: find.byIcon(Icons.hub_outlined));
    if (tab.evaluate().isEmpty) return; // phones have no tab strip
    await tester.longPress(tab.first);
    await settleVisual(tester, 4);
  }),

  // Sidebar scrolled to its end: library kinds and custom categories.
  AlignScenario('shell:sidebar-end', (d) => Routes.home(d.worldId),
      (tester, d) => _sidebarToEnd(tester)),

  // Search: results with snippets, a kind filter on, no matches.
  AlignScenario('search:results', (d) => Routes.search(d.worldId),
      (tester, d) => _search(tester, 'amber')),
  AlignScenario('search:filtered', (d) => Routes.search(d.worldId),
      (tester, d) async {
    await _search(tester, 'amber');
    // The first kind chip: in view without scrolling the chip row.
    await tester.tap(find.ancestor(
        of: find.byIcon(EntityKind.character.icon),
        matching: find.byType(FilterChip)));
    await settleVisual(tester, 6);
  }),
  AlignScenario('search:no-match', (d) => Routes.search(d.worldId),
      (tester, d) => _search(tester, 'zzqxw')),

  // Graph kind filter menu, before and after hiding a kind.
  AlignScenario('graph:filter', (d) => Routes.graph(d.worldId),
      (tester, d) => _tap(tester, find.byIcon(Icons.filter_list))),
  AlignScenario('graph:filter-hidden', (d) => Routes.graph(d.worldId),
      (tester, d) async {
    await _tap(tester, find.byIcon(Icons.filter_list));
    await _tap(tester, find.byType(PopupMenuItem<String>).first);
    await settleVisual(tester, 6);
    await _tap(tester, find.byIcon(Icons.filter_list));
  }),
  // Every kind hidden: the empty-graph message.
  AlignScenario('graph:empty', (d) => Routes.graph(d.worldId),
      (tester, d) async {
    final filter = find.byIcon(Icons.filter_list);
    await _tap(tester, filter);
    final count = find.byType(PopupMenuItem<String>).evaluate().length;
    for (var i = 0; i < count; i++) {
      if (i > 0) await _tap(tester, filter);
      await _tap(tester, find.byType(PopupMenuItem<String>).at(i));
      await settleVisual(tester, 6);
    }
  }),
  AlignScenario(
      'graph:local-filter',
      (d) => Routes.graph(d.worldId, focusEntityId: d.byName['Ravenport']!.id),
      (tester, d) => _tap(tester, find.byIcon(Icons.filter_list))),

  // User guide: the schematic figures with their legends, a screenshot.
  AlignScenario('help:shell', (d) => Routes.help(d.worldId),
      (tester, d) async {
    await _expandHelp(tester, Icons.view_sidebar_outlined,
        reveal: _inExpanded(find.byType(AspectRatio)));
  }),
  AlignScenario('help:shell-legend', (d) => Routes.help(d.worldId),
      (tester, d) async {
    await _expandHelp(tester, Icons.view_sidebar_outlined,
        reveal: _inExpanded(find.byType(AspectRatio)));
    await tester.drag(find.byType(ListView).last, const Offset(0, -260));
    await settleVisual(tester, 3);
  }),
  AlignScenario('help:entry', (d) => Routes.help(d.worldId),
      (tester, d) async {
    await _expandHelp(tester, Icons.article_outlined,
        reveal: _inExpanded(find.byType(AspectRatio)));
  }),
  AlignScenario('help:constructor', (d) => Routes.help(d.worldId),
      (tester, d) async {
    await _expandHelp(tester, Icons.category_outlined,
        reveal: _inExpanded(find.byType(AspectRatio)));
  }),
  AlignScenario('help:screenshot', (d) => Routes.help(d.worldId),
      (tester, d) async {
    await _expandHelp(tester, Icons.hub_outlined,
        reveal: _inExpanded(find.byType(Image)));
  }),

  // Trash: confirm dialogs, then the empty state.
  AlignScenario('trash:confirm-purge', (d) => Routes.trash(d.worldId),
      (tester, d) =>
          _tap(tester, find.byIcon(Icons.delete_forever_outlined).first)),
  AlignScenario('trash:confirm-empty', (d) => Routes.trash(d.worldId),
      (tester, d) => _tap(tester, find.byIcon(Icons.delete_sweep_outlined))),
  // Restores one of the two demo entries: the restore snackbar.
  AlignScenario('trash:restored', (d) => Routes.trash(d.worldId),
      (tester, d) async {
    await _tap(tester, find.byIcon(Icons.restore_from_trash_outlined).first);
    await _awaitSnackBar(tester);
  }),
  // Empties the demo trash for good: keep it after every other trash
  // screen.
  AlignScenario('trash:empty', (d) => Routes.trash(d.worldId),
      (tester, d) async {
    await _tap(tester, find.byIcon(Icons.delete_sweep_outlined));
    await _tap(
        tester,
        find.descendant(
            of: find.byType(AlertDialog), matching: find.byType(FilledButton)));
    await settleVisual(tester, 6);
  }),

  // The scenarios below leave recents, a saved backup and collapsed
  // sidebar sections in the demo world, so they come after the rest.

  // Idle search with recently opened entries under the quick actions.
  AlignScenario('search:recents', (d) => Routes.search(d.worldId),
      (tester, d) async {
    final search = _container(tester).read(searchRepositoryProvider);
    for (final name in [
      'Ravenport',
      'Curse of the Amber Throne',
      'Wren Six-Fingers',
    ]) {
      // The database completes on the test's clock: settle, don't await.
      unawaited(search.recordOpened(d.byName[name]!.id));
      await settleVisual(tester, 2);
    }
    await settleVisual(tester, 4);
  }),
  // Pause menu > Save project: the saved snackbar over the page.
  AlignScenario('shell:pause-saved', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _shortcut(tester, LogicalKeyboardKey.escape);
    await _tap(
        tester,
        find.descendant(
            of: find.byType(Dialog),
            matching: find.byIcon(Icons.save_outlined)));
    await _awaitSnackBar(tester);
  }),
  // Sidebar with the WORLD and LIBRARY sections collapsed, at its end.
  AlignScenario('shell:sidebar-collapsed', (d) => Routes.home(d.worldId),
      (tester, d) async {
    final container = _container(tester);
    for (final group in ['worldKinds', 'libraryKinds']) {
      container
          .read(sidebarCollapsedProvider('${d.worldId}|$group').notifier)
          .toggle();
    }
    await settleVisual(tester, 4);
    await _sidebarToEnd(tester);
  }),

  // Navigation rail (tablet width). Resizes the window for the rest of
  // the variant, so it stays last.
  AlignScenario('shell:rail', (d) => Routes.search(d.worldId),
      (tester, d) async {
    tester.view.physicalSize =
        Size(800, tester.view.physicalSize.height);
    await settleVisual(tester, 6);
  }),
];
