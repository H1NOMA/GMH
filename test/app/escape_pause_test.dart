import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/app.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/data/db/app_database.dart';
import 'package:gmh/data/storage/media_vault.dart';

/// Drift streams resolve on real async, so plain pumpAndSettle would spin
/// forever — pump with short real-time gaps instead (same trick as the
/// screenshot harnesses).
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('Escape on a plain page opens the pause menu', (tester) async {
    final dir = Directory.systemTemp.createTempSync('gmh_escape_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appRootDirProvider.overrideWithValue(dir.path),
      databaseProvider.overrideWithValue(db),
      mediaVaultProvider.overrideWithValue(MediaVault(dir.path)),
    ]);
    addTearDown(container.dispose);

    final world = (await tester.runAsync(() => container
        .read(worldRepositoryProvider)
        .createWorld(name: 'Testland', description: '')))!;

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: GmhApp(initialLocation: Routes.home(world.id)),
    ));
    await _settle(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _settle(tester);

    expect(find.text("Game Master's Hub"), findsOneWidget,
        reason: 'Escape should open the pause menu');

    // A second Escape closes it again (normal dialog dismissal).
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _settle(tester);
    expect(find.text("Game Master's Hub"), findsNothing);
  });
}
