import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/generators/generator_engine.dart';
import '../../../domain/models/world.dart';
import '../../shell/ui_providers.dart';
import '../tool_scaffold.dart';
import 'generators_l10n.dart';
import 'generators_state.dart';
import 'generators_widgets.dart';

/// Width from which the picker becomes a side panel.
const _wideLayout = 840.0;

/// Quick generators: names, NPCs, settlements, taverns, hooks, loot,
/// factions, weather and rumors in the world's genre, with per-line
/// rerolls, pinning and one-click saving into the world.
class GeneratorsScreen extends ConsumerStatefulWidget {
  final String worldId;

  const GeneratorsScreen({super.key, required this.worldId});

  @override
  ConsumerState<GeneratorsScreen> createState() => _GeneratorsScreenState();
}

class _GeneratorsScreenState extends ConsumerState<GeneratorsScreen> {
  /// Result ids / name keys being saved right now.
  final Set<String> _saving = {};

  GeneratorsController get _controller =>
      ref.read(generatorsProvider(widget.worldId).notifier);

  String get _language => GeneratorEngine.normalizeLanguage(
    Localizations.localeOf(context).languageCode,
  );

  WorldStyle _worldStyle() =>
      ref.read(worldProvider(widget.worldId)).valueOrNull?.style ??
      WorldStyle.fantasy;

  void _generate() {
    final state = ref.read(generatorsProvider(widget.worldId));
    _controller.generate(state.style ?? _worldStyle(), _language);
  }

