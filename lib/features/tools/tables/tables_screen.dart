import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../app/tools.dart';
import '../../../domain/tables/random_table.dart';
import '../tool_scaffold.dart';
import 'table_page.dart';
import 'tables_actions.dart';
import 'tables_dialogs.dart';
import 'tables_library_page.dart';

/// Random tables: the world's table list, the built-in library
/// ([tablesLibraryObjectId]) or — with a [tableId] — one table's page.
class RandomTablesScreen extends StatelessWidget {
  final String worldId;
  final String? tableId;

  const RandomTablesScreen({super.key, required this.worldId, this.tableId});

  @override
  Widget build(BuildContext context) {
    final id = tableId;
    if (id == null) return _TableList(worldId: worldId);
    if (id == tablesLibraryObjectId) {
      return TablesLibraryPage(worldId: worldId);
    }
    return TablePage(key: ValueKey(id), worldId: worldId, tableId: id);
  }
}

/// Distinct non-empty folders, sorted.
List<String> tableFolders(Iterable<RandomTable> tables) =>
    ({for (final t in tables) if (t.folder.isNotEmpty) t.folder}.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));

Future<void> createTableFlow(BuildContext context, WidgetRef ref,
    String worldId, List<RandomTable> existing) async {
  final l = context.l10n;
  final draft = await showTableDetailsDialog(
    context,
    title: l.tablesNewTable,
    initial: RandomTable(
        worldId: worldId, name: l.tablesDefaultName(existing.length + 1)),
    confirmLabel: l.create,
    folders: tableFolders(existing),
  );
  if (draft == null || !context.mounted) return;
  final table = await ref.read(tablesActionsProvider).create(worldId, draft);
  if (!context.mounted) return;
  context.go(Routes.tool(worldId, 'tables', table.id));
}

Future<void> importTableFlow(BuildContext context, WidgetRef ref,
    String worldId, List<RandomTable> existing) async {
  final l = context.l10n;
  final actions = ref.read(tablesActionsProvider);
  final imported = await showTableTextDialog(
    context,
    title: l.tablesImportTitle,
    initialName: l.tablesDefaultName(existing.length + 1),
    initialText: '',
    confirmLabel: l.tablesImportAction,
  );
  if (imported == null || imported.name.isEmpty || !context.mounted) return;
  final table = await actions.create(
      worldId,
      withImportedRows(
          RandomTable(worldId: worldId, name: imported.name), imported.rows));
  if (!context.mounted) return;
  context.go(Routes.tool(worldId, 'tables', table.id));
}

class _TableList extends ConsumerStatefulWidget {
  final String worldId;
  const _TableList({required this.worldId});

  @override
  ConsumerState<_TableList> createState() => _TableListState();
}

class _TableListState extends ConsumerState<_TableList> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(RandomTable t) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return t.name.toLowerCase().contains(q) ||
        t.description.toLowerCase().contains(q) ||
        t.folder.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final worldId = widget.worldId;
    final tool = toolById('tables')!;
    final async = ref.watch(worldTablesProvider(worldId));
    final tables = async.valueOrNull ?? const <RandomTable>[];
    void openLibrary() =>
        context.go(Routes.tool(worldId, 'tables', tablesLibraryObjectId));

    final Widget body;
    if (async.isLoading && !async.hasValue) {
      body = const Center(child: CircularProgressIndicator());
    } else if (tables.isEmpty) {
      body = ToolEmptyState(
        icon: tool.icon,
        title: l.tablesEmptyTitle,
        hint: l.tablesEmptyHint,
        action: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              key: const ValueKey('tables-empty-library'),
              onPressed: openLibrary,
              icon: const Icon(Icons.local_library_outlined, size: 18),
              label: Text(l.tablesOpenLibrary),
            ),
            OutlinedButton.icon(
              onPressed: () => createTableFlow(context, ref, worldId, tables),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.tablesNewTable),
            ),
          ],
        ),
      );
    } else {
      final visible = tables.where(_matches).toList();
      final groups = <String, List<RandomTable>>{};
      for (final t in visible) {
        groups.putIfAbsent(t.folder, () => []).add(t);
      }
      final folders = groups.keys.toList()
        ..sort((a, b) {
          if (a.isEmpty != b.isEmpty) return a.isEmpty ? 1 : -1;
          return a.toLowerCase().compareTo(b.toLowerCase());
        });
      body = LayoutBuilder(builder: (context, constraints) {
        final side =
            ((constraints.maxWidth - 900) / 2).clamp(16.0, double.infinity);
        return ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 40),
          children: [
            TextField(
              key: const ValueKey('tables-search'),
              controller: _search,
              decoration: InputDecoration(
                hintText: l.tablesSearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l.clear,
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _search.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(l.tablesNoMatches,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: GmhColors.parchmentDim)),
              ),
            for (final folder in folders) ...[
              _FolderHeader(
                label: folder.isEmpty ? l.tablesNoFolder : folder,
                count: groups[folder]!.length,
              ),
              for (final t in groups[folder]!)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _TableCard(table: t),
                ),
            ],
          ],
        );
      });
    }

    return ToolScaffold(
      toolId: 'tables',
      actions: [
        IconButton(
          key: const ValueKey('tables-open-library'),
          tooltip: l.tablesLibrary,
          icon: const Icon(Icons.local_library_outlined),
          onPressed: openLibrary,
        ),
        IconButton(
          key: const ValueKey('tables-import'),
          tooltip: l.tablesImport,
          icon: const Icon(Icons.playlist_add_outlined),
          onPressed: () => importTableFlow(context, ref, worldId, tables),
        ),
        IconButton(
          key: const ValueKey('tables-new'),
          tooltip: l.tablesNewTable,
          icon: const Icon(Icons.add),
          onPressed: () => createTableFlow(context, ref, worldId, tables),
        ),
      ],
      body: body,
    );
  }
}

