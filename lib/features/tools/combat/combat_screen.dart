import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/tools.dart';
import '../tool_scaffold.dart';

// Placeholder page; the full tool replaces this file.
class CombatScreen extends StatelessWidget {
  final String worldId;
  final String? encounterId;

  const CombatScreen({super.key, required this.worldId, this.encounterId});

  @override
  Widget build(BuildContext context) {
    final tool = toolById('combat')!;
    return ToolScaffold(
      toolId: 'combat',
      body: ToolEmptyState(
        icon: tool.icon,
        title: tool.label(context.l10n),
        hint: tool.description(context.l10n),
      ),
    );
  }
}
