import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/tools.dart';
import '../tool_scaffold.dart';

// Placeholder page; the full tool replaces this file.
class DiceScreen extends StatelessWidget {
  final String worldId;

  const DiceScreen({super.key, required this.worldId});

  @override
  Widget build(BuildContext context) {
    final tool = toolById('dice')!;
    return ToolScaffold(
      toolId: 'dice',
      body: ToolEmptyState(
        icon: tool.icon,
        title: tool.label(context.l10n),
        hint: tool.description(context.l10n),
      ),
    );
  }
}
