import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/tools.dart';
import '../tool_scaffold.dart';

// Placeholder page; the full tool replaces this file.
class MapsScreen extends StatelessWidget {
  final String worldId;
  final String? mapId;

  const MapsScreen({super.key, required this.worldId, this.mapId});

  @override
  Widget build(BuildContext context) {
    final tool = toolById('maps')!;
    return ToolScaffold(
      toolId: 'maps',
      body: ToolEmptyState(
        icon: tool.icon,
        title: tool.label(context.l10n),
        hint: tool.description(context.l10n),
      ),
    );
  }
}
