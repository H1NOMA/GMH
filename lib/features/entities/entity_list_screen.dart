import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';
import '../categories/category_ui.dart';
import '../shell/ui_providers.dart';
import 'widgets/entity_card.dart';
import 'widgets/new_entity_dialog.dart';

/// Browsable, filterable list of all entities of one kind — or, when
/// [customCategoryId] is set, of one user-defined category (which behaves
/// exactly like a built-in kind).
class EntityListScreen extends ConsumerStatefulWidget {
  final String worldId;
  final EntityKind kind;
  final String? customCategoryId;

  const EntityListScreen({
    super.key,
    required this.worldId,
    required this.kind,
    this.customCategoryId,
  });

  @override
  ConsumerState<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends ConsumerState<EntityListScreen> {
  EntitySort _sort = EntitySort.updatedDesc;
  String? _tagId;
  bool _favoritesOnly = false;
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final entities = ref.watch(entityListProvider((
      worldId: widget.worldId,
      kind: widget.kind,
      customCategoryId: widget.customCategoryId,
      tagId: _tagId,
      favoritesOnly: _favoritesOnly,
      sort: _sort,
    )));
    final tags =
        ref.watch(worldTagsProvider(widget.worldId)).valueOrNull ?? [];
    final category = widget.customCategoryId == null
        ? null
        : ref.watch(categoryMapProvider(widget.worldId))[
            widget.customCategoryId];
    final title =
        category?.name ?? widget.kind.localizedPlural(context);
    final icon =
        category == null ? widget.kind.icon : categoryIconFor(category.icon);
    final color =
        category == null ? widget.kind.color : Color(category.color);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _favoritesOnly
                ? context.l10n.showAll
                : context.l10n.favoritesOnly,
            icon: Icon(_favoritesOnly ? Icons.star : Icons.star_border,
                color: _favoritesOnly ? GmhColors.ember : null),
            onPressed: () =>
                setState(() => _favoritesOnly = !_favoritesOnly),
          ),
          PopupMenuButton<EntitySort>(
            tooltip: context.l10n.sortTooltip,
            icon: const Icon(Icons.sort),
            onSelected: (sort) => setState(() => _sort = sort),
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: EntitySort.updatedDesc,
                  child: Text(context.l10n.sortRecentlyEdited)),
              PopupMenuItem(
                  value: EntitySort.nameAsc,
                  child: Text(context.l10n.sortNameAz)),
              PopupMenuItem(
                  value: EntitySort.createdDesc,
                  child: Text(context.l10n.sortNewestFirst)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'newOfKind',
        tooltip: context.l10n.newOfKind(
            category?.name ?? widget.kind.localizedLabel(context)),
        onPressed: () => showNewEntityDialog(context, ref, widget.worldId,
            initialKind: widget.kind,
            initialCategoryId: widget.customCategoryId),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.l10n.filterHint(title.toLowerCase()),
                prefixIcon: const Icon(Icons.filter_alt_outlined, size: 18),
              ),
              onChanged: (text) =>
                  setState(() => _filter = text.toLowerCase()),
            ),
          ),
          if (tags.isNotEmpty)
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final tag in tags)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(tag.name,
                            style: TextStyle(
                                fontSize: 11.5, color: Color(tag.color))),
                        selected: _tagId == tag.id,
                        onSelected: (selected) => setState(
                            () => _tagId = selected ? tag.id : null),
                        selectedColor:
                            Color(tag.color).withValues(alpha: 0.2),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: entities.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(context.l10n.errorGeneric('$e'))),
              data: (list) {
                final visible = _filter.isEmpty
                    ? list
                    : list
                        .where((e) =>
                            e.name.toLowerCase().contains(_filter) ||
                            e.summary.toLowerCase().contains(_filter))
                        .toList();
                if (visible.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon,
                            size: 44, color: color.withValues(alpha: 0.4)),
                        const SizedBox(height: 10),
                        Text(
                          context.l10n.noEntriesOfKind(title),
                          style: TextStyle(
                              color: GmhColors.parchmentDim),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => EntityCard(
                      entity: visible[index], worldId: widget.worldId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
