import 'package:flutter/material.dart';

import '../features/tools/combat/combat_screen.dart';
import '../features/tools/dice/dice_screen.dart';
import '../features/tools/generators/generators_screen.dart';
import '../features/tools/maps/maps_screen.dart';
import '../features/tools/reference/reference_screen.dart';
import '../features/tools/tables/tables_screen.dart';
import '../features/tools/timeline/timeline_screen.dart';
import 'l10n_ext.dart';

/// A game-master tool reachable from the Tools hub, the sidebar, the rail
/// and the command palette. Every tool lives under one generic route —
/// `/w/:worldId/tools/:toolId[/:objectId]` — so adding a tool never touches
/// the router, the shell or the tab strip: only this registry.
@immutable
class GmhTool {
  final String id;
  final IconData icon;
  final String Function(AppLocalizations l) label;
  final String Function(AppLocalizations l) description;

  /// Builds the tool page. [objectId] is the optional detail object (an
  /// encounter, a map, a random table…) from the last path segment.
  final Widget Function(String worldId, String? objectId) builder;

  const GmhTool({
    required this.id,
    required this.icon,
    required this.label,
    required this.description,
    required this.builder,
  });
}

/// Registry in display order.
final List<GmhTool> gmhTools = [
  GmhTool(
    id: 'dice',
    icon: Icons.casino_outlined,
    label: (l) => l.toolDice,
    description: (l) => l.toolDiceHint,
    builder: (worldId, _) => DiceScreen(worldId: worldId),
  ),
  GmhTool(
    id: 'combat',
    icon: Icons.sports_martial_arts_outlined,
    label: (l) => l.toolCombat,
    description: (l) => l.toolCombatHint,
    builder: (worldId, objectId) =>
        CombatScreen(worldId: worldId, encounterId: objectId),
  ),
  GmhTool(
    id: 'tables',
    icon: Icons.table_rows_outlined,
    label: (l) => l.toolTables,
    description: (l) => l.toolTablesHint,
    builder: (worldId, objectId) =>
        RandomTablesScreen(worldId: worldId, tableId: objectId),
  ),
  GmhTool(
    id: 'generators',
    icon: Icons.auto_awesome_outlined,
    label: (l) => l.toolGenerators,
    description: (l) => l.toolGeneratorsHint,
    builder: (worldId, _) => GeneratorsScreen(worldId: worldId),
  ),
  GmhTool(
    id: 'maps',
    icon: Icons.explore_outlined,
    label: (l) => l.toolMaps,
    description: (l) => l.toolMapsHint,
    builder: (worldId, objectId) =>
        MapsScreen(worldId: worldId, mapId: objectId),
  ),
  GmhTool(
    id: 'timeline',
    icon: Icons.timeline_outlined,
    label: (l) => l.toolTimeline,
    description: (l) => l.toolTimelineHint,
    builder: (worldId, _) => TimelineScreen(worldId: worldId),
  ),
  GmhTool(
    id: 'reference',
    icon: Icons.menu_book_outlined,
    label: (l) => l.toolReference,
    description: (l) => l.toolReferenceHint,
    builder: (worldId, _) => ReferenceScreen(worldId: worldId),
  ),
];

GmhTool? toolById(String id) {
  for (final tool in gmhTools) {
    if (tool.id == id) return tool;
  }
  return null;
}
