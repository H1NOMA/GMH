import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/world.dart';
import '../../domain/repositories/repositories.dart';
import '../shell/ui_providers.dart';

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
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create a New World'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: 'World name', hintText: 'e.g. The Aurion Realms'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Description (optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create')),
        ],
      ),
    );
    if (created != true || nameController.text.trim().isEmpty) return;

    final world = await ref.read(worldRepositoryProvider).createWorld(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
        );
    if (context.mounted) await _openWorld(context, ref, world);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worlds = ref.watch(worldsProvider);

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
                Text(GmhConstants.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 4),
                Text('Your worlds, entirely yours — stored on this device.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 28),
                Flexible(
                  child: worlds.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Could not load worlds: $e'),
                    data: (list) => list.isEmpty
                        ? Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'No worlds yet. Forge your first one below.',
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
                                  leading: const Icon(Icons.public,
                                      color: GmhColors.ember),
                                  title: Text(world.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  subtitle: Text(
                                    world.description.isEmpty
                                        ? 'Edited ${timeAgo(world.updatedAt)}'
                                        : world.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
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
                  label: const Text('Create New World'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
