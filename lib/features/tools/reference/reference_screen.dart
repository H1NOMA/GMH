import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../core/widgets/field_action_row.dart';
import '../../../domain/combat/combatant.dart';
import '../../../domain/combat/encounter.dart';
import '../../../domain/combat/turn_order.dart';
import '../../../domain/dice/dice_engine.dart';
import '../../../domain/gm_screen/gm_screen_state.dart';
import '../../../domain/models/world_object.dart';
import '../../../domain/reference/conditions.dart';
import '../../../domain/reference/rules_reference.dart';
import '../../../domain/tables/random_table.dart';
import '../../../domain/tables/table_roller.dart';
import '../../categories/category_ui.dart';
import '../../entities/widgets/entity_picker_dialog.dart';
import '../../shell/ui_providers.dart';
import '../dice/dice_providers.dart';
import '../tool_scaffold.dart';

/// The GM screen: everything needed at the table on one page — the
/// running fight, pinned entries, session notes, quick dice and tables,
/// and a rules reference. Panels can be hidden; the layout flows into as
/// many columns as the window allows.
class ReferenceScreen extends ConsumerStatefulWidget {
  final String worldId;

  const ReferenceScreen({super.key, required this.worldId});

  @override
  ConsumerState<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends ConsumerState<ReferenceScreen> {
  WorldObject? _object;

  WorldObjectQuery get _query => (
    worldId: widget.worldId,
    type: WorldObjectTypes.gmScreen,
    parentId: null,
  );

  /// Writes the state; the first write creates the world's screen object.
  Future<void> _save(GmScreenState state) async {
    final repo = ref.read(worldObjectRepositoryProvider);
    final existing = _object;
    if (existing == null) {
      _object = await repo.create(
        worldId: widget.worldId,
        type: WorldObjectTypes.gmScreen,
        data: state.toData(),
      );
    } else {
      _object = await repo.update(existing.copyWith(data: state.toData()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final objects = ref.watch(worldObjectsProvider(_query));
    _object = objects.valueOrNull?.firstOrNull ?? _object;
    final state = GmScreenState.fromObject(_object);

    final panels = <GmPanel, Widget>{
      GmPanel.encounter: _EncounterPanel(worldId: widget.worldId),
      GmPanel.pinned: _PinnedPanel(
        worldId: widget.worldId,
        state: state,
        onChanged: _save,
      ),
      GmPanel.notes: _NotesPanel(
        key: ValueKey(_object?.id),
        state: state,
        onChanged: _save,
      ),
      GmPanel.dice: const _DicePanel(),
      GmPanel.tables: _TablesPanel(
        worldId: widget.worldId,
        state: state,
        onChanged: _save,
      ),
      GmPanel.conditions: const _ConditionsPanel(),
      GmPanel.rules: const _RulesPanel(),
    };
    final visible = [
      for (final p in GmPanel.values)
        if (!state.hidden.contains(p)) panels[p]!,
    ];

    return ToolScaffold(
      toolId: 'reference',
      actions: [
        PopupMenuButton<GmPanel>(
          key: const ValueKey('gm-panels'),
          tooltip: l.gmScreenPanels,
          icon: const Icon(Icons.dashboard_customize_outlined),
          onSelected: (panel) {
            final hidden = {...state.hidden};
            if (!hidden.remove(panel)) hidden.add(panel);
            _save(state.copyWith(hidden: hidden));
          },
          itemBuilder: (context) => [
            for (final p in GmPanel.values)
              CheckedPopupMenuItem(
                value: p,
                checked: !state.hidden.contains(p),
                child: Text(_panelTitle(l, p)),
              ),
          ],
        ),
      ],
      body: objects.isLoading && _object == null
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final columns = (constraints.maxWidth / 380).floor().clamp(
                  1,
                  4,
                );
                // Round-robin into columns: a masonry-like flow without
                // forcing every panel to the height of its row.
                final lanes = List.generate(columns, (_) => <Widget>[]);
                for (var i = 0; i < visible.length; i++) {
                  lanes[i % columns].add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: visible[i],
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < columns; i++) ...[
                            if (i > 0) const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: lanes[i],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!state.hidden.contains(GmPanel.conditions) ||
                          !state.hidden.contains(GmPanel.rules))
                        Tooltip(
                          message: srdAttribution,
                          child: Text(
                            l.gmScreenAttribution,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: GmhColors.parchmentFaint,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

String _panelTitle(AppLocalizations l, GmPanel panel) => switch (panel) {
  GmPanel.encounter => l.gmScreenEncounter,
  GmPanel.pinned => l.gmScreenPinned,
  GmPanel.notes => l.gmScreenNotes,
  GmPanel.dice => l.gmScreenDice,
  GmPanel.tables => l.gmScreenTables,
  GmPanel.conditions => l.gmScreenConditions,
  GmPanel.rules => l.gmScreenRules,
};

/// A titled card; [trailing] sits at the right of the title.
class _Panel extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Widget child;

  const _Panel({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fixed height: headers line up across columns whether or not
            // they carry a button.
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Icon(icon, size: 18, color: GmhColors.ember),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}

class _EncounterPanel extends ConsumerWidget {
  final String worldId;
  const _EncounterPanel({required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final encounters = [
      for (final o
          in ref
                  .watch(
                    worldObjectsProvider((
                      worldId: worldId,
                      type: WorldObjectTypes.encounter,
                      parentId: null,
                    )),
                  )
                  .valueOrNull ??
              const <WorldObject>[])
        Encounter.fromObject(o),
    ];
    final active = encounters
        .where((e) => e.status == EncounterStatus.active)
        .firstOrNull;
    final combatants = active == null
        ? const <Combatant>[]
        : sortCombatants([
            for (final o
                in ref
                        .watch(
                          worldObjectsProvider((
                            worldId: worldId,
                            type: WorldObjectTypes.combatant,
                            parentId: active.id,
                          )),
                        )
                        .valueOrNull ??
                    const <WorldObject>[])
              Combatant.fromObject(o),
          ]);
    final turn = active == null
        ? -1
        : resolveTurnIndex(combatants, active.turnIndex, active.activeId);

    return _Panel(
      icon: Icons.sports_martial_arts_outlined,
      title: active == null
          ? l.gmScreenEncounter
          : '${active.name} · ${l.gmScreenRound(active.round)}',
      trailing: TextButton(
        onPressed: () => context.go(Routes.tool(worldId, 'combat', active?.id)),
        child: Text(l.gmScreenOpenTracker),
      ),
      child: active == null
          ? Text(
              l.gmScreenNoFight,
              style: TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, c) in combatants.indexed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: i == turn
                          ? GmhColors.ember.withValues(alpha: 0.14)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '${c.initiative ?? '–'}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: GmhColors.parchmentDim,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            c.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              decoration: c.defeated
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: c.defeated
                                  ? GmhColors.parchmentFaint
                                  : GmhColors.parchment,
                            ),
                          ),
                        ),
                        if (c.hpMax > 0)
                          Text(
                            '${c.hpCurrent}/${c.hpMax}',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.hpCurrent * 4 <= c.hpMax
                                  ? GmhColors.danger
                                  : GmhColors.parchmentDim,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _PinnedPanel extends ConsumerWidget {
  final String worldId;
  final GmScreenState state;
  final Future<void> Function(GmScreenState) onChanged;

  const _PinnedPanel({
    required this.worldId,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final categories = ref.watch(categoryMapProvider(worldId));
    return _Panel(
      icon: Icons.push_pin_outlined,
      title: l.gmScreenPinned,
      trailing: IconButton(
        key: const ValueKey('gm-add-pin'),
        tooltip: l.gmScreenAddPin,
        icon: const Icon(Icons.add, size: 20),
        onPressed: () async {
          final entity = await showEntityPickerDialog(
            context,
            worldId: worldId,
            excludeIds: state.pinnedEntities.toSet(),
            title: l.gmScreenAddPin,
          );
          if (entity == null) return;
          await onChanged(
            state.copyWith(
              pinnedEntities: [...state.pinnedEntities, entity.id],
            ),
          );
        },
      ),
      child: state.pinnedEntities.isEmpty
          ? Text(
              l.gmScreenPinHint,
              style: TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final id in state.pinnedEntities)
                  if (ref.watch(entityProvider(id)).valueOrNull
                      case final entity? when !entity.isDeleted)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        entityIcon(entity, categories),
                        color: entityColor(entity, categories),
                        size: 20,
                      ),
                      title: Text(
                        entity.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: entity.summary.isEmpty
                          ? null
                          : Text(
                              entity.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                      trailing: IconButton(
                        tooltip: l.gmScreenUnpin,
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => onChanged(
                          state.copyWith(
                            pinnedEntities: [
                              for (final p in state.pinnedEntities)
                                if (p != id) p,
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        ref.read(searchRepositoryProvider).recordOpened(id);
                        context.go(Routes.entity(worldId, id));
                      },
                    ),
              ],
            ),
    );
  }
}

class _NotesPanel extends StatefulWidget {
  final GmScreenState state;
  final Future<void> Function(GmScreenState) onChanged;

  const _NotesPanel({super.key, required this.state, required this.onChanged});

  @override
  State<_NotesPanel> createState() => _NotesPanelState();
}

class _NotesPanelState extends State<_NotesPanel> {
  late final _text = TextEditingController(text: widget.state.notes);
  Timer? _debounce;

  void _schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _flush);
  }

  void _flush() {
    _debounce?.cancel();
    if (_text.text != widget.state.notes) {
      widget.onChanged(widget.state.copyWith(notes: _text.text));
    }
  }

  @override
  void dispose() {
    // Typed-but-unsaved notes are written on the way out.
    if (_debounce?.isActive ?? false) _flush();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _Panel(
      icon: Icons.edit_note_outlined,
      title: l.gmScreenNotes,
      child: TextField(
        controller: _text,
        minLines: 5,
        maxLines: 14,
        onChanged: (_) => _schedule(),
        decoration: InputDecoration(hintText: l.gmScreenNotesHint),
      ),
    );
  }
}

class _DicePanel extends ConsumerStatefulWidget {
  const _DicePanel();

  @override
  ConsumerState<_DicePanel> createState() => _DicePanelState();
}

class _DicePanelState extends ConsumerState<_DicePanel> {
  final _expression = TextEditingController(text: '1d20');
  DiceRollResult? _result;
  String? _error;

  @override
  void dispose() {
    _expression.dispose();
    super.dispose();
  }

  void _roll([String? expression]) {
    if (expression != null) _expression.text = expression;
    try {
      final result = DiceEngine(
        random: ref.read(diceRandomProvider),
      ).roll(_expression.text);
      setState(() {
        _result = result;
        _error = null;
      });
    } on DiceParseException {
      setState(() => _error = '⚠');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _Panel(
      icon: Icons.casino_outlined,
      title: l.gmScreenDice,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldActionRow(
            error: _error,
            field: TextField(
              key: const ValueKey('gm-dice-expression'),
              controller: _expression,
              onSubmitted: (_) => _roll(),
              decoration: InputDecoration(
                error: _error == null ? null : FieldActionRow.errorMarker,
              ),
            ),
            actions: [
              FilledButton(
                key: const ValueKey('gm-dice-roll'),
                onPressed: _roll,
                child: Text(l.gmScreenRoll),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final die in [
                '1d4',
                '1d6',
                '1d8',
                '1d10',
                '1d12',
                '1d20',
                '2d6',
                '1d100',
              ])
                ActionChip(label: Text(die), onPressed: () => _roll(die)),
            ],
          ),
          if (_result case final r?) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${r.total}',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: GmhColors.ember),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    r.breakdown,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: GmhColors.parchmentDim,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TablesPanel extends ConsumerStatefulWidget {
  final String worldId;
  final GmScreenState state;
  final Future<void> Function(GmScreenState) onChanged;

  const _TablesPanel({
    required this.worldId,
    required this.state,
    required this.onChanged,
  });

  @override
  ConsumerState<_TablesPanel> createState() => _TablesPanelState();
}

class _TablesPanelState extends ConsumerState<_TablesPanel> {
  final _results = <String, String>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tables = [
      for (final o
          in ref
                  .watch(
                    worldObjectsProvider((
                      worldId: widget.worldId,
                      type: WorldObjectTypes.randomTable,
                      parentId: null,
                    )),
                  )
                  .valueOrNull ??
              const <WorldObject>[])
        RandomTable.fromObject(o),
    ];
    final byId = {for (final t in tables) t.id: t};
    final pinned = [
      for (final id in widget.state.pinnedTables)
        if (byId[id] != null) byId[id]!,
    ];
    final unpinned = [
      for (final t in tables)
        if (!widget.state.pinnedTables.contains(t.id)) t,
    ];

    return _Panel(
      icon: Icons.table_rows_outlined,
      title: l.gmScreenTables,
      trailing: unpinned.isEmpty
          ? null
          : PopupMenuButton<String>(
              key: const ValueKey('gm-add-table'),
              tooltip: l.gmScreenAddTable,
              icon: const Icon(Icons.add, size: 20),
              onSelected: (id) => widget.onChanged(
                widget.state.copyWith(
                  pinnedTables: [...widget.state.pinnedTables, id],
                ),
              ),
              itemBuilder: (context) => [
                for (final t in unpinned)
                  PopupMenuItem(
                    key: ValueKey('gm-add-table-${t.id}'),
                    value: t.id,
                    child: Text(t.name),
                  ),
              ],
            ),
      child: tables.isEmpty
          ? Text(
              l.gmScreenNoTables,
              style: TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final table in pinned)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                table.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              key: ValueKey('gm-table-roll-${table.id}'),
                              onPressed: () {
                                final roller = TableRoller.forTables(
                                  tables,
                                  random: ref.read(diceRandomProvider),
                                );
                                final result = roller.roll(table);
                                setState(
                                  () => _results[table.id] = result.text,
                                );
                              },
                              child: Text(l.gmScreenRoll),
                            ),
                            IconButton(
                              tooltip: l.gmScreenUnpin,
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () => widget.onChanged(
                                widget.state.copyWith(
                                  pinnedTables: [
                                    for (final p in widget.state.pinnedTables)
                                      if (p != table.id) p,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_results[table.id] case final text?)
                          SelectableText(
                            text,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: GmhColors.parchment,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (pinned.isEmpty)
                  Text(
                    l.gmScreenAddTable,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: GmhColors.parchmentDim,
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ConditionsPanel extends StatelessWidget {
  const _ConditionsPanel();

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return _Panel(
      icon: Icons.healing_outlined,
      title: context.l10n.gmScreenConditions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in srdConditions)
            Theme(
              // No divider lines between the tiles of a dense list.
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                minTileHeight: 34,
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                title: Text(
                  c.name(lang),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                children: [
                  Text(
                    localized(conditionRules[c.id]!, lang),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: GmhColors.parchmentDim,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RulesPanel extends StatelessWidget {
  const _RulesPanel();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    TextStyle dim() => TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim);
    return _Panel(
      icon: Icons.rule_outlined,
      title: l.gmScreenRules,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.gmScreenDifficulty,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          for (final (label, dc) in difficultyLadder)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                children: [
                  Expanded(child: Text(localized(label, lang), style: dim())),
                  Text(
                    '$dc',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: GmhColors.ember,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Text(
            l.gmScreenCover,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          for (final (name, effect) in coverRules)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${localized(name, lang)}: ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: localized(effect, lang)),
                  ],
                ),
                style: dim(),
              ),
            ),
        ],
      ),
    );
  }
}
