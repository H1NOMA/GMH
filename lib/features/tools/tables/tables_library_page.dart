import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/packs/setting_packs.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/world.dart';
import '../../../domain/tables/content/table_library.dart';
import '../../../domain/tables/random_table.dart';
import '../../../domain/tables/table_roller.dart';
import '../../shell/ui_providers.dart';
import '../dice/dice_providers.dart';
import '../tool_scaffold.dart';
import 'tables_actions.dart';
import 'tables_dialogs.dart';
import 'tables_l10n.dart';
import 'tables_result.dart';
import 'tables_screen.dart';

/// Built-in tables of every setting pack, the world's own pack first.
/// Tables are previewed here and copied into the world to be edited.
class TablesLibraryPage extends ConsumerStatefulWidget {
  final String worldId;
  const TablesLibraryPage({super.key, required this.worldId});

  @override
  ConsumerState<TablesLibraryPage> createState() => _TablesLibraryPageState();
}

class _TablesLibraryPageState extends ConsumerState<TablesLibraryPage> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String get _lang => Localizations.localeOf(context).languageCode;

  bool _matches(LibraryTable t) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final lang = _lang;
    return t.name.of(lang).toLowerCase().contains(q) ||
        t.description.of(lang).toLowerCase().contains(q) ||
        t.folder.label.of(lang).toLowerCase().contains(q);
  }

  Future<void> _add(LibraryTable table, List<RandomTable> worldTables) async {
    final l = context.l10n;
    final lang = _lang;
    final actions = ref.read(tablesActionsProvider);
    final messenger = ScaffoldMessenger.of(context);
    final deps = missingDependencies(table, worldTables, lang);
    var extra = const <LibraryTable>[];
    if (deps.isNotEmpty) {
      final chosen = await showLibraryDependenciesDialog(
        context,
        table: table,
        dependencies: deps,
        lang: lang,
      );
      if (chosen == null || !mounted) return;
      extra = chosen;
    }
    final added = await actions.addFromLibrary(widget.worldId, [
      table,
      ...extra,
    ], lang);
    if (!mounted || added.isEmpty) return;
    final router = GoRouter.of(context);
    final target = Routes.tool(widget.worldId, 'tables', added.first.id);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.tablesAddedCount(added.length)),
        action: SnackBarAction(
          label: l.open,
          onPressed: () => router.go(target),
        ),
      ),
    );
  }

  Future<void> _preview(
    LibraryTable table,
    bool inWorld,
    List<RandomTable> worldTables,
  ) async {
    final add = await showDialog<bool>(
      context: context,
      builder: (context) =>
          _PreviewDialog(table: table, lang: _lang, inWorld: inWorld),
    );
    if (add == true && mounted) await _add(table, worldTables);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style =
        ref.watch(worldProvider(widget.worldId)).valueOrNull?.style ??
        WorldStyle.fantasy;
    final worldTables =
        ref.watch(worldTablesProvider(widget.worldId)).valueOrNull ??
        const <RandomTable>[];
    final sources = {for (final t in worldTables) t.source};
    final order = TableLibrary.packOrder(style);
    final searching = _query.trim().isNotEmpty;

    Widget card(LibraryTable t) {
      final inWorld = sources.contains(RandomTableSource.library(t.id));
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _LibraryCard(
          table: t,
          lang: _lang,
          inWorld: inWorld,
          onPreview: () => _preview(t, inWorld, worldTables),
          onAdd: () => _add(t, worldTables),
        ),
      );
    }

    final own = TableLibrary.forStyle(style).where(_matches).toList();
    final children = <Widget>[
      Text(
        l.tablesLibraryHint,
        style: TextStyle(
          fontSize: 13,
          height: 1.4,
          color: GmhColors.parchmentDim,
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        key: const ValueKey('tables-library-search'),
        controller: _search,
        decoration: InputDecoration(
          hintText: l.tablesSearchHint,
          prefixIcon: const Icon(Icons.search, size: 20),
          isDense: true,
        ),
        onChanged: (value) => setState(() => _query = value),
      ),
      const SizedBox(height: 16),
      _SectionTitle(label: l.tablesYourSetting),
      _PackHeader(style: style, count: own.length),
      const SizedBox(height: 8),
      for (final t in own) card(t),
      const SizedBox(height: 16),
      _SectionTitle(label: l.tablesOtherSettings),
      for (final other in order.skip(1))
        if (TableLibrary.forStyle(other).any(_matches))
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: ValueKey('tables-pack-${other.name}-$searching'),
              initiallyExpanded: searching,
              tilePadding: const EdgeInsets.symmetric(horizontal: 4),
              childrenPadding: const EdgeInsets.only(bottom: 8),
              title: _PackHeader(
                style: other,
                count: TableLibrary.forStyle(other).where(_matches).length,
              ),
              children: [
                for (final t in TableLibrary.forStyle(other).where(_matches))
                  card(t),
              ],
            ),
          ),
    ];

    return ToolScaffold(
      toolId: 'tables',
      title: l.tablesLibraryTitle,
      actions: [
        IconButton(
          key: const ValueKey('tables-back'),
          tooltip: l.tablesAllTables,
          icon: const Icon(Icons.view_list_outlined),
          onPressed: () => context.go(Routes.tool(widget.worldId, 'tables')),
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final side = ((constraints.maxWidth - 900) / 2).clamp(
            16.0,
            double.infinity,
          );
          return ListView(
            padding: EdgeInsets.fromLTRB(side, 16, side, 40),
            children: children,
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: GmhColors.parchmentDim,
      ),
    ),
  );
}

