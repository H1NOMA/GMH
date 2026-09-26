import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/entity_template.dart';
import 'package:gmh/features/campaigns/campaigns_screen.dart';
import 'package:gmh/features/home/home_screen.dart';
import 'package:gmh/features/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';

import '../../support/demo_world.dart';
import '../../support/visual_routes.dart';
import 'scenario.dart';

Future<void> _tap(WidgetTester tester, Finder finder,
    {int settle = 4, bool warnIfMissed = true}) async {
  await tester.ensureVisible(finder);
  await settleVisual(tester, 2);
  await tester.tap(finder, warnIfMissed: warnIfMissed);
  await settleVisual(tester, settle);
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await settleVisual(tester, 3);
}

/// Scrolls the first list inside [scope] until [finder] is built and on
/// screen: ListView children far below the fold do not exist until then.
Future<void> _scrollIn(WidgetTester tester, Finder scope, Finder finder) async {
  final scrollable =
      find.descendant(of: scope, matching: find.byType(Scrollable)).first;
  for (var i = 0; i < 40 && finder.evaluate().isEmpty; i++) {
    final position = tester.state<ScrollableState>(scrollable).position;
    position.jumpTo(
        (position.pixels + 200).clamp(0.0, position.maxScrollExtent));
    await tester.pump();
  }
  await _reveal(tester, finder);
}

Future<void> _scrollTo<T extends Widget>(WidgetTester tester, Finder finder) =>
    _scrollIn(tester, find.byType(T), finder);

/// Scrolls the screen's main list to its very end.
Future<void> _scrollToEnd<T extends Widget>(WidgetTester tester) async {
  final scrollable = find
      .descendant(of: find.byType(T), matching: find.byType(Scrollable))
      .first;
  // The extent grows as lazily built children get laid out.
  for (var i = 0; i < 6; i++) {
    final position = tester.state<ScrollableState>(scrollable).position;
    position.jumpTo(position.maxScrollExtent);
    await settleVisual(tester, 2);
  }
}

