import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../app/tools.dart';
import '../../../domain/models/world_object.dart';
import '../../../domain/tables/random_table.dart';
import '../../../domain/tables/table_ranges.dart';
import '../../../domain/tables/table_roller.dart';
import '../../../domain/tables/table_text.dart';
import '../../shell/ui_providers.dart';
import '../dice/dice_providers.dart';
import '../tool_scaffold.dart';
import 'tables_actions.dart';
import 'tables_dialogs.dart';
import 'tables_l10n.dart';
import 'tables_result.dart';
import 'tables_screen.dart';

const _saveDelay = Duration(milliseconds: 400);
const _maxLog = 50;
final _rangeFormatter = FilteringTextInputFormatter.allow(RegExp(r'^-?\d{0,6}'));

/// Editable text fields of one row; [key] survives reordering.
class _RowFields {
  final int key;
  final TextEditingController text;
  final TextEditingController from;
  final TextEditingController to;
  final TextEditingController weight;

  _RowFields(this.key, RandomTableRow row)
      : text = TextEditingController(text: row.text),
        from = TextEditingController(text: row.from?.toString() ?? ''),
        to = TextEditingController(text: row.to?.toString() ?? ''),
        weight = TextEditingController(text: '${row.weight}');

  void sync(RandomTableRow row) {
    void set(TextEditingController c, String value) {
      if (c.text != value) c.text = value;
    }

    set(text, row.text);
    // Keep what the user typed while it parses to the stored value.
    if (int.tryParse(from.text.trim()) != row.from) {
      set(from, row.from?.toString() ?? '');
    }
    if (int.tryParse(to.text.trim()) != row.to) {
      set(to, row.to?.toString() ?? '');
    }
    if ((int.tryParse(weight.text.trim()) ?? 1).clamp(1, 1000000) !=
        row.weight) {
      set(weight, '${row.weight}');
    }
  }

  RandomTableRow toRow() {
    final a = int.tryParse(from.text.trim());
    final b = int.tryParse(to.text.trim());
    return RandomTableRow(
      text.text,
      weight: (int.tryParse(weight.text.trim()) ?? 1).clamp(1, 1000000),
      from: a != null && b != null ? a : null,
      to: a != null && b != null ? b : null,
    );
  }

  void dispose() {
    text.dispose();
    from.dispose();
    to.dispose();
    weight.dispose();
  }
}

/// One table: header, row editor and the roll panel with result and log.
class TablePage extends ConsumerStatefulWidget {
  final String worldId;
  final String tableId;

  const TablePage({super.key, required this.worldId, required this.tableId});

  @override
  ConsumerState<TablePage> createState() => _TablePageState();
}

class _TablePageState extends ConsumerState<TablePage> {
  late final TablesActions _actions;
  ProviderSubscription<AsyncValue<WorldObject?>>? _subscription;
  final _resultKey = GlobalKey();

  RandomTable? _table;
  bool _loaded = false;
  bool _missing = false;
  bool _ready = false;
  final _rows = <_RowFields>[];
  int _nextKey = 0;
  int? _focusKey;
  Timer? _saveTimer;
  int _pendingSaves = 0;
  List<RandomTable> _worldTables = const [];

  /// This page's rolls, newest first.
  final _log = <TableRollResult>[];

  @override
  void initState() {
    super.initState();
    _actions = ref.read(tablesActionsProvider);
    _subscription = ref.listenManual(
        worldObjectProvider(widget.tableId), _onObject,
        fireImmediately: true);
    _ready = true;
  }

