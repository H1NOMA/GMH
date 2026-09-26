import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/router.dart';

import '../../support/visual_routes.dart';
import 'scenario.dart';

Future<void> _roll(WidgetTester tester, String expression) async {
  final field = find.byKey(const ValueKey('dice-expression'));
  await tester.ensureVisible(field);
  await tester.pump();
  await tester.enterText(field, expression);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await settleVisual(tester, 4);
}

final playScenarios = <AlignScenario>[
  AlignScenario('dice:error', (d) => Routes.tool(d.worldId, 'dice'),
      (tester, d) => _roll(tester, '2d6+')),
  AlignScenario('dice:result', (d) => Routes.tool(d.worldId, 'dice'),
      (tester, d) => _roll(tester, '2d6+3')),
];
