import 'package:flutter/foundation.dart';
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
import '../../app/tools.dart';
import 'command_palette.dart';
import 'history_buttons.dart';
import 'tab_strip.dart';
import 'ui_providers.dart';
import 'workspace_tabs.dart';

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
    // Wide layouts get browser-style workspace tabs above the page.
    final tabbedContent = Column(
      // Stretch: the strip's scroll view sizes to its tabs, and a
      // centering column would float them in the middle.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkspaceTabStrip(worldId: worldId),
        Expanded(child: content),
      ],
    );
    final Widget scaffold;
    if (width >= GmhConstants.desktopMinWidth) {
      scaffold = Scaffold(
        body: Row(
          children: [
            SizedBox(width: 264, child: _Sidebar(worldId: worldId)),
            const VerticalDivider(width: 1),
            Expanded(child: tabbedContent),
          ],
        ),
      );
    } else if (width >= GmhConstants.phoneMaxWidth) {
      scaffold = Scaffold(
        body: Row(
          children: [
            _Rail(worldId: worldId),
            const VerticalDivider(width: 1),
            Expanded(child: tabbedContent),
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

enum _Section { home, search, graph, campaigns, tools, settings }

/// Null when no top-level section matches (browsing a kind, a category or
/// an entry) — the rail/bottom nav must not highlight "Home" then. Matches
/// on the path segment after the world id, never on substrings: a world or
/// entry id containing "graph" must not light up the Graph tab.
_Section? _currentSection(BuildContext context) {
  final segments = GoRouterState.of(context).uri.pathSegments;
  if (segments.length < 3) return null;
  return switch (segments[2]) {
    'home' => _Section.home,
    'search' => _Section.search,
    'graph' => _Section.graph,
    'campaigns' => _Section.campaigns,
    'tools' => _Section.tools,
    'settings' => _Section.settings,
    _ => null,
  };
}

/// The active tool id when a tool page is open.
String? _currentToolId(BuildContext context) {
  final segments = GoRouterState.of(context).uri.pathSegments;
  return segments.length >= 4 && segments[2] == 'tools' ? segments[3] : null;
}

String _sectionRoute(String worldId, _Section section) => switch (section) {
      _Section.home => Routes.home(worldId),
      _Section.search => Routes.search(worldId),
      _Section.graph => Routes.graph(worldId),
      _Section.campaigns => Routes.campaigns(worldId),
      _Section.tools => Routes.tools(worldId),
      _Section.settings => Routes.settings(worldId),
    };

void _goToSection(BuildContext context, String worldId, _Section section) =>
    context.go(_sectionRoute(worldId, section));

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
          // Quick jump: the command palette for mouse users (Ctrl+P).
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => showCommandPalette(context,
                  worldId: worldId, appRef: ref),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: GmhColors.border),
                  color: GmhColors.background,
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt, size: 16, color: GmhColors.parchmentDim),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(context.l10n.paletteTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.5, color: GmhColors.parchmentDim)),
                    ),
                    Text('Ctrl+P',
                        style: TextStyle(
                            fontSize: 11, color: GmhColors.parchmentFaint)),
                  ],
                ),
              ),
            ),
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
                      _mainNavTile(context, ref, id, section, location),
                  onReorder: (order) => ref
                      .read(sidebarOrderProvider('$worldId|nav').notifier)
                      .setOrder(order),
                ),
                _CollapsibleSection(
                  worldId: worldId,
                  group: 'worldKinds',
                  label: context.l10n.sectionWorld,
                  child: _kindGroup(
                      ref, 'worldKinds', EntityKind.worldKinds, counts),
                ),
                _CollapsibleSection(
                  worldId: worldId,
                  group: 'tools',
                  label: context.l10n.sectionTools,
                  child: _toolGroup(context, ref),
                ),
                _CollapsibleSection(
                  worldId: worldId,
                  group: 'libraryKinds',
                  label: context.l10n.sectionLibrary,
                  child: _kindGroup(
                      ref, 'libraryKinds', EntityKind.libraryKinds, counts),
                ),
                _CategoriesSection(worldId: worldId),
              ],
            ),
          ),
          const Divider(),
          if ((ref.watch(trashProvider(worldId)).valueOrNull ?? const [])
              case final trashed when trashed.isNotEmpty)
            _NavTile(
              icon: Icons.delete_outline,
              label: '${context.l10n.trashTitle} · ${trashed.length}',
              selected: location.endsWith('/trash'),
              onTap: () => ref
                  .read(workspaceTabsProvider.notifier)
                  .openInNewTab(Routes.trash(worldId)),
            ),
          _NavTile(
            icon: Icons.help_outline,
            label: context.l10n.helpTitle,
            selected: location.endsWith('/help'),
            onTap: () => ref
                .read(workspaceTabsProvider.notifier)
                .openInNewTab(Routes.help(worldId)),
          ),
          _NavTile(
            icon: Icons.settings_outlined,
            label: context.l10n.navSettings,
            selected: section == _Section.settings,
            onTap: () => ref
                .read(workspaceTabsProvider.notifier)
                .openInNewTab(Routes.settings(worldId)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

extension on _Sidebar {
  Widget _mainNavTile(BuildContext context, WidgetRef ref, String id,
      _Section? section, String location) {
    void openTab(String target) =>
        ref.read(workspaceTabsProvider.notifier).openInNewTab(target);
    switch (id) {
      case 'dashboard':
        return _NavTile(
          icon: Icons.dashboard_outlined,
          label: context.l10n.navDashboard,
          selected: section == _Section.home,
          onTap: () => openTab(Routes.home(worldId)),
        );
      case 'search':
        return _NavTile(
          icon: Icons.search,
          label: context.l10n.navSearch,
          selected: section == _Section.search,
          onTap: () => openTab(Routes.search(worldId)),
        );
      case 'graph':
        return _NavTile(
          icon: Icons.hub_outlined,
          label: context.l10n.navGraph,
          selected: section == _Section.graph,
          onTap: () => openTab(Routes.graph(worldId)),
        );
      case 'campaigns':
        return _NavTile(
          icon: Icons.map_outlined,
          label: EntityKind.campaign.localizedPlural(context),
          selected: section == _Section.campaigns,
          onTap: () => openTab(Routes.campaigns(worldId)),
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

  Widget _toolGroup(BuildContext context, WidgetRef ref) {
    final activeTool = _currentToolId(context);
    return _DraggableGroup(
      ids: applySidebarOrder(
        [for (final t in gmhTools) t.id],
        ref.watch(sidebarOrderProvider('$worldId|tools')),
      ),
      itemBuilder: (id) {
        final tool = toolById(id)!;
        return _NavTile(
          icon: tool.icon,
          label: tool.label(context.l10n),
          selected: activeTool == id,
          onTap: () => ref
              .read(workspaceTabsProvider.notifier)
              .openInNewTab(Routes.tool(worldId, id)),
        );
      },
      onReorder: (order) => ref
          .read(sidebarOrderProvider('$worldId|tools').notifier)
          .setOrder(order),
    );
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
class _DraggableGroup extends StatefulWidget {
  final List<String> ids;
  final Widget Function(String id) itemBuilder;
  final void Function(List<String> newOrder) onReorder;

  const _DraggableGroup({
    required this.ids,
    required this.itemBuilder,
    required this.onReorder,
  });

  @override
  State<_DraggableGroup> createState() => _DraggableGroupState();
}

class _DraggableGroupState extends State<_DraggableGroup> {
  /// Shown order. A drop applies it at once; without this the list
  /// snapped back to the old order until the store's stream caught up,
  /// then jumped.
  late List<String> _order = widget.ids;

  @override
  void didUpdateWidget(_DraggableGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.ids, widget.ids)) _order = widget.ids;
  }

  @override
  Widget build(BuildContext context) {
    final ids = _order;
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        final order = [...ids];
        if (newIndex > oldIndex) newIndex--;
        order.insert(newIndex, order.removeAt(oldIndex));
        setState(() => _order = order);
        widget.onReorder(order);
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
            child: widget.itemBuilder(ids[i]),
          ),
      ],
    );
  }
}

/// A sidebar section whose header toggles it open/closed (persisted per
/// world and group).
class _CollapsibleSection extends ConsumerWidget {
  final String worldId;
  final String group;
  final String label;
  final Widget child;

  const _CollapsibleSection({
    required this.worldId,
    required this.group,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = '$worldId|$group';
    final collapsed = ref.watch(sidebarCollapsedProvider(key));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          label,
          collapsed: collapsed,
          onTap: () =>
              ref.read(sidebarCollapsedProvider(key).notifier).toggle(),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.topCenter,
          child: collapsed ? const SizedBox(width: double.infinity) : child,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  /// When set, the header is a toggle showing a chevron.
  final bool? collapsed;
  final VoidCallback? onTap;
  const _SectionHeader(this.label, {this.collapsed, this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 10.5,
        letterSpacing: 1.6,
        fontWeight: FontWeight.w700,
        color: GmhColors.parchmentFaint,
      ),
    );
    if (onTap == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
        child: text,
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
          child: Row(
            children: [
              Expanded(child: text),
              AnimatedRotation(
                turns: collapsed == true ? -0.25 : 0,
                duration: const Duration(milliseconds: 160),
                child: Icon(Icons.expand_more,
                    size: 16, color: GmhColors.parchmentFaint),
              ),
            ],
          ),
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

class _KindTile extends ConsumerWidget {
  final String worldId;
  final EntityKind kind;
  final int? count;

  const _KindTile({required this.worldId, required this.kind, this.count});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onTap: () => ref
          .read(workspaceTabsProvider.notifier)
          .openInNewTab(Routes.browse(worldId, kind)),
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
              onTap: () => ref
                  .read(workspaceTabsProvider.notifier)
                  .openInNewTab(
                      Routes.browseCategory(worldId, category.id)),
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

class _Rail extends ConsumerWidget {
  final String worldId;
  const _Rail({required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = _currentSection(context);
    // Six destinations plus the world and history buttons need ~600px:
    // on short windows (or large text) the rail scrolls instead of
    // overflowing.
    return LayoutBuilder(
      builder: (context, constraints) => ColoredBox(
        color: GmhColors.surface,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: _rail(context, ref, section)),
          ),
        ),
      ),
    );
  }

  Widget _rail(BuildContext context, WidgetRef ref, _Section? section) {
    return NavigationRail(
      backgroundColor: GmhColors.surface,
      selectedIndex: section?.index,
      onDestinationSelected: (index) => ref
          .read(workspaceTabsProvider.notifier)
          .openInNewTab(
              _sectionRoute(worldId, _Section.values[index])),
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: [
          IconButton(
            tooltip: context.l10n.switchWorld,
            icon: Icon(Icons.public, color: GmhColors.ember),
            onPressed: () => context.go(Routes.worlds()),
          ),
          const HistoryButtons(compact: true, vertical: true),
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
            label: Text(EntityKind.campaign.localizedPlural(context))),
        NavigationRailDestination(
            icon: const Icon(Icons.handyman_outlined),
            label: Text(context.l10n.navTools)),
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
              child: HistoryButtons(compact: true),
            ),
            Expanded(
              child: NavigationBar(
                // NavigationBar can't render "nothing selected"; hide the
                // indicator instead when no top-level section is active.
                selectedIndex: _phoneSections.contains(section)
                    ? _phoneSections.indexOf(section!)
                    : 0,
                indicatorColor: _phoneSections.contains(section)
                    ? null
                    : Colors.transparent,
                // Five localized labels in ~64px slots break mid-word
                // (German, French, Russian): narrow phones label only the
                // active section — the rest keep their tooltips — and
                // no label at all reads as "selected" when none is.
                labelBehavior: !_phoneSections.contains(section)
                    ? NavigationDestinationLabelBehavior.alwaysHide
                    : MediaQuery.sizeOf(context).width < 480
                        ? NavigationDestinationLabelBehavior.onlyShowSelected
                        : NavigationDestinationLabelBehavior.alwaysShow,
                height: 64,
                onDestinationSelected: (index) =>
                    _goToSection(context, worldId, _phoneSections[index]),
                destinations: _destinations(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Five slots fit a phone: the graph stays reachable from the dashboard.
  static const _phoneSections = [
    _Section.home,
    _Section.search,
    _Section.campaigns,
    _Section.tools,
    _Section.settings,
  ];

  List<NavigationDestination> _destinations(BuildContext context) => [
        NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            label: context.l10n.navHome),
        NavigationDestination(
            icon: const Icon(Icons.search), label: context.l10n.navSearch),
        NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            label: EntityKind.campaign.localizedPlural(context)),
        NavigationDestination(
            icon: const Icon(Icons.handyman_outlined),
            label: context.l10n.navTools),
        NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: context.l10n.navSettingsShort),
      ];
}
