import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/utils/save_flush.dart';

/// Game-style pause menu opened with Escape (fullscreen has no title bar,
/// so this is also the only way to quit): logo, app name, save project,
/// settings and exit. Escape or a click outside closes it.
Future<void> showPauseMenu(BuildContext context,
    {required String? worldId}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => _PauseMenu(worldId: worldId),
  );
}

class _PauseMenu extends ConsumerStatefulWidget {
  final String? worldId;
  const _PauseMenu({required this.worldId});

  @override
  ConsumerState<_PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends ConsumerState<_PauseMenu> {
  bool _saving = false;

  Future<void> _saveProject() async {
    final worldId = widget.worldId;
    if (worldId == null || _saving) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final savedText = context.l10n.backupSaved;
    final errorText = context.l10n.errorUnexpected;
    try {
      // Persist any debounced editor edits first, or the archive would
      // zip a database that misses the last seconds of typing.
      await flushPendingSaves();
      await ref.read(backupServiceProvider).backupNow(worldId);
      messenger.showSnackBar(SnackBar(content: Text(savedText)));
    } catch (_) {
      // Disk full / locked file: the menu must not close pretending the
      // backup succeeded.
      messenger.showSnackBar(SnackBar(content: Text(errorText)));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _exit() async {
    // Quitting must terminate for real — no tray, no background
    // process. exit(0) skips widget disposal, so pending debounced
    // saves are flushed explicitly first.
    try {
      await flushPendingSaves();
    } catch (_) {}
    try {
      await windowManager.destroy();
    } catch (_) {}
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final worldId = widget.worldId;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icon/gmh_icon_1024.png',
                    width: 88,
                    height: 88,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  "Game Master's Hub",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 24),
              if (worldId != null) ...[
                FilledButton.icon(
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_outlined, size: 18),
                  label: Text(l.pauseSaveProject),
                  onPressed: _saveProject,
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.settings_outlined, size: 18),
                  label: Text(l.navSettingsShort),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(Routes.settings(worldId));
                  },
                ),
                const SizedBox(height: 10),
              ],
              OutlinedButton.icon(
                icon: Icon(Icons.power_settings_new,
                    size: 18, color: GmhColors.danger),
                style: OutlinedButton.styleFrom(
                    foregroundColor: GmhColors.danger),
                label: Text(l.pauseExit),
                onPressed: _exit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
