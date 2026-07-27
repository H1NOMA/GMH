import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Browser-style workspace tabs shown above the content area on wide
/// layouts. Semantics:
///
///  * clicking a sidebar destination opens it in a NEW tab (the current
///    tab keeps its page) — unless some tab already shows exactly that
///    location, which is activated instead;
///  * navigation inside the content (cards, mentions, graph taps, the
///    back/forward history) stays in the ACTIVE tab;
///  * "+" opens a fresh tab on the world dashboard;
///  * closing the last tab resets it to the dashboard.
///
/// Tabs are session-scoped: the persisted last-location still reopens the
/// active page after a restart.
class WorkspaceTabsState {
  final List<String> locations;
  final int activeIndex;

  const WorkspaceTabsState({
    this.locations = const [],
    this.activeIndex = 0,
  });

  String? get activeLocation =>
      activeIndex >= 0 && activeIndex < locations.length
          ? locations[activeIndex]
          : null;
}

class WorkspaceTabs extends Notifier<WorkspaceTabsState> {
  /// Wired by the app root to `router.go`.
  void Function(String location)? navigate;

  @override
  WorkspaceTabsState build() => const WorkspaceTabsState();

  /// Router callback: the active tab follows in-content navigation.
  /// The very first location creates the initial tab.
  void onLocationChanged(String location) {
    if (state.locations.isEmpty) {
      state = WorkspaceTabsState(locations: [location], activeIndex: 0);
      return;
    }
    if (state.activeLocation == location) return;
    final locations = List.of(state.locations);
    locations[state.activeIndex] = location;
    state = WorkspaceTabsState(
        locations: locations, activeIndex: state.activeIndex);
  }

  /// Sidebar destinations: open in a new tab, keeping the current one.
  /// An existing tab with the same location is activated instead of
  /// spawning a duplicate.
  void openInNewTab(String location) {
    if (state.activeLocation == location) return;
    final existing = state.locations.indexOf(location);
    if (existing != -1) {
      activate(existing);
      return;
    }
    final locations = List.of(state.locations)..add(location);
    state = WorkspaceTabsState(
        locations: locations, activeIndex: locations.length - 1);
    navigate?.call(location);
  }

  void activate(int index) {
    if (index < 0 || index >= state.locations.length) return;
    if (index == state.activeIndex) return;
    state = WorkspaceTabsState(
        locations: state.locations, activeIndex: index);
    navigate?.call(state.locations[index]);
  }

  /// Closes a tab. The last remaining tab is reset to [fallbackLocation]
  /// (the dashboard) instead of disappearing.
  void close(int index, {required String fallbackLocation}) {
    if (index < 0 || index >= state.locations.length) return;
    if (state.locations.length == 1) {
      state =
          WorkspaceTabsState(locations: [fallbackLocation], activeIndex: 0);
      navigate?.call(fallbackLocation);
      return;
    }
    final locations = List.of(state.locations)..removeAt(index);
    var active = state.activeIndex;
    final closedActive = index == state.activeIndex;
    if (index < active || active >= locations.length) active -= 1;
    if (active < 0) active = 0;
    state = WorkspaceTabsState(locations: locations, activeIndex: active);
    if (closedActive) navigate?.call(locations[active]);
  }
}

final workspaceTabsProvider =
    NotifierProvider<WorkspaceTabs, WorkspaceTabsState>(WorkspaceTabs.new);
