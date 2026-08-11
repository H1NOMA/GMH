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
    test('sort persists per section and is restored after restart', () async {
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

  group('SidebarOrder', () {
    test('drag order persists per group and survives restart', () async {
      const canonical = ['dashboard', 'search', 'graph', 'campaigns', 'tags'];
      final controller =
          container.read(sidebarOrderProvider('w1|nav').notifier);
      controller.setOrder(
          const ['search', 'dashboard', 'graph', 'campaigns', 'tags']);

      expect(
        applySidebarOrder(
            canonical, container.read(sidebarOrderProvider('w1|nav'))),
        ['search', 'dashboard', 'graph', 'campaigns', 'tags'],
      );

      // Restart: order loads back from settings.
      final restarted = ProviderContainer(overrides: [
        settingsRepositoryProvider.overrideWithValue(h.settings),
      ]);
      restarted.read(sidebarOrderProvider('w1|nav'));
      final deadline = DateTime.now().add(const Duration(seconds: 2));
      while (restarted.read(sidebarOrderProvider('w1|nav')).isEmpty &&
          DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(restarted.read(sidebarOrderProvider('w1|nav')).first, 'search');
      restarted.dispose();
    });

    test('saved order tolerates added and removed tabs', () {
      // A tab was removed ('x') and a new one shipped ('new').
      expect(
        applySidebarOrder(
            ['a', 'b', 'new'], ['b', 'x', 'a']),
        ['b', 'a', 'new'],
      );
      // No saved order -> canonical.
      expect(applySidebarOrder(['a', 'b'], []), ['a', 'b']);
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
