import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'app/locale_provider.dart';
import 'app/theme_provider.dart';
import 'app/providers.dart';
import 'app/router.dart';
import 'domain/repositories/repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop opens as a borderless window over the whole screen, like a
  // game; the Escape pause menu (logo, save, settings, exit) replaces the
  // title bar. On Windows the runner creates that window natively
  // (windows/runner/win32_window.cpp), so it is right from the first frame.
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
  } else if (Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    const options = WindowOptions(
      title: "Game Master's Hub",
      titleBarStyle: TitleBarStyle.hidden,
      fullScreen: true,
    );
    unawaited(windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setFullScreen(true);
      await windowManager.show();
      await windowManager.focus();
    }));
  }

  // All user data lives under {documents}/gmh — database, media vault,
  // backups. Fully local, fully offline.
  final documentsDir = await getApplicationDocumentsDirectory();
  final rootDir = p.join(documentsDir.path, 'gmh');
  await Directory(rootDir).create(recursive: true);

  final container = ProviderContainer(
    overrides: [appRootDirProvider.overrideWithValue(rootDir)],
  );

  // Load the persisted language before the first frame. Absent = follow the
  // system language, so a Russian system gets Russian automatically on
  // first launch (resolved by Flutter against supportedLocales).
  final settings = container.read(settingsRepositoryProvider);
  final savedLocale =
      localeFromSetting(await settings.get(SettingsKeys.appLocale));
  if (savedLocale != null) {
    container.read(localeControllerProvider.notifier).seed(savedLocale);
  }
  final savedTheme =
      themeModeFromSetting(await settings.get(SettingsKeys.themeMode));
  if (savedTheme != ThemeMode.system) {
    container.read(themeModeProvider.notifier).seed(savedTheme);
  }
  final lastWorldId = await settings.get(SettingsKeys.lastOpenedWorld);
  var initialLocation = Routes.worlds();
  if (lastWorldId != null) {
    final world =
        await container.read(worldRepositoryProvider).getWorld(lastWorldId);
    if (world != null) {
      initialLocation = Routes.home(world.id);
      // Reopen exactly where the user left off (section, campaign, entry)
      // as long as the route belongs to a world that still exists.
      final lastLocation = await settings.get(SettingsKeys.lastLocation);
      if (lastLocation != null &&
          lastLocation.startsWith('/w/${world.id}/')) {
        initialLocation = lastLocation;
      }
      // Fire-and-forget; must never block startup. Unused media is swept
      // only right after a fresh backup, so anything removed stays
      // restorable.
      final backups = container.read(backupServiceProvider);
      final media = container.read(mediaRepositoryProvider);
      unawaited(() async {
        try {
          if (await backups.autoBackupIfDue(world.id)) {
            await media.collectGarbage(world.id);
          }
        } catch (_) {
          // Housekeeping only; the next start tries again.
        }
      }());
    }
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: GmhApp(initialLocation: initialLocation),
    ),
  );
}