  @override
  void dispose() {
    _subscription?.close();
    if (_saveTimer?.isActive ?? false) {
      _saveTimer!.cancel();
      final table = _table;
      if (table != null) unawaited(_actions.save(table));
    }
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _apply(VoidCallback change) {
    if (!mounted) return;
    if (_ready) {
      setState(change);
    } else {
      change();
    }
  }

  void _onObject(AsyncValue<WorldObject?>? _, AsyncValue<WorldObject?> next) {
    if (next.hasError) {
      _apply(() => _loaded = _missing = true);
      return;
    }
    final object = next.valueOrNull;
    if (object == null) {
      if (next.hasValue) _apply(() => _loaded = _missing = true);
      return;
    }
    // Local edits win until they are saved; the stream then catches up.
    if ((_saveTimer?.isActive ?? false) || _pendingSaves > 0) return;
    final table = RandomTable.fromObject(object);
    _apply(() {
      _loaded = true;
      _missing = false;
      _table = table;
      _syncFields(table.rows);
    });
  }

  void _syncFields(List<RandomTableRow> rows) {
    for (var i = 0; i < rows.length; i++) {
      if (i < _rows.length) {
        _rows[i].sync(rows[i]);
      } else {
        _rows.add(_RowFields(_nextKey++, rows[i]));
      }
    }
    if (_rows.length > rows.length) {
      final removed = _rows.sublist(rows.length);
      _rows.removeRange(rows.length, _rows.length);
      _disposeLater(removed);
    }
  }

  /// The fields may still be attached to text fields in this frame.
  void _disposeLater(List<_RowFields> fields) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final f in fields) {
        f.dispose();
      }
    });
  }

  Future<void> _flush() async {
    _saveTimer?.cancel();
    _saveTimer = null;
    final table = _table;
    if (table == null) return;
    _pendingSaves++;
    try {
      await _actions.save(table);
    } finally {
      _pendingSaves--;
    }
  }

  /// Shows [next] right away and saves it (typing is debounced).
  void _commit(RandomTable next, {bool immediate = false}) {
    setState(() => _table = next);
    _saveTimer?.cancel();
    if (immediate) {
      unawaited(_flush());
    } else {
      _saveTimer = Timer(_saveDelay, () => unawaited(_flush()));
    }
  }

  void _fieldsChanged() {
    final table = _table;
    if (table == null) return;
    _commit(table.copyWith(rows: [for (final f in _rows) f.toRow()]));
  }

  void _replaceRows(RandomTable next) {
    setState(() => _syncFields(next.rows));
    _commit(next, immediate: true);
  }

  void _addRow() {
    final table = _table;
    if (table == null) return;
    final fields = _RowFields(_nextKey++, const RandomTableRow(''));
    setState(() {
      _rows.add(fields);
      _focusKey = fields.key;
    });
    _commit(table.copyWith(rows: [for (final f in _rows) f.toRow()]),
        immediate: true);
  }

  void _deleteRow(int index) {
    final table = _table;
    if (table == null) return;
    final removed = _rows.removeAt(index);
    _disposeLater([removed]);
    _commit(table.copyWith(rows: [for (final f in _rows) f.toRow()]),
        immediate: true);
  }

  void _reorder(int oldIndex, int newIndex) {
    final table = _table;
    if (table == null) return;
    if (newIndex > oldIndex) newIndex--;
    if (newIndex == oldIndex) return;
    final moved = _rows.removeAt(oldIndex);
    _rows.insert(newIndex, moved);
    _commit(table.copyWith(rows: [for (final f in _rows) f.toRow()]),
        immediate: true);
  }

  void _autoRanges() {
    final table = _table;
    final bounds = table == null ? null : formulaBounds(table.formula);
    if (table == null || bounds == null) return;
    _replaceRows(table.copyWith(
        rows: autoRanges([for (final f in _rows) f.toRow()], bounds)));
  }

  Future<void> _bulkEdit() async {
    final table = _table;
    if (table == null) return;
    final l = context.l10n;
    final edited = await showTableTextDialog(
      context,
      title: l.tablesBulkEditTitle,
      initialText: exportTableText(table.rows),
      confirmLabel: l.tablesApply,
    );
    final current = _table;
    if (edited == null || current == null || !mounted) return;
    _replaceRows(withImportedRows(current, edited.rows));
  }

  Future<void> _editDetails() async {
    final table = _table;
    if (table == null) return;
    final l = context.l10n;
    final edited = await showTableDetailsDialog(
      context,
      title: l.tablesEditTitle,
      initial: table,
      confirmLabel: l.save,
      folders: tableFolders(_worldTables),
    );
    final current = _table;
    if (edited == null || current == null || !mounted) return;
    _commit(
        current.copyWith(
          name: edited.name,
          description: edited.description,
          folder: edited.folder,
          formula: edited.formula,
        ),
        immediate: true);
  }

  void _roll() {
    final table = _table;
    if (table == null) return;
    // The page's own (possibly unsaved) version first: references to its
    // name resolve to what is on screen.
    final roller = TableRoller.forTables(
      [table, for (final t in _worldTables) if (t.id != table.id) t],
      random: ref.read(diceRandomProvider),
    );
    final result = roller.roll(table);
    setState(() {
      _log.insert(0, result);
      if (_log.length > _maxLog) _log.removeLast();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardContext = _resultKey.currentContext;
      if (!mounted || cardContext == null) return;
      Scrollable.ensureVisible(cardContext,
          duration: const Duration(milliseconds: 200),
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd);
    });
  }

  Future<void> _copy(String text) async {
    final messenger = ScaffoldMessenger.of(context);
    final copied = context.l10n.tablesCopied;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(copied)));
  }

  void _toList() => context.go(Routes.tool(widget.worldId, 'tables'));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    _worldTables =
        ref.watch(worldTablesProvider(widget.worldId)).valueOrNull ?? const [];
    final table = _table;
    final backButton = IconButton(
      key: const ValueKey('tables-back'),
      tooltip: l.tablesAllTables,
      icon: const Icon(Icons.view_list_outlined),
      onPressed: _toList,
    );
    if (!_loaded) {
      return const ToolScaffold(
          toolId: 'tables', body: Center(child: CircularProgressIndicator()));
    }
    if (_missing || table == null) {
      return ToolScaffold(
        toolId: 'tables',
        body: ToolEmptyState(
          icon: toolById('tables')!.icon,
          title: l.tablesMissing,
          hint: '',
          action: FilledButton(
              onPressed: _toList, child: Text(l.tablesAllTables)),
        ),
      );
    }

    return ToolScaffold(
      toolId: 'tables',
      title: table.name,
      actions: [
        backButton,
        TableMenu(
          table: table,
          onDeleted: _toList,
          extra: [
            PopupMenuItem(value: 'edit', child: Text(l.tablesEdit)),
            PopupMenuItem(value: 'text', child: Text(l.tablesBulkEdit)),
          ],
          onExtra: (action) => action == 'edit' ? _editDetails() : _bulkEdit(),
        ),
      ],
      body: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final header = _Header(table: table, onEdit: _editDetails);
        final rollPanel = _rollPanel(context, table);
        if (wide) {
          final panelWidth =
              (constraints.maxWidth * 0.38).clamp(340.0, 560.0);
          final side = ((constraints.maxWidth - panelWidth - 1 - 900) / 2)
              .clamp(20.0, double.infinity);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(side, 16, side, 0),
                      sliver: SliverToBoxAdapter(child: header),
                    ),
                    ..._editorSlivers(context, table,
                        EdgeInsets.fromLTRB(side, 0, side, 0)),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: panelWidth,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: rollPanel,
                ),
              ),
            ],
          );
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [header, const SizedBox(height: 16), rollPanel],
                ),
              ),
            ),
            ..._editorSlivers(
                context, table, const EdgeInsets.symmetric(horizontal: 16)),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      }),
    );
  }

  Widget _rollPanel(BuildContext context, RandomTable table) {
    final l = context.l10n;
    final latest = _log.isEmpty ? null : _log.first;
    final earlier = _log.skip(1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          key: const ValueKey('tables-roll'),
          onPressed: _roll,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          icon: const Icon(Icons.casino_outlined),
          label: Text(l.tablesRoll),
        ),
        const SizedBox(height: 12),
        TableResultCard(
          key: _resultKey,
          result: latest,
          onRollAgain: _roll,
          onCopy: latest == null ? null : () => _copy(latest.text),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.history, size: 18, color: GmhColors.parchmentDim),
            const SizedBox(width: 8),
            Expanded(
              child: Text(l.tablesRollLog,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            if (_log.isNotEmpty)
              TextButton(
                key: const ValueKey('tables-clear-log'),
                onPressed: () => setState(_log.clear),
                child: Text(l.tablesClearLog),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (earlier.isEmpty)
          Text(l.tablesRollLogEmpty,
              style: TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim))
        else
          for (final r in earlier)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TableLogTile(result: r, onCopy: () => _copy(r.text)),
            ),
      ],
    );
  }

  List<Widget> _editorSlivers(
      BuildContext context, RandomTable table, EdgeInsets padding) {
    final l = context.l10n;
    final bounds = table.usesFormula ? formulaBounds(table.formula) : null;
    final issues = validateTable(table);
    return [
      SliverPadding(
        padding: padding.copyWith(top: 20, bottom: 8),
        sliver: SliverToBoxAdapter(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('${l.tablesRows} · ${table.rows.length}',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 4),
              OutlinedButton.icon(
                key: const ValueKey('tables-add-row'),
                onPressed: _addRow,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l.tablesAddRow),
              ),
              if (table.usesFormula)
                Tooltip(
                  message: l.tablesAutoRangesHint,
                  child: OutlinedButton.icon(
                    key: const ValueKey('tables-auto-ranges'),
                    onPressed: bounds == null || _rows.isEmpty
                        ? null
                        : _autoRanges,
                    icon: const Icon(Icons.linear_scale, size: 18),
                    label: Text(l.tablesAutoRanges),
                  ),
                ),
              OutlinedButton.icon(
                key: const ValueKey('tables-bulk-edit'),
                onPressed: _bulkEdit,
                icon: const Icon(Icons.notes, size: 18),
                label: Text(l.tablesBulkEdit),
              ),
            ],
          ),
        ),
      ),
      if (issues.isNotEmpty && _rows.isNotEmpty)
        SliverPadding(
          padding: padding.copyWith(bottom: 8),
          sliver: SliverToBoxAdapter(
            child: _Issues(
                lines: [
              for (final issue in issues.take(6))
                tableIssueText(l, issue, bounds: bounds),
              if (issues.length > 6) '…',
            ]),
          ),
        ),
      if (_rows.isEmpty)
        SliverPadding(
          padding: padding.copyWith(top: 8),
          sliver: SliverToBoxAdapter(
            child: Text(l.tablesRowsEmpty,
                key: const ValueKey('tables-rows-empty'),
                style: TextStyle(
                    fontSize: 13, height: 1.4, color: GmhColors.parchmentDim)),
          ),
        )
      else
        SliverPadding(
          padding: padding,
          sliver: SliverReorderableList(
            itemCount: _rows.length,
            onReorder: _reorder,
            itemBuilder: (context, index) {
              final fields = _rows[index];
              return Padding(
                key: ValueKey('row-${fields.key}'),
                padding: const EdgeInsets.only(bottom: 6),
                child: _RowEditor(
                  index: index,
                  fields: fields,
                  usesFormula: table.usesFormula,
                  autofocus: _focusKey == fields.key,
                  onChanged: _fieldsChanged,
                  onDelete: () => _deleteRow(index),
                ),
              );
            },
          ),
        ),
    ];
  }
}

