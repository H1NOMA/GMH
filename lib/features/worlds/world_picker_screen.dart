import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';

import '../../domain/models/world.dart';
import '../../domain/repositories/repositories.dart';
import '../shell/ui_providers.dart';

/// Entry screen: pick, create or import a world.
class _StyleChoice extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  const _StyleChoice({
    required this.label,
    required this.hint,
    required this.icon,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? accent : GmhColors.border,
            width: selected ? 1.8 : 1,
          ),
          color: selected
              ? accent.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: accent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(hint,
                      style: TextStyle(
                          fontSize: 11.5, color: GmhColors.parchmentDim)),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, size: 18, color: accent),
          ],
        ),
      ),
    );
  }
}

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
    var style = WorldStyle.fantasy;
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.createWorldTitle),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: context.l10n.worldNameLabel,
                      hintText: context.l10n.worldNameHint),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: context.l10n.worldDescriptionLabel),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(context.l10n.worldStyleLabel,
                      style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                _StyleChoice(
                  label: context.l10n.worldStyleFantasy,
                  hint: context.l10n.worldStyleFantasyHint,
                  icon: Icons.auto_stories,
                  accent: gmhDarkPalette.ember,
                  selected: style == WorldStyle.fantasy,
                  onTap: () =>
                      setDialogState(() => style = WorldStyle.fantasy),
                ),
                const SizedBox(height: 8),
                _StyleChoice(
                  label: context.l10n.worldStyleCyberpunk,
                  hint: context.l10n.worldStyleCyberpunkHint,
                  icon: Icons.memory,
                  accent: gmhCyberDarkPalette.ember,
                  selected: style == WorldStyle.cyberpunk,
                  onTap: () =>
                      setDialogState(() => style = WorldStyle.cyberpunk),
                ),
              ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.create)),
          ],
        ),
      ),
    );
    if (created != true || nameController.text.trim().isEmpty) return;

    final world = await ref.read(worldRepositoryProvider).createWorld(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          style: style,
        );
    if (context.mounted) await _openWorld(context, ref, world);
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
                                    world.style == WorldStyle.cyberpunk
                                        ? Icons.memory
                                        : Icons.public,
                                    color:
                                        world.style == WorldStyle.cyberpunk
                                            ? gmhCyberDarkPalette.ember
                                            : GmhColors.ember,
                                  ),
                                  title: Text(world.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  subtitle: Text(
                                    world.description.isEmpty
                                        ? context.l10n.worldEdited(
                                            localizedTimeAgo(
                                                context, world.updatedAt))
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
                  label: Text(context.l10n.createNewWorld),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
