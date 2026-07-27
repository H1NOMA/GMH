import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../app/l10n_ext.dart';
import '../../core/constants.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/world.dart';
import '../../app/nav_state.dart';
import '../categories/category_ui.dart';
import '../tags/tag_manager_sheet.dart';
import '../categories/manage_categories_sheet.dart';
import 'ui_providers.dart';

/// Adaptive navigation shell:
///  * desktop / wide tablet — persistent left sidebar (world navigator);
///  * narrow tablet — navigation rail;
///  * phone — bottom navigation bar, categories reachable from Home.
class AppShell extends ConsumerWidget {
  final String worldId;
  final Widget child;

  const AppShell({super.key, required this.worldId, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;

    // The open world's flavor drives the whole shell: palette facade,
    // ThemeData override and the slang used for kind labels.
    final style = ref.watch(worldProvider(worldId)).valueOrNull?.style ??
        WorldStyle.fantasy;
    final brightness = Theme.of(context).brightness;
    GmhStyle.current = style;
    GmhColors.palette = GmhStyle.paletteFor(style, brightness);

    // One shared bucket for all pages: scroll positions (and other
    // PageStorage values) survive navigating between sections.
    final content = PageStorage(bucket: appPageBucket, child: child);
    final Widget scaffold;
    if (width >= GmhConstants.desktopMinWidth) {
      scaffold = Scaffold(
        body: Row(
          children: [
            SizedBox(width: 264, child: _Sidebar(worldId: worldId)),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    } else if (width >= GmhConstants.phoneMaxWidth) {
      scaffold = Scaffold(
        body: Row(
          children: [
            _Rail(worldId: worldId),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    } else {
      scaffold = Scaffold(
        body: content,
        bottomNavigationBar: _BottomNav(worldId: worldId),
      );
    }
    // Always wrap in a Theme — for fantasy too. Inserting the Theme widget
    // only for cyberpunk changes the tree shape when the world style
    // resolves, failing Widget.canUpdate and remounting the entire page
    // subtree (editor state, graph simulation, scroll positions).
    return Theme(
        data: GmhStyle.themeFor(style, brightness), child: scaffold);
  }
}

/// Browser-style back/forward controls fed by the navigation history.
class _HistoryButtons extends ConsumerWidget {
  final bool compact;
  final bool vertical;
  const _HistoryButtons({this.compact = false, this.vertical = false});

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

enum _Section { home, search, graph, campaigns, settings }

/// Null when no top-level section matches (browsing a kind, a category or
/// an entry) — the rail/bottom nav must not highlight "Home" then.
_Section? _currentSection(BuildContext context) {
  final location = GoRouterState.of(context).uri.path;
  if (location.contains('/search')) return _Section.search;
  if (location.contains('/graph')) return _Section.graph;
  if (location.contains('/campaigns')) return _Section.campaigns;
  if (location.contains('/settings')) return _Section.settings;
  if (location.endsWith('/home')) return _Section.home;
  return null;
}

void _goToSection(BuildContext context, String worldId, _Section section) {
  switch (section) {
    case _Section.home:
      context.go(Routes.home(worldId));
    case _Section.search:
      context.go(Routes.search(worldId));
    case _Section.graph:
      context.go(Routes.graph(worldId));
    case _Section.campaigns:
      context.go(Routes.campaigns(worldId));
    case _Section.settings:
      context.go(Routes.settings(worldId));
  }
}

// ---------------------------------------------------------------- sidebar

class _Sidebar extends ConsumerWidget {
  final String worldId;
  const _Sidebar({required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldProvider(worldId)).valueOrNull;
    final counts =
        ref.watch(entityCountsProvider(worldId)).valueOrNull ?? const {};
    final section = _currentSection(context);
    final location = GoRouterState.of(context).uri.path;

    return ColoredBox(
      color: GmhColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // World switcher header
          InkWell(
            onTap: () => context.go(Routes.worlds()),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 12, 14),
              child: Row(
                children: [
                  Icon(Icons.public, color: GmhColors.ember, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      world?.name ?? '…',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.unfold_more,
                      size: 18, color: GmhColors.parchmentDim),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(children: const [_HistoryButtons()]),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Every group below reorders by press-and-hold drag; the
                // custom order persists per world.
                _DraggableGroup(
                  ids: applySidebarOrder(
                    const ['dashboard', 'search', 'graph', 'campaigns',
                        'tags'],
                    ref.watch(sidebarOrderProvider('$worldId|nav')),
                  ),
                  itemBuilder: (id) =>
                      _mainNavTile(context, id, section, location),
                  onReorder: (order) => ref
                      .read(sidebarOrderProvider('$worldId|nav').notifier)
                      .setOrder(order),
                ),
                _SectionHeader(context.l10n.sectionWorld),
                _kindGroup(ref, 'worldKinds', EntityKind.worldKinds, counts),
                _SectionHeader(context.l10n.sectionLibrary),
                _kindGroup(
                    ref, 'libraryKinds', EntityKind.libraryKinds, counts),
                _CategoriesSection(worldId: worldId),
              ],
            ),
          ),
          const Divider(),
          _NavTile(
            icon: Icons.help_outline,
            label: context.l10n.helpTitle,
            selected: location.endsWith('/help'),
            onTap: () => context.go(Routes.help(worldId)),
          ),
          _NavTile(
            icon: Icons.settings_outlined,
            label: context.l10n.navSettings,
            selected: section == _Section.settings,
            onTap: () => context.go(Routes.settings(worldId)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

extension on _Sidebar {
  Widget _mainNavTile(
      BuildContext context, String id, _Section? section, String location) {
    switch (id) {
      case 'dashboard':
        return _NavTile(
          icon: Icons.dashboard_outlined,
          label: context.l10n.navDashboard,
          selected: section == _Section.home,
          onTap: () => context.go(Routes.home(worldId)),
        );
      case 'search':
        return _NavTile(
          icon: Icons.search,
          label: context.l10n.navSearch,
          selected: section == _Section.search,
          onTap: () => context.go(Routes.search(worldId)),
        );
      case 'graph':
        return _NavTile(
          icon: Icons.hub_outlined,
          label: context.l10n.navGraph,
          selected: section == _Section.graph,
          onTap: () => context.go(Routes.graph(worldId)),
        );
      case 'campaigns':
        return _NavTile(
          icon: Icons.map_outlined,
          label: context.l10n.navCampaigns,
          selected: section == _Section.campaigns,
          onTap: () => context.go(Routes.campaigns(worldId)),
        );
      case 'tags':
      default:
        return _NavTile(
          icon: Icons.sell_outlined,
          label: context.l10n.tagManagerTitle,
          selected: false,
          onTap: () => showTagManagerSheet(context, worldId),
        );
    }
  }

  Widget _kindGroup(WidgetRef ref, String group, List<EntityKind> kinds,
      Map<EntityKind, int> counts) {
    final byName = {for (final k in kinds) k.name: k};
    return _DraggableGroup(
      ids: applySidebarOrder(
        [for (final k in kinds) k.name],
        ref.watch(sidebarOrderProvider('$worldId|$group')),
      ),
      itemBuilder: (name) {
        final kind = byName[name]!;
        return _KindTile(worldId: worldId, kind: kind, count: counts[kind]);
      },
      onReorder: (order) => ref
          .read(sidebarOrderProvider('$worldId|$group').notifier)
          .setOrder(order),
    );
  }
}

/// A vertical group whose children reorder by press-and-hold drag
/// (mouse and touch), like browser tabs.
class _DraggableGroup extends StatelessWidget {
  final List<String> ids;
  final Widget Function(String id) itemBuilder;
  final void Function(List<String> newOrder) onReorder;

  const _DraggableGroup({
    required this.ids,
    required this.itemBuilder,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        final order = [...ids];
        if (newIndex > oldIndex) newIndex--;
        order.insert(newIndex, order.removeAt(oldIndex));
        onReorder(order);
      },
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: ColoredBox(
          color: GmhColors.surfaceHigh,
          child: child,
        ),
      ),
      children: [
        for (var i = 0; i < ids.length; i++)
          ReorderableDelayedDragStartListener(
            key: ValueKey(ids[i]),
            index: i,
            child: itemBuilder(ids[i]),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w700,
          color: GmhColors.parchmentFaint,
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          size: 19, color: selected ? GmhColors.ember : GmhColors.parchmentDim),
      title: Text(label,
          style: TextStyle(
            fontSize: 13.5,
            color: selected ? GmhColors.emberBright : GmhColors.parchment,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          )),
      selected: selected,
      selectedTileColor: GmhColors.ember.withValues(alpha: 0.08),
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -2),
    );
  }
}

class _KindTile extends StatelessWidget {
  final String worldId;
  final EntityKind kind;
  final int? count;

  const _KindTile({required this.worldId, required this.kind, this.count});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selected = location.endsWith('/browse/${kind.name}');
    return ListTile(
      leading: Icon(kind.icon,
          size: 19, color: selected ? kind.color : GmhColors.parchmentDim),
      title: Text(kind.localizedPlural(context),
          style: TextStyle(
            fontSize: 13.5,
            color: selected ? GmhColors.emberBright : GmhColors.parchment,
          )),
      trailing: count == null || count == 0
          ? null
          : Text('$count',
              style: TextStyle(
                  fontSize: 12, color: GmhColors.parchmentFaint)),
      selected: selected,
      selectedTileColor: GmhColors.ember.withValues(alpha: 0.08),
      onTap: () => context.go(Routes.browse(worldId, kind)),
      visualDensity: const VisualDensity(vertical: -3),
    );
  }
}

class _CategoriesSection extends ConsumerWidget {
  final String worldId;
  const _CategoriesSection({required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(worldCategoriesProvider(worldId)).valueOrNull ?? [];
    final counts =
        ref.watch(categoryCountsProvider(worldId)).valueOrNull ?? const {};
    final location = GoRouterState.of(context).uri.path;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 6, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.sectionCategories,
                  style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                    color: GmhColors.parchmentFaint,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => showManageCategoriesSheet(context, worldId),
                child: Tooltip(
                  message: context.l10n.manageCategories,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.tune,
                        size: 15, color: GmhColors.parchmentFaint),
                  ),
                ),
              ),
            ],
          ),
        ),
        _DraggableGroup(
          ids: [for (final c in categories) c.id],
          itemBuilder: (id) {
            final category = categories.firstWhere((c) => c.id == id);
            final selected = location.endsWith('/category/${category.id}');
            return ListTile(
              leading: Icon(categoryIconFor(category.icon),
                  size: 19,
                  color: selected
                      ? adaptiveAccent(Color(category.color))
                      : GmhColors.parchmentDim),
              title: Text(category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: selected
                        ? GmhColors.emberBright
                        : GmhColors.parchment,
                  )),
              trailing: (counts[category.id] ?? 0) == 0
                  ? null
                  : Text('${counts[category.id]}',
                      style: TextStyle(
                          fontSize: 12, color: GmhColors.parchmentFaint)),
              selected: selected,
              selectedTileColor: GmhColors.ember.withValues(alpha: 0.08),
              onTap: () =>
                  context.go(Routes.browseCategory(worldId, category.id)),
              visualDensity: const VisualDensity(vertical: -3),
            );
          },
          // Category order is already a first-class concept — persist the
          // drag result straight into the repository.
          onReorder: (order) =>
              ref.read(categoryRepositoryProvider).reorder(worldId, order),
        ),
        ListTile(
          leading: Icon(Icons.add,
              size: 18, color: GmhColors.parchmentFaint),
          title: Text(context.l10n.newCategory,
              style: TextStyle(
                  fontSize: 13, color: GmhColors.parchmentDim)),
          onTap: () => showManageCategoriesSheet(context, worldId),
          visualDensity: const VisualDensity(vertical: -3),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------- rail

class _Rail extends StatelessWidget {
  final String worldId;
  const _Rail({required this.worldId});

  @override
  Widget build(BuildContext context) {
    final section = _currentSection(context);
    return NavigationRail(
      backgroundColor: GmhColors.surface,
      selectedIndex: section?.index,
      onDestinationSelected: (index) =>
          _goToSection(context, worldId, _Section.values[index]),
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: [
          IconButton(
            tooltip: context.l10n.switchWorld,
            icon: Icon(Icons.public, color: GmhColors.ember),
            onPressed: () => context.go(Routes.worlds()),
          ),
          const _HistoryButtons(compact: true, vertical: true),
        ],
      ),
      destinations: [
        NavigationRailDestination(
            icon: const Icon(Icons.dashboard_outlined),
            label: Text(context.l10n.navHome)),
        NavigationRailDestination(
            icon: const Icon(Icons.search),
            label: Text(context.l10n.navSearch)),
        NavigationRailDestination(
            icon: const Icon(Icons.hub_outlined),
            label: Text(context.l10n.navGraphShort)),
        NavigationRailDestination(
            icon: const Icon(Icons.map_outlined),
            label: Text(context.l10n.navCampaigns)),
        NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            label: Text(context.l10n.navSettingsShort)),
      ],
    );
  }
}

// ------------------------------------------------------------- bottom nav

class _BottomNav extends StatelessWidget {
  final String worldId;
  const _BottomNav({required this.worldId});

  @override
  Widget build(BuildContext context) {
    final section = _currentSection(context);
    return ColoredBox(
      color: GmhColors.surface,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 2),
              child: _HistoryButtons(compact: true),
            ),
            Expanded(
              child: NavigationBar(
                // NavigationBar can't render "nothing selected"; hide the
                // indicator instead when no top-level section is active.
                selectedIndex: section?.index ?? 0,
                indicatorColor:
                    section == null ? Colors.transparent : null,
                height: 64,
                onDestinationSelected: (index) =>
                    _goToSection(context, worldId, _Section.values[index]),
                destinations: _destinations(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<NavigationDestination> _destinations(BuildContext context) => [
        NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            label: context.l10n.navHome),
        NavigationDestination(
            icon: const Icon(Icons.search), label: context.l10n.navSearch),
        NavigationDestination(
            icon: const Icon(Icons.hub_outlined),
            label: context.l10n.navGraphShort),
        NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            label: context.l10n.navCampaigns),
        NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: context.l10n.navSettingsShort),
      ];
}
