import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/dice/dice_engine.dart';
import '../../../domain/dice/dice_history.dart';
import '../../../domain/dice/dice_presets.dart';
import '../tool_scaffold.dart';
import 'dice_l10n.dart';
import 'dice_providers.dart';
import 'dice_widgets.dart';
import 'preset_dialog.dart';

const _quickDice = [4, 6, 8, 10, 12, 20, 100];

/// Dice roller: free notation, quick dice, system presets and the world's
/// roll log.
class DiceScreen extends ConsumerStatefulWidget {
  final String worldId;

  const DiceScreen({super.key, required this.worldId});

  @override
  ConsumerState<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends ConsumerState<DiceScreen> {
  final _expression = TextEditingController();
  final _label = TextEditingController();
  final _expressionFocus = FocusNode();
  final _resultKey = GlobalKey();

  RollMode _mode = RollMode.normal;
  int _modifier = 0;
  DiceParseException? _error;
  ShownRoll? _shown;

  @override
  void dispose() {
    _expression.dispose();
    _label.dispose();
    _expressionFocus.dispose();
    super.dispose();
  }

  void _show(ShownRoll shown) {
    setState(() {
      _shown = shown;
      _error = null;
    });
    logDiceRoll(ref, widget.worldId, shown.toEntry());
    // On narrow layouts the card may be scrolled away (history re-rolls,
    // presets at the bottom): bring the fresh result into view.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardContext = _resultKey.currentContext;
      if (!mounted || cardContext == null) return;
      Scrollable.ensureVisible(cardContext,
          duration: const Duration(milliseconds: 200),
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart);
    });
  }

  /// Rolls [text] with the advantage and modifier options applied.
  void _roll(String text) {
    try {
      final expression = DiceEngine.parse(text)
          .withOptions(mode: _mode, modifier: _modifier);
      final roll = expression.evaluate(ref.read(diceRandomProvider));
      _show(ShownRoll(roll, label: _label.text.trim()));
    } on DiceParseException catch (e) {
      setState(() => _error = e);
    }
  }

  void _submitExpression() {
    _roll(_expression.text);
    _expressionFocus.requestFocus();
  }

  void _appendDie(int sides) {
    final current = _expression.text.trim();
    final text = current.isEmpty ? '1d$sides' : '$current + 1d$sides';
    _expression.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() => _error = null);
  }

  Future<void> _preset(DicePresetKind kind) async {
    Map<String, Object?>? params = const {};
    if (kind != DicePresetKind.abilityScore) {
      params = await showDicePresetDialog(context, kind);
    }
    if (params == null || !mounted) return;
    final result =
        DicePresets(random: ref.read(diceRandomProvider)).run(kind, params);
    _show(ShownRoll.preset(result, label: _label.text.trim()));
  }

  void _reroll(DiceHistoryEntry entry) {
    final random = ref.read(diceRandomProvider);
    final preset = entry.preset;
    try {
      _show(preset != null
          ? ShownRoll.preset(
              DicePresets(random: random).run(preset, entry.params),
              label: entry.label)
          : ShownRoll(DiceEngine(random: random).roll(entry.expression),
              label: entry.label));
    } on DiceParseException catch (e) {
      setState(() => _error = e);
    }
  }

  Future<void> _copy(DiceHistoryEntry entry) async {
    final messenger = ScaffoldMessenger.of(context);
    final copied = context.l10n.diceCopied;
    await Clipboard.setData(ClipboardData(text: entry.shareText));
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(copied)));
  }

  Future<void> _confirmClear() async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.diceClearHistoryTitle),
        content: SizedBox(width: 420, child: Text(l.diceClearHistoryBody)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.diceClearHistory),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await DiceHistory.clear(
        ref.read(worldObjectRepositoryProvider), widget.worldId);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final history = ref.watch(diceHistoryProvider(widget.worldId));
    final entries = history.valueOrNull ?? const <DiceHistoryEntry>[];

    return ToolScaffold(
      toolId: 'dice',
      actions: [
        IconButton(
          tooltip: l.diceClearHistory,
          icon: const Icon(Icons.delete_sweep_outlined),
          onPressed: entries.isEmpty ? null : _confirmClear,
        ),
      ],
      body: LayoutBuilder(builder: (context, constraints) {
        final roller = _roller(context);
        if (constraints.maxWidth >= 900) {
          final historyWidth = (constraints.maxWidth * 0.36).clamp(320.0, 520.0);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: roller,
                    ),
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: historyWidth,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      sliver: SliverToBoxAdapter(
                          child: _HistoryHeader(count: entries.length)),
                    ),
                    ..._historySlivers(entries),
                  ],
                ),
              ),
            ],
          );
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(child: roller),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(
                  child: _HistoryHeader(count: entries.length)),
            ),
            ..._historySlivers(entries),
          ],
        );
      }),
    );
  }

  List<Widget> _historySlivers(List<DiceHistoryEntry> entries) {
    if (entries.isEmpty) {
      return [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          sliver: SliverToBoxAdapter(
            child: Text(context.l10n.diceHistoryEmpty,
                style: TextStyle(fontSize: 13, color: GmhColors.parchmentDim)),
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        sliver: SliverList.separated(
          itemCount: entries.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _HistoryTile(
              key: ValueKey(entry.id),
              entry: entry,
              onReroll: () => _reroll(entry),
              onCopy: () => _copy(entry),
            );
          },
        ),
      ),
    ];
  }

  Widget _roller(BuildContext context) {
    final l = context.l10n;
    final sectionStyle = TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: GmhColors.parchmentDim);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DiceResultCard(key: _resultKey, shown: _shown),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('dice-expression'),
                controller: _expression,
                focusNode: _expressionFocus,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: l.diceExpressionLabel,
                  hintText: l.diceExpressionHint,
                  errorText: _error == null ? null : diceErrorText(l, _error!),
                  errorMaxLines: 2,
                  prefixIcon: const Icon(Icons.casino_outlined, size: 20),
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                onSubmitted: (_) => _submitExpression(),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: FilledButton(
                key: const ValueKey('dice-roll'),
                onPressed: _submitExpression,
                style: FilledButton.styleFrom(
                    minimumSize: const Size(64, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 16)),
                child: Text(l.diceRollAction),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final sides in _quickDice)
              OutlinedButton(
                key: ValueKey('dice-quick-$sides'),
                onPressed: () => _roll('1d$sides'),
                onLongPress: () => _appendDie(sides),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(56, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('d$sides',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(l.diceQuickHint,
            style: TextStyle(fontSize: 11.5, color: GmhColors.parchmentFaint)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilterChip(
              label: Text(l.diceAdvantage),
              selected: _mode == RollMode.advantage,
              onSelected: (on) => setState(
                  () => _mode = on ? RollMode.advantage : RollMode.normal),
            ),
            FilterChip(
              label: Text(l.diceDisadvantage),
              selected: _mode == RollMode.disadvantage,
              onSelected: (on) => setState(
                  () => _mode = on ? RollMode.disadvantage : RollMode.normal),
            ),
            DiceStepper(
              label: l.diceModifier,
              value: _modifier,
              onChanged: (v) => setState(() => _modifier = v),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: TextField(
                controller: _label,
                decoration: InputDecoration(
                  hintText: l.diceLabelHint,
                  isDense: true,
                  prefixIcon: const Icon(Icons.label_outline, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(l.dicePresets.toUpperCase(), style: sectionStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final kind in DicePresetKind.values)
              ActionChip(
                key: ValueKey('dice-preset-${kind.name}'),
                avatar: Icon(dicePresetIcon(kind),
                    size: 16, color: GmhColors.ember),
                label: Text(dicePresetName(l, kind)),
                onPressed: () => _preset(kind),
              ),
          ],
        ),
      ],
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final int count;
  const _HistoryHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.history, size: 18, color: GmhColors.parchmentDim),
        const SizedBox(width: 8),
        Flexible(
          child: Text(context.l10n.diceHistory,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall),
        ),
        if (count > 0) ...[
          const SizedBox(width: 8),
          Text('$count',
              style: TextStyle(fontSize: 12, color: GmhColors.parchmentFaint)),
        ],
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final DiceHistoryEntry entry;
  final VoidCallback onReroll;
  final VoidCallback onCopy;

  const _HistoryTile({
    super.key,
    required this.entry,
    required this.onReroll,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final title = entry.label.isNotEmpty
        ? entry.label
        : entry.preset != null
            ? dicePresetName(l, entry.preset!)
            : entry.expression;
    final showExpression = title != entry.expression;
    final summary = diceSummaryText(l,
        preset: entry.preset, outcome: entry.outcome, total: entry.total);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
      decoration: BoxDecoration(
        color: GmhColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GmhColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: GmhColors.ember.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('${entry.total}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: GmhColors.ember)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w600)),
                Text(
                  [
                    if (showExpression) entry.expression,
                    ?summary,
                    localizedTimeAgo(context, entry.createdAt),
                  ].join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 12, color: GmhColors.parchmentDim),
                ),
                if (entry.breakdown.isNotEmpty)
                  Text(entry.breakdown,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.5, color: GmhColors.parchmentFaint)),
              ],
            ),
          ),
          IconButton(
            tooltip: l.diceReroll,
            icon: const Icon(Icons.replay, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: onReroll,
          ),
          IconButton(
            tooltip: l.diceCopy,
            icon: const Icon(Icons.copy_outlined, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}
