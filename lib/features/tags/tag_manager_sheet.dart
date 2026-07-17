import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/tag.dart';
import '../shell/ui_providers.dart';

/// Colors offered by the tag color picker.
const tagColorChoices = [
  0xFFB4846C, 0xFF7D8F69, 0xFFA26769, 0xFF6C7B95,
  0xFF9A8C98, 0xFFC9A227, 0xFF5F797B, 0xFF8E6C88,
  0xFFD9A441, 0xFF6FA8DC, 0xFF93C47D, 0xFFC4574A,
];

enum _TagSort { name, created, usage }

/// Usage counts per tag, recomputed when tags change.
final tagUsageProvider =
    FutureProvider.family<Map<String, int>, String>((ref, worldId) {
  ref.watch(worldTagsProvider(worldId));
  return ref.watch(tagRepositoryProvider).usageCounts(worldId);
});

/// Dedicated Tag Manager: searchable list of every tag with usage counts;
/// create, rename, recolor, merge and delete (with confirmation).
Future<void> showTagManagerSheet(BuildContext context, String worldId) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 640),
        child: _TagManager(worldId: worldId),
      ),
    ),
  );
}

class _TagManager extends ConsumerStatefulWidget {
  final String worldId;
  const _TagManager({required this.worldId});

  @override
  ConsumerState<_TagManager> createState() => _TagManagerState();
}

class _TagManagerState extends ConsumerState<_TagManager> {
  String _query = '';
  _TagSort _sort = _TagSort.name;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final allTags =
        ref.watch(worldTagsProvider(widget.worldId)).valueOrNull ?? [];
    final usage =
        ref.watch(tagUsageProvider(widget.worldId)).valueOrNull ?? const {};

    final visible = [
      for (final tag in allTags)
        if (_query.isEmpty ||
            tag.name.toLowerCase().contains(_query.toLowerCase()))
          tag
    ];
    switch (_sort) {
      case _TagSort.name:
        visible.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case _TagSort.created:
        visible.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case _TagSort.usage:
        visible.sort(
            (a, b) => (usage[b.id] ?? 0).compareTo(usage[a.id] ?? 0));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 6),
          child: Row(
            children: [
              Icon(Icons.sell_outlined,
                  size: 19, color: GmhColors.ember),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l.tagManagerTitle,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              PopupMenuButton<_TagSort>(
                tooltip: l.sortTooltip,
                icon: const Icon(Icons.sort, size: 19),
                onSelected: (sort) => setState(() => _sort = sort),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: _TagSort.name, child: Text(l.sortByName)),
                  PopupMenuItem(
                      value: _TagSort.created,
                      child: Text(l.sortByCreated)),
                  PopupMenuItem(
                      value: _TagSort.usage, child: Text(l.sortByUsage)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 19),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: l.searchTagsHint,
              prefixIcon: const Icon(Icons.search, size: 18),
            ),
            onChanged: (text) => setState(() => _query = text.trim()),
          ),
        ),
        const Divider(),
        Flexible(
          child: allTags.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l.noTags,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: GmhColors.parchmentDim)),
                )
              : visible.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l.noTagMatches,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: GmhColors.parchmentDim)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final tag = visible[index];
                        return _TagRow(
                          tag: tag,
                          count: usage[tag.id] ?? 0,
                          onRename: () => _rename(tag),
                          onColor: () => _pickColor(tag),
                          onMerge: () => _merge(tag, allTags),
                          onDelete: () =>
                              _delete(tag, usage[tag.id] ?? 0),
                        );
                      },
                    ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: Text(l.newTag),
            onPressed: _create,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------- actions

  Future<String?> _promptName({String initial = ''}) async {
    final controller = TextEditingController(text: initial);
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(initial.isEmpty
            ? context.l10n.newTag
            : context.l10n.rename),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration:
              InputDecoration(hintText: context.l10n.tagNameHint),
          onSubmitted: (_) => Navigator.pop(context, true),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.save)),
        ],
      ),
    );
    final name = controller.text.trim();
    return (saved == true && name.isNotEmpty) ? name : null;
  }

  Future<void> _create() async {
    final name = await _promptName();
    if (name != null) {
      await ref.read(tagRepositoryProvider).getOrCreate(widget.worldId, name);
    }
  }

  Future<void> _rename(Tag tag) async {
    final name = await _promptName(initial: tag.name);
    if (name != null && name != tag.name) {
      await ref.read(tagRepositoryProvider).rename(tag.id, name);
    }
  }

  Future<void> _pickColor(Tag tag) async {
    final color = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.changeColor),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final choice in tagColorChoices)
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => Navigator.pop(context, choice),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(choice),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: tag.color == choice
                          ? GmhColors.parchment
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (color != null) {
      await ref.read(tagRepositoryProvider).setColor(tag.id, color);
    }
  }

  Future<void> _merge(Tag tag, List<Tag> allTags) async {
    final others = [
      for (final other in allTags)
        if (other.id != tag.id) other
    ];
    if (others.isEmpty) return;
    final target = await showDialog<Tag>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.mergeTagTitle(tag.name)),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.mergeTagBody(tag.name),
                  style: TextStyle(
                      fontSize: 12.5, color: GmhColors.parchmentDim)),
              const SizedBox(height: 10),
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final other in others)
                        ActionChip(
                          avatar: CircleAvatar(
                              radius: 5,
                              backgroundColor: Color(other.color)),
                          label: Text(other.name,
                              style: const TextStyle(fontSize: 12)),
                          onPressed: () => Navigator.pop(context, other),
                        ),
                    ],
                  ),
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
      ),
    );
    if (target != null) {
      await ref
          .read(tagRepositoryProvider)
          .merge(fromTagId: tag.id, intoTagId: target.id);
    }
  }

  Future<void> _delete(Tag tag, int count) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteTagTitle(tag.name)),
        content: Text(context.l10n.deleteTagBody(count)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: GmhColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(tagRepositoryProvider).delete(tag.id);
    }
  }
}

class _TagRow extends StatelessWidget {
  final Tag tag;
  final int count;
  final VoidCallback onRename;
  final VoidCallback onColor;
  final VoidCallback onMerge;
  final VoidCallback onDelete;

  const _TagRow({
    required this.tag,
    required this.count,
    required this.onRename,
    required this.onColor,
    required this.onMerge,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListTile(
      leading: InkWell(
        onTap: onColor,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Color(tag.color),
            shape: BoxShape.circle,
          ),
        ),
      ),
      title: Text(tag.name, style: const TextStyle(fontSize: 14)),
      subtitle: Text(l.entriesCount(count),
          style: const TextStyle(fontSize: 11.5)),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_horiz, size: 18),
        onSelected: (action) {
          switch (action) {
            case 'rename':
              onRename();
            case 'color':
              onColor();
            case 'merge':
              onMerge();
            case 'delete':
              onDelete();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'rename', child: Text(l.rename)),
          PopupMenuItem(value: 'color', child: Text(l.changeColor)),
          PopupMenuItem(value: 'merge', child: Text(l.mergeTagAction)),
          PopupMenuItem(
              value: 'delete',
              child: Text(l.delete,
                  style: TextStyle(color: GmhColors.danger))),
        ],
      ),
      onTap: onRename,
    );
  }
}
