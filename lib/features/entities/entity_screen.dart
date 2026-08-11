import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/category_blueprint.dart';
import '../../domain/models/document_model.dart';
import '../../domain/models/entity.dart';
import '../categories/category_ui.dart';
import '../editor/lore_editor.dart';
import '../shell/history_buttons.dart';
import '../shell/workspace_tabs.dart';
import '../shell/ui_providers.dart';
import '../attachments/attachments_panel.dart';
import '../../domain/models/entity_kind.dart';
import 'character_profile.dart';
import 'widgets/attribute_form.dart';
import 'widgets/cover_square.dart';
import 'widgets/gallery_strip.dart';
import 'widgets/relations_panel.dart';
import 'widgets/stat_block.dart';
import 'widgets/tag_editor.dart';

/// The entity page: rich-text document in the center, properties/relations/
/// gallery in a right panel (desktop) or tabs (mobile).
class EntityScreen extends ConsumerWidget {
  final String worldId;
  final String entityId;

  const EntityScreen({
    super.key,
    required this.worldId,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityAsync = ref.watch(entityProvider(entityId));
    final entity = entityAsync.valueOrNull;

    if (entityAsync.isLoading && entity == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
    ModalRoute<Object?>? dialogRoute;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        dialogRoute ??= ModalRoute.of(context);
        return AlertDialog(
          title: Text(context.l10n.editEntryTitle),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.nameLabel,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: summaryController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: context.l10n.summaryLabel,
                    hintText: context.l10n.summaryHint,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.save),
            ),
          ],
        );
      },
    );
    final name = nameController.text.trim();
    final summary = summaryController.text.trim();
    // Release the controllers only once the dialog route is fully gone.
    dialogRoute?.completed.whenComplete(() {
      nameController.dispose();
      summaryController.dispose();
    });
    if (saved != true) return;
    await ref
        .read(entityServiceProvider)
        .update(entity.copyWith(name: name, summary: summary));
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
            child: Text(context.l10n.cancel),
          ),
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
    // Other tabs (and history stacks) may still point at the deleted
    // entry — close/scrub them so Back or a tab click can't resurrect it.
    ref
        .read(workspaceTabsProvider.notifier)
        .closeForLocation(Routes.entity(worldId, entity.id));
    if (!context.mounted) return;
    // Every navigation here uses go() with a single-page match list, so
    // there is never anything to pop — pop() would throw and strand the
    // user on the "entry gone" screen. Return to the entry's section.
    if (entity.kind == EntityKind.custom && entity.customCategoryId != null) {
      context.go(Routes.browseCategory(worldId, entity.customCategoryId!));
    } else {
      context.go(Routes.browse(worldId, entity.kind));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    final appBar = AppBar(
      leading: historyLeading(),
      leadingWidth: kHistoryLeadingWidth,
      titleSpacing: 8,
      title: Row(
        children: [
          // Breadcrumb: the kind icon jumps to the entry's section list —
          // the same "click the crumb to go up a level" affordance as in
          // Notion/Obsidian.
          IconButton(
            tooltip: entity.kind == EntityKind.custom
                ? (ref
                          .watch(
                            categoryMapProvider(worldId),
                          )[entity.customCategoryId]
                          ?.name ??
                      entity.kind.localizedPlural(context))
                : entity.kind.localizedPlural(context),
            icon: Icon(entity.kind.icon, color: entity.kind.color, size: 20),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              if (entity.kind == EntityKind.custom &&
                  entity.customCategoryId != null) {
                context.go(
                  Routes.browseCategory(worldId, entity.customCategoryId!),
                );
              } else {
                context.go(Routes.browse(worldId, entity.kind));
              }
            },
          ),
          const SizedBox(width: 4),
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
          icon: Icon(
            entity.isFavorite ? Icons.star : Icons.star_border,
            color: entity.isFavorite ? GmhColors.ember : null,
          ),
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
                context.go(Routes.graph(worldId, focusEntityId: entity.id));
              case 'delete':
                _delete(context, ref);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(context.l10n.menuEditNameSummary),
            ),
            PopupMenuItem(
              value: 'graph',
              child: Text(context.l10n.menuShowInGraph),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                context.l10n.delete,
                style: TextStyle(color: GmhColors.danger),
              ),
            ),
          ],
        ),
      ],
    );

    // Characters get the full tabbed profile instead of the generic
    // document + side panel layout (same data, richer presentation).
    if (entity.kind == EntityKind.character) {
      return Scaffold(
        appBar: appBar,
        // Keyed by entity id: the route element is reused between /e/A and
        // /e/B, and the profile's TabController must not leak A's tab
        // index (and writes) into B's remembered tab.
        body: CharacterProfile(
          key: ValueKey(entity.id),
          worldId: worldId,
          entity: entity,
        ),
      );
    }

    // Custom sections are assembled from their category's blueprint: the
    // constructor decides which modules exist on this page.
    final blueprint = entity.kind == EntityKind.custom
        ? (ref
                  .watch(categoryMapProvider(worldId))[entity.customCategoryId]
                  ?.blueprint ??
              CategoryBlueprint.standard)
        : CategoryBlueprint.standard;

    final document = _DocumentPane(worldId: worldId, entity: entity);
    final sidePanel = _SidePanel(entity: entity, blueprint: blueprint);

    if (!blueprint.has(CategoryModule.document)) {
      // No document module: the side panel becomes the whole page.
      return Scaffold(
        appBar: appBar,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: sidePanel,
          ),
        ),
      );
    }

    // Spell/creature/item pages lead with the stat card and fields — the
    // structured data is the point of these entries; the free-text lore
    // window sits below it.
    final statFirst = const {
      EntityKind.magicSystem,
      EntityKind.creature,
      EntityKind.item,
    }.contains(entity.kind);

    if (isWide) {
      // Same split everywhere: notes/lore on the left, the structured
      // panel on the right. Stat-card kinds (spells, creatures, items)
      // get a wider right panel so the stat block reads like a card.
      // The editor keeps priority: on mid-size windows the panel narrows
      // first so the text column never shrinks to a sliver.
      final split = LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 1250;
          final panelWidth = statFirst
              ? (compact ? 360.0 : 420.0)
              : (compact ? 290.0 : 330.0);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: document),
              const VerticalDivider(width: 1),
              SizedBox(width: panelWidth, child: sidePanel),
            ],
          );
        },
      );
      return Scaffold(
        appBar: appBar,
        // Locations carry a full-width image strip under both panes: the
        // battle maps and vistas of a place are worth a dedicated shelf.
        body: entity.kind == EntityKind.location
            ? Column(
                children: [
                  Expanded(child: split),
                  EntityGalleryStrip(entity: entity),
                ],
              )
            : split,
      );
    }

    return DefaultTabController(
      // Keyed like CharacterProfile: the route element is reused between
      // /e/A and /e/B, and statFirst swaps the tab order — a surviving
      // controller would open stat-first pages on the wrong tab.
      key: ValueKey(entity.id),
      length: 2,
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            TabBar(
              tabs: [
                if (statFirst) ...[
                  Tab(text: context.l10n.tabDetails),
                  Tab(text: context.l10n.tabDocument),
                ] else ...[
                  Tab(text: context.l10n.tabDocument),
                  Tab(text: context.l10n.tabDetails),
                ],
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: statFirst
                    ? [sidePanel, document]
                    : [document, sidePanel],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentPane extends ConsumerStatefulWidget {
  final String worldId;
  final Entity entity;

  const _DocumentPane({required this.worldId, required this.entity});

  @override
  ConsumerState<_DocumentPane> createState() => _DocumentPaneState();
}

class _DocumentPaneState extends ConsumerState<_DocumentPane> {
  // Memoized per entity: a future re-created on every rebuild (each
  // entity-row emission, e.g. an attribute autosave) would flash the
  // spinner and dispose/recreate the editor mid-typing, losing the
  // current debounce window of edits.
  late Future<DocumentModel> _doc = ref
      .read(documentRepositoryProvider)
      .getOrCreate(widget.entity.id);

  @override
  void didUpdateWidget(covariant _DocumentPane old) {
    super.didUpdateWidget(old);
    if (old.entity.id != widget.entity.id) {
      _doc = ref.read(documentRepositoryProvider).getOrCreate(widget.entity.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Load once (not watch): the editor owns the document while open;
    // watching would reset it on every autosave.
    return FutureBuilder<DocumentModel>(
      future: _doc,
      builder: (context, snapshot) {
        final doc = snapshot.data;
        if (doc == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return LoreEditor(
          key: ValueKey('editor-${widget.entity.id}'),
          worldId: widget.worldId,
          entityId: widget.entity.id,
          initialContentJson: doc.contentJson,
        );
      },
    );
  }
}

class _SidePanel extends StatelessWidget {
  final Entity entity;
  final CategoryBlueprint blueprint;

  const _SidePanel({
    required this.entity,
    this.blueprint = CategoryBlueprint.standard,
  });

  @override
  Widget build(BuildContext context) {
    final showMedia =
        blueprint.has(CategoryModule.gallery) ||
        blueprint.has(CategoryModule.attachments);
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
      children: [
        // Cover square + summary header. Hovering the square shows a
        // pencil; clicking it uploads/replaces the entry's cover image.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditableCoverSquare(entity: entity),
            const SizedBox(width: 12),
            Expanded(
              child: entity.summary.isEmpty
                  ? const SizedBox.shrink()
                  : Text(
                      entity.summary,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: GmhColors.parchmentDim,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (blueprint.has(CategoryModule.tags)) TagEditor(entity: entity),
        const SizedBox(height: 6),
        // D&D-style read-only stat card for spells, creatures and items;
        // the form below stays the editor.
        StatBlock(entity: entity),
        if (blueprint.has(CategoryModule.fields))
          AttributeForm(
            entity: entity,
            sectionsOverride: entity.kind == EntityKind.custom
                ? blueprint.toSections(context.l10n.blueprintFieldsSection)
                : null,
          ),
        if (blueprint.has(CategoryModule.relations)) ...[
          const SizedBox(height: 16),
          RelationsPanel(entity: entity),
        ],
        if (showMedia) ...[
          const SizedBox(height: 16),
          AttachmentsPanel(
            entity: entity,
            showImages: blueprint.has(CategoryModule.gallery),
            showFiles: blueprint.has(CategoryModule.attachments),
          ),
        ],
      ],
    );
  }
}
