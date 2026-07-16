import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import 'graph_simulation.dart';

/// Obsidian-style relationship graph. World mode shows every linked entity
/// (filterable by kind); focus mode shows the n-hop neighborhood of one
/// entity. Tap a node to open it, pinch/scroll to zoom, drag to pan.
class GraphScreen extends ConsumerStatefulWidget {
  final String worldId;
  final String? focusEntityId;

  const GraphScreen(
      {super.key, required this.worldId, this.focusEntityId});

  @override
  ConsumerState<GraphScreen> createState() => _GraphScreenState();
}

/// Display cap so layout and painting stay smooth far past 10k entities —
/// the graph shows the most connected nodes and the UI says so.
const _maxGraphNodes = 400;

class _GraphScreenState extends ConsumerState<GraphScreen>
    with SingleTickerProviderStateMixin {
  final _transformController = TransformationController();
  late final AnimationController _ticker;

  GraphSimulation? _simulation;
  Map<String, Entity> _entitiesById = const {};
  final Set<EntityKind> _hiddenKinds = {};
  bool _loading = true;
  bool _truncated = false;
  String? _focusId;

  @override
  void initState() {
    super.initState();
    _focusId = widget.focusEntityId;
    _ticker = AnimationController(
        vsync: this, duration: const Duration(days: 1))
      ..addListener(() {
        final simulation = _simulation;
        if (simulation != null && simulation.tick()) {
          setState(() {});
        } else {
          _ticker.stop();
        }
      });
    _build();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _transformController.dispose();
    super.dispose();
  }

  Future<void> _build() async {
    setState(() => _loading = true);

    final entities = await ref
        .read(entityRepositoryProvider)
        .getAllEntities(widget.worldId);
    final links =
        await ref.read(linkRepositoryProvider).allForWorld(widget.worldId);
    final byId = {for (final e in entities) e.id: e};

    // Collapse multi-edges; drop links to soft-deleted/missing entities.
    final edgePairs = <String, String>{}; // "a|b" -> role
    final degree = <String, int>{};
    for (final link in links) {
      if (!byId.containsKey(link.sourceId) ||
          !byId.containsKey(link.targetId)) {
        continue;
      }
      final a = link.sourceId.compareTo(link.targetId) < 0
          ? link.sourceId
          : link.targetId;
      final b = a == link.sourceId ? link.targetId : link.sourceId;
      edgePairs.putIfAbsent('$a|$b', () => link.role);
      degree[link.sourceId] = (degree[link.sourceId] ?? 0) + 1;
      degree[link.targetId] = (degree[link.targetId] ?? 0) + 1;
    }

    // Choose visible node set.
    Set<String> visible;
    if (_focusId != null && byId.containsKey(_focusId)) {
      visible = {_focusId!};
      var frontier = {_focusId!};
      for (var hop = 0; hop < 2; hop++) {
        final next = <String>{};
        for (final pair in edgePairs.keys) {
          final parts = pair.split('|');
          if (frontier.contains(parts[0])) next.add(parts[1]);
          if (frontier.contains(parts[1])) next.add(parts[0]);
        }
        next.removeAll(visible);
        visible.addAll(next);
        frontier = next;
      }
    } else {
      final linked = entities.where((e) => (degree[e.id] ?? 0) > 0).toList()
        ..sort((a, b) => (degree[b.id] ?? 0).compareTo(degree[a.id] ?? 0));
      visible = linked.map((e) => e.id).toSet();
    }
    visible.removeWhere((id) => _hiddenKinds.contains(byId[id]!.kind));

    _truncated = visible.length > _maxGraphNodes;
    if (_truncated) {
      final ranked = visible.toList()
        ..sort((a, b) => (degree[b] ?? 0).compareTo(degree[a] ?? 0));
      visible = ranked.take(_maxGraphNodes).toSet();
      if (_focusId != null) visible.add(_focusId!);
    }

    final ids = visible.toList();
    final indexById = {for (var i = 0; i < ids.length; i++) ids[i]: i};
    final nodes = GraphSimulation.seedPositions(ids,
        radius: 120 + sqrt(ids.length) * 34);
    for (final node in nodes) {
      node.degree = degree[node.id] ?? 0;
    }
    final edges = <GraphEdge>[
      for (final entry in edgePairs.entries)
        if (indexById.containsKey(entry.key.split('|')[0]) &&
            indexById.containsKey(entry.key.split('|')[1]))
          GraphEdge(
            indexById[entry.key.split('|')[0]]!,
            indexById[entry.key.split('|')[1]]!,
            entry.value,
          ),
    ];

    final simulation = GraphSimulation(nodes: nodes, edges: edges)..settle();

    if (!mounted) return;
    setState(() {
      _entitiesById = byId;
      _simulation = simulation;
      _loading = false;
    });
  }

  void _onTapUp(TapUpDetails details) {
    final simulation = _simulation;
    if (simulation == null) return;
    final scenePoint =
        _transformController.toScene(details.localPosition);
    // Canvas origin is centered by the painter.
    final size = context.size ?? Size.zero;
    final point =
        scenePoint - Offset(size.width / 2, size.height / 2);

    GraphNode? hit;
    var bestDistance = 24.0;
    for (final node in simulation.nodes) {
      final distance = (node.position - point).distance;
      if (distance < bestDistance) {
        bestDistance = distance;
        hit = node;
      }
    }
    if (hit != null) {
      ref.read(searchRepositoryProvider).recordOpened(hit.id);
      context.go(Routes.entity(widget.worldId, hit.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final simulation = _simulation;
    return Scaffold(
      appBar: AppBar(
        title: Text(_focusId == null ? 'Graph View' : 'Local Graph'),
        actions: [
          if (_focusId != null)
            TextButton.icon(
              icon: const Icon(Icons.public, size: 16),
              label: const Text('Whole world'),
              onPressed: () {
                setState(() => _focusId = null);
                _build();
              },
            ),
          PopupMenuButton<EntityKind>(
            tooltip: 'Filter kinds',
            icon: const Icon(Icons.filter_list),
            onSelected: (kind) {
              setState(() {
                if (!_hiddenKinds.remove(kind)) _hiddenKinds.add(kind);
              });
              _build();
            },
            itemBuilder: (context) => [
              for (final kind in EntityKind.values)
                PopupMenuItem(
                  value: kind,
                  child: Row(
                    children: [
                      Icon(
                        _hiddenKinds.contains(kind)
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 16,
                        color: _hiddenKinds.contains(kind)
                            ? GmhColors.parchmentFaint
                            : kind.color,
                      ),
                      const SizedBox(width: 8),
                      Text(kind.pluralLabel),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : simulation == null || simulation.nodes.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No connections yet.\nLink entries with @ mentions, '
                      'relations or structured fields, and the web of your '
                      'world will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: GmhColors.parchmentDim),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTapUp: _onTapUp,
                        child: InteractiveViewer(
                          transformationController: _transformController,
                          minScale: 0.15,
                          maxScale: 4,
                          boundaryMargin:
                              const EdgeInsets.all(double.infinity),
                          constrained: true,
                          child: SizedBox.expand(
                            child: CustomPaint(
                              painter: _GraphPainter(
                                simulation: simulation,
                                entitiesById: _entitiesById,
                                focusId: _focusId,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_truncated)
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: GmhColors.surfaceRaised,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: GmhColors.border),
                          ),
                          child: Text(
                            'Showing the $_maxGraphNodes most connected '
                            'entries. Focus an entry for its local graph.',
                            style: const TextStyle(
                                fontSize: 11.5,
                                color: GmhColors.parchmentDim),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final GraphSimulation simulation;
  final Map<String, Entity> entitiesById;
  final String? focusId;

  _GraphPainter({
    required this.simulation,
    required this.entitiesById,
    required this.focusId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final edgePaint = Paint()
      ..color = GmhColors.border.withValues(alpha: 0.8)
      ..strokeWidth = 1;

    for (final edge in simulation.edges) {
      canvas.drawLine(
        simulation.nodes[edge.sourceIndex].position,
        simulation.nodes[edge.targetIndex].position,
        edgePaint,
      );
    }

    for (final node in simulation.nodes) {
      final entity = entitiesById[node.id];
      if (entity == null) continue;
      final isFocus = node.id == focusId;
      final radius = (5.0 + min(node.degree, 12) * 0.8) * (isFocus ? 1.4 : 1);

      if (isFocus) {
        canvas.drawCircle(
          node.position,
          radius + 6,
          Paint()
            ..color = GmhColors.ember.withValues(alpha: 0.25)
            ..style = PaintingStyle.fill,
        );
      }
      canvas.drawCircle(
        node.position,
        radius,
        Paint()..color = entity.kind.color,
      );
      canvas.drawCircle(
        node.position,
        radius,
        Paint()
          ..color = GmhColors.background
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: entity.name.length > 22
              ? '${entity.name.substring(0, 22)}…'
              : entity.name,
          style: TextStyle(
            fontSize: isFocus ? 12 : 10.5,
            color: isFocus ? GmhColors.emberBright : GmhColors.parchmentDim,
            fontWeight: isFocus ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: 140);
      textPainter.paint(
        canvas,
        node.position +
            Offset(-textPainter.width / 2, radius + 3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}
