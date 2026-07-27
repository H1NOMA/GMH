import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/nav_state.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../core/utils/debouncer.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/search_result.dart';
import '../categories/category_ui.dart';
import '../entities/widgets/new_entity_dialog.dart';
import '../tags/tag_manager_sheet.dart';
import '../shell/ui_providers.dart';

/// Global full-text search across every entity — names, summaries, document
/// bodies and tags — with kind filters, recents and quick commands.
/// FTS5 with prefix indexes keeps this instant at 10,000+ entries.
class SearchScreen extends ConsumerStatefulWidget {
  final String worldId;
  const SearchScreen({super.key, required this.worldId});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  // Query and filters live in a per-world session provider, so leaving the
  // search screen and coming back restores the exact search.
  late final _controller = TextEditingController(
      text: ref.read(searchStateProvider(widget.worldId)).query);
  final _debouncer = Debouncer(GmhConstants.searchDebounce);
  List<SearchResult> _results = const [];
  bool _searching = false;
  // Monotonic token: two quick searches can resolve out of order, and the
  // earlier one must not overwrite the later one's results.
  int _searchGeneration = 0;

  EntityKind? get _kindFilter =>
      ref.read(searchStateProvider(widget.worldId)).kind;

  String? get _categoryFilter {
    final id = ref.read(searchStateProvider(widget.worldId)).categoryId;
    if (id == null) return null;
    // The session-kept filter may point at a category deleted meanwhile;
    // silently filtering every query down to zero results would look like
    // the search is broken. Treat a missing category as "no filter" (the
    // stored id is cleared post-frame, never during build).
    final categories =
        ref.read(worldCategoriesProvider(widget.worldId)).valueOrNull;
    if (categories != null && !categories.any((c) => c.id == id)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // The category chip sets kind=custom together with the id; both
        // must go, or a hidden custom-kind filter keeps every query empty
        // with no chip visibly selected.
        ref
            .read(searchStateProvider(widget.worldId).notifier)
            .update(clearCategory: true, clearKind: true);
      });
      return null;
    }
    return id;
  }

  @override
  void initState() {
    super.initState();
    if (_controller.text.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _search());
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    ref
        .read(searchStateProvider(widget.worldId).notifier)
        .update(query: query);
    if (query.isEmpty) {
      // Invalidate any in-flight search so its late result can't repaint
      // the cleared box.
      ++_searchGeneration;
      setState(() {
        _results = const [];
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    final generation = ++_searchGeneration;
    final results = await ref.read(searchRepositoryProvider).search(
        widget.worldId, query,
        kind: _kindFilter, customCategoryId: _categoryFilter);
    if (!mounted || generation != _searchGeneration) return;
    setState(() {
      _results = results;
      _searching = false;
    });
  }

  void _open(String entityId) {
    ref.read(searchRepositoryProvider).recordOpened(entityId);
    context.go(Routes.entity(widget.worldId, entityId));
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _controller.text.trim().isNotEmpty;
    final recents =
        ref.watch(recentEntitiesProvider(widget.worldId)).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navSearch)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.searchHint,
                prefixIcon: const Icon(Icons.search, size: 19),
                suffixIcon: hasQuery
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 17),
                        onPressed: () {
                          _controller.clear();
                          _search();
                        },
                      )
                    : null,
              ),
              onChanged: (_) {
                setState(() {}); // update suffix icon promptly
                _debouncer(() => unawaited(_search()));
              },
            ),
          ),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(context.l10n.searchAll,
                        style: const TextStyle(fontSize: 11.5)),
                    selected: _kindFilter == null && _categoryFilter == null,
                    onSelected: (_) {
                      ref
                          .read(searchStateProvider(widget.worldId).notifier)
                          .update(clearKind: true, clearCategory: true);
                      setState(() {});
                      unawaited(_search());
                    },
                  ),
                ),
                for (final kind in EntityKind.values)
                  if (kind != EntityKind.custom)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        avatar: Icon(kind.icon, size: 13, color: kind.color),
                        label: Text(kind.localizedPlural(context),
                            style: const TextStyle(fontSize: 11.5)),
                        selected: _kindFilter == kind,
                        onSelected: (selected) {
                          ref
                              .read(searchStateProvider(widget.worldId)
                                  .notifier)
                              .update(
                                  kind: selected ? kind : null,
                                  clearKind: !selected,
                                  clearCategory: true);
                          setState(() {});
                          unawaited(_search());
                        },
                      ),
                    ),
                for (final category in ref
                        .watch(worldCategoriesProvider(widget.worldId))
                        .valueOrNull ??
                    [])
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      avatar: Icon(categoryIconFor(category.icon),
                          size: 13, color: adaptiveAccent(Color(category.color))),
                      label: Text(category.name,
                          style: const TextStyle(fontSize: 11.5)),
                      selected: _categoryFilter == category.id,
                      onSelected: (selected) {
                        ref
                            .read(searchStateProvider(widget.worldId)
                                .notifier)
                            .update(
                                categoryId:
                                    selected ? category.id : null,
                                clearCategory: !selected,
                                kind:
                                    selected ? EntityKind.custom : null,
                                clearKind: !selected);
                        setState(() {});
                        unawaited(_search());
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: !hasQuery
                ? _IdleView(
                    worldId: widget.worldId,
                    recents: recents,
                    onOpen: _open,
                  )
                : _searching && _results.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _results.isEmpty
                        ? Center(
                            child: Text(context.l10n.searchNoMatches,
                                style: TextStyle(
                                    color: GmhColors.parchmentDim)))
                        : ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(16, 4, 16, 40),
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final result = _results[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Icon(result.kind.icon,
                                      size: 20, color: result.kind.color),
                                  title: Text(result.name),
                                  subtitle: _SnippetText(result: result),
                                  onTap: () => _open(result.entityId),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _IdleView extends ConsumerWidget {
  final String worldId;
  final List recents;
  final void Function(String entityId) onOpen;

  const _IdleView({
    required this.worldId,
    required this.recents,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(context.l10n.quickActions,
              style: TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                  color: GmhColors.parchmentFaint)),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.add, size: 15),
              label: Text(context.l10n.quickNewEntry),
              onPressed: () => showNewEntityDialog(context, ref, worldId),
            ),
            ActionChip(
              avatar: const Icon(Icons.hub_outlined, size: 15),
              label: Text(context.l10n.quickOpenGraph),
              onPressed: () => context.go(Routes.graph(worldId)),
            ),
            ActionChip(
              avatar: const Icon(Icons.map_outlined, size: 15),
              label: Text(context.l10n.navCampaigns),
              onPressed: () => context.go(Routes.campaigns(worldId)),
            ),
            ActionChip(
              avatar: const Icon(Icons.sell_outlined, size: 15),
              label: Text(context.l10n.tagManagerTitle),
              onPressed: () => showTagManagerSheet(context, worldId),
            ),
            ActionChip(
              avatar: const Icon(Icons.save_outlined, size: 15),
              label: Text(context.l10n.quickBackupExport),
              onPressed: () => context.go(Routes.settings(worldId)),
            ),
          ],
        ),
        if (recents.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(context.l10n.recentlyOpenedCaps,
                style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: GmhColors.parchmentFaint)),
          ),
          for (final entity in recents)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(entity.kind.icon,
                    size: 20, color: entity.kind.color),
                title: Text(entity.name),
                subtitle: entity.summary.isEmpty
                    ? null
                    : Text(entity.summary,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => onOpen(entity.id),
              ),
            ),
        ],
      ],
    );
  }
}

