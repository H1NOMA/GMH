import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../domain/repositories/repositories.dart';
import '../shell/ui_providers.dart';

/// Picks a `.gmhw` archive and imports it: shows which world it holds,
/// asks before replacing an existing world with the same id, rebuilds the
/// search index, remembers the world for the next start and opens it.
/// Shared by Settings and the world picker. Returns the world id, or null
/// when cancelled or failed (failures are reported in a SnackBar).
Future<String?> importWorldArchive(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  final archives = ref.read(projectArchiveServiceProvider);
  final search = ref.read(searchRepositoryProvider);
  final settings = ref.read(settingsRepositoryProvider);
  final worlds = ref.read(worldsProvider).valueOrNull ?? const [];

  final picked = await FilePicker.platform.pickFiles(
    dialogTitle: l10n.importPickArchive,
    type: FileType.any,
  );
  final path = picked?.files.firstOrNull?.path;
  if (path == null || !context.mounted) return null;

  final manifest = await archives.inspectArchive(path);
  if (!context.mounted) return null;
  if (manifest.isErr) {
    messenger.showSnackBar(
        SnackBar(content: Text(localizedError(context, manifest.error))));
    return null;
  }
  // Importing a world that already exists replaces it: say so.
  final existing =
      worlds.where((w) => w.id == manifest.value.worldId).firstOrNull;
  if (existing != null) {
    final replace = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importReplaceTitle(existing.name)),
        content: SizedBox(width: 420, child: Text(l10n.importReplaceBody)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.importReplaceAction)),
        ],
      ),
    );
    if (replace != true || !context.mounted) return null;
  }

  final result = await archives.importArchive(path);
  if (!context.mounted) return null;
  if (result.isErr) {
    messenger.showSnackBar(
        SnackBar(content: Text(localizedError(context, result.error))));
    return null;
  }
  final worldId = result.value;
  var indexed = true;
  try {
    await search.rebuildIndex(worldId);
  } catch (_) {
    indexed = false;
  }
  await settings.set(SettingsKeys.lastOpenedWorld, worldId);
  messenger.showSnackBar(SnackBar(
      content:
          Text(indexed ? l10n.worldImported : l10n.searchIndexFailed)));
  router.go(Routes.home(worldId));
  return worldId;
}
