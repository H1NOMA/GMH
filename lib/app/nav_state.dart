import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/entity_kind.dart';
import '../domain/repositories/repositories.dart';
import 'providers.dart';

/// Navigation & UI state that must survive moving between sections — and,
/// where it makes sense, app restarts:
///
///  * browser-style back/forward history ([NavHistory]);
///  * the selected campaign (persisted per world);
///  * the last visited location (persisted; restored on startup);
///  * list sort order (persisted per world), list filters, search state and
///    profile tab (kept for the whole session);
///  * scroll positions via a shared [PageStorageBucket].

/// One shared bucket for the whole shell so scroll offsets and other
/// PageStorage values survive route changes (each `go` replaces the page,
/// so route-scoped buckets would be lost).
final appPageBucket = PageStorageBucket();

// ------------------------------------------------------------- history

class NavHistoryState {
  final List<String> back;
  final String? current;
  final List<String> forward;

  const NavHistoryState({
    this.back = const [],
    this.current,
    this.forward = const [],
  });

  bool get canGoBack => back.isNotEmpty;
  bool get canGoForward => forward.isNotEmpty;
}

/// Browser-like history over go_router locations. The router reports every
/// location change to [onLocationChanged]; [goBack]/[goForward] navigate via
/// the provided callback while suppressing history recording.
class NavHistory extends Notifier<NavHistoryState> {
  bool _suppress = false;

  /// Wired by the app root to `router.go`.
  void Function(String location)? navigate;

  @override
  NavHistoryState build() => const NavHistoryState();

  void onLocationChanged(String location) {
    if (state.current == location) {
      // The router echoing our own goBack/goForward navigation lands here;
      // the flag must clear or the next real navigation would be swallowed.
      _suppress = false;
      return;
    }
    if (_suppress) {
      _suppress = false;
      return;
    }
    state = NavHistoryState(
      back: [
        ...state.back,
        if (state.current != null) state.current!,
      ],
      current: location,
      // A brand-new navigation clears the forward stack, like a browser.
      forward: const [],
    );
  }

  void goBack() {
    if (!state.canGoBack) return;
    final target = state.back.last;
    state = NavHistoryState(
      back: state.back.sublist(0, state.back.length - 1),
      current: target,
      forward: [
        if (state.current != null) state.current!,
        ...state.forward,
      ],
    );
    _suppress = true;
    navigate?.call(target);
  }

  void goForward() {
    if (!state.canGoForward) return;
    final target = state.forward.first;
    state = NavHistoryState(
      back: [
        ...state.back,
        if (state.current != null) state.current!,
      ],
      current: target,
      forward: state.forward.sublist(1),
    );
    _suppress = true;
    navigate?.call(target);
  }
}

final navHistoryProvider =
    NotifierProvider<NavHistory, NavHistoryState>(NavHistory.new);

// -------------------------------------------------- selected campaign

/// The selected campaign per world. Persisted, so it survives navigating
/// away, and app restarts; only an explicit user choice changes it.
class CampaignSelection extends FamilyAsyncNotifier<String?, String> {
  String get _key => '${SettingsKeys.selectedCampaign}.$arg';

  @override
  Future<String?> build(String worldId) async {
    return ref.read(settingsRepositoryProvider).get(_key);
  }

  Future<void> select(String campaignId) async {
    // Let the initial load settle first, otherwise its completion would
    // overwrite the selection we set below.
    try {
      await future;
    } catch (_) {}
    await ref.read(settingsRepositoryProvider).set(_key, campaignId);
    state = AsyncData(campaignId);
  }
}

final selectedCampaignProvider =
    AsyncNotifierProvider.family<CampaignSelection, String?, String>(
        CampaignSelection.new);

// ---------------------------------------------------- last location

/// Records the current location (throttled by equality) so startup can
/// reopen exactly where the user left off.
Future<void> persistLastLocation(WidgetRef ref, String location) {
  return ref
      .read(settingsRepositoryProvider)
      .set(SettingsKeys.lastLocation, location);
}

// --------------------------------------------------- list preferences

/// Filter/sort state of one entity list, keyed by "worldId|scope" where
/// scope is a kind name or a category id. Sort order also persists across
/// restarts (per world); filters live for the session.
class ListPrefs {
  final EntitySort sort;
  final String? tagId;
  final bool favoritesOnly;
  final String filterText;

  /// Gallery grid vs. list; null = the section's default (the Concept
  /// Archive opens as a grid, everything else as a list). Persisted.
  final bool? gridView;

  const ListPrefs({
    this.sort = EntitySort.updatedDesc,
    this.tagId,
    this.favoritesOnly = false,
    this.filterText = '',
    this.gridView,
  });

  ListPrefs copyWith({
    EntitySort? sort,
    String? Function()? tagId,
    bool? favoritesOnly,
    String? filterText,
    bool? gridView,
  }) {
    return ListPrefs(
      sort: sort ?? this.sort,
      tagId: tagId != null ? tagId() : this.tagId,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      filterText: filterText ?? this.filterText,
      gridView: gridView ?? this.gridView,
    );
  }
}

