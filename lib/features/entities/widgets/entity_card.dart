import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/entity.dart';
import '../../categories/category_ui.dart';
import '../../shell/ui_providers.dart';
import 'entity_context.dart';

/// Card representation of an entity used in lists, dashboards and search.
class EntityCard extends ConsumerWidget {
  final Entity entity;
  final String worldId;

  /// Optional highlighted snippet (from search results).
  final Widget? subtitleOverride;

  const EntityCard({
    super.key,
    required this.entity,
    required this.worldId,
    this.subtitleOverride,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(entityTagsProvider(entity.id)).valueOrNull ?? [];
    final categories = ref.watch(categoryMapProvider(worldId));

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          ref.read(searchRepositoryProvider).recordOpened(entity.id);
          context.go(Routes.entity(worldId, entity.id));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _CoverThumb(
                  entity: entity,
                  icon: entityIcon(entity, categories),
                  color: entityColor(entity, categories)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(entity.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.titleMedium),
                        ),
                        if (entity.isFavorite)
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(Icons.star,
                                size: 15, color: GmhColors.ember),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    subtitleOverride ??
                        Text(
                          entity.summary.isEmpty
                              ? (categories[entity.customCategoryId]?.name ??
                                  entity.kind.localizedLabel(context))
                              : entity.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    // What this section cares about: status/class for
                    // characters, rarity for items, CR for creatures…
                    ContextBadgesRow(
                        entity: entity,
                        category: categories[entity.customCategoryId]),
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          for (final tag in tags.take(4))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(tag.color)
                                    .withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                    color: Color(tag.color)
                                        .withValues(alpha: 0.5)),
                              ),
                              child: Text(tag.name,
                                  style: TextStyle(
                                      fontSize: 10.5,
                                      color: Color(tag.color))),
                            ),
                        ],
                      ),
                    ],
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

class _CoverThumb extends ConsumerWidget {
  final Entity entity;
  final IconData icon;
  final Color color;

  const _CoverThumb(
      {required this.entity, required this.icon, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverId = entity.coverMediaId;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: coverId == null
          ? Icon(icon, color: color, size: 22)
          : FutureBuilder<String?>(
              future: () async {
                final media =
                    await ref.read(mediaRepositoryProvider).get(coverId);
                if (media == null) return null;
                return ref.read(mediaRepositoryProvider).absolutePath(media);
              }(),
              builder: (context, snapshot) {
                final path = snapshot.data;
                if (path == null) {
                  return Icon(icon, color: color, size: 22);
                }
                return Image.file(File(path),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Icon(icon, color: color, size: 22));
              },
            ),
    );
  }
}
