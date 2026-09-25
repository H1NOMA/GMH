import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../app/theme_provider.dart';
import '../../app/tools.dart';
import '../../core/constants.dart';
import '../../core/utils/debouncer.dart';
import '../../domain/models/entity.dart';
import '../categories/category_ui.dart';
import '../entities/widgets/new_entity_dialog.dart';
import 'ui_providers.dart';
import 'workspace_tabs.dart';

/// Scores how well [query] matches [candidate] as a case-insensitive
/// subsequence ("nwen" → "New entry"); null when it doesn't match.
/// Consecutive runs, word starts and an early first hit score higher.
double? fuzzyScore(String query, String candidate) {
  final q = query.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  if (q.isEmpty) return 0;
  final c = candidate.toLowerCase();
  var score = 0.0;
  var from = 0;
  var previous = -2;
  for (final char in q.split('')) {
    final at = c.indexOf(char, from);
    if (at < 0) return null;
    score += 1;
    if (at == previous + 1) score += 2; // consecutive
    if (at == 0 || c[at - 1] == ' ' || c[at - 1] == '-') score += 1.5;
    if (previous < 0) score -= at * 0.05; // an early first hit
    previous = at;
    from = at + 1;
  }
  return score - (c.length - q.length) * 0.01;
}

/// A runnable palette item.
class _PaletteItem {
  final IconData icon;
  final Color? color;
  final String label;
  final String? detail;
  final FutureOr<void> Function() run;

  const _PaletteItem({
    required this.icon,
    required this.label,
    required this.run,
    this.color,
    this.detail,
  });
}

/// Ctrl+P: one box to jump anywhere — entries by name, sections, tools —
/// or run a command (new entry, theme, backup…), all from the keyboard.
///
/// [appRef] must outlive the palette: commands run after it has closed.
Future<void> showCommandPalette(BuildContext context,
    {required String worldId, required WidgetRef appRef}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: context.l10n.paletteTitle,
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 90),
    pageBuilder: (context, _, _) =>
        _CommandPalette(worldId: worldId, appRef: appRef),
  );
}

class _CommandPalette extends ConsumerStatefulWidget {
  final String worldId;
  final WidgetRef appRef;
  const _CommandPalette({required this.worldId, required this.appRef});

  @override
  ConsumerState<_CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends ConsumerState<_CommandPalette> {
  final _query = TextEditingController();
  final _debouncer = Debouncer(GmhConstants.searchDebounce);
  List<Entity> _matches = const [];
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _query.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _query.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    setState(() => _selected = 0);
    final text = _query.text.trim();
    if (text.isEmpty) {
      setState(() => _matches = const []);
      return;
    }
    _debouncer(() async {
      final found = await ref
          .read(entityRepositoryProvider)
          .lookupByName(widget.worldId, text, limit: 8);
      if (!mounted || _query.text.trim() != text) return;
      setState(() => _matches = found);
    });
  }

