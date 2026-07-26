import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n_ext.dart';
import 'locale_provider.dart';
import 'nav_state.dart';
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

class _BackIntent extends Intent {
  const _BackIntent();
}

class _ForwardIntent extends Intent {
  const _ForwardIntent();
}

class _GmhAppState extends ConsumerState<GmhApp> {
  late final GoRouter _router =
      createRouter(initialLocation: widget.initialLocation);

  @override
  void initState() {
    super.initState();
    // Feed every location change into the browser-style history and persist
    // it so the app can reopen exactly where the user left off.
    final history = ref.read(navHistoryProvider.notifier);
    history.navigate = (location) => _router.go(location);
    String location() =>
        _router.routerDelegate.currentConfiguration.uri.toString();
    history.onLocationChanged(location());
    _router.routerDelegate.addListener(() {
      final current = location();
      history.onLocationChanged(current);
      persistLastLocation(ref, current);
    });
  }

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
      // Browser-style history shortcuts, active app-wide.
      shortcuts: {
        ...WidgetsApp.defaultShortcuts,
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
            const _BackIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
            const _ForwardIntent(),
      },
      actions: {
        ...WidgetsApp.defaultActions,
        _BackIntent: CallbackAction<_BackIntent>(
            onInvoke: (_) =>
                ref.read(navHistoryProvider.notifier).goBack()),
        _ForwardIntent: CallbackAction<_ForwardIntent>(
            onInvoke: (_) =>
                ref.read(navHistoryProvider.notifier).goForward()),
      },
      debugShowCheckedModeBanner: false,
      theme: GmhTheme.light(),
      darkTheme: GmhTheme.dark(),
      themeMode: themeMode,
      builder: (context, child) {
        // Keep the GmhColors facade in sync with the resolved theme so the
        // whole widget tree (built after this) reads the right palette.
        // Resolve against the active world style — hardcoding the fantasy
        // palettes here would repaint a cyberpunk world in gold for a frame
        // whenever this builder runs after the shell set the style.
        GmhColors.palette = GmhStyle.paletteFor(
            GmhStyle.current, Theme.of(context).brightness);
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
