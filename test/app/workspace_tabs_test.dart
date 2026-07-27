import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/features/shell/workspace_tabs.dart';

void main() {
  late ProviderContainer container;
  late WorkspaceTabs tabs;
  late List<String> visited;

  setUp(() {
    container = ProviderContainer();
    tabs = container.read(workspaceTabsProvider.notifier);
    visited = [];
    tabs.navigate = visited.add;
  });

  tearDown(() => container.dispose());

  WorkspaceTabsState state() => container.read(workspaceTabsProvider);

  test('first location creates the initial tab', () {
    tabs.onLocationChanged('/w/1/home');
    expect(state().locations, ['/w/1/home']);
    expect(state().activeIndex, 0);
    expect(visited, isEmpty);
  });

  test('in-content navigation stays in the active tab', () {
    tabs.onLocationChanged('/w/1/home');
    tabs.onLocationChanged('/w/1/e/abc');
    expect(state().locations, ['/w/1/e/abc']);
    expect(state().activeIndex, 0);
  });

  test('openInNewTab keeps the current tab and navigates', () {
    tabs.onLocationChanged('/w/1/e/abc');
    tabs.openInNewTab('/w/1/browse/creature');
    expect(state().locations, ['/w/1/e/abc', '/w/1/browse/creature']);
    expect(state().activeIndex, 1);
    expect(visited, ['/w/1/browse/creature']);

    // In-tab follow-up: picking a beast replaces the new tab's location,
    // the character tab stays untouched.
    tabs.onLocationChanged('/w/1/e/beast');
    expect(state().locations, ['/w/1/e/abc', '/w/1/e/beast']);
  });

  test('openInNewTab always spawns an independent duplicate', () {
    tabs.onLocationChanged('/w/1/home');
    tabs.openInNewTab('/w/1/browse/creature');
    tabs.openInNewTab('/w/1/browse/creature');
    expect(state().locations,
        ['/w/1/home', '/w/1/browse/creature', '/w/1/browse/creature']);
    expect(state().activeIndex, 2);

    // Each duplicate browses on its own: navigating in the newest tab
    // leaves its twin untouched.
    tabs.onLocationChanged('/w/1/e/beastB');
    tabs.activate(1);
    tabs.onLocationChanged('/w/1/e/beastA');
    expect(state().locations,
        ['/w/1/home', '/w/1/e/beastA', '/w/1/e/beastB']);
  });

  test('activate switches tabs and navigates', () {
    tabs.onLocationChanged('/w/1/home');
    tabs.openInNewTab('/w/1/search');
    tabs.activate(0);
    expect(state().activeIndex, 0);
    expect(visited.last, '/w/1/home');
  });

  test('closing tabs adjusts the active index and navigates as needed', () {
    tabs.onLocationChanged('/w/1/home');
    tabs.openInNewTab('/w/1/search');
    tabs.openInNewTab('/w/1/graph');

    // Close an inactive tab before the active one: index shifts left.
    tabs.close(0, fallbackLocation: '/w/1/home');
    expect(state().locations, ['/w/1/search', '/w/1/graph']);
    expect(state().activeIndex, 1);

    // Close the active tab: the neighbor becomes active and is opened.
    tabs.close(1, fallbackLocation: '/w/1/home');
    expect(state().locations, ['/w/1/search']);
    expect(state().activeIndex, 0);
    expect(visited.last, '/w/1/search');

    // Closing the last tab resets it to the fallback dashboard.
    tabs.close(0, fallbackLocation: '/w/1/home');
    expect(state().locations, ['/w/1/home']);
    expect(visited.last, '/w/1/home');
  });
}