  Future<void> _copy(String text) async {
    final messenger = ScaffoldMessenger.of(context);
    final copied = context.l10n.generatorsCopied;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(copied)));
  }

  Future<void> _save(String key, EntityDraft draft) async {
    if (_saving.contains(key)) return;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final service = ref.read(entityServiceProvider);
    final controller = _controller;
    final worldId = widget.worldId;
    setState(() => _saving.add(key));
    final result = await service.create(
      worldId: worldId,
      kind: draft.kind,
      name: draft.name,
      summary: draft.summary,
      attributes: draft.attributes,
    );
    if (!mounted) return;
    setState(() => _saving.remove(key));
    if (result.isErr) {
      messenger.showSnackBar(
        SnackBar(content: Text(localizedError(context, result.error))),
      );
      return;
    }
    final entity = result.value;
    controller.markSaved(key, entity.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l.generatorsSaved(entity.name)),
          action: SnackBarAction(
            label: l.open,
            onPressed: () => router.go(Routes.entity(worldId, entity.id)),
          ),
        ),
      );
  }

  void _saveResult(GeneratedResult r) {
    final l = context.l10n;
    final draft = ref
        .read(generatorEngineProvider)
        .toEntity(r, (key) => generatorFieldLabel(l, key, kind: r.kind));
    _save(r.id, draft);
  }

  void _saveName(NameBatch batch, int index) {
    final draft = ref
        .read(generatorEngineProvider)
        .nameToEntity(batch.names[index], batch.style, batch.language);
    _save(GeneratorsState.nameKey(batch, index), draft);
  }

  void _open(String entityId) =>
      context.go(Routes.entity(widget.worldId, entityId));

  String _resultText(GeneratedResult r) {
    final l = context.l10n;
    return r.toText(
      (key) => generatorFieldLabel(l, key, kind: r.kind),
      heading: generatorKindLabel(l, r.kind),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(generatorsProvider(widget.worldId));
    final worldStyle =
        ref.watch(worldProvider(widget.worldId)).valueOrNull?.style ??
        WorldStyle.fantasy;
    final style = state.style ?? worldStyle;

    return ToolScaffold(
      toolId: 'generators',
      body: LayoutBuilder(
        builder: (context, constraints) {
          final options = _Options(
            state: state,
            style: style,
            worldStyle: worldStyle,
            cultures: ref
                .read(generatorEngineProvider)
                .cultures(style, _language),
            controller: _controller,
          );
          final generate = FilledButton.icon(
            key: const ValueKey('gen-generate'),
            onPressed: _generate,
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: Text(l.generatorsGenerate),
          );
          final results = _results(context, state);

          if (constraints.maxWidth >= _wideLayout) {
            final panelWidth = (constraints.maxWidth * 0.26).clamp(
              260.0,
              340.0,
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: panelWidth,
                  child: ListView(
                    key: const ValueKey('gen-picker'),
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 32),
                    children: [
                      for (final kind in GeneratorKind.values)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: GeneratorKindTile(
                            kind: kind,
                            selected: kind == state.kind,
                            onTap: () => _controller.select(kind),
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: options,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: generate,
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: ListView(
                    key: const ValueKey('gen-results'),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    children: [
                      for (final w in results)
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 860),
                            child: w,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }
          return ListView(
            key: const ValueKey('gen-results'),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              _KindChips(selected: state.kind, onSelected: _controller.select),
              const SizedBox(height: 12),
              options,
              const SizedBox(height: 12),
              generate,
              const SizedBox(height: 16),
              ...results,
            ],
          );
        },
      ),
    );
  }

  List<Widget> _results(BuildContext context, GeneratorsState state) {
    final l = context.l10n;
    final engine = ref.read(generatorEngineProvider);
    String packName(WorldStyle style) => style.localizedName(context);
    Widget card(GeneratedResult r, {bool dismissible = false}) =>
        GeneratorResultCard(
          key: ValueKey('gen-result-${r.id}'),
          result: r,
          packName: packName(r.style),
          kept: state.isKept(r.id),
          saving: _saving.contains(r.id),
          savedEntityId: state.saved[r.id],
          onRerollField: (key) => _controller.rerollField(r.id, key),
          onRerollAll: () => _controller.rerollAll(r.id),
          onCopy: () => _copy(_resultText(r)),
          onKeep: () => _controller.toggleKeep(r.id),
          onSave: () => _saveResult(r),
          onOpen: () => _open(state.saved[r.id]!),
          onDismiss: dismissible ? () => _controller.dismiss(r.id) : null,
        );

    final current = state.currentResult;
    final names = state.names;
    final Widget main;
    if (state.kind == GeneratorKind.names) {
      if (names == null) {
        main = const GeneratorEmptyHint(kind: GeneratorKind.names);
      } else {
        final labels = {
          for (final c in engine.cultures(names.style, names.language))
            c.id: c.label,
        };
        main = GeneratorNamesCard(
          batch: names,
          packName: packName(names.style),
          cultureLabels: labels,
          saved: state.saved,
          saving: _saving,
          onCopyAll: () => _copy(names.names.map((n) => n.toText()).join('\n')),
          onCopy: (i) => _copy(names.names[i].toText()),
          onSave: (i) => _saveName(names, i),
          onOpen: _open,
        );
      }
    } else {
      main = current == null
          ? GeneratorEmptyHint(kind: state.kind)
          : card(current);
    }

    final kept = [
      for (final r in state.kept)
        if (r.id != current?.id) r,
    ];
    return [
      main,
      if (kept.isNotEmpty) ...[
        const SizedBox(height: 20),
        GeneratorSectionHeader(
          icon: Icons.push_pin_outlined,
          title: l.generatorsKept,
          count: kept.length,
        ),
        const SizedBox(height: 8),
        for (final r in kept.reversed) ...[
          card(r, dismissible: true),
          const SizedBox(height: 12),
        ],
      ],
      const SizedBox(height: 20),
      GeneratorSectionHeader(
        icon: Icons.history,
        title: l.generatorsHistory,
        count: state.history.length,
        trailing: state.history.isEmpty
            ? null
            : TextButton(
                key: const ValueKey('gen-history-clear'),
                onPressed: _controller.clearHistory,
                child: Text(l.clear),
              ),
      ),
      const SizedBox(height: 8),
      if (state.history.isEmpty)
        Text(
          l.generatorsHistoryEmpty,
          style: TextStyle(fontSize: 13, color: GmhColors.parchmentDim),
        )
      else
        for (var i = 0; i < state.history.length; i++) ...[
          GeneratorHistoryTile(
            key: ValueKey('gen-history-entry-${state.history[i].id}'),
            index: i,
            entry: state.history[i],
            packName: packName(state.history[i].style),
            onRestore: () => _controller.restore(state.history[i].id),
          ),
          const SizedBox(height: 8),
        ],
    ];
  }
}

/// The picker as a row of chips on narrow screens.
class _KindChips extends StatelessWidget {
  final GeneratorKind selected;
  final ValueChanged<GeneratorKind> onSelected;

  const _KindChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SingleChildScrollView(
      key: const ValueKey('gen-kind-chips'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final kind in GeneratorKind.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: ValueKey('gen-kind-${kind.name}'),
                avatar: Icon(generatorKindIcon(kind), size: 16),
                label: Text(generatorKindLabel(l, kind)),
                selected: kind == selected,
                showCheckmark: false,
                onSelected: (_) => onSelected(kind),
              ),
            ),
        ],
      ),
    );
  }
}

