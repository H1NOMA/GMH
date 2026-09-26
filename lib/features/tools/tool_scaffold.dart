import 'package:flutter/material.dart';

import '../../app/l10n_ext.dart';
import '../../app/theme/gmh_theme.dart';
import '../../app/tools.dart';
import '../shell/history_buttons.dart';

/// Shared page chrome for every GM tool: history buttons, the tool's icon
/// and name, optional actions — so all tools look and behave alike.
class ToolScaffold extends StatelessWidget {
  final String toolId;

  /// Replaces the tool name in the app bar (e.g. an open map's name).
  final String? title;
  final List<Widget> actions;
  final Widget body;
  final Widget? floatingActionButton;

  const ToolScaffold({
    super.key,
    required this.toolId,
    this.title,
    this.actions = const [],
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final tool = toolById(toolId);
    return Scaffold(
      appBar: AppBar(
        leading: historyLeading(),
        leadingWidth: kHistoryLeadingWidth,
        titleSpacing: 8,
        title: Row(
          children: [
            if (tool != null)
              Icon(tool.icon, size: 20, color: GmhColors.ember),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title ?? tool?.label(context.l10n) ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [...actions, const SizedBox(width: 6)],
      ),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}

/// Centered icon + title + hint + optional action: the empty state every
/// tool shows before the user has created anything.
class ToolEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hint;
  final Widget? action;

  const ToolEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44, color: GmhColors.parchmentFaint),
              const SizedBox(height: 14),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              if (hint.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(hint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: GmhColors.parchmentDim)),
              ],
              if (action != null) ...[
                const SizedBox(height: 18),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
