import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/app.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';
import 'package:gmh/domain/dice/dice_history.dart';
import 'package:gmh/domain/dice/dice_presets.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/features/tools/dice/dice_inline.dart';
import 'package:gmh/features/tools/dice/dice_providers.dart';
import 'package:gmh/features/tools/dice/dice_screen.dart';
import 'package:gmh/features/tools/dice/quick_roll_dialog.dart';

import 'scripted_random.dart';

/// Drift streams resolve on real async: pump with short real-time gaps.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

class _Env {
  final ProviderContainer container;
  final String worldId;
  _Env(this.container, this.worldId);

  Future<List<DiceHistoryEntry>> history(WidgetTester tester) async =>
      DiceHistory.fromObjects((await tester.runAsync(() => container
          .read(worldObjectRepositoryProvider)
          .list(worldId, WorldObjectTypes.diceRoll)))!);
}

Future<_Env> _pumpApp(
  WidgetTester tester, {
  required ScriptedRandom random,
  Size size = const Size(1280, 800),
  Future<String> Function(ProviderContainer c, String worldId)? location,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final dir = Directory.systemTemp.createTempSync('gmh_dice_');
  addTearDown(() => dir.deleteSync(recursive: true));
  final db = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(overrides: [
    appRootDirProvider.overrideWithValue(dir.path),
    databaseProvider.overrideWithValue(db),
    mediaVaultProvider.overrideWithValue(MediaVault(dir.path)),
    diceRandomProvider.overrideWithValue(random),
  ]);

  final world = (await tester.runAsync(() => container
      .read(worldRepositoryProvider)
      .createWorld(name: 'Testland', description: '')))!;
  final initial = location == null
      ? Routes.tool(world.id, 'dice')
      : (await tester.runAsync(() => location(container, world.id)))!;

  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: GmhApp(initialLocation: initial),
  ));
  await _settle(tester);
  return _Env(container, world.id);
}

Future<void> _tearDown(WidgetTester tester, _Env env) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 5));
  await tester.runAsync(() async {
    env.container.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 20));
  });
}

