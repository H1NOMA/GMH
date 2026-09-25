import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../categories/category_ui.dart';
import '../../../app/providers.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../core/constants.dart';
import '../../../core/utils/debouncer.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/entity_kind.dart';

/// Search-as-you-type entity picker used by the mention button, entityRef
/// attribute fields and the relations panel. Returns the chosen entity.
Future<Entity?> showEntityPickerDialog(
  BuildContext context, {
  required String worldId,
  List<EntityKind> kinds = const [],
  Set<String> excludeIds = const {},
  String? title,
}) {
  return showDialog<Entity>(
    context: context,
    builder: (context) => _EntityPickerDialog(
        worldId: worldId,
        kinds: kinds,
        excludeIds: excludeIds,
        title: title ?? context.l10n.pickerTitleDefault),
  );
}

class _EntityPickerDialog extends ConsumerStatefulWidget {
  final String worldId;
  final List<EntityKind> kinds;
  final Set<String> excludeIds;
  final String title;

  const _EntityPickerDialog({
    required this.worldId,
    required this.kinds,
    required this.excludeIds,
    required this.title,
  });

  @override
  ConsumerState<_EntityPickerDialog> createState() =>
      _EntityPickerDialogState();
}

class _EntityPickerDialogState extends ConsumerState<_EntityPickerDialog> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer(GmhConstants.searchDebounce);
  List<Entity> _results = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_query(''));
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _query(String text) async {
    // The kind restriction is applied in SQL: filtering the 30-row result
    // afterwards could show "no matches" for an existing campaign whenever
    // same-named locations/items consumed the whole limit.
    final all = await ref
        .read(entityRepositoryProvider)
        .lookupByName(widget.worldId, text,
            limit: 30 + widget.excludeIds.length, kinds: widget.kinds);
    if (!mounted) return;
    setState(() {
      _results = [
        for (final e in all)
          if (!widget.excludeIds.contains(e.id)) e
      ].take(30).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 440,
        height: 420,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.kinds.isEmpty
                    ? context.l10n.pickerSearchAll
                    : context.l10n.pickerSearchKinds(widget.kinds
                        .map((k) => midSentence(
                            context, k.localizedPlural(context)))
                        .join(', ')),
                prefixIcon: const Icon(Icons.search, size: 18),
              ),
              onChanged: (text) => _debouncer(() => _query(text)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(
                          child: Text(context.l10n.pickerNoMatches,
                              style: TextStyle(
                                  color: GmhColors.parchmentDim)))
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final entity = _results[index];
                            final categories = ref
                                .watch(categoryMapProvider(widget.worldId));
                            return ListTile(
                              leading: Icon(entityIcon(entity, categories),
                                  size: 19,
                                  color: entityColor(entity, categories)),
                              title: Text(entity.name),
                              subtitle: entity.summary.isEmpty
                                  ? Text(
                                      typeLabel(
                                          context,
                                          entity.kind,
                                          entity.customCategoryId,
                                          categories),
                                      style: const TextStyle(fontSize: 11))
                                  : Text(entity.summary,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11)),
                              onTap: () => Navigator.pop(context, entity),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel)),
      ],
    );
  }
}

