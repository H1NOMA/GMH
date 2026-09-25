import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../app/tools.dart';
import '../shell/history_buttons.dart';
import '../shell/workspace_tabs.dart';

/// "At the table": a grid of every GM tool with a one-line description.
class ToolsHubScreen extends ConsumerWidget {
  final String worldId;
  const ToolsHubScreen({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: historyLeading(),
        leadingWidth: kHistoryLeadingWidth,
        title: Text(l.navTools),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final columns = (constraints.maxWidth / 300).floor().clamp(1, 4);
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 112,
          ),
          itemCount: gmhTools.length,
          itemBuilder: (context, index) {
            final tool = gmhTools[index];
            return ToolCard(
              tool: tool,
              // Inside the hub a tool opens in the same tab, like any
              // in-content navigation; the sidebar opens new tabs.
              onTap: () => ref
                  .read(workspaceTabsProvider.notifier)
                  .navigate
                  ?.call(Routes.tool(worldId, tool.id)),
            );
          },
        );
      }),
    );
  }
}

/// A tool tile: icon badge, name, two-line description.
class ToolCard extends StatelessWidget {
  final GmhTool tool;
  final VoidCallback onTap;
  const ToolCard({super.key, required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GmhColors.ember.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(tool.icon, size: 22, color: GmhColors.ember),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tool.label(l),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(tool.description(l),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            color: GmhColors.parchmentDim)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
