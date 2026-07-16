import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
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

  // Resolve the start location and kick off an automatic backup for the
  // last opened world (throttled inside the service).
  final settings = container.read(settingsRepositoryProvider);
  final lastWorldId = await settings.get(SettingsKeys.lastOpenedWorld);
  var initialLocation = Routes.worlds();
  if (lastWorldId != null) {
    final world =
        await container.read(worldRepositoryProvider).getWorld(lastWorldId);
    if (world != null) {
      initialLocation = Routes.home(world.id);
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