/// Renders an FTS snippet, highlighting matched terms.
class _SnippetText extends StatelessWidget {
  final SearchResult result;
  const _SnippetText({required this.result});

  @override
  Widget build(BuildContext context) {
    final text = result.snippet.isEmpty ? result.summary : result.snippet;
    if (text.isEmpty) {
      return Text(result.kind.localizedLabel(context),
          style: const TextStyle(fontSize: 11.5));
    }

    final spans = <TextSpan>[];
    var remaining = text;
    while (true) {
      final start = remaining.indexOf(SearchResult.snippetMarkerStart);
      if (start < 0) {
        spans.add(TextSpan(text: remaining));
        break;
      }
      final end = remaining.indexOf(SearchResult.snippetMarkerEnd,
          start + SearchResult.snippetMarkerStart.length);
      if (end < 0) {
        spans.add(TextSpan(text: remaining));
        break;
      }
      if (start > 0) {
        spans.add(TextSpan(text: remaining.substring(0, start)));
      }
      spans.add(TextSpan(
        text: remaining.substring(
            start + SearchResult.snippetMarkerStart.length, end),
        style: TextStyle(
            color: GmhColors.emberBright, fontWeight: FontWeight.w600),
      ));
      remaining =
          remaining.substring(end + SearchResult.snippetMarkerEnd.length);
    }

    return Text.rich(
      TextSpan(
          style: TextStyle(
              fontSize: 11.5, color: GmhColors.parchmentDim),
          children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