String _total(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const ValueKey('dice-total'))).data!;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('roll, re-roll, presets and clearing the history',
      (tester) async {
    final random = ScriptedRandom.dice([
      4, 5, // 2d6+3
      7, 18, // advantage d20
      3, 9, // re-roll of 2d20kh1
      5, 5, // PbtA 2d6
    ]);
    final env = await _pumpApp(tester, random: random);
    expect(find.byType(DiceScreen), findsOneWidget);
    expect(find.text('No rolls yet. Every roll is logged here.'),
        findsOneWidget);

    // Typed expression.
    await tester.enterText(
        find.byKey(const ValueKey('dice-expression')), '2d6+3');
    await tester.tap(find.byKey(const ValueKey('dice-roll')));
    await _settle(tester);
    expect(_total(tester), '12');
    var history = await env.history(tester);
    expect(history.single.expression, '2d6 + 3');
    expect(history.single.total, 12);
    expect(history.single.breakdown, '2d6 (4, 5) + 3');

    // Quick die with advantage.
    await tester.tap(find.widgetWithText(FilterChip, 'Advantage'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('dice-quick-20')));
    await _settle(tester);
    expect(_total(tester), '18');
    history = await env.history(tester);
    expect(history.length, 2);
    expect(history.first.expression, '2d20kh1');

    // An invalid expression shows a localized error and logs nothing.
    await tester.enterText(
        find.byKey(const ValueKey('dice-expression')), '2d6+');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await _settle(tester);
    expect(find.text('The expression ends too early'), findsOneWidget);
    expect((await env.history(tester)).length, 2);

    // Re-roll the newest history entry as stored.
    await tester.tap(find.byTooltip('Roll again').first);
    await _settle(tester);
    expect(_total(tester), '9');
    history = await env.history(tester);
    expect(history.length, 3);
    expect(history.first.expression, '2d20kh1');

    // A system preset through its form.
    await tester.tap(find.byKey(const ValueKey('dice-preset-pbta')));
    await _settle(tester);
    await tester.tap(find.text('Roll').last);
    await _settle(tester);
    expect(_total(tester), '10');
    expect(find.text('Full success'), findsWidgets);
    history = await env.history(tester);
    expect(history.first.preset, DicePresetKind.pbta);
    expect(history.first.outcome, DiceOutcome.fullSuccess);
    expect(random.remaining, 0);

    // Long-press appends a die to the expression.
    await tester.enterText(
        find.byKey(const ValueKey('dice-expression')), '1d8');
    await tester.longPress(find.byKey(const ValueKey('dice-quick-6')));
    await tester.pump();
    expect(find.text('1d8 + 1d6'), findsOneWidget);

    // Copy puts the entry on the clipboard.
    String? clipboard;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        clipboard = (call.arguments as Map)['text'] as String?;
      }
      return null;
    });
    await tester.tap(find.byTooltip('Copy').first);
    await _settle(tester);
    expect(clipboard, startsWith('2d6 = 10'));
    expect(find.text('Copied to clipboard'), findsOneWidget);

    // Clear with confirmation.
    await tester.tap(find.byTooltip('Clear history'));
    await _settle(tester);
    expect(find.text('Clear roll history?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Clear history'));
    await _settle(tester);
    expect(await env.history(tester), isEmpty);
    expect(find.text('No rolls yet. Every roll is logged here.'),
        findsOneWidget);

    await _tearDown(tester, env);
  });

  testWidgets('phone layout: single column, rolls still logged',
      (tester) async {
    final env = await _pumpApp(tester,
        random: ScriptedRandom.dice([3]), size: const Size(400, 780));
    await tester.tap(find.byKey(const ValueKey('dice-quick-4')));
    await _settle(tester);
    expect(_total(tester), '3');
    await tester.scrollUntilVisible(find.text('Roll history'), 200,
        scrollable: find
            .descendant(
                of: find.byType(DiceScreen), matching: find.byType(Scrollable))
            .first);
    await _settle(tester);
    expect(find.byTooltip('Roll again'), findsOneWidget);
    expect((await env.history(tester)).single.expression, '1d4');
    expect(tester.takeException(), isNull);
    await _tearDown(tester, env);
  });

  testWidgets('quick roll dialog rolls and logs', (tester) async {
    final env = await _pumpApp(tester, random: ScriptedRandom.dice([6, 2]));
    final context = tester.element(find.byType(DiceScreen));
    showQuickRollDialog(context, worldId: env.worldId, initialExpression: '1d6!');
    await _settle(tester);
    expect(find.text('Quick roll'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('quick-roll-roll')));
    await _settle(tester);
    expect(find.text('8'), findsWidgets);
    final history = await env.history(tester);
    expect(history.single.expression, '1d6!');
    expect(history.single.total, 8);

    await tester.enterText(
        find.byKey(const ValueKey('quick-roll-expression')), '1d');
    await tester.tap(find.byKey(const ValueKey('quick-roll-roll')));
    await _settle(tester);
    expect(find.text('The expression ends too early'), findsOneWidget);
    await _tearDown(tester, env);
  });

  testWidgets('stat block dice are tappable roll chips', (tester) async {
    final env = await _pumpApp(
      tester,
      random: ScriptedRandom.dice([1, 2, 3, 4, 5, 6, 7, 8]),
      location: (c, worldId) async {
        final creature = await c.read(entityRepositoryProvider).createEntity(
          worldId: worldId,
          kind: EntityKind.creature,
          name: 'Harbor Wyrm',
          attributes: {'ac': '15', 'hp': '52 (8d10 + 8)'},
        );
        return Routes.entity(worldId, creature.id);
      },
    );
    final chip = find.byType(DiceInlineChip);
    expect(chip, findsOneWidget);
    expect(tester.widget<DiceInlineChip>(chip).expression, '8d10 + 8');
    await tester.ensureVisible(chip);
    await tester.pump();
    await tester.tap(chip);
    await _settle(tester);
    expect(find.textContaining('8d10 + 8: 44'), findsOneWidget);
    final history = await env.history(tester);
    expect(history.single.total, 44);
    expect(history.single.expression, '8d10 + 8');
    await _tearDown(tester, env);
  });
}
