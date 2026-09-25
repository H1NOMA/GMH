import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/combat/combatant.dart';
import '../../../domain/combat/hit_points.dart';
import '../../../domain/reference/conditions.dart';
import 'combat_actions.dart';
import 'combat_dialogs.dart';
import 'difficulty_panel.dart';

/// One combatant in the initiative list: initiative, name, AC, hit points
/// with a quick damage / heal / temp input, conditions and toggles.
class CombatantRow extends ConsumerStatefulWidget {
  final Combatant combatant;

  /// It is this combatant's turn.
  final bool active;

  /// Every combatant of the encounter (for numbering duplicates).
  final List<Combatant> all;

  const CombatantRow({
    super.key,
    required this.combatant,
    required this.active,
    required this.all,
  });

  @override
  ConsumerState<CombatantRow> createState() => _CombatantRowState();
}

class _CombatantRowState extends ConsumerState<CombatantRow> {
  final _amount = TextEditingController();
  final _initiative = TextEditingController();
  final _initiativeFocus = FocusNode();

  Combatant get _c => widget.combatant;

  @override
  void initState() {
    super.initState();
    _initiative.text = _initiativeText(_c.initiative);
    _initiativeFocus.addListener(() {
      if (!_initiativeFocus.hasFocus) _commitInitiative();
    });
  }

  @override
  void didUpdateWidget(CombatantRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.combatant.initiative != _c.initiative &&
        !_initiativeFocus.hasFocus) {
      _initiative.text = _initiativeText(_c.initiative);
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _initiative.dispose();
    _initiativeFocus.dispose();
    super.dispose();
  }

  static String _initiativeText(num? value) {
    if (value == null) return '';
    return value == value.roundToDouble() ? '${value.round()}' : '$value';
  }

  CombatActions get _actions => ref.read(combatActionsProvider);

  void _commitInitiative() {
    if (!mounted) return;
    final text = _initiative.text.trim();
    final value = text.isEmpty ? null : num.tryParse(text);
    if (text.isNotEmpty && value == null) {
      _initiative.text = _initiativeText(_c.initiative);
      return;
    }
    if (value == _c.initiative) return;
    _actions.saveCombatant(_c.copyWith(initiative: () => value));
  }

  void _snack(String message) {
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _applyAmount(String kind) async {
    final amount = int.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) return;
    final l = context.l10n;
    _amount.clear();
    switch (kind) {
      case 'damage':
        final result = applyDamage(_c, amount);
        await _actions.saveCombatant(result.combatant);
        if (!mounted) return;
        if (result.becameDefeated) _snack(l.combatDefeatedNotice(_c.name));
        if (result.concentrationDc case final dc?) {
          _snack(l.combatConcentrationCheck(_c.name, dc));
        }
      case 'heal':
        await _actions.saveCombatant(applyHeal(_c, amount));
      case 'temp':
        await _actions.saveCombatant(applyTempHp(_c, amount));
    }
  }

  Future<void> _editDuration(CombatCondition condition, String label) async {
    final l = context.l10n;
    final result = await showCombatNumberDialog(context,
        title: l.combatConditionDurationTitle(label),
        label: l.combatConditionRounds,
        initial: condition.rounds,
        allowEmpty: true);
    if (result == null || !mounted) return;
    await _actions.saveCombatant(_c.copyWith(conditions: [
      for (final c in _c.conditions)
        c.id == condition.id ? c.withRounds(result.value) : c,
    ]));
  }

