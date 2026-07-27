import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/shell/pause_menu.dart';

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

class _QuickSearchIntent extends Intent {
  const _QuickSearchIntent();
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

  /// Ctrl/Cmd+K: jump to the current world's search from anywhere.
  void _goToSearch() {
    final location = _router.routerDelegate.currentConfiguration.uri.path;
    final worldId =
        RegExp(r'^/w/([^/]+)/').firstMatch(location)?.group(1);
    if (worldId != null) _router.go(Routes.search(worldId));
  }

  /// App-level fallback for [DismissIntent]: reached only when nothing
  /// closer to the focus consumed Escape (open dialogs, popups and text
  /// fields all handle it first), so plain Escape on a page opens the
  /// pause menu. Registered on DismissIntent rather than a custom Escape
  /// shortcut: a LogicalKeySet(escape) entry can never win over the
  /// default SingleActivator mapping — first match wins per trigger.
  void _onEscape() {
    final navigator = _router.routerDelegate.navigatorKey.currentState;
    // A modal that opted out of barrier dismissal (e.g. the section
    // constructor) lets the intent bubble here — never stack the pause
    // menu on top of it, and never force it closed.
    if (navigator == null || navigator.canPop()) return;
    final location = _router.routerDelegate.currentConfiguration.uri.path;
    final worldId =
        RegExp(r'^/w/([^/]+)/').firstMatch(location)?.group(1);
    unawaited(showPauseMenu(navigator.context, worldId: worldId));
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
        // Quick switch to search, the Obsidian/Notion muscle-memory combo.
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK):
            const _QuickSearchIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK):
            const _QuickSearchIntent(),
      },
      actions: {
        ...WidgetsApp.defaultActions,
        _BackIntent: CallbackAction<_BackIntent>(
            onInvoke: (_) =>
                ref.read(navHistoryProvider.notifier).goBack()),
        _ForwardIntent: CallbackAction<_ForwardIntent>(
            onInvoke: (_) =>
                ref.read(navHistoryProvider.notifier).goForward()),
        DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) => _onEscape()),
        _QuickSearchIntent: CallbackAction<_QuickSearchIntent>(
            onInvoke: (_) => _goToSearch()),
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
        // Mouse side buttons navigate history, like in every browser.
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) {
            if (event.kind != PointerDeviceKind.mouse) return;
            if (event.buttons == kBackMouseButton) {
              ref.read(navHistoryProvider.notifier).goBack();
            } else if (event.buttons == kForwardMouseButton) {
              ref.read(navHistoryProvider.notifier).goForward();
            }
          },
          child: child!,
        );
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
