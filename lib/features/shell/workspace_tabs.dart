import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Browser-style workspace tabs shown above the content area on wide
/// layouts. Semantics:
///
///  * clicking a sidebar destination opens it in a NEW tab (the current
///    tab keeps its page) — always a fresh, independent tab, so the same
///    section can be open many times with different entries in each;
///  * navigation inside the content (cards, mentions, graph taps) stays
///    in the ACTIVE tab;
///  * every tab carries its OWN back/forward history — Back never jumps
///    a tab to a page that was visited in a different tab;
///  * switching worlds resets the strip: tabs from another world would
///    silently teleport the user back, so they are closed instead;
///  * the world picker and other non-world routes are not tabbable and
///    leave the strip untouched;
///  * "+" opens a fresh tab on the world dashboard;
///  * closing the last tab resets it to the dashboard.
///
/// Tabs are session-scoped: the persisted last-location still reopens the
/// active page after a restart.
class WorkspaceTab {
  final String location;
  final List<String> back;
  final List<String> forward;

  const WorkspaceTab(
    this.location, {
    this.back = const [],
    this.forward = const [],
  });
}

class WorkspaceTabsState {
  final List<WorkspaceTab> tabs;
  final int activeIndex;

  const WorkspaceTabsState({this.tabs = const [], this.activeIndex = 0});

  List<String> get locations => [for (final t in tabs) t.location];

  WorkspaceTab? get active =>
      activeIndex >= 0 && activeIndex < tabs.length ? tabs[activeIndex] : null;

  String? get activeLocation => active?.location;

  bool get canGoBack => active?.back.isNotEmpty ?? false;
  bool get canGoForward => active?.forward.isNotEmpty ?? false;
}

class WorkspaceTabs extends Notifier<WorkspaceTabsState> {
  /// Wired by the app root to `router.go`.
  void Function(String location)? navigate;

  @override
  WorkspaceTabsState build() => const WorkspaceTabsState();

  static String? _worldOf(String location) =>
      RegExp(r'^/w/([^/]+)/').firstMatch(location)?.group(1);

  /// Router callback: the active tab follows in-content navigation and
  /// records it in the tab's own back stack.
  void onLocationChanged(String location) {
    // The world picker (and any other non-world route) is chrome, not
    // content — recording it would turn tabs into world-picker time bombs.
    if (_worldOf(location) == null) return;
    if (state.tabs.isEmpty) {
      state = WorkspaceTabsState(tabs: [WorkspaceTab(location)]);
      return;
    }
    // Tab state is always updated BEFORE navigate() fires, so the router
    // echo of our own goBack/goForward/activate lands here as an
    // already-current location and is not re-recorded.
    final current = state.activeLocation;
    if (current == location) return;
    // Entering a different world: every other tab still points into the
    // old world and would silently teleport back — start a clean strip.
    if (_worldOf(location) != _worldOf(current ?? '')) {
      state = WorkspaceTabsState(tabs: [WorkspaceTab(location)]);
      return;
    }
    final tabs = List.of(state.tabs);
    final active = tabs[state.activeIndex];
    tabs[state.activeIndex] = WorkspaceTab(
      location,
      back: [...active.back, active.location],
      // A brand-new navigation clears the forward stack, like a browser.
      forward: const [],
    );
    state = WorkspaceTabsState(tabs: tabs, activeIndex: state.activeIndex);
  }

  void goBack() {
    final active = state.active;
    if (active == null || active.back.isEmpty) return;
    final target = active.back.last;
    final tabs = List.of(state.tabs);
    tabs[state.activeIndex] = WorkspaceTab(
      target,
      back: active.back.sublist(0, active.back.length - 1),
      forward: [active.location, ...active.forward],
    );
    state = WorkspaceTabsState(tabs: tabs, activeIndex: state.activeIndex);
    navigate?.call(target);
  }

  void goForward() {
    final active = state.active;
    if (active == null || active.forward.isEmpty) return;
    final target = active.forward.first;
    final tabs = List.of(state.tabs);
    tabs[state.activeIndex] = WorkspaceTab(
      target,
      back: [...active.back, active.location],
      forward: active.forward.sublist(1),
    );
    state = WorkspaceTabsState(tabs: tabs, activeIndex: state.activeIndex);
    navigate?.call(target);
  }

  /// Sidebar destinations: open in a new tab, keeping the current one.
  /// Duplicates are deliberate — every tab is independent, so the same
  /// section can be open in ten tabs, each browsing its own entry.
  void openInNewTab(String location) {
    final tabs = List.of(state.tabs)..add(WorkspaceTab(location));
    state = WorkspaceTabsState(tabs: tabs, activeIndex: tabs.length - 1);
    navigate?.call(location);
  }

  void activate(int index) {
    if (index < 0 || index >= state.tabs.length) return;
    if (index == state.activeIndex) return;
    state = WorkspaceTabsState(tabs: state.tabs, activeIndex: index);
    navigate?.call(state.tabs[index].location);
  }

  /// Closes a tab. The last remaining tab is reset to [fallbackLocation]
  /// (the dashboard) instead of disappearing.
  void close(int index, {required String fallbackLocation}) {
    if (index < 0 || index >= state.tabs.length) return;
    if (state.tabs.length == 1) {
      state = WorkspaceTabsState(tabs: [WorkspaceTab(fallbackLocation)]);
      navigate?.call(fallbackLocation);
      return;
    }
    final tabs = List.of(state.tabs)..removeAt(index);
    var active = state.activeIndex;
    final closedActive = index == state.activeIndex;
    if (index < active || active >= tabs.length) active -= 1;
    if (active < 0) active = 0;
    state = WorkspaceTabsState(tabs: tabs, activeIndex: active);
    if (closedActive) navigate?.call(tabs[active].location);
  }

  /// Called after an entry is deleted: inactive tabs still pointing at it
  /// are closed (the active tab is navigated away by the caller), and the
  /// dead location is scrubbed from every tab's history stacks so Back
  /// can no longer resurrect it.
  void closeForLocation(String location) {
    if (state.tabs.isEmpty) return;
    final kept = <WorkspaceTab>[];
    var active = state.activeIndex;
    for (var i = 0; i < state.tabs.length; i++) {
      final tab = state.tabs[i];
      if (tab.location == location && i != state.activeIndex) {
        if (i < state.activeIndex) active -= 1;
        continue;
      }
      kept.add(
        WorkspaceTab(
          tab.location,
          back: [
            for (final l in tab.back)
              if (l != location) l,
          ],
          forward: [
            for (final l in tab.forward)
              if (l != location) l,
          ],
        ),
      );
    }
    if (active < 0) active = 0;
    if (active >= kept.length) active = kept.length - 1;
    state = WorkspaceTabsState(tabs: kept, activeIndex: active);
  }
}

final workspaceTabsProvider =
    NotifierProvider<WorkspaceTabs, WorkspaceTabsState>(WorkspaceTabs.new);
