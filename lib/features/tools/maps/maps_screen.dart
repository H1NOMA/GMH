import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'map_page.dart';
import 'maps_actions.dart';
import 'maps_list.dart';

/// Maps: the world's map list or — with a [mapId] — one map's page.
class MapsScreen extends StatelessWidget {
  final String worldId;
  final String? mapId;

  const MapsScreen({super.key, required this.worldId, this.mapId});

  /// The `?pin=` of the current location (the router hands tools only the
  /// object id).
  static String? _pinQuery(BuildContext context) {
    try {
      return GoRouterState.of(context).uri.queryParameters[mapPinQuery];
    } on GoError {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = mapId;
    if (id == null) return MapList(worldId: worldId);
    return MapPage(
      key: ValueKey(id),
      worldId: worldId,
      mapId: id,
      focusPinId: _pinQuery(context),
    );
  }
}
