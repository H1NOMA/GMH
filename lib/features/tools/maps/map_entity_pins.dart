import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/maps/map_search.dart';
import '../../../domain/models/entity.dart';
import 'maps_actions.dart';
import 'maps_style.dart';

/// "On maps" row of an entry page: one chip per pin linking the entry,
/// opening its map centered on the pin. Empty when no pin links it.
class EntityMapPins extends ConsumerWidget {
  final Entity entity;

  const EntityMapPins({super.key, required this.entity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pins = pinsLinkedTo(
      ref.watch(worldPinsProvider(entity.worldId)).valueOrNull ?? const [],
      entity.id,
    );
    if (pins.isEmpty) return const SizedBox.shrink();
    final maps = {
      for (final m
          in ref.watch(worldMapsProvider(entity.worldId)).valueOrNull ??
              const [])
        m.id: m,
    };
    final shown = [
      for (final p in pins)
        if (maps.containsKey(p.mapId)) p,
    ];
    if (shown.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        key: const ValueKey('entity-on-maps'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.mapsOnMaps.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
              color: GmhColors.parchmentFaint,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final pin in shown)
                Tooltip(
                  message: pin.displayLabel(entity.name),
                  child: ActionChip(
                    key: ValueKey('entity-map-pin-${pin.id}'),
                    avatar: Icon(
                      pinIconData(pin.icon),
                      size: 16,
                      color: GmhColors.ember,
                    ),
                    label: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Text(
                        maps[pin.mapId]!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => context.go(
                      mapPinLocation(entity.worldId, pin.mapId, pin.id),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
