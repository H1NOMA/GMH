import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/app/router.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';

import '../support/app_harness.dart';

void main() {
  late String worldId;

  Future<AppHarness> start(WidgetTester tester) async {
    final app = await AppHarness.create(tester);
    worldId = (await app.run(() => app.container
            .read(worldRepositoryProvider)
            .createWorld(name: 'Trash World')))
        .id;
    return app;
  }

  Future<Entity> entry(AppHarness app, String name) async => (await app.run(
          () => app.container.read(entityServiceProvider).create(
              worldId: worldId, kind: EntityKind.character, name: name)))
      .value;

  Future<Entity?> fetch(AppHarness app, String id) =>
      app.run(() => app.container.read(entityRepositoryProvider).getEntity(id));

  testWidgets('delete from the entry page, then undo', (tester) async {
    final app = await start(tester);
    final mira = await entry(app, 'Mira');
    await app.pump(Routes.entity(worldId, mira.id));

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await app.settle();
    await tester.tap(find.text('Delete').last);
    await app.settle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await app.settle();

    expect((await fetch(app, mira.id))!.isDeleted, isTrue);
    expect(find.text('“Mira” moved to trash'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await app.settle();
    expect((await fetch(app, mira.id))!.isDeleted, isFalse);
    final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
    expect(router.routerDelegate.currentConfiguration.uri.path,
        Routes.entity(worldId, mira.id));
  });

  testWidgets('the trash page restores, purges and empties', (tester) async {
    final app = await start(tester);
    final service = app.container.read(entityServiceProvider);
    final ids = <String, String>{};
    for (final name in ['Alpha', 'Beta', 'Gamma', 'Delta']) {
      final e = await entry(app, name);
      ids[name] = e.id;
      await app.run(() => service.moveToTrash(e.id));
    }
    await app.pump(Routes.trash(worldId));
    for (final name in ids.keys) {
      expect(find.text(name), findsOneWidget);
    }

    // Restore one.
    await tester.tap(find.descendant(
        of: find.ancestor(of: find.text('Alpha'), matching: find.byType(Card)),
        matching: find.byIcon(Icons.restore_from_trash_outlined)));
    await app.settle();
    expect((await fetch(app, ids['Alpha']!))!.isDeleted, isFalse);
    expect(find.text('Alpha'), findsNothing);

    // Delete one forever, after confirming.
    await tester.tap(find.descendant(
        of: find.ancestor(of: find.text('Beta'), matching: find.byType(Card)),
        matching: find.byIcon(Icons.delete_forever_outlined)));
    await app.settle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete forever'));
    await app.settle();
    expect(await fetch(app, ids['Beta']!), isNull);

    // Empty the rest.
    await tester.tap(find.text('Empty trash'));
    await app.settle();
    expect(find.textContaining('2 entries will be deleted'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete forever'));
    await app.settle();
    expect(await fetch(app, ids['Gamma']!), isNull);
    expect(await fetch(app, ids['Delta']!), isNull);
    expect(find.textContaining('Trash is empty'), findsOneWidget);
  });
}
