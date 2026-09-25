import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/dice/dice_engine.dart';
import '../../../domain/tables/content/table_library.dart';
import '../../../domain/tables/random_table.dart';
import '../../../domain/tables/table_ranges.dart';
import '../../../domain/tables/table_text.dart';

/// Name, description, folder and formula of a table. Returns [initial]
/// with the new values, or null when cancelled or the name is empty.
Future<RandomTable?> showTableDetailsDialog(
  BuildContext context, {
  required String title,
  required RandomTable initial,
  required String confirmLabel,
  List<String> folders = const [],
}) async {
  final name = TextEditingController(text: initial.name)
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: initial.name.length,
    );
  final description = TextEditingController(text: initial.description);
  final folder = TextEditingController(text: initial.folder);
  final formula = TextEditingController(text: initial.formula);
  final controllers = [name, description, folder, formula];
  ModalRoute<Object?>? dialogRoute;
  String? formulaError(AppLocalizations l) {
    final text = formula.text.trim();
    if (text.isEmpty || DiceEngine.isValid(text)) return null;
    return l.tablesFormulaInvalid;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      final l = context.l10n;
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final error = formulaError(l);
          void submit() {
            if (formulaError(l) == null) Navigator.pop(context, true);
          }

          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      key: const ValueKey('tables-name-field'),
                      controller: name,
                      autofocus: true,
                      decoration: InputDecoration(labelText: l.nameLabel),
                      onSubmitted: (_) => submit(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('tables-description-field'),
                      controller: description,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l.tablesDescriptionLabel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('tables-formula-field'),
                      controller: formula,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: l.tablesFormulaLabel,
                        hintText: l.tablesFormulaHint,
                        errorText: error,
                        prefixIcon: const Icon(Icons.casino_outlined, size: 20),
                      ),
                      onChanged: (_) => setDialogState(() {}),
                      onSubmitted: (_) => submit(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('tables-folder-field'),
                      controller: folder,
                      decoration: InputDecoration(
                        labelText: l.tablesFolderLabel,
                        hintText: l.tablesFolderHint,
                        prefixIcon: const Icon(Icons.folder_outlined, size: 20),
                      ),
                    ),
                    if (folders.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final f in folders)
                            ActionChip(
                              label: Text(
                                f,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>
                                  setDialogState(() => folder.text = f),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: error == null ? submit : null,
                child: Text(confirmLabel),
              ),
            ],
          );
        },
      );
    },
  );
  final result = () {
    final trimmed = name.text.trim();
    if (confirmed != true || trimmed.isEmpty) return null;
    final f = formula.text.trim();
    return initial.copyWith(
      name: trimmed,
      description: description.text.trim(),
      folder: folder.text.trim(),
      formula: f.isEmpty || DiceEngine.isValid(f) ? f : initial.formula,
    );
  }();
  dialogRoute?.completed.whenComplete(() {
    for (final c in controllers) {
      c.dispose();
    }
  });
  return result;
}

/// Rows in the plain-text format, for bulk editing ([initialName] null) or
/// importing a new table (with a name field). Null when cancelled.
Future<({String name, List<RandomTableRow> rows})?> showTableTextDialog(
  BuildContext context, {
  required String title,
  required String initialText,
  required String confirmLabel,
  String? initialName,
}) async {
  final name = initialName == null
      ? null
      : (TextEditingController(text: initialName)
          ..selection = TextSelection(
            baseOffset: 0,
            extentOffset: initialName.length,
          ));
  final text = TextEditingController(text: initialText);
  ModalRoute<Object?>? dialogRoute;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      dialogRoute ??= ModalRoute.of(context);
      final l = context.l10n;
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final count = parseTableText(text.text).length;
          final nameOk = name == null || name.text.trim().isNotEmpty;
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 620,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (name != null) ...[
                      TextField(
                        key: const ValueKey('tables-import-name'),
                        controller: name,
                        decoration: InputDecoration(labelText: l.nameLabel),
                        onChanged: (_) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      l.tablesTextFormatHelp,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: GmhColors.parchmentDim,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      key: const ValueKey('tables-text-field'),
                      controller: text,
                      autofocus: name == null,
                      minLines: 8,
                      maxLines: 16,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 13.5, height: 1.4),
                      decoration: InputDecoration(
                        labelText: l.tablesImportRows,
                        alignLabelWithHint: true,
                      ),
                      onChanged: (_) => setDialogState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.tablesImportFound(count),
                      key: const ValueKey('tables-text-count'),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: GmhColors.parchmentDim,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel),
              ),
              FilledButton(
                key: const ValueKey('tables-text-confirm'),
                onPressed: nameOk ? () => Navigator.pop(context, true) : null,
                child: Text(confirmLabel),
              ),
            ],
          );
        },
      );
    },
  );
  final result = confirmed == true
      ? (name: name?.text.trim() ?? '', rows: parseTableText(text.text))
      : null;
  dialogRoute?.completed.whenComplete(() {
    name?.dispose();
    text.dispose();
  });
  return result;
}

/// Applies imported [rows] to [table]: a table without a formula whose
/// rows all carry ranges gets the matching formula.
RandomTable withImportedRows(RandomTable table, List<RandomTableRow> rows) {
  final suggested = table.usesFormula ? null : suggestFormula(rows);
  return table.copyWith(rows: rows, formula: suggested ?? table.formula);
}

Future<bool> confirmDeleteTable(BuildContext context, String name) async {
  final l = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        l.tablesDeleteTitle(name),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(width: 420, child: Text(l.tablesDeleteBody)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const ValueKey('tables-delete-confirm'),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return result == true;
}

/// Offers the library tables [table] references. Returns the ones to add
/// along with it (possibly none), or null when cancelled.
Future<List<LibraryTable>?> showLibraryDependenciesDialog(
  BuildContext context, {
  required LibraryTable table,
  required List<LibraryTable> dependencies,
  required String lang,
}) {
  final selected = {for (final d in dependencies) d.id};
  return showDialog<List<LibraryTable>>(
    context: context,
    builder: (context) {
      final l = context.l10n;
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.tablesAddDepsTitle),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.tablesAddDepsBody(table.name.of(lang)),
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: GmhColors.parchmentDim,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final dep in dependencies)
                    CheckboxListTile(
                      key: ValueKey('tables-dep-${dep.id}'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: selected.contains(dep.id),
                      title: Text(
                        dep.name.of(lang),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onChanged: (on) => setDialogState(
                        () => on == true
                            ? selected.add(dep.id)
                            : selected.remove(dep.id),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.cancel),
            ),
            FilledButton(
              key: const ValueKey('tables-deps-confirm'),
              onPressed: () => Navigator.pop(context, [
                for (final d in dependencies)
                  if (selected.contains(d.id)) d,
              ]),
              child: Text(l.tablesAddToWorld),
            ),
          ],
        ),
      );
    },
  );
}