class _Header extends StatelessWidget {
  final RandomTable table;
  final VoidCallback onEdit;

  const _Header({required this.table, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(table.name,
                  key: const ValueKey('tables-title'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            IconButton(
              key: const ValueKey('tables-edit-details'),
              tooltip: l.tablesEdit,
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
            ),
          ],
        ),
        if (table.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(table.description,
              style: TextStyle(
                  fontSize: 13.5, height: 1.4, color: GmhColors.parchmentDim)),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ...tableTags(l, table),
            if (table.folder.isNotEmpty)
              TableTag(label: table.folder, icon: Icons.folder_outlined),
          ],
        ),
      ],
    );
  }
}

class _Issues extends StatelessWidget {
  final List<String> lines;
  const _Issues({required this.lines});

  @override
  Widget build(BuildContext context) {
    final color = GmhColors.danger;
    return Container(
      key: const ValueKey('tables-issues'),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(Icons.warning_amber_rounded,
                        size: 15, color: color),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(line,
                        style: TextStyle(fontSize: 12.5, color: color)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RowEditor extends StatelessWidget {
  final int index;
  final _RowFields fields;
  final bool usesFormula;
  final bool autofocus;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const _RowEditor({
    required this.index,
    required this.fields,
    required this.usesFormula,
    required this.autofocus,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget number(TextEditingController c, String key, String label,
            {String? prefix}) =>
        SizedBox(
          width: 54,
          child: TextField(
            key: ValueKey(key),
            controller: c,
            textAlign: TextAlign.center,
            keyboardType:
                const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [_rangeFormatter],
            style: const TextStyle(fontSize: 13.5),
            decoration: InputDecoration(
              isDense: true,
              hintText: label,
              prefixText: prefix,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            ),
            onChanged: (_) => onChanged(),
          ),
        );

    return Material(
      color: GmhColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        key: ValueKey('tables-row-$index'),
        padding: const EdgeInsets.fromLTRB(2, 6, 0, 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: GmhColors.border),
        ),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Tooltip(
                message: l.tablesDragToReorder,
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.drag_indicator,
                        size: 20, color: GmhColors.parchmentFaint),
                  ),
                ),
              ),
            ),
            if (usesFormula) ...[
              number(fields.from, 'tables-row-from-$index', l.tablesFrom),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text('–',
                    style: TextStyle(color: GmhColors.parchmentDim)),
              ),
              number(fields.to, 'tables-row-to-$index', l.tablesTo),
            ] else
              Tooltip(
                message: l.tablesWeight,
                child: number(fields.weight, 'tables-row-weight-$index',
                    l.tablesWeight,
                    prefix: '×'),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: ValueKey('tables-row-text-$index'),
                controller: fields.text,
                autofocus: autofocus,
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(fontSize: 13.5, height: 1.35),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l.tablesRowTextHint('{2d6}', '{a|b}', '[[…]]'),
                  hintMaxLines: 1,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
            IconButton(
              key: ValueKey('tables-row-delete-$index'),
              tooltip: l.tablesDeleteRow,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
