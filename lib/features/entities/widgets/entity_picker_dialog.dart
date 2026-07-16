import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  String title = 'Link an entry',
}) {
  return showDialog<Entity>(
    context: context,
    builder: (context) =>
        _EntityPickerDialog(worldId: worldId, kinds: kinds, title: title),
  );
}

class _EntityPickerDialog extends ConsumerStatefulWidget {
  final String worldId;
  final List<EntityKind> kinds;
  final String title;

  const _EntityPickerDialog({
    required this.worldId,
    required this.kinds,
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
    final all = await ref
        .read(entityRepositoryProvider)
        .lookupByName(widget.worldId, text, limit: 30);
    if (!mounted) return;
    setState(() {
      _results = widget.kinds.isEmpty
          ? all
          : all.where((e) => widget.kinds.contains(e.kind)).toList();
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
                    ? 'Search all entries…'
                    : 'Search ${widget.kinds.map((k) => k.pluralLabel.toLowerCase()).join(', ')}…',
                prefixIcon: const Icon(Icons.search, size: 18),
              ),
              onChanged: (text) => _debouncer(() => _query(text)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? const Center(
                          child: Text('No matching entries',
                              style:
                                  TextStyle(color: GmhColors.parchmentDim)))
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final entity = _results[index];
                            return ListTile(
                              leading: Icon(entity.kind.icon,
                                  size: 19, color: entity.kind.color),
                              title: Text(entity.name),
                              subtitle: entity.summary.isEmpty
                                  ? Text(entity.kind.label,
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
            child: const Text('Cancel')),
      ],
    );
  }
}
