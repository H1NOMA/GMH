import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/tools.dart';
import '../tool_scaffold.dart';

// Placeholder page; the full tool replaces this file.
class RandomTablesScreen extends StatelessWidget {
  final String worldId;
  final String? tableId;

  const RandomTablesScreen({super.key, required this.worldId, this.tableId});

  @override
  Widget build(BuildContext context) {
    final tool = toolById('tables')!;
    return ToolScaffold(
      toolId: 'tables',
      body: ToolEmptyState(
        icon: tool.icon,
        title: tool.label(context.l10n),
        hint: tool.description(context.l10n),
      ),
    );
  }
}
