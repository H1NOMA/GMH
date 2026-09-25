import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
import 'package:gmh/domain/maps/game_map.dart';
import 'package:gmh/domain/maps/map_pin.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world_object.dart';
import 'package:gmh/features/tools/maps/maps_actions.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../support/demo_world.dart';

/// Drift streams resolve on real async, so plain pumpAndSettle would spin
/// forever — pump with short real-time gaps instead.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
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

  Future<List<GameMap>> maps(WidgetTester tester) async =>
      (await tester.runAsync(
        () => container
            .read(worldObjectRepositoryProvider)
            .list(worldId, WorldObjectTypes.map),
      ))!.map(GameMap.fromObject).toList();

  Future<List<MapPin>> pins(WidgetTester tester, {String? mapId}) async =>
      (await tester.runAsync(
        () => container
            .read(worldObjectRepositoryProvider)
            .list(worldId, WorldObjectTypes.mapPin, parentId: mapId),
      ))!.map(MapPin.fromObject).toList();
}

Future<_Harness> _pumpApp(
  WidgetTester tester, {
  required String Function(String worldId) location,
  Future<void> Function(ProviderContainer c, String worldId)? seed,
  Locale locale = const Locale('en'),
  ThemeMode theme = ThemeMode.dark,
  List<XFile> Function()? pickImages,
}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final dir = Directory.systemTemp.createTempSync('gmh_maps_');
  final db = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(
    overrides: [
      appRootDirProvider.overrideWithValue(dir.path),
      databaseProvider.overrideWithValue(db),
      mediaVaultProvider.overrideWithValue(MediaVault(dir.path)),
      mapImagePickerProvider.overrideWithValue(
        () async => pickImages?.call() ?? const [],
      ),
    ],
  );
  container.read(localeControllerProvider.notifier).seed(locale);
  container.read(themeModeProvider.notifier).seed(theme);
  final worldId = (await tester.runAsync(() async {
    final world = await container
        .read(worldRepositoryProvider)
        .createWorld(name: 'Testland');
    await seed?.call(container, world.id);
    return world.id;
  }))!;
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: GmhApp(initialLocation: location(worldId)),
    ),
  );
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

Future<void> _tapAt(WidgetTester tester, Offset at) async {
  await tester.tapAt(at);
  await _settle(tester);
}

Future<void> _enter(WidgetTester tester, String key, String text) async {
  await tester.enterText(find.byKey(ValueKey(key)), text);
  await tester.pump();
}

void _useSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Screen rectangle the map content (image pixels) is fitted into.
Rect _mapRect(WidgetTester tester, Size content) {
  final viewer = tester.getRect(find.byKey(const ValueKey('maps-viewer')));
  const padding = 16.0;
  final scale = [
    (viewer.width - padding * 2) / content.width,
    (viewer.height - padding * 2) / content.height,
  ].reduce((a, b) => a < b ? a : b);
  final size = Size(content.width * scale, content.height * scale);
  return Rect.fromCenter(
    center: viewer.center,
    width: size.width,
    height: size.height,
  );
}

Offset _at(Rect map, double x, double y) =>
    Offset(map.left + map.width * x, map.top + map.height * y);

Future<GameMap> _seedMap(
  ProviderContainer c,
  String worldId,
  GameMap map,
) => c.read(mapsActionsProvider).create(worldId, map);

Future<MapPin> _seedPin(ProviderContainer c, GameMap map, MapPin pin) =>
    c.read(mapsActionsProvider).addPin(map, pin);

Future<List<int>> _pngBytes(int width, int height) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ui.Paint()..color = const ui.Color(0xFF336699),
  );
  final image = await recorder.endRecording().toImage(width, height);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

