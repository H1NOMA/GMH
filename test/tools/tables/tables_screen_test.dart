import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/app.dart';
import 'package:gmh/app/locale_provider.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme_provider.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/domain/tables/random_table.dart';
import 'package:gmh/features/tools/dice/dice_providers.dart';
import 'package:gmh/features/tools/tables/tables_actions.dart';

import '../../support/demo_world.dart';
import '../dice/scripted_random.dart';

/// Drift streams resolve on real async, so plain pumpAndSettle would spin
/// forever — pump with short real-time gaps instead.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump(const Duration(milliseconds: 60));
  }
}

class _Harness {
  final ProviderContainer container;
  final String worldId;
  _Harness(this.container, this.worldId);

  Future<List<RandomTable>> tables(WidgetTester tester) async =>
      (await tester.runAsync(() => container
              .read(worldObjectRepositoryProvider)
              .list(worldId, WorldObjectTypes.randomTable)))!
          .map(RandomTable.fromObject)
          .toList();
}

Future<_Harness> _pumpApp(
  WidgetTester tester, {
  required String Function(String worldId) location,
  required Random random,
  Future<void> Function(ProviderContainer c, String worldId)? seed,
  Locale locale = const Locale('en'),
  ThemeMode theme = ThemeMode.dark,
  WorldStyle style = WorldStyle.fantasy,
}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final dir = Directory.systemTemp.createTempSync('gmh_tables_');
  final db = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(overrides: [
    appRootDirProvider.overrideWithValue(dir.path),
    databaseProvider.overrideWithValue(db),
    mediaVaultProvider.overrideWithValue(MediaVault(dir.path)),
    diceRandomProvider.overrideWithValue(random),
  ]);
  container.read(localeControllerProvider.notifier).seed(locale);
  container.read(themeModeProvider.notifier).seed(theme);
  final worldId = (await tester.runAsync(() async {
    final world = await container
        .read(worldRepositoryProvider)
        .createWorld(name: 'Testland', style: style);
    await seed?.call(container, world.id);
    return world.id;
  }))!;
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: GmhApp(initialLocation: location(worldId)),
  ));
  await _settle(tester);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    await tester.runAsync(() async {
      container.dispose();
      await db.close();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });
  });
  return _Harness(container, worldId);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await _settle(tester);
}

Future<void> _enter(WidgetTester tester, String key, String text) async {
  await tester.enterText(find.byKey(ValueKey(key)), text);
  await tester.pump();
}

Future<RandomTable> _seedTable(ProviderContainer c, String worldId,
        RandomTable table) =>
    c.read(tablesActionsProvider).create(worldId, table);

