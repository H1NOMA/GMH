import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/nav_state.dart';

/// Browser-style back/forward controls fed by the navigation history.
/// Lives at the top-left of every page's app bar (like Obsidian and the
/// browser chrome users already know), plus the rail and the bottom bar.
class HistoryButtons extends ConsumerWidget {
  final bool compact;
  final bool vertical;
  const HistoryButtons({super.key, this.compact = false, this.vertical = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(navHistoryProvider);
    final controller = ref.read(navHistoryProvider.notifier);
    final size = compact ? 18.0 : 19.0;
    return Flex(
      direction: vertical ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: '${context.l10n.navBack} (Alt+←)',
          icon: Icon(Icons.arrow_back, size: size),
          onPressed: history.canGoBack ? controller.goBack : null,
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          tooltip: '${context.l10n.navForward} (Alt+→)',
          icon: Icon(Icons.arrow_forward, size: size),
          onPressed: history.canGoForward ? controller.goForward : null,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

/// Standard leading slot for page app bars: back/forward at the top-left.
const kHistoryLeadingWidth = 92.0;

Widget historyLeading() => const Padding(
      padding: EdgeInsets.only(left: 6),
      child: HistoryButtons(compact: true),
    );