class ListPrefsController extends FamilyNotifier<ListPrefs, String> {
  String get _worldId => arg.split('|').first;
  String get _sortKey => '${SettingsKeys.entitySort}.$_worldId';
  String get _viewKey => '${SettingsKeys.listViewMode}.$arg';

  @override
  ListPrefs build(String key) {
    // Sort order and view mode load asynchronously; defaults show meanwhile.
    Future.microtask(() async {
      final settings = ref.read(settingsRepositoryProvider);
      final saved = await settings.get(_sortKey);
      final sort = EntitySort.values
          .where((s) => s.name == saved)
          .firstOrNull;
      if (sort != null && state.sort != sort) {
        state = state.copyWith(sort: sort);
      }
      final view = await settings.get(_viewKey);
      if (view != null) {
        state = state.copyWith(gridView: view == 'grid');
      }
    });
    return const ListPrefs();
  }

  void setSort(EntitySort sort) {
    state = state.copyWith(sort: sort);
    ref.read(settingsRepositoryProvider).set(_sortKey, sort.name);
  }

  void setGridView(bool grid) {
    state = state.copyWith(gridView: grid);
    ref
        .read(settingsRepositoryProvider)
        .set(_viewKey, grid ? 'grid' : 'list');
  }

  void setTag(String? tagId) => state = state.copyWith(tagId: () => tagId);
  void setFavoritesOnly(bool value) =>
      state = state.copyWith(favoritesOnly: value);
  void setFilterText(String text) => state = state.copyWith(filterText: text);
}

final listPrefsProvider =
    NotifierProvider.family<ListPrefsController, ListPrefs, String>(
        ListPrefsController.new);

String listPrefsKey(String worldId,
        {EntityKind? kind, String? categoryId}) =>
    '$worldId|${categoryId ?? kind?.name ?? 'all'}';

// -------------------------------------------------------- search state

class SearchState {
  final String query;
  final EntityKind? kind;
  final String? categoryId;

  const SearchState({this.query = '', this.kind, this.categoryId});
}

/// The search screen's query and filters, kept per world for the session so
/// leaving and returning restores the exact search.
class SearchStateController extends FamilyNotifier<SearchState, String> {
  @override
  SearchState build(String worldId) => const SearchState();

  void update({String? query, EntityKind? kind, String? categoryId,
      bool clearKind = false, bool clearCategory = false}) {
    state = SearchState(
      query: query ?? state.query,
      kind: clearKind ? null : (kind ?? state.kind),
      categoryId: clearCategory ? null : (categoryId ?? state.categoryId),
    );
  }
}

final searchStateProvider =
    NotifierProvider.family<SearchStateController, SearchState, String>(
        SearchStateController.new);

// ------------------------------------------------- sidebar tab order

/// User-defined order of the sidebar tabs, one list per group
/// (`'<worldId>|nav'`, `'<worldId>|worldKinds'`, `'<worldId>|libraryKinds'`).
/// Reordered by long-press drag; persisted so it survives restarts.
class SidebarOrderController extends FamilyNotifier<List<String>, String> {
  String get _key =>
      '${SettingsKeys.sidebarOrder}.${arg.replaceAll('|', '.')}';

  @override
  List<String> build(String key) {
    Future.microtask(() async {
      final saved = await ref.read(settingsRepositoryProvider).get(_key);
      if (saved == null) return;
      try {
        final ids = (jsonDecode(saved) as List).cast<String>();
        if (ids.isNotEmpty) state = ids;
      } catch (_) {}
    });
    return const [];
  }

  void setOrder(List<String> ids) {
    state = ids;
    ref.read(settingsRepositoryProvider).set(_key, jsonEncode(ids));
  }
}

final sidebarOrderProvider =
    NotifierProvider.family<SidebarOrderController, List<String>, String>(
        SidebarOrderController.new);

/// Applies a saved order to the canonical id list: unknown saved ids are
/// dropped, new canonical ids are appended — so app updates that add tabs
/// keep working with an old saved order.
List<String> applySidebarOrder(
    List<String> canonical, List<String> saved) {
  if (saved.isEmpty) return canonical;
  final available = canonical.toSet();
  final ordered = [
    for (final id in saved)
      if (available.contains(id)) id
  ];
  for (final id in canonical) {
    if (!ordered.contains(id)) ordered.add(id);
  }
  return ordered;
}

// -------------------------------------------------- profile active tab

/// Active tab per character profile (session-scoped).
final profileTabProvider =
    NotifierProvider.family<ProfileTabController, int, String>(
        ProfileTabController.new);

class ProfileTabController extends FamilyNotifier<int, String> {
  @override
  int build(String entityId) => 0;

  void set(int index) => state = index;
}
