import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../domain/models/entity_kind.dart';
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
                  label: 'Dashboard',
                  selected: section == _Section.home &&
                      location.endsWith('/home'),
                  onTap: () => context.go(Routes.home(worldId)),
                ),
                _NavTile(
                  icon: Icons.search,
                  label: 'Search',
                  selected: section == _Section.search,
                  onTap: () => context.go(Routes.search(worldId)),
                ),
                _NavTile(
                  icon: Icons.hub_outlined,
                  label: 'Graph View',
                  selected: section == _Section.graph,
                  onTap: () => context.go(Routes.graph(worldId)),
                ),
                _NavTile(
                  icon: Icons.map_outlined,
                  label: 'Campaigns',
                  selected: section == _Section.campaigns,
                  onTap: () => context.go(Routes.campaigns(worldId)),
                ),
                const _SectionHeader('WORLD'),
                for (final kind in EntityKind.worldKinds)
                  _KindTile(worldId: worldId, kind: kind, count: counts[kind]),
                const _SectionHeader('LIBRARY'),
                for (final kind in EntityKind.libraryKinds)
                  _KindTile(worldId: worldId, kind: kind, count: counts[kind]),
              ],
            ),
          ),
          const Divider(),
          _NavTile(
            icon: Icons.settings_outlined,
            label: 'Settings & Backup',
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
      title: Text(kind.pluralLabel,
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
        tooltip: 'Switch world',
        icon: const Icon(Icons.public, color: GmhColors.ember),
        onPressed: () => context.go(Routes.worlds()),
      ),
      destinations: const [
        NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined), label: Text('Home')),
        NavigationRailDestination(
            icon: Icon(Icons.search), label: Text('Search')),
        NavigationRailDestination(
            icon: Icon(Icons.hub_outlined), label: Text('Graph')),
        NavigationRailDestination(
            icon: Icon(Icons.map_outlined), label: Text('Campaigns')),
        NavigationRailDestination(
            icon: Icon(Icons.settings_outlined), label: Text('Settings')),
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
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.dashboard_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(icon: Icon(Icons.hub_outlined), label: 'Graph'),
        NavigationDestination(
            icon: Icon(Icons.map_outlined), label: 'Campaigns'),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
    );
  }
}
