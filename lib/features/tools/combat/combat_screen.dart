import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../app/tools.dart';
import '../../../domain/combat/combatant.dart';
import '../../../domain/combat/difficulty.dart';
import '../../../domain/combat/encounter.dart';
import '../../../domain/models/world_object.dart';
import '../../shell/ui_providers.dart';
import '../tool_scaffold.dart';
import 'combat_actions.dart';
import 'combat_dialogs.dart';
import 'difficulty_panel.dart';
import 'encounter_tracker.dart';

/// Combat tracker: the world's encounters, or — with [encounterId] — the
/// initiative tracker of one encounter.
class CombatScreen extends StatelessWidget {
  final String worldId;
  final String? encounterId;

  const CombatScreen({super.key, required this.worldId, this.encounterId});

  @override
  Widget build(BuildContext context) {
    final id = encounterId;
    if (id == null) return _EncounterList(worldId: worldId);
    return EncounterTracker(worldId: worldId, encounterId: id);
  }
}

String encounterStatusLabel(AppLocalizations l, EncounterStatus status) =>
    switch (status) {
      EncounterStatus.planning => l.combatStatusPlanning,
      EncounterStatus.active => l.combatStatusActive,
      EncounterStatus.finished => l.combatStatusFinished,
    };

Color encounterStatusColor(EncounterStatus status) => switch (status) {
      EncounterStatus.planning => GmhColors.parchmentDim,
      EncounterStatus.active => GmhColors.ember,
      EncounterStatus.finished => GmhColors.success,
    };

/// Asks for a name and opens the new encounter.
Future<void> createEncounterFlow(
    BuildContext context, WidgetRef ref, String worldId, int existing) async {
  final l = context.l10n;
  final name = await showCombatNameDialog(
    context,
    title: l.combatNewEncounter,
    initial: l.combatEncounterDefaultName(existing + 1),
    confirmLabel: l.create,
  );
  if (name == null || !context.mounted) return;
  final encounter =
      await ref.read(combatActionsProvider).createEncounter(worldId, name);
  if (!context.mounted) return;
  context.go(Routes.tool(worldId, 'combat', encounter.id));
}

class _EncounterList extends ConsumerWidget {
  final String worldId;
  const _EncounterList({required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final tool = toolById('combat')!;
    final encounters = ref.watch(worldObjectsProvider((
      worldId: worldId,
      type: WorldObjectTypes.encounter,
      parentId: null,
    )));
    final combatants = ref.watch(worldObjectsProvider((
      worldId: worldId,
      type: WorldObjectTypes.combatant,
      parentId: null,
    )));
    final byEncounter = <String, List<Combatant>>{};
    for (final object in combatants.valueOrNull ?? const <WorldObject>[]) {
      final c = Combatant.fromObject(object);
      byEncounter.putIfAbsent(c.encounterId, () => []).add(c);
    }
    final list = [
      for (final o in encounters.valueOrNull ?? const <WorldObject>[])
        Encounter.fromObject(o),
    ];

    return ToolScaffold(
      toolId: 'combat',
      actions: [
        IconButton(
          key: const ValueKey('combat-new-encounter'),
          tooltip: l.combatNewEncounter,
          icon: const Icon(Icons.add),
          onPressed: () =>
              createEncounterFlow(context, ref, worldId, list.length),
        ),
      ],
      body: encounters.isLoading && !encounters.hasValue
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? ToolEmptyState(
                  icon: tool.icon,
                  title: l.combatEmptyTitle,
                  hint: l.combatEmptyHint,
                  action: FilledButton.icon(
                    onPressed: () =>
                        createEncounterFlow(context, ref, worldId, 0),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l.combatNewEncounter),
                  ),
                )
              : LayoutBuilder(builder: (context, constraints) {
                  final side = ((constraints.maxWidth - 900) / 2)
                      .clamp(16.0, double.infinity);
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(side, 12, side, 40),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final encounter = list[index];
                      return _EncounterCard(
                        encounter: encounter,
                        combatants: byEncounter[encounter.id] ?? const [],
                      );
                    },
                  );
                }),
    );
  }
}

class _EncounterCard extends StatelessWidget {
  final Encounter encounter;
  final List<Combatant> combatants;

  const _EncounterCard({required this.encounter, required this.combatants});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final result = rateCombatants(encounter, combatants);
    return Card(
      key: ValueKey('encounter-${encounter.id}'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(
            Routes.tool(encounter.worldId, 'combat', encounter.id)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GmhColors.ember.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(toolById('combat')!.icon,
                    size: 22, color: GmhColors.ember),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(encounter.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CombatBadge(
                          label: encounterStatusLabel(l, encounter.status),
                          color: encounterStatusColor(encounter.status),
                        ),
                        if (encounter.status != EncounterStatus.planning)
                          Text(l.combatRound(encounter.round),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: GmhColors.parchmentDim)),
                        Text(l.combatCombatantCount(combatants.length),
                            style: TextStyle(
                                fontSize: 12, color: GmhColors.parchmentDim)),
                        DifficultyBadge(result: result),
                      ],
                    ),
                  ],
                ),
              ),
              EncounterMenu(encounter: encounter, combatants: combatants),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rename / duplicate / delete, shared by the list and the tracker.
class EncounterMenu extends ConsumerWidget {
  final Encounter encounter;
  final List<Combatant> combatants;

  /// Where to go after the encounter was deleted (the tracker returns to
  /// the list); null stays put.
  final VoidCallback? onDeleted;

  const EncounterMenu({
    super.key,
    required this.encounter,
    required this.combatants,
    this.onDeleted,
  });

  Future<void> _handle(BuildContext context, WidgetRef ref, String action) async {
    final l = context.l10n;
    final actions = ref.read(combatActionsProvider);
    switch (action) {
      case 'rename':
        final name = await showCombatNameDialog(context,
            title: l.combatRenameTitle,
            initial: encounter.name,
            confirmLabel: l.save);
        if (name == null || !context.mounted) return;
        await actions.saveEncounter(encounter.copyWith(name: name));
      case 'duplicate':
        final copy = await actions.duplicateEncounter(
            encounter, combatants, l.combatCopyName(encounter.name));
        if (!context.mounted) return;
        context.go(Routes.tool(encounter.worldId, 'combat', copy.id));
      case 'delete':
        final ok = await confirmDeleteEncounter(context, encounter.name);
        if (!ok || !context.mounted) return;
        onDeleted?.call();
        await actions.deleteEncounter(encounter.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      key: ValueKey('encounter-menu-${encounter.id}'),
      tooltip: l.combatEncounterActions,
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => _handle(context, ref, action),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'rename', child: Text(l.rename)),
        PopupMenuItem(value: 'duplicate', child: Text(l.combatDuplicate)),
        PopupMenuItem(value: 'delete', child: Text(l.delete)),
      ],
    );
  }
}
