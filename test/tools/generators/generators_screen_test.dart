import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/app.dart';
import 'package:gmh/app/locale_provider.dart';
import 'package:gmh/app/packs/setting_packs.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/app/theme_provider.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/domain/generators/generator_engine.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/features/tools/generators/generators_screen.dart';
import 'package:gmh/features/tools/generators/generators_state.dart';

import '../../support/demo_world.dart';

/// Drift streams resolve on real async, so plain pumpAndSettle would spin
/// forever — pump with short real-time gaps instead.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(milliseconds: 60));
  }
}

class _Harness {
  final ProviderContainer container;
  final String worldId;
  _Harness(this.container, this.worldId);

  GeneratorsState get state => container.read(generatorsProvider(worldId));

  Future<List<Entity>> entities(WidgetTester tester) async =>
      (await tester.runAsync(
        () => container.read(entityRepositoryProvider).getAllEntities(worldId),
      ))!;
}

Future<_Harness> _pumpApp(
  WidgetTester tester, {
  int seed = 5,
  Locale locale = const Locale('en'),
  ThemeMode theme = ThemeMode.dark,
  WorldStyle style = WorldStyle.fantasy,
}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final dir = Directory.systemTemp.createTempSync('gmh_generators_');
  final db = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(
    overrides: [
      appRootDirProvider.overrideWithValue(dir.path),
      databaseProvider.overrideWithValue(db),
      mediaVaultProvider.overrideWithValue(MediaVault(dir.path)),
      generatorRandomProvider.overrideWithValue(Random(seed)),
    ],
  );
  container.read(localeControllerProvider.notifier).seed(locale);
  container.read(themeModeProvider.notifier).seed(theme);
  final worldId = (await tester.runAsync(() async {
    final world = await container
        .read(worldRepositoryProvider)
        .createWorld(name: 'Testland', style: style);
    return world.id;
  }))!;
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: GmhApp(initialLocation: Routes.tool(worldId, 'generators')),
    ),
  );
  await _settle(tester);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
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
  if (finder.evaluate().isEmpty) {
    // Lists build lazily: look above, then below.
    final results = find
        .descendant(
          of: find.byKey(const ValueKey('gen-results')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.drag(results, const Offset(0, 20000));
    await tester.pump();
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(finder, 300, scrollable: results);
    }
  }
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await _settle(tester);
}

Future<void> _tapKey(WidgetTester tester, String key) =>
    _tap(tester, find.byKey(ValueKey(key)));

void _useSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void _mockClipboard(WidgetTester tester, void Function(String?) onCopy) {
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'Clipboard.setData') {
        onCopy((call.arguments as Map)['text'] as String?);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
}

String _packName(WorldStyle style, [String lang = 'en']) =>
    SettingPacks.of(style).term(lang, 'name')!;

