import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../app/tools.dart';
import '../../domain/models/entity_kind.dart';
import '../categories/category_ui.dart';
import 'ui_providers.dart';
import 'workspace_tabs.dart';

/// The browser-like tab strip above the content area (wide layouts).
class WorkspaceTabStrip extends ConsumerStatefulWidget {
  final String worldId;
  const WorkspaceTabStrip({super.key, required this.worldId});

  @override
  ConsumerState<WorkspaceTabStrip> createState() => _WorkspaceTabStripState();
}

class _WorkspaceTabStripState extends ConsumerState<WorkspaceTabStrip> {
  final _scroll = ScrollController();
  final _activeKey = GlobalKey();
  int _lastActive = -1;
  int _lastCount = 0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Keeps the active tab visible: opening a tab beyond the right edge or
  /// activating one scrolled out of view brings it back into the strip.
  void _revealActiveTab(WorkspaceTabsState tabs) {
    if (tabs.activeIndex == _lastActive && tabs.tabs.length == _lastCount) {
      return;
    }
    _lastActive = tabs.activeIndex;
    _lastCount = tabs.tabs.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _activeKey.currentContext;
      if (context == null || !mounted) return;
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 150),
      );
    });
  }

  Future<void> _showTabMenu(
    BuildContext context,
    Offset position,
    int index,
    int count,
  ) async {
    final controller = ref.read(workspaceTabsProvider.notifier);
    final l = context.l10n;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(value: 'duplicate', child: Text(l.tabDuplicate)),
        PopupMenuItem(value: 'close', child: Text(l.tabClose)),
        PopupMenuItem(
          value: 'others',
          enabled: count > 1,
          child: Text(l.tabCloseOthers),
        ),
        PopupMenuItem(
          value: 'right',
          enabled: index < count - 1,
          child: Text(l.tabCloseRight),
        ),
      ],
    );
    switch (choice) {
      case 'duplicate':
        controller.duplicate(index);
      case 'close':
        controller.close(index, fallbackLocation: Routes.home(widget.worldId));
      case 'others':
        controller.closeOthers(index);
      case 'right':
        controller.closeToRight(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(workspaceTabsProvider);
    final controller = ref.read(workspaceTabsProvider.notifier);
    if (tabs.tabs.isEmpty) return const SizedBox.shrink();
    _revealActiveTab(tabs);

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: GmhColors.surface,
        border: Border(bottom: BorderSide(color: GmhColors.border)),
      ),
      // A plain scrollable Row (not a lazy list): every tab stays built,
      // so ensureVisible can always reach the active one. "+" trails the
      // last tab like in a browser.
      child: SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 6, top: 5, right: 4),
        child: Row(
          children: [
            for (var index = 0; index < tabs.tabs.length; index++)
              _WorkspaceTab(
                key: index == tabs.activeIndex ? _activeKey : null,
                location: tabs.tabs[index].location,
                active: index == tabs.activeIndex,
                onTap: () => controller.activate(index),
                onClose: () => controller.close(
                  index,
                  fallbackLocation: Routes.home(widget.worldId),
                ),
                onMenu: (position) =>
                    _showTabMenu(context, position, index, tabs.tabs.length),
              ),
            IconButton(
              tooltip: context.l10n.newTab,
              icon: const Icon(Icons.add, size: 18),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 28),
              // A fresh dashboard tab, like a browser's new tab.
              onPressed: () =>
                  controller.openInNewTab(Routes.home(widget.worldId)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceTab extends ConsumerWidget {
  final String location;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final void Function(Offset globalPosition) onMenu;

  const _WorkspaceTab({
    super.key,
    required this.location,
    required this.active,
    required this.onTap,
    required this.onClose,
    required this.onMenu,
  });

  /// Resolves a display icon + label for a location.
  (IconData, String) _describe(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final entityMatch = RegExp(r'^/w/[^/]+/e/([^/]+)$').firstMatch(location);
    if (entityMatch != null) {
      final entity = ref
          .watch(entityProvider(entityMatch.group(1)!))
          .valueOrNull;
      if (entity == null) return (Icons.description_outlined, '…');
      final categories = ref.watch(categoryMapProvider(entity.worldId));
      return (entityIcon(entity, categories), entity.name);
    }
    final browseMatch = RegExp(
      r'^/w/[^/]+/browse/([^/]+)$',
    ).firstMatch(location);
    if (browseMatch != null) {
      final kind = EntityKind.tryParse(browseMatch.group(1)!);
      if (kind != null) return (kind.icon, kind.localizedPlural(context));
    }
    final categoryMatch = RegExp(
      r'^/w/([^/]+)/category/([^/]+)$',
    ).firstMatch(location);
    if (categoryMatch != null) {
      final category = ref.watch(
        categoryMapProvider(categoryMatch.group(1)!),
      )[categoryMatch.group(2)!];
      if (category != null) {
        return (categoryIconFor(category.icon), category.name);
      }
      return (Icons.folder_outlined, '…');
    }
    final toolMatch = RegExp(
      r'^/w/[^/]+/tools(?:/([^/]+))?(?:/([^/]+))?$',
    ).firstMatch(location);
    if (toolMatch != null) {
      final tool = toolById(toolMatch.group(1) ?? '');
      if (tool == null) return (Icons.handyman_outlined, l.navTools);
      final objectId = toolMatch.group(2);
      if (objectId != null) {
        // A specific map / encounter / table: show its own name.
        final object = ref.watch(worldObjectProvider(objectId)).valueOrNull;
        if (object != null && object.name.isNotEmpty) {
          return (tool.icon, object.name);
        }
      }
      return (tool.icon, tool.label(l));
    }
    if (location.endsWith('/home')) {
      return (Icons.dashboard_outlined, l.navHome);
    }
    if (location.contains('/search')) return (Icons.search, l.navSearch);
    if (location.contains('/graph')) {
      return (Icons.hub_outlined, l.navGraphShort);
    }
    if (location.contains('/campaigns')) {
      return (Icons.map_outlined, EntityKind.campaign.localizedPlural(context));
    }
    if (location.endsWith('/trash')) {
      return (Icons.delete_outline, l.trashTitle);
    }
    if (location.contains('/settings')) {
      return (Icons.settings_outlined, l.navSettingsShort);
    }
    if (location.endsWith('/help')) {
      return (Icons.help_outline, l.helpTitle);
    }
    return (Icons.public, l.navHome);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, label) = _describe(context, ref);
    final color = active ? GmhColors.parchment : GmhColors.parchmentDim;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      // Browser habits: middle-click closes, right-click (or long-press)
      // opens the tab menu.
      child: Listener(
        onPointerDown: (event) {
          if (event.buttons == kMiddleMouseButton) onClose();
        },
        child: GestureDetector(
          onSecondaryTapUp: (details) => onMenu(details.globalPosition),
          onLongPressStart: (details) => onMenu(details.globalPosition),
          child: InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 190),
              decoration: BoxDecoration(
                color: active ? GmhColors.background : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                // A rounded box only accepts a uniform border; the ember
                // accent is painted separately as the strip below.
                border: active ? Border.all(color: GmhColors.border) : null,
              ),
              clipBehavior: active ? Clip.antiAlias : Clip.none,
              // centerLeft keeps the icon+label row vertically centered in the
              // tab; the default topLeft pushed text against the top border.
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 14, color: color),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: active
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          icon: const Icon(Icons.close, size: 13),
                          color: GmhColors.parchmentFaint,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints(
                            minWidth: 26,
                            minHeight: 26,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: onClose,
                        ),
                      ],
                    ),
                  ),
                  if (active)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(height: 2, color: GmhColors.ember),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
