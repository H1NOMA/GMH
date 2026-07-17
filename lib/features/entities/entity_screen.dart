import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/document_model.dart';
import '../../domain/models/entity.dart';
import '../editor/lore_editor.dart';
import '../shell/ui_providers.dart';
import '../attachments/attachments_panel.dart';
import '../../domain/models/entity_kind.dart';
import 'character_profile.dart';
import 'widgets/attribute_form.dart';
import 'widgets/relations_panel.dart';
import 'widgets/tag_editor.dart';

/// The entity page: rich-text document in the center, properties/relations/
/// gallery in a right panel (desktop) or tabs (mobile).
class EntityScreen extends ConsumerWidget {
  final String worldId;
  final String entityId;

  const EntityScreen(
      {super.key, required this.worldId, required this.entityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityAsync = ref.watch(entityProvider(entityId));
    final entity = entityAsync.valueOrNull;

    if (entityAsync.isLoading && entity == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    if (entity == null || entity.isDeleted) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.entryGone)),
      );
    }

    return _EntityScaffold(entity: entity, worldId: worldId);
  }
}

class _EntityScaffold extends ConsumerWidget {
  final Entity entity;
  final String worldId;

  const _EntityScaffold({required this.entity, required this.worldId});

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController(text: entity.name);
    final summaryController = TextEditingController(text: entity.summary);
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.editEntryTitle),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: context.l10n.nameLabel),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: summaryController,
                maxLines: 2,
                decoration: InputDecoration(
                    labelText: context.l10n.summaryLabel,
                    hintText: context.l10n.summaryHint),
              ),
            ],
          ),
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
    if (saved != true) return;
    await ref.read(entityServiceProvider).update(entity.copyWith(
          name: nameController.text.trim(),
          summary: summaryController.text.trim(),
        ));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteEntryTitle(entity.name)),
        content: Text(context.l10n.deleteEntryBody),
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
    if (confirmed != true) return;
    await ref.read(entityServiceProvider).moveToTrash(entity.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    final appBar = AppBar(
      titleSpacing: 8,
      title: Row(
        children: [
          Icon(entity.kind.icon, color: entity.kind.color, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: InkWell(
              onTap: () => _rename(context, ref),
              child: Text(entity.name, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: entity.isFavorite
              ? context.l10n.removeFromFavorites
              : context.l10n.addToFavorites,
          icon: Icon(entity.isFavorite ? Icons.star : Icons.star_border,
              color: entity.isFavorite ? GmhColors.ember : null),
          onPressed: () => ref
              .read(entityServiceProvider)
              .setFavorite(entity.id, !entity.isFavorite),
        ),
        PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'edit':
                _rename(context, ref);
              case 'graph':
                context.go(
                    Routes.graph(worldId, focusEntityId: entity.id));
              case 'delete':
                _delete(context, ref);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 'edit',
                child: Text(context.l10n.menuEditNameSummary)),
            PopupMenuItem(
                value: 'graph', child: Text(context.l10n.menuShowInGraph)),
            PopupMenuItem(
                value: 'delete',
                child: Text(context.l10n.delete,
                    style: const TextStyle(color: GmhColors.danger))),
          ],
        ),
      ],
    );

    // Characters get the full tabbed profile instead of the generic
    // document + side panel layout (same data, richer presentation).
    if (entity.kind == EntityKind.character) {
      return Scaffold(
        appBar: appBar,
        body: CharacterProfile(worldId: worldId, entity: entity),
      );
    }

    final document = _DocumentPane(worldId: worldId, entity: entity);
    final sidePanel = _SidePanel(entity: entity);

    if (isWide) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: document),
            const VerticalDivider(width: 1),
            SizedBox(
              width: 330,
              child: sidePanel,
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            TabBar(tabs: [
              Tab(text: context.l10n.tabDocument),
              Tab(text: context.l10n.tabDetails),
            ]),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [document, sidePanel],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentPane extends ConsumerWidget {
  final String worldId;
  final Entity entity;

  const _DocumentPane({required this.worldId, required this.entity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load once (not watch): the editor owns the document while open;
    // watching would reset it on every autosave.
    return FutureBuilder<DocumentModel>(
      future: ref.read(documentRepositoryProvider).getOrCreate(entity.id),
      builder: (context, snapshot) {
        final doc = snapshot.data;
        if (doc == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return LoreEditor(
          key: ValueKey('editor-${entity.id}'),
          worldId: worldId,
          entityId: entity.id,
          initialContentJson: doc.contentJson,
        );
      },
    );
  }
}

class _SidePanel extends StatelessWidget {
  final Entity entity;

  const _SidePanel({required this.entity});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
      children: [
        if (entity.summary.isNotEmpty) ...[
          Text(entity.summary,
              style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: GmhColors.parchmentDim)),
          const SizedBox(height: 10),
        ],
        TagEditor(entity: entity),
        const SizedBox(height: 6),
        AttributeForm(entity: entity),
        const SizedBox(height: 16),
        RelationsPanel(entity: entity),
        const SizedBox(height: 16),
        AttachmentsPanel(entity: entity),
      ],
    );
  }
}