  List<_PaletteItem> _commands(BuildContext context) {
    final l = context.l10n;
    final worldId = widget.worldId;
    final tabs = ref.read(workspaceTabsProvider.notifier);
    final theme = ref.read(themeModeProvider.notifier);
    // Captured now: the palette is closed (and this context gone) by the
    // time a command runs.
    final router = GoRouter.of(context);
    final navigatorContext =
        Navigator.of(context, rootNavigator: true).context;
    void open(String location) => tabs.openInNewTab(location);
    return [
      _PaletteItem(
          icon: Icons.add_circle_outline,
          label: l.newEntryTitle,
          run: () =>
              showNewEntityDialog(navigatorContext, widget.appRef, worldId)),
      _PaletteItem(
          icon: Icons.dashboard_outlined,
          label: l.navHome,
          run: () => open(Routes.home(worldId))),
      _PaletteItem(
          icon: Icons.search,
          label: l.navSearch,
          run: () => open(Routes.search(worldId))),
      _PaletteItem(
          icon: Icons.hub_outlined,
          label: l.navGraph,
          run: () => open(Routes.graph(worldId))),
      _PaletteItem(
          icon: Icons.handyman_outlined,
          label: l.navTools,
          run: () => open(Routes.tools(worldId))),
      for (final tool in gmhTools)
        _PaletteItem(
            icon: tool.icon,
            label: tool.label(l),
            detail: tool.description(l),
            run: () => open(Routes.tool(worldId, tool.id))),
      _PaletteItem(
          icon: Icons.settings_outlined,
          label: l.navSettings,
          run: () => open(Routes.settings(worldId))),
      _PaletteItem(
          icon: Icons.delete_outline,
          label: l.trashTitle,
          run: () => open(Routes.trash(worldId))),
      _PaletteItem(
          icon: Icons.help_outline,
          label: l.helpTitle,
          run: () => open(Routes.help(worldId))),
      _PaletteItem(
          icon: Icons.contrast,
          label: l.paletteToggleTheme,
          run: () {
            final dark = Theme.of(navigatorContext).brightness ==
                Brightness.dark;
            return theme.setMode(dark ? ThemeMode.light : ThemeMode.dark);
          }),
      _PaletteItem(
          icon: Icons.public,
          label: l.switchWorld,
          run: () => router.go(Routes.worlds())),
    ];
  }

  List<_PaletteItem> _items(BuildContext context) {
    final query = _query.text.trim();
    final categories = ref.watch(categoryMapProvider(widget.worldId));
    final tabs = ref.read(workspaceTabsProvider.notifier);
    final search = ref.read(searchRepositoryProvider);
    _PaletteItem entryItem(Entity e) => _PaletteItem(
          icon: entityIcon(e, categories),
          color: entityColor(e, categories),
          label: e.name,
          detail: typeLabel(context, e.kind, e.customCategoryId, categories),
          run: () {
            search.recordOpened(e.id);
            tabs.openInNewTab(Routes.entity(widget.worldId, e.id));
          },
        );

    final commands = _commands(context);
    if (query.isEmpty) {
      final recent =
          ref.watch(recentEntitiesProvider(widget.worldId)).valueOrNull ??
              const [];
      return [...recent.take(6).map(entryItem), ...commands];
    }
    final scored = [
      for (final c in commands)
        if (fuzzyScore(query, c.label) case final double s) (c, s)
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return [
      ..._matches.map(entryItem),
      ...scored.map((e) => e.$1),
    ];
  }

  Future<void> _run(_PaletteItem item) async {
    Navigator.of(context).pop();
    await item.run();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items(context);
    final selected = items.isEmpty ? 0 : _selected.clamp(0, items.length - 1);

    return Align(
      alignment: const Alignment(0, -0.6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 460),
          child: Material(
            color: GmhColors.surfaceRaised,
            elevation: 12,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                    setState(() => _selected =
                        items.isEmpty ? 0 : (selected + 1) % items.length),
                const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                    setState(() => _selected = items.isEmpty
                        ? 0
                        : (selected - 1 + items.length) % items.length),
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _query,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: context.l10n.paletteHint,
                        prefixIcon: const Icon(Icons.bolt, size: 18),
                      ),
                      onSubmitted: (_) {
                        if (items.isNotEmpty) _run(items[selected]);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Flexible(
                    child: items.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(context.l10n.paletteNoMatches,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: GmhColors.parchmentDim)),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ListTile(
                                dense: true,
                                selected: index == selected,
                                selectedTileColor:
                                    GmhColors.ember.withValues(alpha: 0.12),
                                leading: Icon(item.icon,
                                    size: 18,
                                    color: item.color ?? GmhColors.parchmentDim),
                                title: Text(item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                subtitle: item.detail == null
                                    ? null
                                    : Text(item.detail!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11)),
                                onTap: () => _run(item),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
