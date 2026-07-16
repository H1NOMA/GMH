import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/link.dart';
import '../../shell/ui_providers.dart';
import 'entity_picker_dialog.dart';

/// Relations & backlinks panel: outgoing links grouped by role, incoming
/// backlinks, and manual link management. Document mentions and attribute
/// mirrors are shown but only manual links can be removed here.
class RelationsPanel extends ConsumerWidget {
  final Entity entity;

  const RelationsPanel({super.key, required this.entity});

  Future<void> _addManualLink(BuildContext context, WidgetRef ref) async {
    final target = await showEntityPickerDialog(context,
        worldId: entity.worldId, title: 'Add relation');
    if (target == null || !context.mounted) return;

    final roleController = TextEditingController(text: LinkRoles.related);
    final role = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Relation to "${target.name}"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                  labelText: 'Role', hintText: 'e.g. owner, ally, rival'),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: [
                for (final suggestion in LinkRoles.suggestions)
                  ActionChip(
                    label: Text(LinkRoles.label(suggestion),
                        style: const TextStyle(fontSize: 11.5)),
                    onPressed: () => roleController.text = suggestion,
                  ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(context, roleController.text.trim()),
              child: const Text('Add')),
        ],
      ),
    );
    if (role == null || role.isEmpty) return;

    await ref.read(linkRepositoryProvider).create(
          worldId: entity.worldId,
          sourceId: entity.id,
          targetId: target.id,
          role: role,
          origin: LinkOrigin.manual,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outgoing =
        ref.watch(outgoingLinksProvider(entity.id)).valueOrNull ?? [];
    final incoming =
        ref.watch(incomingLinksProvider(entity.id)).valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('RELATIONS',
                  style: const TextStyle(
                      fontSize: 10.5,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      color: GmhColors.parchmentFaint)),
            ),
            IconButton(
              tooltip: 'Add relation',
              icon: const Icon(Icons.add, size: 17),
              visualDensity: VisualDensity.compact,
              onPressed: () => _addManualLink(context, ref),
            ),
            IconButton(
              tooltip: 'Open in graph',
              icon: const Icon(Icons.hub_outlined, size: 16),
              visualDensity: VisualDensity.compact,
              onPressed: () => context.go(
                  Routes.graph(entity.worldId, focusEntityId: entity.id)),
            ),
          ],
        ),
        if (outgoing.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text('No outgoing relations yet.',
                style:
                    TextStyle(fontSize: 12, color: GmhColors.parchmentFaint)),
          )
        else
          _LinkGroupList(
            links: outgoing,
            worldId: entity.worldId,
            direction: _Direction.outgoing,
            roleLabel: (role) => LinkRoles.label(role),
          ),
        const SizedBox(height: 14),
        const Text('BACKLINKS',
            style: TextStyle(
                fontSize: 10.5,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                color: GmhColors.parchmentFaint)),
        const SizedBox(height: 4),
        if (incoming.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text('Nothing links here yet.',
                style:
                    TextStyle(fontSize: 12, color: GmhColors.parchmentFaint)),
          )
        else
          _LinkGroupList(
            links: incoming,
            worldId: entity.worldId,
            direction: _Direction.incoming,
            roleLabel: (role) => role == LinkRoles.mention
                ? 'Mentioned in'
                : '${LinkRoles.label(role)} ←',
          ),
      ],
    );
  }
}

enum _Direction { outgoing, incoming }

class _LinkGroupList extends ConsumerWidget {
  final List<Link> links;
  final String worldId;
  final _Direction direction;
  final String Function(String role) roleLabel;

  const _LinkGroupList({
    required this.links,
    required this.worldId,
    required this.direction,
    required this.roleLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = groupBy(links, (link) => link.role);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 2),
            child: Text(roleLabel(entry.key),
                style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: GmhColors.parchmentDim)),
          ),
          for (final link in entry.value)
            _LinkRow(link: link, worldId: worldId, direction: direction),
        ],
      ],
    );
  }
}

class _LinkRow extends ConsumerWidget {
  final Link link;
  final String worldId;
  final _Direction direction;

  const _LinkRow({
    required this.link,
    required this.worldId,
    required this.direction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherId =
        direction == _Direction.outgoing ? link.targetId : link.sourceId;
    final other = ref.watch(entityProvider(otherId)).valueOrNull;
    if (other == null || other.isDeleted) return const SizedBox.shrink();

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        ref.read(searchRepositoryProvider).recordOpened(other.id);
        context.go(Routes.entity(worldId, other.id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Icon(other.kind.icon, size: 15, color: other.kind.color),
            const SizedBox(width: 7),
            Expanded(
              child: Text(other.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13)),
            ),
            if (link.origin == LinkOrigin.document)
              const Tooltip(
                message: 'From a document mention',
                child: Icon(Icons.notes, size: 13,
                    color: GmhColors.parchmentFaint),
              )
            else if (link.origin == LinkOrigin.attribute)
              const Tooltip(
                message: 'From a structured field',
                child: Icon(Icons.tune, size: 13,
                    color: GmhColors.parchmentFaint),
              )
            else if (direction == _Direction.outgoing)
              InkWell(
                onTap: () =>
                    ref.read(linkRepositoryProvider).delete(link.id),
                child: const Icon(Icons.close,
                    size: 14, color: GmhColors.parchmentFaint),
              ),
          ],
        ),
      ),
    );
  }
}
