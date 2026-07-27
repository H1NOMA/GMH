import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity_kind.dart';
import '../categories/category_ui.dart';
import 'ui_providers.dart';
import 'workspace_tabs.dart';

/// The browser-like tab strip above the content area (wide layouts).
class WorkspaceTabStrip extends ConsumerWidget {
  final String worldId;
  const WorkspaceTabStrip({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(workspaceTabsProvider);
    final controller = ref.read(workspaceTabsProvider.notifier);
    if (tabs.locations.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: GmhColors.surface,
        border: Border(bottom: BorderSide(color: GmhColors.border)),
      ),
      // "+" trails the last tab like in a browser, scrolling with the
      // strip instead of sitting pinned at the far edge.
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 6, top: 5, right: 4),
        itemCount: tabs.locations.length + 1,
        itemBuilder: (context, index) {
          if (index == tabs.locations.length) {
            return IconButton(
              tooltip: context.l10n.navHome,
              icon: const Icon(Icons.add, size: 18),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 32, minHeight: 28),
              // A fresh dashboard tab, like a browser's new tab.
              onPressed: () =>
                  controller.openInNewTab(Routes.home(worldId)),
            );
          }
          return _WorkspaceTab(
            location: tabs.locations[index],
            active: index == tabs.activeIndex,
            onTap: () => controller.activate(index),
            onClose: () => controller.close(
              index,
              fallbackLocation: Routes.home(worldId),
            ),
          );
        },
      ),
    );
  }
}

class _WorkspaceTab extends ConsumerWidget {
  final String location;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _WorkspaceTab({
    required this.location,
    required this.active,
    required this.onTap,
    required this.onClose,
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
    if (location.endsWith('/home')) {
      return (Icons.dashboard_outlined, l.navHome);
    }
    if (location.contains('/search')) return (Icons.search, l.navSearch);
    if (location.contains('/graph')) {
      return (Icons.hub_outlined, l.navGraphShort);
    }
    if (location.contains('/campaigns')) {
      return (Icons.map_outlined, l.navCampaigns);
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
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 190),
          decoration: BoxDecoration(
            color: active ? GmhColors.background : Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            // A rounded box only accepts a uniform border; the ember
            // accent is painted separately as the strip below.
            border: active ? Border.all(color: GmhColors.border) : null,
          ),
          clipBehavior: active ? Clip.antiAlias : Clip.none,
          child: Stack(
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
    );
  }
}
