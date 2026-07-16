import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/repositories/repositories.dart';
import '../shell/ui_providers.dart';
import 'widgets/entity_card.dart';
import 'widgets/new_entity_dialog.dart';

/// Browsable, filterable list of all entities of one kind.
class EntityListScreen extends ConsumerStatefulWidget {
  final String worldId;
  final EntityKind kind;

  const EntityListScreen(
      {super.key, required this.worldId, required this.kind});

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
      tagId: _tagId,
      favoritesOnly: _favoritesOnly,
      sort: _sort,
    )));
    final tags =
        ref.watch(worldTagsProvider(widget.worldId)).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(widget.kind.icon, color: widget.kind.color, size: 22),
            const SizedBox(width: 10),
            Text(widget.kind.pluralLabel),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _favoritesOnly ? 'Show all' : 'Favorites only',
            icon: Icon(_favoritesOnly ? Icons.star : Icons.star_border,
                color: _favoritesOnly ? GmhColors.ember : null),
            onPressed: () =>
                setState(() => _favoritesOnly = !_favoritesOnly),
          ),
          PopupMenuButton<EntitySort>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            onSelected: (sort) => setState(() => _sort = sort),
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: EntitySort.updatedDesc,
                  child: Text('Recently edited')),
              PopupMenuItem(
                  value: EntitySort.nameAsc, child: Text('Name (A–Z)')),
              PopupMenuItem(
                  value: EntitySort.createdDesc,
                  child: Text('Newest first')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'newOfKind',
        tooltip: 'New ${widget.kind.label}',
        onPressed: () => showNewEntityDialog(context, ref, widget.worldId,
            initialKind: widget.kind),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter ${widget.kind.pluralLabel.toLowerCase()}…',
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
              error: (e, _) => Center(child: Text('Error: $e')),
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
                        Icon(widget.kind.icon,
                            size: 44,
                            color: widget.kind.color.withValues(alpha: 0.4)),
                        const SizedBox(height: 10),
                        Text(
                          'No ${widget.kind.pluralLabel.toLowerCase()} yet',
                          style: const TextStyle(
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
