import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/nav_state.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/domain/repositories/repositories.dart';

import '../helpers.dart';

void main() {
  late TestHarness h;
  late ProviderContainer container;

  setUp(() async {
    h = await TestHarness.create();
    container = ProviderContainer(overrides: [
      settingsRepositoryProvider.overrideWithValue(h.settings),
    ]);
  });

  tearDown(() async {
    container.dispose();
    await h.dispose();
  });

  group('NavHistory', () {
    test('records locations and navigates back/forward like a browser', () {
      final history = container.read(navHistoryProvider.notifier);
      final visited = <String>[];
      history.navigate = visited.add;

      history.onLocationChanged('/w/1/home');
      history.onLocationChanged('/w/1/search');
      history.onLocationChanged('/w/1/campaigns');

      var state = container.read(navHistoryProvider);
      expect(state.current, '/w/1/campaigns');
      expect(state.back, ['/w/1/home', '/w/1/search']);
      expect(state.canGoBack, isTrue);
      expect(state.canGoForward, isFalse);

      history.goBack();
      state = container.read(navHistoryProvider);
      expect(visited, ['/w/1/search']);
      expect(state.current, '/w/1/search');
      expect(state.forward, ['/w/1/campaigns']);

      // The router echoes the location change; it must not re-record.
      history.onLocationChanged('/w/1/search');
      state = container.read(navHistoryProvider);
      expect(state.back, ['/w/1/home']);
      expect(state.forward, ['/w/1/campaigns']);

      history.goForward();
      state = container.read(navHistoryProvider);
      expect(visited, ['/w/1/search', '/w/1/campaigns']);
      expect(state.current, '/w/1/campaigns');
      expect(state.canGoForward, isFalse);
      expect(state.back, ['/w/1/home', '/w/1/search']);
    });

    test('a new navigation clears the forward stack', () {
      final history = container.read(navHistoryProvider.notifier);
      history.navigate = (_) {};

      history.onLocationChanged('/a');
      history.onLocationChanged('/b');
      history.goBack();
      history.onLocationChanged('/a');
      expect(container.read(navHistoryProvider).canGoForward, isTrue);

      history.onLocationChanged('/c');
      final state = container.read(navHistoryProvider);
      expect(state.current, '/c');
      expect(state.forward, isEmpty);
      expect(state.back, ['/a']);
    });

    test('goBack/goForward at the edges are no-ops', () {
      final history = container.read(navHistoryProvider.notifier);
      final visited = <String>[];
      history.navigate = visited.add;

      history.goBack();
      history.goForward();
      expect(visited, isEmpty);

      history.onLocationChanged('/only');
      history.goBack();
      history.goForward();
      expect(visited, isEmpty);
    });
  });

  group('CampaignSelection', () {
    test('persists per world and survives a fresh container (restart)',
        () async {
      await container
          .read(selectedCampaignProvider('w1').notifier)
          .select('camp-1');
      await container
          .read(selectedCampaignProvider('w2').notifier)
          .select('camp-9');

      expect(await container.read(selectedCampaignProvider('w1').future),
          'camp-1');
      expect(await container.read(selectedCampaignProvider('w2').future),
          'camp-9');

      // Simulate an app restart: a brand-new container over the same DB.
      final restarted = ProviderContainer(overrides: [
        settingsRepositoryProvider.overrideWithValue(h.settings),
      ]);
      expect(await restarted.read(selectedCampaignProvider('w1').future),
          'camp-1');
      expect(await restarted.read(selectedCampaignProvider('w2').future),
          'camp-9');
      restarted.dispose();
    });

    test('unset world has no selection', () async {
      expect(await container.read(selectedCampaignProvider('none').future),
          isNull);
    });
  });

  group('ListPrefs', () {
    test('sort persists per world and is restored after restart', () async {
      final key = listPrefsKey('w1', categoryId: null);
      container.read(listPrefsProvider(key).notifier)
        ..setSort(EntitySort.nameAsc)
        ..setFavoritesOnly(true)
        ..setFilterText('dragon');

      final prefs = container.read(listPrefsProvider(key));
      expect(prefs.sort, EntitySort.nameAsc);
      expect(prefs.favoritesOnly, isTrue);
      expect(prefs.filterText, 'dragon');

      // Restart: sort comes back from settings, filters reset by design.
      final restarted = ProviderContainer(overrides: [
        settingsRepositoryProvider.overrideWithValue(h.settings),
      ]);
      // Loading is async (microtask + DB read), so wait for it to land.
      restarted.read(listPrefsProvider(key));
      final deadline = DateTime.now().add(const Duration(seconds: 2));
      while (restarted.read(listPrefsProvider(key)).sort !=
              EntitySort.nameAsc &&
          DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      final reloaded = restarted.read(listPrefsProvider(key));
      expect(reloaded.sort, EntitySort.nameAsc);
      expect(reloaded.favoritesOnly, isFalse);
      expect(reloaded.filterText, isEmpty);
      restarted.dispose();
    });

    test('keys separate scopes within a world', () {
      expect(listPrefsKey('w1'), 'w1|all');
      expect(listPrefsKey('w1', categoryId: 'cat1'), 'w1|cat1');
    });
  });

  group('SearchState', () {
    test('query and filters live for the session per world', () {
      container
          .read(searchStateProvider('w1').notifier)
          .update(query: 'ancient sword');
      expect(container.read(searchStateProvider('w1')).query,
          'ancient sword');
      expect(container.read(searchStateProvider('w2')).query, isEmpty);

      container.read(searchStateProvider('w1').notifier).update(
          clearKind: true, clearCategory: true);
      expect(container.read(searchStateProvider('w1')).query,
          'ancient sword');
    });
  });

  group('Last location', () {
    test('is persisted under the well-known key', () async {
      await h.settings.set(SettingsKeys.lastLocation, '/w/1/campaigns');
      expect(await h.settings.get(SettingsKeys.lastLocation),
          '/w/1/campaigns');
    });
  });
}
