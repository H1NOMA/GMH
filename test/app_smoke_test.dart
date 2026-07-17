import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/providers.dart';
import 'package:gmh/l10n/app_localizations.dart';
import 'package:gmh/app/theme/gmh_theme.dart';
import 'package:gmh/core/utils/dates.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/repositories/repositories.dart';
import 'package:gmh/features/worlds/world_picker_screen.dart';

/// Hermetic widget smoke test: the world picker rendered against an
/// in-memory [WorldRepository] fake (full DB round-trips are covered by the
/// tests in `test/data/`).
class _FakeWorldRepository implements WorldRepository {
  final List<World> worlds;
  _FakeWorldRepository(this.worlds);

  @override
  Stream<List<World>> watchWorlds() => Stream.value(worlds);

  @override
  Future<World?> getWorld(String id) async =>
      worlds.where((w) => w.id == id).firstOrNull;

  @override
  Future<World> createWorld(
      {required String name, String description = ''}) async {
    final world = World(
        id: newId(),
        name: name,
        description: description,
        createdAt: nowMs(),
        updatedAt: nowMs());
    worlds.add(world);
    return world;
  }

  @override
  Future<void> updateWorld(World world) async {}

  @override
  Future<void> deleteWorld(String id) async {}
}

Widget _app(WorldRepository repository, {Locale? locale}) {
  return ProviderScope(
    overrides: [worldRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: GmhTheme.dark(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const WorldPickerScreen(),
    ),
  );
}

void main() {
  testWidgets('empty state invites creating the first world', (tester) async {
    await tester.pumpWidget(_app(_FakeWorldRepository([])));
    await tester.pumpAndSettle();

    expect(find.text("Game Master's Hub"), findsOneWidget);
    expect(find.textContaining('Forge your first one'), findsOneWidget);

    await tester.tap(find.text('Create New World'));
    await tester.pumpAndSettle();
    expect(find.text('Create a New World'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'World name'), findsWidgets);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Create a New World'), findsNothing);
  });

  testWidgets('Russian locale renders a fully translated world picker',
      (tester) async {
    await tester.pumpWidget(
        _app(_FakeWorldRepository([]), locale: const Locale('ru')));
    await tester.pumpAndSettle();

    expect(find.text('Создать новый мир'), findsOneWidget);
    expect(find.textContaining('Создайте свой первый мир'), findsOneWidget);

    await tester.tap(find.text('Создать новый мир'));
    await tester.pumpAndSettle();
    expect(find.text('Создание нового мира'), findsOneWidget);
    expect(find.text('Отмена'), findsOneWidget);
  });

  testWidgets('existing worlds are listed', (tester) async {
    final repository = _FakeWorldRepository([
      World(
          id: 'w1',
          name: 'The Aurion Realms',
          description: 'Realm of ash and gold',
          createdAt: nowMs(),
          updatedAt: nowMs()),
    ]);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('The Aurion Realms'), findsOneWidget);
    expect(find.text('Realm of ash and gold'), findsOneWidget);
  });
}
