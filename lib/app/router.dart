import 'package:go_router/go_router.dart';

import '../domain/models/entity_kind.dart';
import '../features/campaigns/campaigns_screen.dart';
import '../features/entities/entity_list_screen.dart';
import '../features/entities/entity_screen.dart';
import '../features/graph/graph_screen.dart';
import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/worlds/world_picker_screen.dart';

/// Route helpers so navigation call-sites never build path strings by hand.
abstract final class Routes {
  static String worlds() => '/worlds';
  static String home(String worldId) => '/w/$worldId/home';
  static String browse(String worldId, EntityKind kind) =>
      '/w/$worldId/browse/${kind.name}';
  static String entity(String worldId, String entityId) =>
      '/w/$worldId/e/$entityId';
  static String search(String worldId) => '/w/$worldId/search';
  static String graph(String worldId, {String? focusEntityId}) =>
      '/w/$worldId/graph${focusEntityId == null ? '' : '?focus=$focusEntityId'}';
  static String campaigns(String worldId) => '/w/$worldId/campaigns';
  static String settings(String worldId) => '/w/$worldId/settings';
}

GoRouter createRouter({required String initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
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
        ],
      ),
    ],
  );
}
