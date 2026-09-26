import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../app/tools.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/utils/save_flush.dart';
import '../../../domain/combat/combatant.dart';
import '../../../domain/combat/encounter.dart';
import '../../../domain/combat/turn_order.dart';
import '../../../domain/models/entity_kind.dart';
import '../../../domain/models/world_object.dart';
import '../../entities/widgets/entity_picker_dialog.dart';
import '../../shell/ui_providers.dart';
import '../tool_scaffold.dart';
import 'combat_actions.dart';
import 'combat_dialogs.dart';
import 'combat_screen.dart';
import 'combatant_row.dart';
import 'difficulty_panel.dart';

/// The initiative tracker of one encounter.
class EncounterTracker extends ConsumerWidget {
  final String worldId;
  final String encounterId;

  const EncounterTracker(
      {super.key, required this.worldId, required this.encounterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final encounterAsync = ref.watch(worldObjectProvider(encounterId));
    final combatantsAsync = ref.watch(worldObjectsProvider((
      worldId: worldId,
      type: WorldObjectTypes.combatant,
      parentId: encounterId,
    )));
    final object = encounterAsync.valueOrNull;
    if (object == null || object.type != WorldObjectTypes.encounter) {
      final loading = encounterAsync.isLoading && !encounterAsync.hasValue;
      return ToolScaffold(
        toolId: 'combat',
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ToolEmptyState(
                icon: toolById('combat')!.icon,
                title: l.combatNotFound,
                hint: '',
                action: FilledButton.tonal(
                  onPressed: () => context.go(Routes.tool(worldId, 'combat')),
                  child: Text(l.combatAllEncounters),
                ),
              ),
      );
    }
    final encounter = Encounter.fromObject(object);
    final combatants = sortCombatants([
      for (final o in combatantsAsync.valueOrNull ?? const <WorldObject>[])
        Combatant.fromObject(o),
    ]);

    return ToolScaffold(
      toolId: 'combat',
      title: encounter.name,
      actions: [
        IconButton(
          tooltip: l.combatAllEncounters,
          icon: const Icon(Icons.format_list_bulleted),
          onPressed: () => context.go(Routes.tool(worldId, 'combat')),
        ),
        EncounterMenu(
          encounter: encounter,
          combatants: combatants,
          onDeleted: () => context.go(Routes.tool(worldId, 'combat')),
        ),
      ],
      body: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 980;
        final main = <Widget>[
          _TurnBar(encounter: encounter, combatants: combatants),
          const SizedBox(height: 12),
          _AddBar(encounter: encounter, combatants: combatants),
          const SizedBox(height: 12),
          if (combatants.isEmpty)
            _InlineHint(
              title: l.combatNoCombatants,
              hint: l.combatNoCombatantsHint,
            )
          else
            ..._rows(encounter, combatants),
        ];
        final side = <Widget>[
          _PanelCard(
            child: DifficultyPanel(
                encounter: encounter, combatants: combatants),
          ),
          const SizedBox(height: 12),
          _PanelCard(child: _NotesField(encounter: encounter)),
        ];
        if (!wide) {
          final gutter = math.max(16.0, (constraints.maxWidth - 900) / 2);
          return ListView(
            padding: EdgeInsets.fromLTRB(gutter, 12, gutter, 40),
            children: [...main, const SizedBox(height: 20), ...side],
          );
        }
        final gutter =
            math.max(16.0, (constraints.maxWidth - 360 - 1100) / 2);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(gutter, 12, 16, 40),
                children: main,
              ),
            ),
            Container(
              width: 360,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: GmhColors.border)),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                children: side,
              ),
            ),
          ],
        );
      }),
    );
  }

  Iterable<Widget> _rows(Encounter encounter, List<Combatant> sorted) sync* {
    final activeIndex = encounter.status == EncounterStatus.active
        ? resolveTurnIndex(sorted, encounter.turnIndex, encounter.activeId)
        : -1;
    for (var i = 0; i < sorted.length; i++) {
      yield Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CombatantRow(
          key: ValueKey('row-${sorted[i].id}'),
          combatant: sorted[i],
          active: i == activeIndex,
          all: sorted,
        ),
      );
    }
  }
}

class _PanelCard extends StatelessWidget {
  final Widget child;
  const _PanelCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GmhColors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GmhColors.border),
      ),
      child: child,
    );
  }
}

class _InlineHint extends StatelessWidget {
  final String title;
  final String hint;
  const _InlineHint({required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      child: Column(
        children: [
          Icon(toolById('combat')!.icon,
              size: 36, color: GmhColors.parchmentFaint),
          const SizedBox(height: 10),
          Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(hint,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: GmhColors.parchmentDim)),
        ],
      ),
    );
  }
}

/// Round counter, whose turn it is, and the combat controls.
class _TurnBar extends ConsumerWidget {
  final Encounter encounter;
  final List<Combatant> combatants;