void main() {
  testWidgets('generate an NPC, reroll a line, keep it and save it', (
    tester,
  ) async {
    _useSize(tester, const Size(1400, 1000));
    final h = await _pumpApp(tester, seed: 5);
    expect(find.byType(GeneratorsScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('gen-empty')), findsOneWidget);
    // The wide layout shows every generator in the side picker.
    for (final kind in GeneratorKind.values) {
      expect(find.byKey(ValueKey('gen-kind-${kind.name}')), findsOneWidget);
    }

    await _tapKey(tester, 'gen-generate');
    final npc = h.state.currentResult!;
    expect(npc.kind, GeneratorKind.npc);
    expect(npc.style, WorldStyle.fantasy);
    // The same seed outside the UI gives the same NPC.
    final expected = GeneratorEngine(
      random: Random(5),
    ).generate(GeneratorKind.npc, style: WorldStyle.fantasy, language: 'en');
    expect(
      [for (final f in npc.fields) f.value],
      [for (final f in expected.fields) f.value],
    );
    expect(find.text(npc.title), findsOneWidget);
    expect(find.text(npc.value('secret')), findsOneWidget);
    expect(find.text('SECRET'), findsOneWidget);

    // Reroll only the secret.
    await _tapKey(tester, 'gen-reroll-${npc.id}-secret');
    final rerolled = h.state.currentResult!;
    expect(rerolled.id, npc.id);
    expect(rerolled.value('secret'), isNot(npc.value('secret')));
    expect(rerolled.value('trait'), npc.value('trait'));
    expect(find.text(rerolled.value('secret')), findsOneWidget);
    expect(find.text(npc.value('secret')), findsNothing);

    // Keep it, then generate a new one: the kept card stays on screen and
    // does not go to the history.
    await _tapKey(tester, 'gen-keep-${npc.id}');
    expect(h.state.isKept(npc.id), isTrue);
    await _tapKey(tester, 'gen-generate');
    final second = h.state.currentResult!;
    expect(second.id, isNot(npc.id));
    expect(find.byKey(ValueKey('gen-card-${npc.id}')), findsOneWidget);
    expect(find.byKey(ValueKey('gen-card-${second.id}')), findsOneWidget);
    expect(find.text('Kept'), findsOneWidget);
    expect(h.state.history, isEmpty);

    // Save the kept card to the world.
    await _tapKey(tester, 'gen-save-${npc.id}');
    final saved = await h.entities(tester);
    expect(saved, hasLength(1));
    final entity = saved.single;
    expect(entity.kind, EntityKind.character);
    expect(entity.name, rerolled.title);
    expect(entity.attributes['secrets'], rerolled.value('secret'));
    expect(entity.attributes['occupation'], rerolled.value('role'));
    expect(entity.attributes['strength'], isA<num>());
    expect(find.text('Saved “${entity.name}” to the world'), findsOneWidget);
    expect(find.byKey(ValueKey('gen-open-${npc.id}')), findsOneWidget);
    expect(find.byKey(ValueKey('gen-save-${npc.id}')), findsNothing);

    // Generating again sends the unsaved second NPC to the history.
    await _tapKey(tester, 'gen-generate');
    expect(h.state.history.single.id, second.id);
    expect(find.byKey(const ValueKey('gen-history-0')), findsOneWidget);

    // The saved card opens its entity.
    await _tap(tester, find.byKey(ValueKey('gen-open-${npc.id}')));
    expect(find.byType(GeneratorsScreen), findsNothing);
  });

  testWidgets('copy, reroll all, dismiss and bring back from the history', (
    tester,
  ) async {
    _useSize(tester, const Size(1400, 1000));
    final h = await _pumpApp(tester, seed: 11);
    String? clipboard;
    _mockClipboard(tester, (text) => clipboard = text);

    await _tapKey(tester, 'gen-kind-hook');
    await _tapKey(tester, 'gen-generate');
    final hook = h.state.currentResult!;
    expect(hook.kind, GeneratorKind.hook);

    await _tapKey(tester, 'gen-copy-${hook.id}');
    expect(clipboard, startsWith(hook.title));
    expect(clipboard, contains('Twist: ${hook.value('twist')}'));
    expect(find.text('Copied to clipboard'), findsOneWidget);

    await _tapKey(tester, 'gen-reroll-all-${hook.id}');
    final all = h.state.currentResult!;
    expect(all.id, hook.id);
    expect(all.value('twist'), isNot(hook.value('twist')));

    // Keep, then dismiss from the kept list: it lands in the history.
    await _tapKey(tester, 'gen-keep-${hook.id}');
    await _tapKey(tester, 'gen-generate');
    await _tapKey(tester, 'gen-dismiss-${hook.id}');
    expect(h.state.kept, isEmpty);
    expect(h.state.history.single.id, hook.id);

    // Switch generator, then bring the hook back from the history.
    await _tapKey(tester, 'gen-kind-weather');
    await _tapKey(tester, 'gen-history-0');
    expect(h.state.kind, GeneratorKind.hook);
    expect(h.state.currentResult!.id, hook.id);
    expect(find.byKey(ValueKey('gen-card-${hook.id}')), findsOneWidget);

    await _tapKey(tester, 'gen-history-clear');
    expect(h.state.history, isEmpty);
    expect(
      find.text(
        'Results you replace without saving land here for this '
        'session.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('the world pack is the default and the pack can be switched', (
    tester,
  ) async {
    _useSize(tester, const Size(1400, 1000));
    final h = await _pumpApp(tester, style: WorldStyle.cyberpunk);
    await _tapKey(tester, 'gen-kind-settlement');
    await _tapKey(tester, 'gen-generate');
    expect(h.state.currentResult!.style, WorldStyle.cyberpunk);
    expect(
      find.text('${_packName(WorldStyle.cyberpunk)} (this world)'),
      findsOneWidget,
    );

    await _tapKey(tester, 'gen-pack');
    await _tap(tester, find.text(_packName(WorldStyle.wuxia)).last);
    expect(h.state.style, WorldStyle.wuxia);
    await _tapKey(tester, 'gen-generate');
    final wuxia = h.state.currentResult!;
    expect(wuxia.style, WorldStyle.wuxia);
    expect(find.textContaining(_packName(WorldStyle.wuxia)), findsWidgets);

    // Picking the world's own pack follows the world again.
    await _tapKey(tester, 'gen-pack');
    await _tap(
      tester,
      find.text('${_packName(WorldStyle.cyberpunk)} (this world)').last,
    );
    expect(h.state.style, isNull);
  });

  testWidgets('names: gender, count, copy and save as a character', (
    tester,
  ) async {
    _useSize(tester, const Size(1400, 1000));
    final h = await _pumpApp(tester, seed: 3);
    String? clipboard;
    _mockClipboard(tester, (text) => clipboard = text);

    await _tapKey(tester, 'gen-kind-names');
    expect(find.byKey(const ValueKey('gen-gender-feminine')), findsOneWidget);
    await _tapKey(tester, 'gen-gender-feminine');
    await _tapKey(tester, 'gen-count-plus');
    await _tapKey(tester, 'gen-count-plus');
    expect(h.state.count, 7);
    await _tapKey(tester, 'gen-epithets');
    await _tapKey(tester, 'gen-generate');

    final batch = h.state.names!;
    expect(batch.names, hasLength(7));
    expect(batch.names.every((n) => n.gender == 'f'), isTrue);
    expect(batch.names.every((n) => n.epithet != null), isTrue);
    for (var i = 0; i < 7; i++) {
      expect(find.byKey(ValueKey('gen-name-$i')), findsOneWidget);
    }
    expect(find.text(batch.names[2].display), findsOneWidget);

    await _tapKey(tester, 'gen-name-copy-1');
    expect(clipboard, batch.names[1].toText());
    await _tapKey(tester, 'gen-names-copy-all');
    expect(clipboard!.split('\n'), hasLength(7));

    await _tapKey(tester, 'gen-name-save-2');
    final saved = await h.entities(tester);
    expect(saved.single.kind, EntityKind.character);
    expect(saved.single.name, batch.names[2].name);
    expect(saved.single.attributes['gender'], 'female');
    expect(saved.single.attributes['title'], batch.names[2].epithet);
    expect(find.byKey(const ValueKey('gen-name-open-2')), findsOneWidget);

    // A naming style limits the culture.
    await _tapKey(tester, 'gen-culture-fantasy');
    await _tap(tester, find.text('Dwarvish').last);
    expect(h.state.cultureId, 'dwarf');
    await _tapKey(tester, 'gen-generate');
    expect(h.state.names!.names.every((n) => n.cultureId == 'dwarf'), isTrue);
    // The replaced batch had unsaved names: it is in the history.
    expect(h.state.history.single.names!.id, batch.id);
  });

  final variants = [
    (
      '400x780 de x1.3',
      const Size(400, 780),
      const Locale('de'),
      1.3,
      ThemeMode.dark,
    ),
    (
      '1280x720 zh',
      const Size(1280, 720),
      const Locale('zh'),
      1.0,
      ThemeMode.light,
    ),
    (
      '2560x1440 en',
      const Size(2560, 1440),
      const Locale('en'),
      1.0,
      ThemeMode.dark,
    ),
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
      Object? failure;
      StackTrace? failureStack;
      try {
        await _layoutFlow(tester, size, locale, theme);
      } catch (e, st) {
        failure = e;
        failureStack = st;
      } finally {
        FlutterError.onError = previous;
      }
      if (failure != null) {
        printOnFailure('Layout problems:\n${problems.join('\n')}');
        Error.throwWithStackTrace(failure, failureStack!);
      }
      expect(problems, isEmpty, reason: problems.join('\n'));
    });
  }
}

