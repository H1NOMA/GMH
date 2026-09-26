import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../app/tools.dart';
import '../../../domain/maps/game_map.dart';
import '../../../domain/maps/map_search.dart';
import '../tool_scaffold.dart';
import 'maps_actions.dart';
import 'maps_canvas.dart';
import 'maps_dialogs.dart';

/// Asks for a name and creates a blank map, then opens it.
Future<void> createBlankMapFlow(
  BuildContext context,
  WidgetRef ref,
  String worldId,
  int existing,
) async {
  final l = context.l10n;
  final actions = ref.read(mapsActionsProvider);
  final name = await showMapNameDialog(
    context,
    title: l.mapsNewBlank,
    initial: l.mapsDefaultName(existing + 1),
    confirmLabel: l.create,
  );
  if (name == null || !context.mounted) return;
  final map = await actions.create(worldId, GameMap(name: name));
  if (!context.mounted) return;
  context.go(Routes.tool(worldId, 'maps', map.id));
}

/// Picks an image, stores it and creates a map sized to it.
Future<void> createImageMapFlow(
  BuildContext context,
  WidgetRef ref,
  String worldId,
) async {
  final l = context.l10n;
  final actions = ref.read(mapsActionsProvider);
  final pick = ref.read(mapImagePickerProvider);
  final messenger = ScaffoldMessenger.of(context);
  final files = await pick();
  if (files.isEmpty || !context.mounted) return;
  final image = await actions.importImage(worldId, files.first);
  if (!context.mounted) return;
  if (image == null) {
    messenger.showSnackBar(SnackBar(content: Text(l.mapsImportFailed)));
    return;
  }
  final dot = image.fileName.lastIndexOf('.');
  final base = (dot > 0 ? image.fileName.substring(0, dot) : image.fileName)
      .trim();
  final map = await actions.create(
    worldId,
    GameMap(
      name: base.isEmpty ? l.mapsDefaultName(1) : base,
      mediaId: image.mediaId,
      width: image.width,
      height: image.height,
    ),
  );
  if (!context.mounted) return;
  context.go(Routes.tool(worldId, 'maps', map.id));
}

class MapList extends ConsumerWidget {
  final String worldId;
  const MapList({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final tool = toolById('maps')!;
    final async = ref.watch(worldMapsProvider(worldId));
    final maps = async.valueOrNull ?? const <GameMap>[];
    final counts = pinCountsByMap(
      ref.watch(worldPinsProvider(worldId)).valueOrNull ?? const [],
    );
    void newBlank() => createBlankMapFlow(context, ref, worldId, maps.length);
    void newImage() => createImageMapFlow(context, ref, worldId);

    final Widget body;
    if (async.isLoading && !async.hasValue) {
      body = const Center(child: CircularProgressIndicator());
    } else if (maps.isEmpty) {
      body = ToolEmptyState(
        icon: tool.icon,
        title: l.mapsEmptyTitle,
        hint: l.mapsEmptyHint,
        action: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              key: const ValueKey('maps-empty-image'),
              onPressed: newImage,
              icon: const Icon(Icons.image_outlined, size: 18),
              label: Text(l.mapsNewFromImage),
            ),
            OutlinedButton.icon(
              key: const ValueKey('maps-empty-blank'),
              onPressed: newBlank,
              icon: const Icon(Icons.crop_landscape, size: 18),
              label: Text(l.mapsNewBlank),
            ),
          ],
        ),
      );
    } else {
      body = LayoutBuilder(
        builder: (context, constraints) {
          const gap = 12.0;
          final side = ((constraints.maxWidth - 1400) / 2).clamp(
            16.0,
            double.infinity,
          );
          final inner = constraints.maxWidth - side * 2;
          final columns = (inner / 300).floor().clamp(1, 6);
          final cardWidth = (inner - gap * (columns - 1)) / columns;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(side, 16, side, 40),
            child: Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final m in maps)
                  SizedBox(
                    width: cardWidth,
                    child: _MapCard(map: m, pinCount: counts[m.id] ?? 0),
                  ),
              ],
            ),
          );
        },
      );
    }

    return ToolScaffold(
      toolId: 'maps',
      actions: [
        IconButton(
          key: const ValueKey('maps-new-image'),
          tooltip: l.mapsNewFromImage,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          onPressed: newImage,
        ),
        IconButton(
          key: const ValueKey('maps-new-blank'),
          tooltip: l.mapsNewBlank,
          icon: const Icon(Icons.add),
          onPressed: newBlank,
        ),
      ],
      body: body,
    );
  }
}

class _MapCard extends StatelessWidget {
  final GameMap map;
  final int pinCount;

  const _MapCard({required this.map, required this.pinCount});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      key: ValueKey('maps-card-${map.id}'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(Routes.tool(map.worldId, 'maps', map.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(aspectRatio: 16 / 10, child: MapThumbnail(map: map)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          map.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.mapsPinCount(pinCount),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: GmhColors.parchmentDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MapMenu(map: map),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rename / duplicate / delete, shared by the list and the map page; the
/// page adds its own entries through [extra].
class MapMenu extends ConsumerWidget {
  final GameMap map;
  final List<PopupMenuEntry<String>> extra;
  final void Function(String action)? onExtra;

  /// Called before the map is deleted (the page returns to the list).
  final VoidCallback? onDeleted;

  const MapMenu({
    super.key,
    required this.map,
    this.extra = const [],
    this.onExtra,
    this.onDeleted,
  });

  Future<void> _handle(BuildContext context, WidgetRef ref, String action) async {
    final l = context.l10n;
    final actions = ref.read(mapsActionsProvider);
    switch (action) {
      case 'rename':
        final name = await showMapNameDialog(
          context,
          title: l.mapsRenameTitle,
          initial: map.name,
          confirmLabel: l.save,
        );
        if (name == null) return;
        await actions.save(map.copyWith(name: name));
      case 'duplicate':
        final copy = await actions.duplicate(map, l.mapsCopyName(map.name));
        if (!context.mounted) return;
        context.go(Routes.tool(map.worldId, 'maps', copy.id));
      case 'delete':
        final ok = await confirmDeleteMap(context, map.name);
        if (!ok || !context.mounted) return;
        onDeleted?.call();
        await actions.delete(map);
      default:
        onExtra?.call(action);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      key: ValueKey('maps-menu-${map.id}'),
      tooltip: l.mapsActions,
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => _handle(context, ref, action),
      itemBuilder: (context) => [
        ...extra,
        PopupMenuItem(
          key: const ValueKey('maps-menu-rename'),
          value: 'rename',
          child: Text(l.rename)),
        PopupMenuItem(
          key: const ValueKey('maps-menu-duplicate'),
          value: 'duplicate',
          child: Text(l.mapsDuplicate)),
        PopupMenuItem(
          key: const ValueKey('maps-menu-delete'),
          value: 'delete',
          child: Text(l.delete)),
      ],
    );
  }
}