void main() {
  testWidgets('blank map: add, edit, link, drag, measure, player view, '
      'delete', (tester) async {
    _useSize(tester, const Size(1400, 1000));
    late String miraId;
    final h = await _pumpApp(
      tester,
      location: (w) => Routes.tool(w, 'maps'),
      seed: (c, worldId) async {
        final result = await c
            .read(entityServiceProvider)
            .create(
              worldId: worldId,
              kind: EntityKind.character,
              name: 'Captain Mira Voss',
            );
        miraId = result.value.id;
      },
    );

    // Empty state → a blank map.
    expect(find.text('No maps yet'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('maps-empty-blank')));
    await _enter(tester, 'maps-name-field', 'Northreach');
    await _tap(tester, find.byKey(const ValueKey('maps-name-confirm')));
    final map = (await h.maps(tester)).single;
    expect(map.name, 'Northreach');
    expect(map.hasImage, isFalse);
    expect((map.width, map.height), (blankMapWidth, blankMapHeight));
    expect(find.text('Northreach'), findsWidgets);
    expect(find.text('No pins yet. Choose “Add pin” and tap the map.'),
        findsOneWidget);
    final content = Size(map.width.toDouble(), map.height.toDouble());
    final rect = _mapRect(tester, content);

    // Add mode: tap the map, name the pin, pick a symbol.
    await _tap(tester, find.byKey(const ValueKey('maps-mode-add')));
    expect(find.byKey(const ValueKey('maps-add-hint')), findsOneWidget);
    await _tapAt(tester, _at(rect, 0.5, 0.6));
    expect(find.text('New pin'), findsOneWidget);
    await _enter(tester, 'maps-pin-label', 'Old Mill');
    await _tap(tester, find.byKey(const ValueKey('maps-icon-castle')));
    await _tap(tester, find.byKey(const ValueKey('maps-pin-save')));
    var pins = await h.pins(tester);
    expect(pins, hasLength(1));
    var pin = pins.single;
    expect(pin.label, 'Old Mill');
    expect(pin.icon, MapPinIcon.castle);
    expect(pin.mapId, map.id);
    expect(pin.x, closeTo(0.5, 0.01));
    expect(pin.y, closeTo(0.6, 0.01));
    expect(pin.gmOnly, isFalse);
    final pinKey = ValueKey('maps-pin-${pin.id}');
    expect(find.byKey(pinKey), findsOneWidget);
    // Back in select mode with the new pin selected.
    expect(find.byKey(const ValueKey('maps-add-hint')), findsNothing);
    expect(find.byKey(const ValueKey('maps-pin-card')), findsOneWidget);
    expect(find.byKey(ValueKey('maps-list-pin-${pin.id}')), findsOneWidget);

    // Edit: link an entry and let its name be the label.
    await _tap(tester, find.byKey(const ValueKey('maps-pin-card-edit')));
    expect(
      find.descendant(of: find.byType(AlertDialog), matching: find.text('Edit pin')),
      findsOneWidget,
    );
    await _tap(tester, find.byKey(const ValueKey('maps-pin-link')));
    await _tap(tester, find.widgetWithText(ListTile, 'Captain Mira Voss'));
    expect(find.byKey(const ValueKey('maps-pin-entity-name')), findsOneWidget);
    await _enter(tester, 'maps-pin-label', '');
    await _enter(tester, 'maps-pin-notes', 'Keeps the harbor keys');
    await _tap(tester, find.byKey(const ValueKey('maps-color-red')));
    await _tap(tester, find.byKey(const ValueKey('maps-pin-save')));
    pin = (await h.pins(tester)).single;
    expect(pin.entityId, miraId);
    expect(pin.label, '');
    expect(pin.notes, 'Keeps the harbor keys');
    expect(pin.color, MapPinColor.red);
    // The label on the map and in the list follows the entry.
    expect(find.text('Captain Mira Voss'), findsWidgets);
    expect(find.byKey(const ValueKey('maps-pin-card-open')), findsOneWidget);

    // Drag the pin: 100 px right, 50 px up on screen.
    final scale = rect.width / content.width;
    await tester.drag(find.byKey(pinKey), const Offset(100, -50));
    await _settle(tester);
    pin = (await h.pins(tester)).single;
    expect(pin.x, closeTo(0.5 + 100 / (content.width * scale), 0.005));
    expect(pin.y, closeTo(0.6 - 50 / (content.height * scale), 0.005));
    expect(pin.x, greaterThan(0.53));
    final center = tester.getCenter(find.byKey(pinKey));
    expect(center.dx, closeTo(_at(rect, pin.x, pin.y).dx, 2));

    // Measure without a scale: pixels.
    await _tap(tester, find.byKey(const ValueKey('maps-mode-measure')));
    expect(find.byKey(const ValueKey('maps-measure-hint')), findsOneWidget);
    await _tapAt(tester, _at(rect, 0.1, 0.2));
    await _tapAt(tester, _at(rect, 0.4, 0.2));
    expect(find.text('Distance: 480 px'), findsOneWidget); // 0.3 * 1600

    // Give the map a scale in the details panel: the distance follows.
    await _tap(tester, find.byKey(const ValueKey('maps-tab-details')));
    expect(find.text('No scale set'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('maps-edit-details')));
    await _enter(tester, 'maps-details-description', 'The frozen north');
    await _enter(tester, 'maps-scale-units', '5');
    await _enter(tester, 'maps-scale-unit-name', 'miles');
    await _enter(tester, 'maps-scale-cell', '80');
    await _tap(tester, find.byKey(const ValueKey('maps-details-save')));
    var saved = (await h.maps(tester)).single;
    expect(
      saved.scale,
      const MapScale(unitsPerCell: 5, unitName: 'miles', cellPx: 80),
    );
    expect(saved.description, 'The frozen north');
    expect(find.text('Distance: 30 miles'), findsOneWidget); // 480 / 80 * 5
    expect(find.text('1 cell = 5 miles (80 px)'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('maps-grid-toggle')));
    saved = (await h.maps(tester)).single;
    expect(saved.showGrid, isTrue);
    await _tap(tester, find.byKey(const ValueKey('maps-measure-clear')));
    expect(find.byKey(const ValueKey('maps-measure-hint')), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('maps-mode-select')));

    // Make the pin GM-only (still selected since the drag): player view
    // hides it.
    expect(find.byKey(const ValueKey('maps-pin-card')), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('maps-pin-card-edit')));
    await _tap(tester, find.byKey(const ValueKey('maps-pin-gm-only')));
    await _tap(tester, find.byKey(const ValueKey('maps-pin-save')));
    expect((await h.pins(tester)).single.gmOnly, isTrue);
    expect(find.byKey(pinKey), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('maps-player-view')));
    expect(find.byKey(pinKey), findsNothing);
    expect(find.byKey(const ValueKey('maps-mode-add')), findsNothing);
    expect(find.byKey(const ValueKey('maps-pin-search')), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('maps-exit-player-view')));
    expect(find.byKey(pinKey), findsOneWidget);
    expect(find.byKey(const ValueKey('maps-mode-add')), findsOneWidget);

    // Delete the pin from its editor, then undo, then delete for good.
    await tester.tap(find.byKey(pinKey));
    await _settle(tester);
    await _tap(tester, find.byKey(const ValueKey('maps-pin-card-edit')));
    await _tap(tester, find.byKey(const ValueKey('maps-pin-delete')));
    expect(await h.pins(tester), isEmpty);
    expect(find.byKey(pinKey), findsNothing);
    expect(find.text('Pin deleted'), findsOneWidget);
    await _tap(tester, find.text('Undo'));
    pins = await h.pins(tester);
    expect(pins.single.entityId, miraId);
    final restoredKey = ValueKey('maps-pin-${pins.single.id}');
    expect(find.byKey(restoredKey), findsOneWidget);
    // Tapping a selected pin opens its editor directly.
    await tester.tap(find.byKey(restoredKey));
    await _settle(tester);
    await tester.tap(find.byKey(restoredKey));
    await _settle(tester);
    await _tap(tester, find.byKey(const ValueKey('maps-pin-delete')));
    expect(await h.pins(tester), isEmpty);

    // A second pin, then delete the whole map: its pins go with it.
    await _tap(tester, find.byKey(const ValueKey('maps-mode-add')));
    await _tapAt(tester, _at(rect, 0.3, 0.3));
    await _tap(tester, find.byKey(const ValueKey('maps-pin-save')));
    expect(await h.pins(tester), hasLength(1));
    await _tap(tester, find.byKey(ValueKey('maps-menu-${map.id}')));
    await _tap(tester, find.text('Delete'));
    await _tap(tester, find.byKey(const ValueKey('maps-delete-confirm')));
    expect(await h.maps(tester), isEmpty);
    expect(await h.pins(tester), isEmpty);
    expect(find.text('No maps yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the entry page lists its pins and opens the map on them', (
    tester,
  ) async {
    _useSize(tester, const Size(1400, 900));
    late String entityId;
    late String pinId;
    late String mapId;
    await _pumpApp(
      tester,
      location: (w) => Routes.entity(w, entityId),
      seed: (c, worldId) async {
        final entity = (await c
                .read(entityServiceProvider)
                .create(
                  worldId: worldId,
                  kind: EntityKind.location,
                  name: 'Ravenport',
                ))
            .value;
        entityId = entity.id;
        final map = await _seedMap(
          c,
          worldId,
          const GameMap(name: 'Sunken Coast', width: 3000, height: 2000),
        );
        mapId = map.id;
        await _seedPin(c, map, MapPin(x: 0.1, y: 0.2, label: 'Lighthouse'));
        final pin = await _seedPin(
          c,
          map,
          MapPin(x: 0.85, y: 0.75, entityId: entity.id),
        );
        pinId = pin.id;
      },
    );

    expect(find.byKey(const ValueKey('entity-on-maps')), findsOneWidget);
    final chip = find.byKey(ValueKey('entity-map-pin-$pinId'));
    expect(chip, findsOneWidget);
    expect(find.text('Sunken Coast'), findsOneWidget);
    await _tap(tester, chip);

    // The map opens centered on the pin, with the pin selected.
    expect(find.byKey(const ValueKey('maps-viewer')), findsOneWidget);
    expect(find.byKey(const ValueKey('maps-pin-card')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('maps-pin-card')),
        matching: find.text('Ravenport'),
      ),
      findsWidgets,
    );
    final viewer = tester.getRect(find.byKey(const ValueKey('maps-viewer')));
    final pinCenter = tester.getCenter(find.byKey(ValueKey('maps-pin-$pinId')));
    expect(pinCenter.dx, closeTo(viewer.center.dx, 2));
    expect(pinCenter.dy, closeTo(viewer.center.dy, 2));

    // "Open entry" from the pin card goes back to the entry.
    await _tap(tester, find.byKey(const ValueKey('maps-pin-card-open')));
    expect(find.byKey(ValueKey('entity-map-pin-$pinId')), findsOneWidget);
    expect(mapId, isNotEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('map from an image, rename, duplicate with pins, list search '
      'and a missing image', (tester) async {
    _useSize(tester, const Size(1280, 800));
    final png = (await tester.runAsync(() => _pngBytes(64, 40)))!;
    late String brokenId;
    final h = await _pumpApp(
      tester,
      location: (w) => Routes.tool(w, 'maps'),
      pickImages: () => [
        XFile.fromData(
          Uint8List.fromList(png),
          name: 'Frostmarch.png',
          mimeType: 'image/png',
        ),
      ],
      seed: (c, worldId) async {
        final broken = await _seedMap(
          c,
          worldId,
          const GameMap(name: 'Lost Atlas', mediaId: 'gone', width: 800, height: 600),
        );
        brokenId = broken.id;
        await _seedPin(c, broken, const MapPin(x: 0.5, y: 0.5, label: 'Camp'));
      },
    );

    expect(find.byKey(ValueKey('maps-card-$brokenId')), findsOneWidget);
    expect(find.text('1 pin'), findsOneWidget);

    // Import: the map takes the file's name and the image's size.
    await _tap(tester, find.byKey(const ValueKey('maps-new-image')));
    await _settle(tester);
    var maps = await h.maps(tester);
    final frost = maps.firstWhere((m) => m.name == 'Frostmarch');
    expect(frost.mediaId, isNotNull);
    expect((frost.width, frost.height), (64, 40));
    expect(find.byKey(const ValueKey('maps-viewer')), findsOneWidget);
    expect(find.byKey(const ValueKey('maps-image-missing')), findsNothing);

    // Back to the list: rename and duplicate the broken map.
    await _tap(tester, find.byKey(const ValueKey('maps-back')));
    await _tap(tester, find.byKey(ValueKey('maps-menu-$brokenId')));
    await _tap(tester, find.text('Rename'));
    await _enter(tester, 'maps-name-field', 'Old Atlas');
    await _tap(tester, find.byKey(const ValueKey('maps-name-confirm')));
    expect(
      (await h.maps(tester)).firstWhere((m) => m.id == brokenId).name,
      'Old Atlas',
    );
    await _tap(tester, find.byKey(ValueKey('maps-menu-$brokenId')));
    await _tap(tester, find.text('Duplicate'));
    maps = await h.maps(tester);
    final copy = maps.firstWhere((m) => m.name == 'Old Atlas (copy)');
    expect(copy.mediaId, 'gone');
    final copyPins = await h.pins(tester, mapId: copy.id);
    expect(copyPins.single.label, 'Camp');
    expect(await h.pins(tester, mapId: brokenId), hasLength(1));

    // The copy's image is missing: a notice, pins still shown and usable.
    expect(find.byKey(const ValueKey('maps-image-missing')), findsOneWidget);
    final pinKey = ValueKey('maps-pin-${copyPins.single.id}');
    expect(find.byKey(pinKey), findsOneWidget);
    await tester.tap(find.byKey(pinKey));
    await _settle(tester);
    expect(find.byKey(const ValueKey('maps-pin-card')), findsOneWidget);

    // Pin search in the side panel.
    await _enter(tester, 'maps-pin-search', 'zzz');
    await _settle(tester);
    expect(find.text('No pins match your search.'), findsOneWidget);
    await _enter(tester, 'maps-pin-search', 'cam');
    await _settle(tester);
    expect(find.byKey(ValueKey('maps-list-pin-${copyPins.single.id}')),
        findsOneWidget);

    // Delete the original: the copy keeps its pin.
    await _tap(tester, find.byKey(const ValueKey('maps-back')));
    await _tap(tester, find.byKey(ValueKey('maps-menu-$brokenId')));
    await _tap(tester, find.text('Delete'));
    await _tap(tester, find.byKey(const ValueKey('maps-delete-confirm')));
    expect(await h.pins(tester, mapId: brokenId), isEmpty);
    expect(await h.pins(tester, mapId: copy.id), hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow windows open the pins panel as a sheet', (tester) async {
    _useSize(tester, const Size(420, 800));
    late String mapId;
    late String farId;
    await _pumpApp(
      tester,
      location: (w) => Routes.tool(w, 'maps', mapId),
      seed: (c, worldId) async {
        final map = await _seedMap(c, worldId, const GameMap(name: 'Isles'));
        mapId = map.id;
        await _seedPin(c, map, const MapPin(x: 0.2, y: 0.2, label: 'Near'));
        farId = (await _seedPin(
          c,
          map,
          const MapPin(x: 0.95, y: 0.9, label: 'Far Reef'),
        )).id;
      },
    );
    expect(find.byKey(const ValueKey('maps-pin-search')), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('maps-panel-toggle')));
    expect(find.byKey(const ValueKey('maps-pin-search')), findsOneWidget);
    await _tap(tester, find.byKey(ValueKey('maps-list-pin-$farId')));
    expect(find.byKey(const ValueKey('maps-pin-search')), findsNothing);
    expect(find.byKey(const ValueKey('maps-pin-card')), findsOneWidget);
    final viewer = tester.getRect(find.byKey(const ValueKey('maps-viewer')));
    final pin = tester.getCenter(find.byKey(ValueKey('maps-pin-$farId')));
    expect(pin.dx, closeTo(viewer.center.dx, 2));
    // Zoom buttons and fit keep working.
    await _tap(tester, find.byKey(const ValueKey('maps-zoom-in')));
    await _tap(tester, find.byKey(const ValueKey('maps-fit')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a missing map shows a way back', (tester) async {
    _useSize(tester, const Size(1280, 720));
    await _pumpApp(
      tester,
      location: (w) => Routes.tool(w, 'maps', 'nope'),
    );
    expect(find.text('This map no longer exists.'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'All maps'));
    expect(find.text('No maps yet'), findsOneWidget);
  });

  // Layout: list, map page with a selected pin, measuring, dialogs and
  // player view, from phone to 1440p, long locales and raised text scale.
  final variants = <(String, Size, Locale, double, ThemeMode)>[
    ('phone de x1.3', const Size(400, 780), const Locale('de'), 1.3, ThemeMode.dark),
    ('phone fr light 600', const Size(400, 600), const Locale('fr'), 1.0, ThemeMode.light),
    ('1280x720 zh', const Size(1280, 720), const Locale('zh'), 1.0, ThemeMode.dark),
    ('1280x720 ru light x1.3', const Size(1280, 720), const Locale('ru'), 1.3, ThemeMode.light),
    ('2560x1440 en', const Size(2560, 1440), const Locale('en'), 1.0, ThemeMode.dark),
  ];
  for (final (name, size, locale, textScale, theme) in variants) {
    testWidgets('layout · $name', (tester) async {
      _useSize(tester, size);
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await loadRealFonts(tester);

      final problems = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (details) =>
          problems.add(details.exceptionAsString().split('\n').first);
      addTearDown(() => FlutterError.onError = previous);

      late String mapId;
      late String pinId;
      await _pumpApp(
        tester,
        locale: locale,
        theme: theme,
        location: (w) => Routes.tool(w, 'maps', mapId),
        seed: (c, worldId) async {
          final entity = (await c
                  .read(entityServiceProvider)
                  .create(
                    worldId: worldId,
                    kind: EntityKind.location,
                    name: 'The unreasonably long name of a harbor town',
                  ))
              .value;
          final map = await _seedMap(
            c,
            worldId,
            GameMap(
              name: 'The extraordinarily long map of the northern wilderness',
              description: 'A very long description ' * 8,
              scale: const MapScale(
                unitsPerCell: 12.5,
                unitName: 'Wegstunden',
                cellPx: 64,
              ),
              showGrid: true,
            ),
          );
          mapId = map.id;
          await _seedMap(
            c,
            worldId,
            const GameMap(name: 'Another map with a very long name indeed'),
          );
          for (var i = 0; i < 8; i++) {
            await _seedPin(
              c,
              map,
              MapPin(
                x: (i + 1) / 10,
                y: 0.3 + i * 0.05,
                label: i.isEven ? 'A long pin label number $i on the map' : '',
                entityId: i.isOdd ? entity.id : null,
                icon: MapPinIcon.values[i],
                color: MapPinColor.values[i],
                notes: 'Notes ' * 40,
                gmOnly: i % 3 == 0,
              ),
            );
          }
          pinId = (await _seedPin(
            c,
            map,
            MapPin(
              x: 0.5,
              y: 0.5,
              entityId: entity.id,
              notes: 'Secret passage ' * 20,
              gmOnly: true,
            ),
          )).id;
        },
      );
      final pinKey = ValueKey('maps-pin-$pinId');
      expect(find.byKey(pinKey), findsOneWidget);
      await tester.tap(find.byKey(pinKey));
      await _settle(tester);
      expect(find.byKey(const ValueKey('maps-pin-card')), findsOneWidget);

      final viewer = tester.getRect(find.byKey(const ValueKey('maps-viewer')));
      await _tap(tester, find.byKey(const ValueKey('maps-mode-measure')));
      await _tapAt(tester, viewer.center + const Offset(-60, 40));
      await _tapAt(tester, viewer.center + const Offset(80, 60));
      expect(find.byKey(const ValueKey('maps-measure-result')), findsOneWidget);
      await _tap(tester, find.byKey(const ValueKey('maps-mode-select')));

      await _tap(tester, find.byKey(const ValueKey('maps-pin-card-edit')));
      expect(find.byKey(const ValueKey('maps-pin-label')), findsOneWidget);
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -2000));
      await _settle(tester);
      await _tap(tester, find.widgetWithText(TextButton, _cancel(locale)));

      await _tap(tester, find.byKey(const ValueKey('maps-panel-toggle')));
      await _tap(tester, find.byKey(const ValueKey('maps-tab-details')));
      await _tap(tester, find.byKey(const ValueKey('maps-edit-details')));
      expect(find.byKey(const ValueKey('maps-scale-units')), findsOneWidget);
      await _tap(tester, find.widgetWithText(TextButton, _cancel(locale)));
      if (size.width < 960) {
        await tester.tapAt(const Offset(10, 10));
        await _settle(tester);
      }

      await _tap(tester, find.byKey(const ValueKey('maps-player-view')));
      expect(find.byKey(pinKey), findsNothing);
      await _tap(tester, find.byKey(const ValueKey('maps-exit-player-view')));

      await _tap(tester, find.byKey(const ValueKey('maps-back')));
      expect(find.byKey(ValueKey('maps-card-$mapId')), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(problems, isEmpty, reason: problems.join('\n'));
    });
  }
}

String _cancel(Locale locale) => switch (locale.languageCode) {
  'de' => 'Abbrechen',
  'fr' => 'Annuler',
  'ru' => 'Отмена',
  'zh' => '取消',
  _ => 'Cancel',
};