class _FolderHeader extends StatelessWidget {
  final String label;
  final int count;
  const _FolderHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 8),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, size: 16, color: GmhColors.parchmentDim),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: GmhColors.parchmentDim)),
          ),
          const SizedBox(width: 8),
          Text('$count',
              style: TextStyle(fontSize: 12, color: GmhColors.parchmentFaint)),
        ],
      ),
    );
  }
}

/// Small rounded label used on table cards and headers.
class TableTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const TableTag({super.key, required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? GmhColors.parchmentDim;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: c),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w600, color: c)),
          ),
        ],
      ),
    );
  }
}

/// Row count, formula (or "by weight") and library origin of [table].
List<Widget> tableTags(AppLocalizations l, RandomTable table) => [
      TableTag(
        label: table.usesFormula ? table.formula : l.tablesWeighted,
        icon: table.usesFormula ? Icons.casino_outlined : Icons.balance,
        color: table.usesFormula ? GmhColors.ember : null,
      ),
      TableTag(label: l.tablesRowCount(table.rows.length)),
      if (RandomTableSource.libraryId(table.source) != null)
        TableTag(
            label: l.tablesFromLibrary, icon: Icons.local_library_outlined),
    ];

class _TableCard extends StatelessWidget {
  final RandomTable table;
  const _TableCard({required this.table});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      key: ValueKey('tables-card-${table.id}'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            context.go(Routes.tool(table.worldId, 'tables', table.id)),
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
                child: Icon(toolById('tables')!.icon,
                    size: 22, color: GmhColors.ember),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(table.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    if (table.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(table.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.5, color: GmhColors.parchmentDim)),
                    ],
                    const SizedBox(height: 6),
                    Wrap(
                        spacing: 6, runSpacing: 4, children: tableTags(l, table)),
                  ],
                ),
              ),
              TableMenu(table: table),
            ],
          ),
        ),
      ),
    );
  }
}

/// Duplicate / delete, shared by the list and the table page; the page
/// adds its own entries through [extra].
class TableMenu extends ConsumerWidget {
  final RandomTable table;
  final List<PopupMenuEntry<String>> extra;
  final void Function(String action)? onExtra;

  /// Where to go once the table is deleted (the page returns to the list).
  final VoidCallback? onDeleted;

  const TableMenu({
    super.key,
    required this.table,
    this.extra = const [],
    this.onExtra,
    this.onDeleted,
  });

  Future<void> _handle(
      BuildContext context, WidgetRef ref, String action) async {
    final l = context.l10n;
    final actions = ref.read(tablesActionsProvider);
    switch (action) {
      case 'duplicate':
        final copy =
            await actions.duplicate(table, l.tablesCopyName(table.name));
        if (!context.mounted) return;
        context.go(Routes.tool(table.worldId, 'tables', copy.id));
      case 'delete':
        final ok = await confirmDeleteTable(context, table.name);
        if (!ok || !context.mounted) return;
        onDeleted?.call();
        await actions.delete(table.id);
      default:
        onExtra?.call(action);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      key: ValueKey('tables-menu-${table.id}'),
      tooltip: l.tablesActions,
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => _handle(context, ref, action),
      itemBuilder: (context) => [
        ...extra,
        PopupMenuItem(value: 'duplicate', child: Text(l.tablesDuplicate)),
        PopupMenuItem(value: 'delete', child: Text(l.delete)),
      ],
    );
  }
}
