import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n_ext.dart';
import 'locale_provider.dart';
import 'theme_provider.dart';
import 'router.dart';
import 'theme/gmh_theme.dart';

class GmhApp extends ConsumerStatefulWidget {
  /// Where the app starts: the last opened world's dashboard, or the world
  /// picker on first launch (resolved in `main()` before `runApp`).
  final String initialLocation;

  const GmhApp({super.key, required this.initialLocation});

  @override
  ConsumerState<GmhApp> createState() => _GmhAppState();
}

class _GmhAppState extends ConsumerState<GmhApp> {
  late final GoRouter _router =
      createRouter(initialLocation: widget.initialLocation);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: GmhTheme.light(),
      darkTheme: GmhTheme.dark(),
      themeMode: themeMode,
      builder: (context, child) {
        // Keep the GmhColors facade in sync with the resolved theme so the
        // whole widget tree (built after this) reads the right palette.
        GmhColors.palette = Theme.of(context).brightness == Brightness.dark
            ? gmhDarkPalette
            : gmhLightPalette;
        return child!;
      },
      routerConfig: _router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        ...FlutterQuillLocalizations.localizationsDelegates,
      ],
    );
  }
}
