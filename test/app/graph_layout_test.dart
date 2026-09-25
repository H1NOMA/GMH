import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/features/graph/graph_simulation.dart';

void main() {
  test('a large layout settles on a background isolate', () async {
    final ids = [for (var i = 0; i < 150; i++) 'n$i'];
    final nodes = GraphSimulation.seedPositions(ids);
    final edges = [
      for (var i = 1; i < ids.length; i++) GraphEdge(i ~/ 3, i, 'related'),
    ];
    final before = nodes.first.position;
    final unsettled = GraphSimulation(nodes: nodes, edges: edges);
    final settled = await Isolate.run(() => unsettled..settle());

    expect(settled.nodes, hasLength(150));
    expect(settled.nodes.first.id, 'n0');
    expect(settled.nodes.first.position, isNot(before));
    for (final node in settled.nodes) {
      expect(node.position.dx.isFinite && node.position.dy.isFinite, isTrue);
    }
  });
}
