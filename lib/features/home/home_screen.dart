import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';
import '../categories/category_ui.dart';
import '../categories/manage_categories_sheet.dart';
import '../entities/widgets/entity_card.dart';
import '../entities/widgets/new_entity_dialog.dart';
import '../shell/history_buttons.dart';
import '../shell/ui_providers.dart';

/// World dashboard: category grid with live counts, recently opened items
/// and favorites.
class HomeScreen extends ConsumerWidget {
  final String worldId;
  const HomeScreen({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldProvider(worldId)).valueOrNull;
    final counts =
        ref.watch(entityCountsProvider(worldId)).valueOrNull ?? const {};
    final recents = ref.watch(recentEntitiesProvider(worldId)).valueOrNull;
    final favorites = ref
        .watch(entityListProvider((
          worldId: worldId,
          kind: null,
          customCategoryId: null,
          tagId: null,
          favoritesOnly: true,
          sort: EntitySort.updatedDesc,
        )))
        .valueOrNull;
    final isPhone =
        MediaQuery.sizeOf(context).width < GmhConstants.phoneMaxWidth;

    return Scaffold(
      appBar: AppBar(
        leading: historyLeading(),
        leadingWidth: kHistoryLeadingWidth,
        title: Text(world?.name ?? ''),
        actions: [
          IconButton(
            tooltip: context.l10n.helpTitle,
            icon: const Icon(Icons.help_outline),
            onPressed: () => context.go(Routes.help(worldId)),
          ),
          if (isPhone)
            IconButton(
              tooltip: context.l10n.switchWorld,
              icon: const Icon(Icons.public),
              onPressed: () => context.go(Routes.worlds()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newEntity',
        onPressed: () => showNewEntityDialog(context, ref, worldId),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.newButton),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          if (world != null && world.description.isNotEmpty) ...[
            Text(world.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GmhColors.parchmentDim,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
          ],
          _SectionTitle(context.l10n.homeTheWorld),
          const SizedBox(height: 10),
          _KindGrid(worldId: worldId, kinds: EntityKind.worldKinds, counts: counts),
          const SizedBox(height: 22),
          _SectionTitle(context.l10n.homeLibrary),
          const SizedBox(height: 10),
          _KindGrid(
              worldId: worldId,
              kinds: [...EntityKind.libraryKinds, ...EntityKind.campaignKinds],
              counts: counts),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                  child:
                      _SectionTitle(context.l10n.manageCategories)),
              IconButton(
                tooltip: context.l10n.manageCategories,
                icon: const Icon(Icons.tune, size: 18),
                onPressed: () =>
                    showManageCategoriesSheet(context, worldId),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _CategoryGrid(worldId: worldId),
          if (favorites != null && favorites.isNotEmpty) ...[
            const SizedBox(height: 22),
            _SectionTitle(context.l10n.homeFavorites),
            const SizedBox(height: 10),
            for (final entity in favorites.take(8))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EntityCard(entity: entity, worldId: worldId),
              ),
          ],
          if (recents != null && recents.isNotEmpty) ...[
            const SizedBox(height: 22),
            _SectionTitle(context.l10n.homeRecentlyOpened),
            const SizedBox(height: 10),
            for (final entity in recents.take(10))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EntityCard(entity: entity, worldId: worldId),
              ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle(this.label);

  @override
  Widget build(BuildContext context) =>
      Text(label, style: Theme.of(context).textTheme.headlineSmall);
}

class _CategoryGrid extends ConsumerWidget {
  final String worldId;
  const _CategoryGrid({required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(worldCategoriesProvider(worldId)).valueOrNull ?? [];
    final counts =
        ref.watch(categoryCountsProvider(worldId)).valueOrNull ?? const {};
    if (categories.isEmpty) {
      return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => showManageCategoriesSheet(context, worldId),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.add, color: GmhColors.parchmentDim),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(context.l10n.noCategoriesYet,
                      style: TextStyle(
                          fontSize: 12.5, color: GmhColors.parchmentDim)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _TileGrid(
      children: [
        for (final category in categories)
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () =>
                  context.go(Routes.browseCategory(worldId, category.id)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(categoryIconFor(category.icon),
                        color: adaptiveAccent(Color(category.color)), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.titleMedium),
                          Text(
                              context.l10n
                                  .entriesCount(counts[category.id] ?? 0),
                              style:
                                  Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _KindGrid extends StatelessWidget {
  final String worldId;
  final List<EntityKind> kinds;
  final Map<EntityKind, int> counts;

  const _KindGrid(
      {required this.worldId, required this.kinds, required this.counts});

  @override
  Widget build(BuildContext context) {
    return _TileGrid(
      children: [
        for (final kind in kinds)
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.go(Routes.browse(worldId, kind)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(kind.icon, color: kind.color, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(kind.localizedPlural(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(context.l10n.entriesCount(counts[kind] ?? 0),
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Dashboard tile grid: columns follow the width the grid actually gets
/// (not the window's, which ignores the sidebar), and tile height grows
/// with the text scale so two lines of large text never overflow.
class _TileGrid extends StatelessWidget {
  final List<Widget> children;
  const _TileGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 210).floor().clamp(2, 6);
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 30 + 42 * textScale,
          ),
          children: children,
        );
      },
    );
  }
}
