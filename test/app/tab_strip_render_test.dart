import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/l10n_ext.dart';
import 'package:gmh/features/shell/tab_strip.dart';
import 'package:gmh/features/shell/workspace_tabs.dart';

void main() {
  testWidgets('tab strip renders labels for section and entity tabs',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final tabs = container.read(workspaceTabsProvider.notifier);
    tabs.navigate = (_) {};
    tabs.onLocationChanged('/w/w1/home');
    tabs.openInNewTab('/w/w1/browse/creature');

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(body: WorkspaceTabStrip(worldId: 'w1')),
      ),
    ));
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Creatures'), findsOneWidget);
  });
}
