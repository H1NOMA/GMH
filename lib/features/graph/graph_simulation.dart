import 'dart:math';
import 'dart:ui';

/// Node in the force-directed layout.
class GraphNode {
  final String id;
  Offset position;
  Offset velocity = Offset.zero;

  /// Degree-based visual weight (set by the builder).
  int degree = 0;

  GraphNode(this.id, this.position);
}

/// Undirected display edge.
class GraphEdge {
  final int sourceIndex;
  final int targetIndex;
  final String role;

  const GraphEdge(this.sourceIndex, this.targetIndex, this.role);
}

/// Small force-directed layout engine (Fruchterman–Reingold style with
/// velocity damping). Pure Dart, no dependencies; a few hundred nodes settle
/// in well under a second, and the tick budget keeps 60 fps while animating.
class GraphSimulation {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;

  final double repulsion;
  final double springLength;
  final double springStrength;
  final double centerPull;
  final double damping;

  double _alpha = 1.0;

  GraphSimulation({
    required this.nodes,
    required this.edges,
    this.repulsion = 5200,
    this.springLength = 110,
    this.springStrength = 0.06,
    this.centerPull = 0.012,
    this.damping = 0.85,
  });

  bool get isSettled => _alpha < 0.02;

  /// Seeds nodes on a circle (deterministic for a given node count).
  static List<GraphNode> seedPositions(List<String> ids, {double radius = 320}) {
    final random = Random(ids.length * 7919 + 13);
    final nodes = <GraphNode>[];
    for (var i = 0; i < ids.length; i++) {
      final angle = (i / max(1, ids.length)) * 2 * pi;
      final r = radius * (0.55 + random.nextDouble() * 0.45);
      nodes.add(GraphNode(ids[i], Offset(cos(angle) * r, sin(angle) * r)));
    }
    return nodes;
  }

  /// Advances the simulation one step. Returns true while still moving.
  bool tick() {
    if (isSettled || nodes.isEmpty) return false;

    final forces = List<Offset>.filled(nodes.length, Offset.zero);

    // Pairwise repulsion (O(n²) — fine for the display cap; the screen
    // limits visible nodes before building the simulation).
    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        var delta = nodes[i].position - nodes[j].position;
        var distanceSquared = delta.distanceSquared;
        if (distanceSquared < 1) {
          // Deterministic pseudo-random direction per pair. (i - j) and
          // (i + j) always share parity, so a parity-based jitter would only
          // ever separate coincident nodes along a single diagonal.
          final angle = (i * 31 + j * 17) % 64 / 64 * 2 * pi;
          delta = Offset(cos(angle), sin(angle)) * 0.5;
          distanceSquared = 0.5;
        }
        final force = delta * (repulsion / distanceSquared / sqrt(distanceSquared));
        forces[i] += force;
        forces[j] -= force;
      }
    }

    // Spring attraction along edges.
    for (final edge in edges) {
      final source = nodes[edge.sourceIndex];
      final target = nodes[edge.targetIndex];
      final delta = target.position - source.position;
      final distance = max(delta.distance, 0.01);
      final stretch = distance - springLength;
      final force = delta / distance * (stretch * springStrength);
      forces[edge.sourceIndex] += force;
      forces[edge.targetIndex] -= force;
    }

    // Gentle pull to origin keeps disconnected clusters on screen.
    for (var i = 0; i < nodes.length; i++) {
      forces[i] -= nodes[i].position * centerPull;
    }

    var totalMovement = 0.0;
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      node.velocity = (node.velocity + forces[i] * _alpha) * damping;
      node.position += node.velocity;
      totalMovement += node.velocity.distance;
    }

    _alpha *= 0.985;
    if (totalMovement / nodes.length < 0.05) _alpha = 0;
    return !isSettled;
  }

  /// Runs the simulation to (near) completion synchronously — used for the
  /// initial layout so the graph appears already organized.
  void settle({int maxTicks = 300}) {
    for (var i = 0; i < maxTicks; i++) {
      if (!tick()) break;
    }
  }
}
