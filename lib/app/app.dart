import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/shell/pause_menu.dart';
import '../features/shell/workspace_tabs.dart';

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
    // Feed every location change into the workspace tabs (each tab keeps
    // its own back/forward history) and persist it so the app can reopen
    // exactly where the user left off.
    final tabs = ref.read(workspaceTabsProvider.notifier);
    tabs.navigate = (location) => _router.go(location);
    String location() =>
        _router.routerDelegate.currentConfiguration.uri.toString();
    void record() {
      if (!mounted) return;
      final current = location();
      tabs.onLocationChanged(current);
      persistLastLocation(ref, current);
    }

    // The delegate notifies mid-build while resolving a route (and this
    // very initState runs during the first build), where provider writes
    // are illegal. Every notification also schedules a frame, so
    // recording after that frame is both safe and lossless.
    void recordAfterFrame() {
      WidgetsBinding.instance.addPostFrameCallback((_) => record());
    }

    recordAfterFrame();
    _router.routerDelegate.addListener(recordAfterFrame);
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

  /// Escape → pause menu, wired as a root [Focus.onKeyEvent] rather than
  /// an action on [DismissIntent]: the Actions lookup stops at the
  /// NEAREST action registered for an intent type, and every page route
  /// installs its own (disabled, barrierDismissible=false) dismiss
  /// action — an app-level DismissIntent handler is permanently
  /// shadowed and never runs. Unhandled key events, in contrast, bubble
  /// up the focus tree all the way to the root.
  ///
  /// While something is open on top (dialog, popup menu), the event is
  /// left unhandled so the framework's regular Escape-dismiss flow closes
  /// it — and a modal that opted out of barrier dismissal (e.g. the
  /// section constructor) keeps ignoring Escape without the pause menu
  /// stacking on top of it.
  KeyEventResult _onRootKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    final navigator = _router.routerDelegate.navigatorKey.currentState;
    if (navigator == null || navigator.canPop()) {
      return KeyEventResult.ignored;
    }
    final location = _router.routerDelegate.currentConfiguration.uri.path;
    final worldId =
        RegExp(r'^/w/([^/]+)/').firstMatch(location)?.group(1);
    unawaited(showPauseMenu(navigator.context, worldId: worldId));
    return KeyEventResult.handled;
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
                ref.read(workspaceTabsProvider.notifier).goBack()),
        _ForwardIntent: CallbackAction<_ForwardIntent>(
            onInvoke: (_) =>
                ref.read(workspaceTabsProvider.notifier).goForward()),
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
        return Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: _onRootKey,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (event.kind != PointerDeviceKind.mouse) return;
              if (event.buttons == kBackMouseButton) {
                ref.read(workspaceTabsProvider.notifier).goBack();
              } else if (event.buttons == kForwardMouseButton) {
                ref.read(workspaceTabsProvider.notifier).goForward();
              }
            },
            child: child!,
          ),
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
