import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../domain/models/entity_kind.dart';
import 'tools.dart';
import '../features/campaigns/campaigns_screen.dart';
import '../features/entities/entity_list_screen.dart';
import '../features/entities/entity_screen.dart';
import '../features/graph/graph_screen.dart';
import '../features/help/help_screen.dart';
import '../features/trash/trash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/tools/tools_hub_screen.dart';
import '../features/worlds/world_picker_screen.dart';

/// Route helpers so navigation call-sites never build path strings by hand.
abstract final class Routes {
  static String worlds() => '/worlds';
  static String home(String worldId) => '/w/$worldId/home';
  static String browse(String worldId, EntityKind kind) =>
      '/w/$worldId/browse/${kind.name}';
  static String browseCategory(String worldId, String categoryId) =>
      '/w/$worldId/category/$categoryId';
  static String entity(String worldId, String entityId) =>
      '/w/$worldId/e/$entityId';
  static String search(String worldId) => '/w/$worldId/search';
  static String graph(String worldId, {String? focusEntityId}) =>
      '/w/$worldId/graph${focusEntityId == null ? '' : '?focus=$focusEntityId'}';
  static String campaigns(String worldId) => '/w/$worldId/campaigns';
  static String settings(String worldId) => '/w/$worldId/settings';
  static String help(String worldId) => '/w/$worldId/help';
  static String trash(String worldId) => '/w/$worldId/trash';
  static String tools(String worldId) => '/w/$worldId/tools';
  static String tool(String worldId, String toolId, [String? objectId]) =>
      '/w/$worldId/tools/$toolId${objectId == null ? '' : '/$objectId'}';
}

/// One page builder for every tool; an unknown tool id (a stale restored
/// location from another app version) falls back to the Tools hub.
Page<void> _toolPage(GoRouterState state, {required String? objectId}) {
  final worldId = state.pathParameters['worldId']!;
  final tool = toolById(state.pathParameters['toolId'] ?? '');
  return NoTransitionPage(
    // Keyed by object: switching encounters/maps inside one tab must not
    // reuse the previous object's page state.
    key: ValueKey(state.uri.path),
    child: tool == null
        ? ToolsHubScreen(worldId: worldId)
        : tool.builder(worldId, objectId),
  );
}

/// [shellNavigatorKey] lets the app tell whether a popup, dropdown or
/// bottom sheet is open inside the shell (pages are always replaced via
/// go(), so the shell stack holds more than one route only then).
GoRouter createRouter({
  required String initialLocation,
  GlobalKey<NavigatorState>? shellNavigatorKey,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    // A location that matches no route (e.g. restored from an older app
    // version) lands on the world picker instead of an error page.
    onException: (context, state, router) => router.go(Routes.worlds()),
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => Routes.worlds(),
      ),
      GoRoute(
        path: '/worlds',
        builder: (context, state) => const WorldPickerScreen(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          final worldId = state.pathParameters['worldId']!;
          return AppShell(worldId: worldId, child: child);
        },
        routes: [
          GoRoute(
            path: '/w/:worldId/home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: HomeScreen(worldId: state.pathParameters['worldId']!),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/browse/:kind',
            pageBuilder: (context, state) {
              final kind =
                  EntityKind.tryParse(state.pathParameters['kind'] ?? '') ??
                      EntityKind.character;
              return NoTransitionPage(
                child: EntityListScreen(
                  worldId: state.pathParameters['worldId']!,
                  kind: kind,
                ),
              );
            },
          ),
          GoRoute(
            path: '/w/:worldId/category/:categoryId',
            pageBuilder: (context, state) => NoTransitionPage(
              child: EntityListScreen(
                worldId: state.pathParameters['worldId']!,
                kind: EntityKind.custom,
                customCategoryId: state.pathParameters['categoryId'],
              ),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/e/:entityId',
            pageBuilder: (context, state) => NoTransitionPage(
              child: EntityScreen(
                worldId: state.pathParameters['worldId']!,
                entityId: state.pathParameters['entityId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/search',
            pageBuilder: (context, state) => NoTransitionPage(
              child: SearchScreen(worldId: state.pathParameters['worldId']!),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/graph',
            pageBuilder: (context, state) => NoTransitionPage(
              child: GraphScreen(
                // /graph and /graph?focus=X are different views: a fresh
                // state per URL instead of a reused local-graph state.
                key: ValueKey(state.uri.toString()),
                worldId: state.pathParameters['worldId']!,
                focusEntityId: state.uri.queryParameters['focus'],
              ),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/campaigns',
            pageBuilder: (context, state) => NoTransitionPage(
              child:
                  CampaignsScreen(worldId: state.pathParameters['worldId']!),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/settings',
            pageBuilder: (context, state) => NoTransitionPage(
              child:
                  SettingsScreen(worldId: state.pathParameters['worldId']!),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/tools',
            pageBuilder: (context, state) => NoTransitionPage(
              child: ToolsHubScreen(worldId: state.pathParameters['worldId']!),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/tools/:toolId',
            pageBuilder: (context, state) =>
                _toolPage(state, objectId: null),
          ),
          GoRoute(
            path: '/w/:worldId/tools/:toolId/:objectId',
            pageBuilder: (context, state) => _toolPage(state,
                objectId: state.pathParameters['objectId']),
          ),
          GoRoute(
            path: '/w/:worldId/trash',
            pageBuilder: (context, state) => NoTransitionPage(
              child: TrashScreen(worldId: state.pathParameters['worldId']!),
            ),
          ),
          GoRoute(
            path: '/w/:worldId/help',
            pageBuilder: (context, state) => NoTransitionPage(
              child: HelpScreen(worldId: state.pathParameters['worldId']!),
            ),
          ),
        ],
      ),
    ],
  );
}
