import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/widgets/entity_card.dart';
import '../entities/widgets/new_entity_dialog.dart';
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
          tagId: null,
          favoritesOnly: true,
          sort: EntitySort.updatedDesc,
        )))
        .valueOrNull;
    final isPhone =
        MediaQuery.sizeOf(context).width < GmhConstants.phoneMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text(world?.name ?? ''),
        actions: [
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

class _KindGrid extends StatelessWidget {
  final String worldId;
  final List<EntityKind> kinds;
  final Map<EntityKind, int> counts;

  const _KindGrid(
      {required this.worldId, required this.kinds, required this.counts});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 1400
        ? 5
        : width > 1000
            ? 4
            : width > 640
                ? 3
                : 2;
    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: [
        for (final kind in kinds)
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
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
