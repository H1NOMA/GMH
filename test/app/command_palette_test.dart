import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/features/shell/command_palette.dart';

import '../support/app_harness.dart';

void main() {
  group('fuzzyScore', () {
    test('matches subsequences, rejects the rest', () {
      expect(fuzzyScore('nwen', 'New entry'), isNotNull);
      expect(fuzzyScore('xyz', 'New entry'), isNull);
      expect(fuzzyScore('', 'Anything'), 0);
    });

    test('prefers word starts and runs', () {
      expect(fuzzyScore('dice', 'Dice roller')!,
          greaterThan(fuzzyScore('dice', 'Random tables: dungeon ice')!));
      expect(fuzzyScore('set', 'Settings')!,
          greaterThan(fuzzyScore('set', 'Reset the timeline')!));
    });
  });

  testWidgets('Ctrl+P jumps to an entry or a tool', (tester) async {
    final app = await AppHarness.create(tester);
    final worldId = (await app.run(() => app.container
            .read(worldRepositoryProvider)
            .createWorld(name: 'Palette World')))
        .id;
    final mira = (await app.run(() => app.container
            .read(entityServiceProvider)
            .create(
                worldId: worldId,
                kind: EntityKind.character,
                name: 'Mira Vale')))
        .value;
    await app.pump(Routes.home(worldId));
    String path() => GoRouter.of(tester.element(find.byType(Scaffold).first))
        .routerDelegate
        .currentConfiguration
        .uri
        .path;

    Future<void> openPalette() async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await app.settle();
    }

    await openPalette();
    await tester.enterText(find.byType(TextField).last, 'mira');
    await app.settle(20);
    expect(find.text('Mira Vale'), findsWidgets);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await app.settle();
    expect(path(), Routes.entity(worldId, mira.id));

    await openPalette();
    await tester.enterText(find.byType(TextField).last, 'dice');
    await app.settle(20);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await app.settle();
    expect(path(), Routes.tool(worldId, 'dice'));
  });
}