ProviderContainer _containerOf(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

// The demo database is shared by every screen of a variant, including
// other areas' scenarios that run after these. State added here is
// remembered per demo world and removed by the next scenario of this file.
final _scratchWorld = Expando<String>();
final _openedHere = Expando<List<String>>();

/// Runs a database write next to the live app. Awaiting it inside
/// runAsync would deadlock on the app's own queries, which only make
/// progress while the fake clock is pumped.
Future<T> _write<T>(WidgetTester tester, Future<T> Function() body) async {
  T? result;
  var done = false;
  Object? error;
  body().then((value) {
    result = value;
    done = true;
  }, onError: (Object e) {
    error = e;
    done = true;
  });
  for (var i = 0; i < 50 && !done; i++) {
    await settleVisual(tester, 1);
  }
  if (error != null) throw error!;
  if (!done) throw StateError('database write did not finish');
  return result as T;
}

Future<void> _cleanUp(WidgetTester tester, DemoWorld d) async {
  final scratch = _scratchWorld[d];
  final opened = _openedHere[d];
  if (scratch == null && opened == null) return;
  _scratchWorld[d] = null;
  _openedHere[d] = null;
  final container = _containerOf(tester);
  await _write(tester, () async {
    if (scratch != null) {
      await container.read(worldRepositoryProvider).deleteWorld(scratch);
    }
    for (final id in opened ?? const <String>[]) {
      await d.db.customStatement(
          'DELETE FROM recent_items WHERE entity_id = ?', [id]);
    }
  });
  await settleVisual(tester, 2);
}

/// Runs [act] on a clean demo world: whatever an earlier scenario of this
/// file added is gone first.
Future<void> Function(WidgetTester, DemoWorld) _clean(
        Future<void> Function(WidgetTester tester, DemoWorld d) act) =>
    (tester, d) async {
      await _cleanUp(tester, d);
      await act(tester, d);
    };

/// Opens [location] in a fresh world with no entries, sections, campaigns
/// or backups, for the empty states. [withCampaign] adds one campaign
/// that has no quests and no sessions.
Future<String> _openEmptyWorld(WidgetTester tester, DemoWorld d,
    String Function(String worldId) location,
    {bool withCampaign = false}) async {
  await _cleanUp(tester, d);
  final container = _containerOf(tester);
  final worldId = await _write(tester, () async {
    final world = await container
        .read(worldRepositoryProvider)
        .createWorld(name: 'Empty Reaches');
    if (withCampaign) {
      await container.read(entityServiceProvider).create(
          worldId: world.id,
          kind: EntityKind.campaign,
          name: 'The Quiet Road');
    }
    return world.id;
  });
  _scratchWorld[d] = worldId;
  GoRouter.of(tester.element(find.byType(Scaffold).first))
      .go(location(worldId));
  await settleVisual(tester, 6);
  return worldId;
}

/// Marks a few entries as opened, so the dashboard shows its Recent
/// section with cards of different heights side by side.
Future<void> _openSomeEntries(WidgetTester tester, DemoWorld d) async {
  await _cleanUp(tester, d);
  final ids = [
    for (final name in const [
      'Old Tom',
      'The Sunken Bell',
      'Seraphine the Ashen',
      'Tidecaller Trident',
      'Harbor Council',
    ])
      d.byName[name]!.id,
  ];
  _openedHere[d] = ids;
  final search = _containerOf(tester).read(searchRepositoryProvider);
  await _write(tester, () async {
    for (final id in ids) {
      await search.recordOpened(id);
    }
  });
  await settleVisual(tester, 4);
}

Finder _key(String key) => find.byKey(ValueKey(key));

/// The constructor opens over the category manager: act on the top one.
Finder get _topDialog => find.byType(Dialog).last;

Finder _dialogAction<T extends Widget>() => find
    .descendant(of: find.byType(AlertDialog), matching: find.byType(T))
    .last;

Future<void> _worldAction(WidgetTester tester, String action) async {
  await _tap(tester, find.byType(PopupMenuButton<String>).first);
  await _tap(tester, _key('world-action-$action'));
}

Future<void> _manageCategories(WidgetTester tester) async {
  await _scrollTo<HomeScreen>(tester, _key('home-manage-categories'));
  await _tap(tester, _key('home-manage-categories'));
}

Future<void> _editGuilds(WidgetTester tester, DemoWorld d) async {
  await _manageCategories(tester);
  await _tap(tester, _key('category-edit-${d.guildCategoryId}'));
}

Future<void> _openAddField(WidgetTester tester) async {
  await _scrollIn(tester, _topDialog, _key('constructor-add-field'));
  await _tap(tester, _key('constructor-add-field'));
}

/// Adds a select field through the field dialog, so the constructor shows
/// a field row with its drag handle and edit / delete buttons.
Future<void> _addSelectField(WidgetTester tester) async {
  await _openAddField(tester);
  await tester.enterText(
      find.descendant(
          of: find.byType(AlertDialog), matching: find.byType(TextField)),
      'Guild hall');
  await settleVisual(tester, 3);
  await _pickSelectType(tester);
  await _tap(tester, _dialogAction<FilledButton>());
}

/// Switches the field dialog's type to "select", which adds the options
/// field. The tap lands on the menu item's ink well rather than on the
/// item's own box, which flutter_test would report as a miss.
Future<void> _pickSelectType(WidgetTester tester) async {
  await _tap(tester, _key('field-type'));
  await _tap(
      tester,
      find
          .byWidgetPredicate((w) =>
              w is DropdownMenuItem<FieldType> && w.value == FieldType.select)
          .last,
      warnIfMissed: false);
}

Future<void> _kindFields(WidgetTester tester) => _tap(
    tester,
    find.descendant(
        of: find.byType(AppBar), matching: find.byIcon(Icons.tune)));

/// Writes a real backup of the demo world, then reopens Settings so its
/// backup list (read once on open) shows it with a Restore button.
Future<void> _makeBackup(WidgetTester tester, DemoWorld d) async {
  final context = tester.element(find.byType(SettingsScreen));
  final container = ProviderScope.containerOf(context);
  final router = GoRouter.of(context);
  await tester.runAsync(
      () => container.read(backupServiceProvider).backupNow(d.worldId));
  router.go(Routes.home(d.worldId));
  await settleVisual(tester, 4);
  router.go(Routes.settings(d.worldId));
  await settleVisual(tester, 6);
  await _scrollToEnd<SettingsScreen>(tester);
}

Finder get _restore => find.byWidgetPredicate((w) =>
    w is TextButton &&
    w.key is ValueKey<String> &&
    (w.key! as ValueKey<String>).value.startsWith('settings-restore-'));

final worldsScenarios = <AlignScenario>[
  for (final scenario in _scenarios)
    AlignScenario(scenario.name, scenario.location, _clean(scenario.act)),
];

final _scenarios = <AlignScenario>[
  // World picker.
  AlignScenario('worlds:new', (d) => Routes.worlds(),
      (tester, d) => _tap(tester, _key('worlds-create'))),
  AlignScenario('worlds:new-styles', (d) => Routes.worlds(),
      (tester, d) async {
    await _tap(tester, _key('worlds-create'));
    await _reveal(tester, find.byIcon(Icons.check_circle));
  }),
  AlignScenario('worlds:actions', (d) => Routes.worlds(),
      (tester, d) => _tap(tester, find.byType(PopupMenuButton<String>).first)),
  AlignScenario('worlds:edit', (d) => Routes.worlds(),
      (tester, d) => _worldAction(tester, 'edit')),
  AlignScenario('worlds:delete', (d) => Routes.worlds(),
      (tester, d) => _worldAction(tester, 'delete')),

  // Dashboard below the fold.
  AlignScenario('home:sections', (d) => Routes.home(d.worldId),
      (tester, d) =>
          _scrollTo<HomeScreen>(tester, _key('home-manage-categories'))),
  AlignScenario('home:recent', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _openSomeEntries(tester, d);
    await _scrollToEnd<HomeScreen>(tester);
  }),

  // Manage categories and the section constructor.
  AlignScenario('categories:manage', (d) => Routes.home(d.worldId),
      (tester, d) => _manageCategories(tester)),
  AlignScenario('categories:new', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _manageCategories(tester);
    await _tap(tester, _key('categories-new'));
  }),
  AlignScenario('categories:edit', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _editGuilds(tester, d);
    await _scrollIn(tester, _topDialog, _key('constructor-add-field'));
  }),
  AlignScenario('categories:add-field', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _editGuilds(tester, d);
    await _openAddField(tester);
  }),
  AlignScenario('categories:add-select', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _editGuilds(tester, d);
    await _openAddField(tester);
    await _pickSelectType(tester);
  }),
  AlignScenario('categories:fields', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _editGuilds(tester, d);
    await _addSelectField(tester);
    await _reveal(
        tester,
        find.descendant(
            of: _topDialog, matching: find.byIcon(Icons.drag_indicator)));
  }),
  AlignScenario('categories:delete', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _manageCategories(tester);
    await _tap(tester, _key('category-delete-${d.guildCategoryId}'));
  }),
  AlignScenario('categories:kind-fields',
      (d) => Routes.browse(d.worldId, EntityKind.character),
      (tester, d) => _kindFields(tester)),
  AlignScenario('categories:kind-fields-list',
      (d) => Routes.browse(d.worldId, EntityKind.character),
      (tester, d) async {
    await _kindFields(tester);
    await _addSelectField(tester);
  }),

  // Campaigns.
  AlignScenario('campaigns:switcher', (d) => Routes.campaigns(d.worldId),
      (tester, d) => _tap(tester, _key('campaign-switcher'))),
  AlignScenario('campaigns:sessions', (d) => Routes.campaigns(d.worldId),
      (tester, d) =>
          _scrollTo<CampaignsScreen>(tester, _key('campaigns-new-session'))),

  // Empty states, in a world with nothing in it.
  AlignScenario('home:empty', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _openEmptyWorld(tester, d, Routes.home);
    await _scrollTo<HomeScreen>(tester, _key('home-manage-categories'));
  }),
  AlignScenario('categories:manage-empty', (d) => Routes.home(d.worldId),
      (tester, d) async {
    await _openEmptyWorld(tester, d, Routes.home);
    await _manageCategories(tester);
  }),
  AlignScenario('campaigns:empty', (d) => Routes.campaigns(d.worldId),
      (tester, d) => _openEmptyWorld(tester, d, Routes.campaigns)),
  AlignScenario('campaigns:empty-campaign', (d) => Routes.campaigns(d.worldId),
      (tester, d) async {
    await _openEmptyWorld(tester, d, Routes.campaigns, withCampaign: true);
    await _scrollTo<CampaignsScreen>(tester, _key('campaigns-new-session'));
  }),
  AlignScenario('settings:no-backups', (d) => Routes.settings(d.worldId),
      (tester, d) async {
    await _openEmptyWorld(tester, d, Routes.settings);
    await _scrollTo<SettingsScreen>(tester, _key('settings-backup-now'));
  }),

  // Settings.
  AlignScenario('settings:world-editor', (d) => Routes.settings(d.worldId),
      (tester, d) => _tap(tester, _key('settings-edit-world'))),
  AlignScenario('settings:export', (d) => Routes.settings(d.worldId),
      (tester, d) =>
          _scrollTo<SettingsScreen>(tester, _key('settings-export-pdf'))),
  AlignScenario('settings:export-pdf', (d) => Routes.settings(d.worldId),
      (tester, d) async {
    await _scrollTo<SettingsScreen>(tester, _key('settings-export-pdf'));
    await _tap(tester, _key('settings-export-pdf'));
  }),
  AlignScenario('settings:backups', (d) => Routes.settings(d.worldId),
      (tester, d) async {
    await _makeBackup(tester, d);
    await _reveal(tester, _restore.first);
  }),
  AlignScenario('settings:backup-section', (d) => Routes.settings(d.worldId),
      (tester, d) =>
          _scrollTo<SettingsScreen>(tester, _key('settings-backup-now'))),
  AlignScenario('settings:restore', (d) => Routes.settings(d.worldId),
      (tester, d) async {
    await _makeBackup(tester, d);
    await _reveal(tester, _restore.first);
    await _tap(tester, _restore.first);
  }),
  AlignScenario('settings:about', (d) => Routes.settings(d.worldId),
      (tester, d) => _scrollToEnd<SettingsScreen>(tester)),
];
