import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/tools.dart';
import '../tool_scaffold.dart';

// Placeholder page; the full tool replaces this file.
class TimelineScreen extends StatelessWidget {
  final String worldId;

  const TimelineScreen({super.key, required this.worldId});

  @override
  Widget build(BuildContext context) {
    final tool = toolById('timeline')!;
    return ToolScaffold(
      toolId: 'timeline',
      body: ToolEmptyState(
        icon: tool.icon,
        title: tool.label(context.l10n),
        hint: tool.description(context.l10n),
      ),
    );
  }
}