/// Visits every part of the screen: three kept results with history,
/// then ten names with epithets, and scrolls to the end.
Future<void> _layoutFlow(
  WidgetTester tester,
  Size size,
  Locale locale,
  ThemeMode theme,
) async {
  final h = await _pumpApp(
    tester,
    seed: 9,
    locale: locale,
    theme: theme,
    style: WorldStyle.steampunk,
  );
  final narrow = size.width < 840;
  expect(
    find.byKey(const ValueKey('gen-kind-chips')),
    narrow ? findsOneWidget : findsNothing,
  );
  expect(
    find.byKey(const ValueKey('gen-picker')),
    narrow ? findsNothing : findsOneWidget,
  );

  for (final kind in [
    GeneratorKind.npc,
    GeneratorKind.establishment,
    GeneratorKind.loot,
  ]) {
    await _tapKey(tester, 'gen-kind-${kind.name}');
    await _tapKey(tester, 'gen-generate');
    final r = h.state.currentResult!;
    expect(r.language, locale.languageCode);
    await _tapKey(tester, 'gen-keep-${r.id}');
    await _tapKey(tester, 'gen-generate');
  }
  await _tapKey(tester, 'gen-kind-names');
  await _tapKey(tester, 'gen-epithets');
  for (var i = 0; i < 5; i++) {
    await _tapKey(tester, 'gen-count-plus');
  }
  await _tapKey(tester, 'gen-generate');
  await _tapKey(tester, 'gen-generate');
  expect(h.state.names!.names, hasLength(10));
  expect(h.state.history, isNotEmpty);

  // Scroll through the whole page so every part is laid out.
  await tester.drag(
    find.byKey(const ValueKey('gen-results')),
    const Offset(0, -3000),
  );
  await _settle(tester);
}