/// Pack selector and, for names, gender, naming style, count and epithets.
class _Options extends StatelessWidget {
  final GeneratorsState state;
  final WorldStyle style;
  final WorldStyle worldStyle;
  final List<NameCulture> cultures;
  final GeneratorsController controller;

  const _Options({
    required this.state,
    required this.style,
    required this.worldStyle,
    required this.cultures,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sectionStyle = generatorSectionStyle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyedSubtree(
          key: const ValueKey('gen-pack'),
          child: DropdownButtonFormField<WorldStyle>(
            key: ValueKey('gen-pack-${style.name}'),
            value: style,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l.generatorsPack,
              isDense: true,
            ),
            items: [
              for (final s in WorldStyle.values)
                DropdownMenuItem(
                  value: s,
                  child: Text(
                    s == worldStyle
                        ? l.generatorsPackWorld(s.localizedName(context))
                        : s.localizedName(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (s) =>
                controller.setStyle(s == null || s == worldStyle ? null : s),
          ),
        ),
        if (state.kind == GeneratorKind.names) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            key: ValueKey('gen-culture-${style.name}'),
            value: cultures.any((c) => c.id == state.cultureId)
                ? state.cultureId
                : null,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l.generatorsCulture,
              isDense: true,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(
                  l.generatorsCultureAny,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (final c in cultures)
                DropdownMenuItem<String?>(
                  value: c.id,
                  child: Text(
                    c.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: controller.setCulture,
          ),
          const SizedBox(height: 12),
          Text(l.generatorsGender.toUpperCase(), style: sectionStyle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final g in NameGender.values)
                ChoiceChip(
                  key: ValueKey('gen-gender-${g.name}'),
                  label: Text(generatorGenderLabel(l, g)),
                  selected: state.gender == g,
                  onSelected: (_) => controller.setGender(g),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.generatorsCount.toUpperCase(), style: sectionStyle),
                  const SizedBox(width: 4),
                  IconButton(
                    key: const ValueKey('gen-count-minus'),
                    tooltip: '−',
                    icon: const Icon(Icons.remove, size: 18),
                    visualDensity: VisualDensity.compact,
                    onPressed: state.count > 1
                        ? () => controller.setCount(state.count - 1)
                        : null,
                  ),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${state.count}',
                      key: const ValueKey('gen-count'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('gen-count-plus'),
                    tooltip: '+',
                    icon: const Icon(Icons.add, size: 18),
                    visualDensity: VisualDensity.compact,
                    onPressed: state.count < 10
                        ? () => controller.setCount(state.count + 1)
                        : null,
                  ),
                ],
              ),
              FilterChip(
                key: const ValueKey('gen-epithets'),
                label: Text(l.generatorsEpithets),
                selected: state.epithets,
                onSelected: controller.setEpithets,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