class _PackHeader extends StatelessWidget {
  final WorldStyle style;
  final int count;
  const _PackHeader({required this.style, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(SettingPacks.of(style).icon, size: 20, color: GmhColors.ember),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            style.localizedName(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          context.l10n.tablesTableCount(count),
          style: TextStyle(fontSize: 12, color: GmhColors.parchmentFaint),
        ),
      ],
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final LibraryTable table;
  final String lang;
  final bool inWorld;
  final VoidCallback onPreview;
  final VoidCallback onAdd;

  const _LibraryCard({
    required this.table,
    required this.lang,
    required this.inWorld,
    required this.onPreview,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      key: ValueKey('tables-lib-${table.id}'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPreview,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                table.name.of(lang),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                table.description.of(lang),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  color: GmhColors.parchmentDim,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TableTag(
                    label: table.formula.isEmpty
                        ? l.tablesWeighted
                        : table.formula,
                    icon: table.formula.isEmpty
                        ? Icons.balance
                        : Icons.casino_outlined,
                    color: table.formula.isEmpty ? null : GmhColors.ember,
                  ),
                  TableTag(label: l.tablesRowCount(table.rows.length)),
                  TableTag(
                    label: table.folder.label.of(lang),
                    icon: Icons.folder_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    TextButton.icon(
                      key: ValueKey('tables-lib-preview-${table.id}'),
                      onPressed: onPreview,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: Text(l.tablesPreview),
                    ),
                    if (inWorld)
                      TextButton.icon(
                        key: ValueKey('tables-lib-in-world-${table.id}'),
                        onPressed: null,
                        icon: const Icon(Icons.check, size: 18),
                        label: Text(l.tablesInWorld),
                      )
                    else
                      FilledButton.tonalIcon(
                        key: ValueKey('tables-lib-add-${table.id}'),
                        onPressed: onAdd,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l.tablesAddToWorld),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// All rows of a library table plus a trial roll. Pops `true` to add it.
class _PreviewDialog extends ConsumerStatefulWidget {
  final LibraryTable table;
  final String lang;
  final bool inWorld;

  const _PreviewDialog({
    required this.table,
    required this.lang,
    required this.inWorld,
  });

  @override
  ConsumerState<_PreviewDialog> createState() => _PreviewDialogState();
}

class _PreviewDialogState extends ConsumerState<_PreviewDialog> {
  TableRollResult? _result;
  late final RandomTable _table = TableLibrary.materialize(
    widget.table,
    widget.lang,
  );

  void _roll() {
    final pack = [
      _table,
      for (final t in TableLibrary.forStyle(widget.table.style))
        if (t.id != widget.table.id) TableLibrary.materialize(t, widget.lang),
    ];
    final roller = TableRoller.forTables(
      pack,
      random: ref.read(diceRandomProvider),
    );
    setState(() => _result = roller.roll(_table));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final table = _table;
    return AlertDialog(
      title: Text(table.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                table.description,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: GmhColors.parchmentDim,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 6, children: tableTags(l, table)),
              const SizedBox(height: 12),
              for (final row in table.rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 56,
                        child: Text(
                          row.hasRange
                              ? tableRangeText(row.from, row.to)
                              : '×${row.weight}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: GmhColors.ember,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row.text,
                          style: const TextStyle(fontSize: 13, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const ValueKey('tables-preview-roll'),
                onPressed: _roll,
                icon: const Icon(Icons.casino_outlined, size: 18),
                label: Text(l.tablesPreviewRoll),
              ),
              if (_result != null) ...[
                const SizedBox(height: 10),
                TableResultCard(result: _result, onRollAgain: _roll),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.close),
        ),
        if (!widget.inWorld)
          FilledButton(
            key: const ValueKey('tables-preview-add'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.tablesAddToWorld),
          ),
      ],
    );
  }
}