void _useSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('create a table, import rows as text, roll, edit and delete',
      (tester) async {
    _useSize(tester, const Size(1400, 1000));
    final random = ScriptedRandom([
      2, 1, // 1d6 → 3 (Rain), {1d4} → 2
      5, // roll again: 1d6 → 6 (Fog)
    ]);
    final h = await _pumpApp(tester,
        random: random, location: (w) => Routes.tool(w, 'tables'));

    // Empty state → new table.
    expect(find.text('No random tables yet'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('tables-new')));
    await _enter(tester, 'tables-name-field', 'Weather');
    await _enter(tester, 'tables-formula-field', '1d6');
    await _enter(tester, 'tables-folder-field', 'Travel');
    await _tap(tester, find.widgetWithText(FilledButton, 'Create'));
    var tables = await h.tables(tester);
    expect(tables.single.name, 'Weather');
    expect(tables.single.formula, '1d6');
    expect(tables.single.folder, 'Travel');
    final id = tables.single.id;
    expect(find.byKey(const ValueKey('tables-title')), findsOneWidget);
    expect(find.byKey(const ValueKey('tables-rows-empty')), findsOneWidget);

    // Bulk edit with the text format.
    await _tap(tester, find.byKey(const ValueKey('tables-bulk-edit')));
    await _enter(tester, 'tables-text-field',
        '# weather\n1-2 | Sun\n3–4 Rain for {1d4} hours\n5-6: Fog');
    expect(find.text('3 rows found'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('tables-text-confirm')));
    tables = await h.tables(tester);
    expect(tables.single.rows, const [
      RandomTableRow('Sun', from: 1, to: 2),
      RandomTableRow('Rain for {1d4} hours', from: 3, to: 4),
      RandomTableRow('Fog', from: 5, to: 6),
    ]);
    expect(find.byKey(const ValueKey('tables-row-text-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('tables-issues')), findsNothing);

    // Roll: the formula total picks the row, inline dice expand.
    await _tap(tester, find.byKey(const ValueKey('tables-roll')));
    expect(find.text('Rain for 2 hours'), findsOneWidget);
    expect(find.text('1d6 → 3'), findsOneWidget);
    expect(find.textContaining('{1d4} = 2'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('tables-roll-again')));
    expect(find.text('Fog'), findsWidgets);
    expect(find.text('1d6 → 6'), findsOneWidget);
    // The earlier roll moved to the log.
    expect(find.text('Rain for 2 hours'), findsOneWidget);
    expect(random.remaining, 0);
    await _tap(tester, find.byKey(const ValueKey('tables-clear-log')));
    expect(find.text('Roll to get a result.'), findsOneWidget);

    // Typing into a row is saved (debounced).
    await _enter(tester, 'tables-row-text-2', 'Thick fog');
    await _settle(tester);
    expect((await h.tables(tester)).single.rows[2].text, 'Thick fog');

    // A new row has no range until auto ranges spreads the die again.
    await _tap(tester, find.byKey(const ValueKey('tables-add-row')));
    await _enter(tester, 'tables-row-text-3', 'Snow');
    await _settle(tester);
    expect(find.text('Row 4 has no range.'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('tables-auto-ranges')));
    tables = await h.tables(tester);
    expect([for (final r in tables.single.rows) (r.from, r.to, r.text)], [
      (1, 2, 'Sun'),
      (3, 4, 'Rain for {1d4} hours'),
      (5, 5, 'Thick fog'),
      (6, 6, 'Snow'),
    ]);
    expect(find.byKey(const ValueKey('tables-issues')), findsNothing);
    expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('tables-row-from-3')))
            .controller!
            .text,
        '6');

    // Delete a row.
    await _tap(tester, find.byKey(const ValueKey('tables-row-delete-0')));
    tables = await h.tables(tester);
    expect([for (final r in tables.single.rows) r.text],
        ['Rain for {1d4} hours', 'Thick fog', 'Snow']);
    expect(find.textContaining('Nothing covers 1–2'), findsOneWidget);

    // Edit details through the dialog.
    await _tap(tester, find.byKey(const ValueKey('tables-edit-details')));
    await _enter(tester, 'tables-name-field', 'Mountain weather');
    await _enter(tester, 'tables-description-field', 'Up in the pass');
    await _tap(tester, find.widgetWithText(FilledButton, 'Save'));
    tables = await h.tables(tester);
    expect(tables.single.name, 'Mountain weather');
    expect(tables.single.description, 'Up in the pass');
    expect(find.text('Up in the pass'), findsOneWidget);

    // Duplicate, then delete the original from its page.
    await _tap(tester, find.byKey(ValueKey('tables-menu-$id')));
    await _tap(tester, find.text('Duplicate'));
    tables = await h.tables(tester);
    expect(tables, hasLength(2));
    final copy = tables.firstWhere((t) => t.id != id);
    expect(copy.name, 'Mountain weather (copy)');
    expect(copy.rows, tables.firstWhere((t) => t.id == id).rows);
    expect(copy.source, RandomTableSource.user);

    await _tap(tester, find.byKey(const ValueKey('tables-back')));
    expect(find.byKey(ValueKey('tables-card-$id')), findsOneWidget);
    expect(find.text('TRAVEL'), findsOneWidget);
    await _tap(tester, find.byKey(ValueKey('tables-card-$id')));
    await _tap(tester, find.byKey(ValueKey('tables-menu-$id')));
    await _tap(tester, find.text('Delete'));
    await _tap(tester, find.byKey(const ValueKey('tables-delete-confirm')));
    tables = await h.tables(tester);
    expect([for (final t in tables) t.id], [copy.id]);
    expect(find.byKey(ValueKey('tables-card-${copy.id}')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('import a table from text, search and roll nested tables',
      (tester) async {
    _useSize(tester, const Size(1280, 800));
    final random = ScriptedRandom([
      1, // weights 1+2+1: value 1 → "Merchant [[Quirks]]"
      0, // Quirks (1 row)
      1, // {red|blue} → blue
    ]);
    final h = await _pumpApp(
      tester,
      random: random,
      location: (w) => Routes.tool(w, 'tables'),
      seed: (c, worldId) => _seedTable(
          c,
          worldId,
          const RandomTable(
              name: 'Quirks',
              folder: 'People',
              rows: [RandomTableRow('wears a {red|blue} hat')])),
    );

    await _tap(tester, find.byKey(const ValueKey('tables-import')));
    await _enter(tester, 'tables-import-name', 'Market');
    await _enter(tester, 'tables-text-field',
        'Pickpocket\nx2 Merchant [[Quirks]]\n\nStray dog');
    expect(find.text('3 rows found'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('tables-text-confirm')));
    final market =
        (await h.tables(tester)).firstWhere((t) => t.name == 'Market');
    expect(market.formula, isEmpty);
    expect([for (final r in market.rows) r.weight], [1, 2, 1]);
    expect(find.text('By weight'), findsWidgets);
    expect(find.byKey(const ValueKey('tables-row-weight-1')), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('tables-roll')));
    expect(find.text('Merchant wears a blue hat'), findsOneWidget);
    // The tree explains the nested roll.
    expect(find.textContaining('Quirks'), findsWidgets);
    expect(find.text('How it was rolled'.toUpperCase()), findsOneWidget);

    // Back to the list: folders and search.
    await _tap(tester, find.byKey(const ValueKey('tables-back')));
    expect(find.text('PEOPLE'), findsOneWidget);
    expect(find.text('OTHER TABLES'), findsOneWidget);
    await _enter(tester, 'tables-search', 'mark');
    expect(find.byKey(ValueKey('tables-card-${market.id}')), findsOneWidget);
    expect(find.text('Quirks'), findsNothing);
    await _enter(tester, 'tables-search', 'zzz');
    expect(find.text('No tables match your search.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('add library tables to the world with their references',
      (tester) async {
    _useSize(tester, const Size(1280, 900));
    final h = await _pumpApp(tester,
        random: Random(3), location: (w) => Routes.tool(w, 'tables'));

    await _tap(tester, find.byKey(const ValueKey('tables-empty-library')));
    expect(find.text('Table library'), findsWidgets);
    expect(find.byKey(const ValueKey('tables-lib-fantasy.tavern_rumors')),
        findsOneWidget);
    // Other packs are grouped and collapsed.
    expect(find.byKey(const ValueKey('tables-lib-wuxia.manuals')),
        findsNothing);

    // Tavern rumors reference road encounters, which reference three more.
    await _tap(tester,
        find.byKey(const ValueKey('tables-lib-add-fantasy.tavern_rumors')));
    expect(find.text('Add the referenced tables too?'), findsOneWidget);
    expect(find.byKey(const ValueKey('tables-dep-fantasy.road_encounters')),
        findsOneWidget);
    await _tap(
        tester, find.byKey(const ValueKey('tables-dep-fantasy.weather')));
    await _tap(tester, find.byKey(const ValueKey('tables-deps-confirm')));
    var tables = await h.tables(tester);
    expect({for (final t in tables) t.source}, {
      'library:fantasy.tavern_rumors',
      'library:fantasy.road_encounters',
      'library:fantasy.treasure',
      'library:fantasy.quirks',
    });
    final rumors = tables.firstWhere((t) => t.name == 'Tavern Rumors');
    expect(rumors.formula, '1d10');
    expect(rumors.folder, 'Rumors & hooks');
    expect(rumors.rows, hasLength(10));
    expect(rumors.rows.first.from, 1);
    expect(rumors.rows.last.to, 10);
    expect(find.text('Added 4 tables'), findsOneWidget);
    expect(
        find.byKey(
            const ValueKey('tables-lib-in-world-fantasy.tavern_rumors')),
        findsOneWidget);

    // Weather only references tables already in the world: no question.
    await _tap(
        tester, find.byKey(const ValueKey('tables-lib-add-fantasy.weather')));
    expect(find.text('Add the referenced tables too?'), findsNothing);
    tables = await h.tables(tester);
    expect(tables, hasLength(5));

    // Preview a table of another pack and try a roll.
    await _tap(
        tester, find.byKey(const ValueKey('tables-pack-cyberpunk-false')));
    await _tap(tester,
        find.byKey(const ValueKey('tables-lib-preview-cyberpunk.corp_rumors')));
    expect(find.text('Corp Rumors'), findsWidgets);
    await _tap(tester, find.byKey(const ValueKey('tables-preview-roll')));
    expect(find.byKey(const ValueKey('tables-result-text')), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('tables-preview-add')));
    // Its street encounters and their references are offered too.
    await _tap(tester, find.byKey(const ValueKey('tables-deps-confirm')));
    tables = await h.tables(tester);
    expect(
        {for (final t in tables) t.source}
            .where((s) => s.startsWith('library:cyberpunk.')),
        {
          'library:cyberpunk.corp_rumors',
          'library:cyberpunk.street_encounters',
          'library:cyberpunk.loot',
          'library:cyberpunk.complications',
          'library:cyberpunk.quirks',
        });
    expect(tester.takeException(), isNull);
  });

  testWidgets('library tables follow the UI language and world pack',
      (tester) async {
    _useSize(tester, const Size(1280, 900));
    final h = await _pumpApp(tester,
        random: Random(1),
        locale: const Locale('de'),
        style: WorldStyle.wuxia,
        location: (w) => Routes.tool(w, 'tables', tablesLibraryObjectId));
    // The world's own pack is expanded first.
    expect(find.byKey(const ValueKey('tables-lib-wuxia.manuals')),
        findsOneWidget);
    await _tap(
        tester, find.byKey(const ValueKey('tables-lib-add-wuxia.manuals')));
    final table = (await h.tables(tester)).single;
    expect(table.name, 'Kampfkunst-Handbücher');
    expect(table.source, 'library:wuxia.manuals');
  });

  testWidgets('a missing table shows a way back', (tester) async {
    _useSize(tester, const Size(1280, 720));
    await _pumpApp(tester,
        random: Random(1), location: (w) => Routes.tool(w, 'tables', 'nope'));
    expect(find.text('This table no longer exists.'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'All tables'));
    expect(find.text('No random tables yet'), findsOneWidget);
  });

  // Layout: table page with a result, the list and the library, from phone
  // to 1440p, long locales and raised text scale.
  final variants = <(String, Size, Locale, double, ThemeMode)>[
    ('phone de x1.3', const Size(400, 780), const Locale('de'), 1.3,
        ThemeMode.dark),
    ('phone fr light', const Size(400, 600), const Locale('fr'), 1.0,
        ThemeMode.light),
    ('900x600 ru x1.3', const Size(900, 600), const Locale('ru'), 1.3,
        ThemeMode.dark),
    ('1280x720 zh', const Size(1280, 720), const Locale('zh'), 1.0,
        ThemeMode.light),
    ('2560x1440 en', const Size(2560, 1440), const Locale('en'), 1.0,
        ThemeMode.dark),
  ];
  for (final (name, size, locale, scale, theme) in variants) {
    testWidgets('layout · $name', (tester) async {
      _useSize(tester, size);
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await loadRealFonts(tester);

      final problems = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (details) =>
          problems.add(details.exceptionAsString().split('\n').first);
      addTearDown(() => FlutterError.onError = previous);

      late String tableId;
      await _pumpApp(
        tester,
        random: Random(7),
        locale: locale,
        theme: theme,
        location: (w) => Routes.tool(w, 'tables', tableId),
        seed: (c, worldId) async {
          await _seedTable(
              c,
              worldId,
              const RandomTable(
                  name: 'Unbelievably long complication table name',
                  rows: [RandomTableRow('bad {luck|weather} for {1d4} days')]));
          final t = await _seedTable(
            c,
            worldId,
            RandomTable(
              name: 'The extraordinarily long table of wilderness encounters',
              description: 'A very long description ' * 6,
              folder: 'Encounters in the far northern wilderness',
              formula: '1d20',
              rows: [
                for (var i = 0; i < 12; i++)
                  RandomTableRow(
                      'Encounter number $i with a rather verbose text and '
                      '{2d6} wolves, then [[Unbelievably long complication '
                      'table name]] and [[Missing table]]',
                      from: i + 1,
                      to: i + 1),
              ],
            ),
          );
          tableId = t.id;
        },
      );
      expect(find.byKey(const ValueKey('tables-title')), findsOneWidget);
      await _tap(tester, find.byKey(const ValueKey('tables-roll')));
      await _tap(tester, find.byKey(const ValueKey('tables-roll-again')));
      expect(find.byKey(const ValueKey('tables-result-text')), findsOneWidget);
      expect(find.byKey(const ValueKey('tables-issues')), findsOneWidget);
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, -3000));
        await _settle(tester);
      }

      await _tap(tester, find.byKey(const ValueKey('tables-back')));
      expect(find.byKey(const ValueKey('tables-search')), findsOneWidget);
      await _tap(tester, find.byKey(const ValueKey('tables-open-library')));
      expect(find.byKey(const ValueKey('tables-library-search')),
          findsOneWidget);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
      await _settle(tester);
      expect(tester.takeException(), isNull);
      expect(problems, isEmpty, reason: problems.join('\n'));
    });
  }
}
