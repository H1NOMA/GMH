import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/packs/setting_packs.dart';
import '../../app/theme/gmh_theme.dart';

import '../../domain/models/world.dart';
import '../../domain/repositories/repositories.dart';
import '../shell/ui_providers.dart';
import 'import_world.dart';
import 'world_editor_dialog.dart';

/// Entry screen: pick, create or import a world.
class WorldPickerScreen extends ConsumerWidget {
  const WorldPickerScreen({super.key});

  Future<void> _openWorld(
      BuildContext context, WidgetRef ref, World world) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingsKeys.lastOpenedWorld, world.id);
    if (context.mounted) context.go(Routes.home(world.id));
  }

  Future<void> _createWorld(BuildContext context, WidgetRef ref) async {
    final draft = await showWorldEditor(context);
    if (draft == null) return;
    final world = await ref.read(worldRepositoryProvider).createWorld(
          name: draft.name,
          description: draft.description,
          style: draft.style,
        );
    if (context.mounted) await _openWorld(context, ref, world);
  }

  Future<void> _editWorld(
      BuildContext context, WidgetRef ref, World world) async {
    final draft = await showWorldEditor(context, initial: world);
    if (draft == null) return;
    await ref.read(worldRepositoryProvider).updateWorld(world.copyWith(
          name: draft.name,
          description: draft.description,
          style: draft.style,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ));
  }

  Future<void> _deleteWorld(
      BuildContext context, WidgetRef ref, World world) async {
    if (!await confirmDeleteWorld(context, world)) return;
    final settings = ref.read(settingsRepositoryProvider);
    if (await settings.get(SettingsKeys.lastOpenedWorld) == world.id) {
      await settings.remove(SettingsKeys.lastOpenedWorld);
    }
    await ref.read(worldRepositoryProvider).deleteWorld(world.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worlds = ref.watch(worldsProvider);

    // Outside any world the neutral fantasy identity applies.
    GmhStyle.current = WorldStyle.fantasy;
    GmhColors.palette = GmhStyle.paletteFor(
        WorldStyle.fantasy, Theme.of(context).brightness);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.auto_stories,
                    size: 56, color: GmhColors.ember.withValues(alpha: 0.9)),
                const SizedBox(height: 12),
                Text(context.l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 28),
                Flexible(
                  child: worlds.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) =>
                        Text(context.l10n.worldsLoadError('$e')),
                    data: (list) => list.isEmpty
                        ? Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                context.l10n.worldsEmpty,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: list.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final world = list[index];
                              return Card(
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                  leading: Icon(
                                    SettingPacks.of(world.style).icon,
                                    color: SettingPacks.of(world.style)
                                        .palette(
                                            Theme.of(context).brightness)
                                        .ember,
                                  ),
                                  title: Text(world.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  subtitle: _WorldMeta(world: world),
                                  trailing: PopupMenuButton<String>(
                                    tooltip: context.l10n.worldActions,
                                    onSelected: (action) => switch (action) {
                                      'edit' =>
                                        _editWorld(context, ref, world),
                                      _ => _deleteWorld(context, ref, world),
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 'edit',
                                          child: Text(
                                              context.l10n.editWorldTitle)),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text(context.l10n.delete,
                                            style: TextStyle(
                                                color: GmhColors.danger)),
                                      ),
                                    ],
                                  ),
                                  onTap: () =>
                                      _openWorld(context, ref, world),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _createWorld(context, ref),
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.createNewWorld),
                ),
                const SizedBox(height: 8),
                // A world from another device or a backup file.
                OutlinedButton.icon(
                  onPressed: () => importWorldArchive(context, ref),
                  icon: const Icon(Icons.file_open_outlined),
                  label: Text(context.l10n.importArchiveTitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Description (when set) and a meta line: setting, size, last edit.
class _WorldMeta extends ConsumerWidget {
  final World world;
  const _WorldMeta({required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts =
        ref.watch(entityCountsProvider(world.id)).valueOrNull ?? const {};
    final total = counts.values.fold(0, (a, b) => a + b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (world.description.isNotEmpty)
          Text(world.description,
              maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(
          [
            world.style.localizedName(context),
            context.l10n.entriesCount(total),
            context.l10n
                .worldEdited(localizedTimeAgo(context, world.updatedAt)),
          ].join(' · '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11.5, color: GmhColors.parchmentFaint),
        ),
      ],
    );
  }
}