  Future<void> _menu(String action) async {
    switch (action) {
      case 'edit':
        final edited = await showCombatantEditor(context, initial: _c);
        if (edited == null || !mounted) return;
        await _actions.saveCombatant(edited);
      case 'duplicate':
        await _actions.duplicateCombatant(_c, widget.all);
      case 'remove':
        await _actions.removeCombatant(_c.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = _c;
    final accent = GmhColors.ember;
    final language = Localizations.localeOf(context).languageCode;
    return Opacity(
      opacity: c.defeated ? 0.5 : 1,
      child: Container(
        key: ValueKey('combatant-${c.id}'),
        decoration: BoxDecoration(
          color: widget.active
              ? accent.withValues(alpha: 0.10)
              : GmhColors.surfaceRaised,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.active ? accent : GmhColors.border,
            width: widget.active ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(8, 8, 4, 10),
        child: LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final indent = compact ? 0.0 : 64.0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerRow(context, l, compact: compact),
              const SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.only(left: indent, right: 8),
                child: _hitPointsRow(context, l, compact: compact),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.only(left: indent, right: 8),
                child: _conditionsRow(context, l, language),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _headerRow(BuildContext context, AppLocalizations l,
      {required bool compact}) {
    final c = _c;
    final linked = c.entityId != null;
    final details = [
      if (c.cr.isNotEmpty) 'CR ${c.cr}',
      if (c.xp > 0) '${formatXp(context, c.xp)} ${l.combatXp}',
      if (c.isPlayer) l.combatPlayer,
    ].join(' · ');
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Tooltip(
            message: l.combatInitiative,
            child: TextField(
              key: ValueKey('combat-initiative-${c.id}'),
              controller: _initiative,
              focusNode: _initiativeFocus,
              textAlign: TextAlign.center,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
              ],
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.active ? GmhColors.ember : null),
              decoration: const InputDecoration(
                isDense: true,
                hintText: '—',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              ),
              onSubmitted: (_) => _commitInitiative(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: linked
                ? () => context.go(Routes.entity(c.worldId, c.entityId!))
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.active) ...[
                        Icon(Icons.play_arrow_rounded,
                            size: 18, color: GmhColors.ember),
                        const SizedBox(width: 2),
                      ],
                      if (c.isPlayer) ...[
                        Icon(Icons.person_outline,
                            size: 15, color: GmhColors.parchmentDim),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            decoration: c.defeated
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      if (linked) ...[
                        const SizedBox(width: 4),
                        Tooltip(
                          message: l.combatOpenEntry,
                          child: Icon(Icons.link,
                              size: 14, color: GmhColors.parchmentFaint),
                        ),
                      ],
                    ],
                  ),
                  if (details.isNotEmpty)
                    Text(details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11.5, color: GmhColors.parchmentDim)),
                ],
              ),
            ),
          ),
        ),
        Tooltip(
          message: l.combatArmorClass,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined,
                    size: 16, color: GmhColors.parchmentDim),
                const SizedBox(width: 3),
                Text(c.ac?.toString() ?? '–',
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        if (!compact) ..._toggles(l),
        PopupMenuButton<String>(
          key: ValueKey('combat-menu-${c.id}'),
          tooltip: l.combatActions,
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: _menu,
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text(l.combatEdit)),
            PopupMenuItem(value: 'duplicate', child: Text(l.combatDuplicate)),
            PopupMenuItem(value: 'remove', child: Text(l.combatRemove)),
          ],
        ),
      ],
    );
  }

  List<Widget> _toggles(AppLocalizations l) {
    final c = _c;
    return [
      IconButton(
        key: ValueKey('combat-concentration-${c.id}'),
        tooltip: l.combatConcentration,
        visualDensity: VisualDensity.compact,
        isSelected: c.concentration,
        color: GmhColors.parchmentFaint,
        selectedIcon: Icon(Icons.psychology, color: GmhColors.arcane),
        icon: const Icon(Icons.psychology_outlined),
        onPressed: () => _actions
            .saveCombatant(c.copyWith(concentration: !c.concentration)),
      ),
      IconButton(
        key: ValueKey('combat-defeated-${c.id}'),
        tooltip: l.combatDefeated,
        visualDensity: VisualDensity.compact,
        isSelected: c.defeated,
        color: GmhColors.parchmentFaint,
        selectedIcon: Icon(Icons.heart_broken, color: GmhColors.danger),
        icon: const Icon(Icons.heart_broken_outlined),
        onPressed: () =>
            _actions.saveCombatant(c.copyWith(defeated: !c.defeated)),
      ),
    ];
  }

  Widget _hitPointsRow(BuildContext context, AppLocalizations l,
      {required bool compact}) {
    final c = _c;
    final fraction =
        c.hpMax > 0 ? (c.hpCurrent / c.hpMax).clamp(0.0, 1.0) : 0.0;
    final barColor = fraction > 0.5
        ? GmhColors.success
        : fraction > 0.25
            ? GmhColors.ember
            : GmhColors.danger;
    final dense = ButtonStyle(
      visualDensity: VisualDensity.compact,
      padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10)),
      minimumSize: const WidgetStatePropertyAll(Size(0, 34)),
    );
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 120, maxWidth: 180),
          child: Tooltip(
            message: '${l.combatHpCurrent} / ${l.combatHpMax}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, size: 13, color: barColor),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        c.hpMax > 0
                            ? '${c.hpCurrent} / ${c.hpMax}'
                            : '${c.hpCurrent}',
                        key: ValueKey('combat-hp-${c.id}'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (c.hpTemp > 0) ...[
                      const SizedBox(width: 6),
                      Text('+${c.hpTemp}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: GmhColors.arcane)),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 6,
                      color: barColor,
                      backgroundColor: GmhColors.surfaceHigh,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 72,
          child: TextField(
            key: ValueKey('combat-amount-${c.id}'),
            controller: _amount,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              isDense: true,
              hintText: l.combatAmountHint,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
            ),
            onSubmitted: (_) => _applyAmount('damage'),
          ),
        ),
        TextButton.icon(
          key: ValueKey('combat-damage-${c.id}'),
          style: dense.merge(
              TextButton.styleFrom(foregroundColor: GmhColors.danger)),
          onPressed: () => _applyAmount('damage'),
          icon: const Icon(Icons.remove_circle_outline, size: 16),
          label: Text(l.combatDamage),
        ),
        TextButton.icon(
          key: ValueKey('combat-heal-${c.id}'),
          style: dense.merge(
              TextButton.styleFrom(foregroundColor: GmhColors.success)),
          onPressed: () => _applyAmount('heal'),
          icon: const Icon(Icons.add_circle_outline, size: 16),
          label: Text(l.combatHeal),
        ),
        TextButton.icon(
          key: ValueKey('combat-temp-${c.id}'),
          style: dense.merge(
              TextButton.styleFrom(foregroundColor: GmhColors.arcane)),
          onPressed: () => _applyAmount('temp'),
          icon: const Icon(Icons.shield_moon_outlined, size: 16),
          label: Text(l.combatTemp),
        ),
        if (compact) ..._toggles(l),
      ],
    );
  }

  Widget _conditionsRow(
      BuildContext context, AppLocalizations l, String language) {
    final c = _c;
    String nameOf(String id) => conditionById(id)?.name(language) ?? id;
    final available = [
      for (final condition in srdConditions)
        if (!c.hasCondition(condition.id)) condition,
    ];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final condition in c.conditions)
          InputChip(
            key: ValueKey('combat-condition-${c.id}-${condition.id}'),
            visualDensity: VisualDensity.compact,
            label: Text(condition.rounds == null
                ? nameOf(condition.id)
                : '${nameOf(condition.id)} · ${condition.rounds}'),
            avatar: condition.rounds == null
                ? null
                : Icon(Icons.hourglass_bottom, size: 14,
                    color: GmhColors.ember),
            deleteButtonTooltipMessage: l.combatRemoveCondition,
            onPressed: () => _editDuration(condition, nameOf(condition.id)),
            onDeleted: () => _actions.saveCombatant(c.copyWith(conditions: [
              for (final other in c.conditions)
                if (other.id != condition.id) other,
            ])),
          ),
        if (available.isNotEmpty)
          PopupMenuButton<String>(
            key: ValueKey('combat-add-condition-${c.id}'),
            tooltip: l.combatAddCondition,
            position: PopupMenuPosition.under,
            constraints: BoxConstraints(
              minWidth: 180,
              maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            ),
            onSelected: (id) => _actions.saveCombatant(c.copyWith(
                conditions: [...c.conditions, CombatCondition(id)])),
            itemBuilder: (context) => [
              for (final condition in available)
                PopupMenuItem(
                  value: condition.id,
                  height: 38,
                  child: Text(condition.name(language)),
                ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: GmhColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 15, color: GmhColors.parchmentDim),
                  const SizedBox(width: 4),
                  Text(l.combatAddCondition,
                      style: TextStyle(
                          fontSize: 12.5, color: GmhColors.parchmentDim)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
