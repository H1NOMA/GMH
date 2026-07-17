import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../app/l10n_ext.dart';
import '../../core/constants.dart';
import '../../domain/models/entity_kind.dart';
import '../categories/category_ui.dart';
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
    if (width >= GmhConstants.desktopMinWidth) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 264, child: _Sidebar(worldId: worldId)),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }
    if (width >= GmhConstants.phoneMaxWidth) {
      return Scaffold(
        body: Row(
          children: [
            _Rail(worldId: worldId),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(worldId: worldId),
    );
  }
}

enum _Section { home, search, graph, campaigns, settings }

_Section _currentSection(BuildContext context) {
  final location = GoRouterState.of(context).uri.path;
  if (location.contains('/search')) return _Section.search;
  if (location.contains('/graph')) return _Section.graph;
  if (location.contains('/campaigns')) return _Section.campaigns;
  if (location.contains('/settings')) return _Section.settings;
  return _Section.home;
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
                  const Icon(Icons.public, color: GmhColors.ember, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      world?.name ?? '…',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.unfold_more,
                      size: 18, color: GmhColors.parchmentDim),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavTile(
                  icon: Icons.dashboard_outlined,
                  label: context.l10n.navDashboard,
                  selected: section == _Section.home &&
                      location.endsWith('/home'),
                  onTap: () => context.go(Routes.home(worldId)),
                ),
                _NavTile(
                  icon: Icons.search,
                  label: context.l10n.navSearch,
                  selected: section == _Section.search,
                  onTap: () => context.go(Routes.search(worldId)),
                ),
                _NavTile(
                  icon: Icons.hub_outlined,
                  label: context.l10n.navGraph,
                  selected: section == _Section.graph,
                  onTap: () => context.go(Routes.graph(worldId)),
                ),
                _NavTile(
                  icon: Icons.map_outlined,
                  label: context.l10n.navCampaigns,
                  selected: section == _Section.campaigns,
                  onTap: () => context.go(Routes.campaigns(worldId)),
                ),
                _SectionHeader(context.l10n.sectionWorld),
                for (final kind in EntityKind.worldKinds)
                  _KindTile(worldId: worldId, kind: kind, count: counts[kind]),
                _SectionHeader(context.l10n.sectionLibrary),
                for (final kind in EntityKind.libraryKinds)
                  _KindTile(worldId: worldId, kind: kind, count: counts[kind]),
                _CategoriesSection(worldId: worldId),
              ],
            ),
          ),
          const Divider(),
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

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Text(
        label,
        style: const TextStyle(
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
              style: const TextStyle(
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
                  style: const TextStyle(
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
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.tune,
                        size: 15, color: GmhColors.parchmentFaint),
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final category in categories)
          ListTile(
            leading: Icon(categoryIconFor(category.icon),
                size: 19,
                color: location.endsWith('/category/${category.id}')
                    ? Color(category.color)
                    : GmhColors.parchmentDim),
            title: Text(category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  color: location.endsWith('/category/${category.id}')
                      ? GmhColors.emberBright
                      : GmhColors.parchment,
                )),
            trailing: (counts[category.id] ?? 0) == 0
                ? null
                : Text('${counts[category.id]}',
                    style: const TextStyle(
                        fontSize: 12, color: GmhColors.parchmentFaint)),
            selected: location.endsWith('/category/${category.id}'),
            selectedTileColor: GmhColors.ember.withValues(alpha: 0.08),
            onTap: () =>
                context.go(Routes.browseCategory(worldId, category.id)),
            visualDensity: const VisualDensity(vertical: -3),
          ),
        ListTile(
          leading: const Icon(Icons.add,
              size: 18, color: GmhColors.parchmentFaint),
          title: Text(context.l10n.newCategory,
              style: const TextStyle(
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
      selectedIndex: section.index,
      onDestinationSelected: (index) =>
          _goToSection(context, worldId, _Section.values[index]),
      labelType: NavigationRailLabelType.all,
      leading: IconButton(
        tooltip: context.l10n.switchWorld,
        icon: const Icon(Icons.public, color: GmhColors.ember),
        onPressed: () => context.go(Routes.worlds()),
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
    return NavigationBar(
      selectedIndex: section.index,
      height: 64,
      onDestinationSelected: (index) =>
          _goToSection(context, worldId, _Section.values[index]),
      destinations: [
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
      ],
    );
  }
}
