import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/maps/game_map.dart';
import '../../../domain/maps/map_geometry.dart';
import '../../../domain/maps/map_pin.dart';
import '../../../domain/maps/map_search.dart';
import '../../categories/category_ui.dart';
import 'maps_actions.dart';
import 'maps_dialogs.dart';
import 'maps_style.dart';

/// Pins (searchable) and map details of one map. Used as the right panel
/// on wide windows and inside a bottom sheet on narrow ones.
class MapSidePanel extends ConsumerStatefulWidget {
  final String worldId;
  final String mapId;
  final String? selectedPinId;
  final ValueChanged<MapPin> onPinTap;

  const MapSidePanel({
    super.key,
    required this.worldId,
    required this.mapId,
    required this.onPinTap,
    this.selectedPinId,
  });

  @override
  ConsumerState<MapSidePanel> createState() => _MapSidePanelState();
}

class _MapSidePanelState extends ConsumerState<MapSidePanel> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final q = (worldId: widget.worldId, mapId: widget.mapId);
    final map = ref.watch(gameMapProvider(widget.mapId)).valueOrNull;
    final pins = ref.watch(mapPinsProvider(q)).valueOrNull ?? const [];
    final entities = ref.watch(mapPinEntitiesProvider(q));
    final categories = ref.watch(categoryMapProvider(widget.worldId));
    final names = {for (final e in entities.entries) e.key: e.value.name};
    final visible = sortPinsByLabel(
      filterPins(pins, _query, entityNames: names),
      entityNames: names,
    );

    final pinsTab = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: TextField(
            key: const ValueKey('maps-pin-search'),
            controller: _search,
            decoration: InputDecoration(
              hintText: l.mapsSearchPins,
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l.clear,
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
                      },
                    ),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: pins.isEmpty || visible.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    pins.isEmpty ? l.mapsNoPins : l.mapsNoPinMatches,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: GmhColors.parchmentDim,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 24),
                  itemCount: visible.length,
                  itemBuilder: (context, i) {
                    final pin = visible[i];
                    final entity = entities[pin.entityId];
                    final label = pin.displayLabel(entity?.name);
                    final color = pinColor(
                      pin.color,
                      entityColor: entity == null
                          ? null
                          : entityColor(entity, categories),
                    );
                    return ListTile(
                      key: ValueKey('maps-list-pin-${pin.id}'),
                      dense: true,
                      selected: pin.id == widget.selectedPinId,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      leading: PinBadge(
                        icon: pin.icon,
                        color: color,
                        size: 28,
                        faded: pin.gmOnly,
                      ),
                      title: Text(
                        label.isEmpty ? l.mapsUntitledPin : label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: entity == null && !pin.gmOnly
                          ? null
                          : Text(
                              [
                                if (entity != null && entity.name != label)
                                  entity.name,
                                if (pin.gmOnly) l.mapsPinGmOnly,
                              ].join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      trailing: pin.gmOnly
                          ? Icon(
                              Icons.visibility_off_outlined,
                              size: 16,
                              color: GmhColors.parchmentFaint,
                            )
                          : null,
                      onTap: () => widget.onPinTap(pin),
                    );
                  },
                ),
        ),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            tabs: [
              Tab(
                key: const ValueKey('maps-tab-pins'),
                text: '${l.mapsPinsTab} · ${pins.length}',
              ),
              Tab(key: const ValueKey('maps-tab-details'), text: l.mapsDetailsTab),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                pinsTab,
                map == null ? const SizedBox.shrink() : _Details(map: map),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Details extends ConsumerWidget {
  final GameMap map;
  const _Details({required this.map});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final actions = ref.read(mapsActionsProvider);
    final scale = map.scale;
    final dim = TextStyle(fontSize: 13, height: 1.4, color: GmhColors.parchmentDim);
    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: [
        heading(l.mapsDescription),
        Text(
          map.description.isEmpty ? l.mapsNoDescription : map.description,
          key: const ValueKey('maps-details-description-text'),
          style: map.description.isEmpty ? dim : const TextStyle(fontSize: 13.5, height: 1.4),
        ),
        heading(l.mapsScale),
        Text(
          scale == null
              ? l.mapsNoScale
              : l.mapsScaleValue(
                  formatDistance(scale.unitsPerCell.toDouble()),
                  scale.unitName,
                  formatDistance(scale.cellPx.toDouble()),
                ),
          key: const ValueKey('maps-details-scale-text'),
          style: scale == null ? dim : null,
        ),
        const SizedBox(height: 4),
        Text(
          map.hasImage
              ? l.mapsImageSize(map.width, map.height)
              : '${l.mapsBlankCanvas} · ${l.mapsImageSize(map.width, map.height)}',
          style: dim.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          key: const ValueKey('maps-grid-toggle'),
          contentPadding: EdgeInsets.zero,
          value: map.showGrid && scale != null,
          onChanged: scale == null
              ? null
              : (v) => actions.save(map.copyWith(showGrid: v)),
          title: Text(l.mapsShowGrid),
          subtitle: scale == null ? Text(l.mapsGridNeedsScale) : null,
        ),
        SwitchListTile(
          key: const ValueKey('maps-pins-visible-default'),
          contentPadding: EdgeInsets.zero,
          value: map.pinsVisibleToPlayers,
          onChanged: (v) =>
              actions.save(map.copyWith(pinsVisibleToPlayers: v)),
          title: Text(l.mapsPinsVisibleDefault),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            key: const ValueKey('maps-edit-details'),
            onPressed: () async {
              final edited = await showMapDetailsDialog(context, initial: map);
              if (edited == null) return;
              await actions.save(edited);
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(l.mapsEditDetails),
          ),
        ),
      ],
    );
  }
}