  const _TurnBar({required this.encounter, required this.combatants});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final actions = ref.read(combatActionsProvider);
    final running = encounter.status == EncounterStatus.active;
    final current = running && combatants.isNotEmpty
        ? combatants[resolveTurnIndex(
            combatants, encounter.turnIndex, encounter.activeId)]
        : null;
    final hasMonsters = combatants.any((c) => !c.isPlayer);
    return _PanelCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CombatBadge(
            key: const ValueKey('combat-round'),
            label: running
                ? l.combatRound(encounter.round)
                : encounterStatusLabel(l, encounter.status),
            color: encounterStatusColor(encounter.status),
            icon: running ? Icons.loop : null,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              current != null ? l.combatTurnOf(current.name) : l.combatNotStarted,
              key: const ValueKey('combat-current-turn'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: current != null ? FontWeight.w600 : null,
                color: current != null ? null : GmhColors.parchmentDim,
              ),
            ),
          ),
          if (running) ...[
            IconButton.outlined(
              key: const ValueKey('combat-previous'),
              tooltip: l.combatPreviousTurn,
              // As tall as the filled and outlined buttons beside it: their
              // minimum size, at the theme's density.
              style: IconButton.styleFrom(
                minimumSize: const Size.square(42),
                visualDensity: Theme.of(context).visualDensity,
              ),
              onPressed: combatants.isEmpty
                  ? null
                  : () => actions.rewindTurn(encounter, combatants),
              icon: const Icon(Icons.skip_previous, size: 20),
            ),
            FilledButton.icon(
              key: const ValueKey('combat-next'),
              onPressed: combatants.isEmpty
                  ? null
                  : () => actions.advanceTurn(encounter, combatants),
              icon: const Icon(Icons.skip_next, size: 18),
              label: Text(l.combatNextTurn),
            ),
            OutlinedButton(
              key: const ValueKey('combat-end'),
              onPressed: () => actions.endCombat(encounter),
              child: Text(l.combatEnd),
            ),
          ] else
            FilledButton.icon(
              key: const ValueKey('combat-start'),
              onPressed: combatants.isEmpty
                  ? null
                  : () => actions.beginCombat(encounter, combatants),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: Text(l.combatStart),
            ),
          Tooltip(
            message: l.combatRollInitiativeHint,
            child: OutlinedButton.icon(
              key: const ValueKey('combat-roll'),
              onPressed: hasMonsters
                  ? () => actions.rollMonsterInitiative(combatants)
                  : null,
              icon: const Icon(Icons.casino_outlined, size: 18),
              label: Text(l.combatRollInitiative),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Add from world" and "Add manually".
class _AddBar extends ConsumerWidget {
  final Encounter encounter;
  final List<Combatant> combatants;

  const _AddBar({required this.encounter, required this.combatants});

  Future<void> _fromWorld(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final entity = await showEntityPickerDialog(context,
        worldId: encounter.worldId,
        kinds: const [EntityKind.creature, EntityKind.character],
        title: l.combatPickTitle);
    if (entity == null || !context.mounted) return;
    final quantity = await showQuantityDialog(context, entity.name);
    if (quantity == null || !context.mounted) return;
    final actions = ref.read(combatActionsProvider);
    await actions.addCombatants(
      encounter,
      actions.draftsFromEntity(entity,
          quantity: quantity,
          encounter: encounter,
          existing: [for (final c in combatants) c.name]),
    );
  }

  Future<void> _manually(BuildContext context, WidgetRef ref) async {
    final draft = await showCombatantEditor(context);
    if (draft == null || !context.mounted) return;
    await ref.read(combatActionsProvider).addCombatants(encounter, [draft]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.tonalIcon(
          key: const ValueKey('combat-add-world'),
          onPressed: () => _fromWorld(context, ref),
          icon: const Icon(Icons.travel_explore, size: 18),
          label: Text(l.combatAddFromWorld),
        ),
        OutlinedButton.icon(
          key: const ValueKey('combat-add-manual'),
          onPressed: () => _manually(context, ref),
          icon: const Icon(Icons.edit_note, size: 18),
          label: Text(l.combatAddManually),
        ),
      ],
    );
  }
}

/// Encounter notes, saved as the user types (debounced; flushed when the
/// page closes or the project is saved).
class _NotesField extends ConsumerStatefulWidget {
  final Encounter encounter;
  const _NotesField({required this.encounter});

  @override
  ConsumerState<_NotesField> createState() => _NotesFieldState();
}

class _NotesFieldState extends ConsumerState<_NotesField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.encounter.notes);
  final _focus = FocusNode();
  final _debouncer = Debouncer(const Duration(milliseconds: 600));
  late final CombatActions _actions;
  late Encounter _latest = widget.encounter;

  /// Typed text not yet written: incoming stream values must not replace it.
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _actions = ref.read(combatActionsProvider);
    saveFlushHooks.add(_flush);
    _focus.addListener(() {
      if (!_focus.hasFocus) unawaited(_flush());
    });
  }

  @override
  void didUpdateWidget(_NotesField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _latest = widget.encounter;
    if (!_dirty &&
        !_focus.hasFocus &&
        widget.encounter.notes != _controller.text) {
      _controller.text = widget.encounter.notes;
    }
  }

  Future<void> _save() {
    _dirty = false;
    return _actions.saveEncounter(_latest.copyWith(notes: _controller.text));
  }

  Future<void> _flush() async {
    var pending = false;
    _debouncer.flush(() => pending = true);
    if (pending) await _save();
  }

  @override
  void dispose() {
    saveFlushHooks.remove(_flush);
    _debouncer.flush(() => unawaited(_save()));
    _debouncer.dispose();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.sticky_note_2_outlined,
                size: 18, color: GmhColors.ember),
            const SizedBox(width: 8),
            Expanded(
              child: Text(l.combatNotes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          key: const ValueKey('combat-notes'),
          controller: _controller,
          focusNode: _focus,
          minLines: 3,
          maxLines: 10,
          decoration: InputDecoration(hintText: l.combatNotesHint),
          onChanged: (_) {
            _dirty = true;
            _debouncer(() => unawaited(_save()));
          },
        ),
      ],
    );
  }
}
