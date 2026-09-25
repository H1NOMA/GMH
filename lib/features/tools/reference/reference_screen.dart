import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/tools.dart';
import '../tool_scaffold.dart';

// Placeholder page; the full tool replaces this file.
class ReferenceScreen extends StatelessWidget {
  final String worldId;

  const ReferenceScreen({super.key, required this.worldId});

  @override
  Widget build(BuildContext context) {
    final tool = toolById('reference')!;
    return ToolScaffold(
      toolId: 'reference',
      body: ToolEmptyState(
        icon: tool.icon,
        title: tool.label(context.l10n),
        hint: tool.description(context.l10n),
      ),
    );
  }
}
