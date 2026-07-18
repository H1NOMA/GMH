import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/locale_provider.dart';
import 'app/theme_provider.dart';
import 'app/providers.dart';
import 'app/router.dart';
import 'domain/repositories/repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      // Fire-and-forget; must never block startup.
      unawaited(
          container.read(backupServiceProvider).autoBackupIfDue(world.id));
    }
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: GmhApp(initialLocation: initialLocation),
    ),
  );
}
