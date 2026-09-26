// A screen state for the alignment audit: a route plus the taps that open
// a dialog, a panel or an error state on it.

import 'package:flutter_test/flutter_test.dart';

import '../../support/demo_world.dart';

class AlignScenario {
  final String name;
  final String Function(DemoWorld d) location;
  final Future<void> Function(WidgetTester tester, DemoWorld d) act;

  const AlignScenario(this.name, this.location, this.act);
}
