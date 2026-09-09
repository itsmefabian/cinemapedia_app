import 'package:cinemapedia_app/presentation/screens/screens.dart';
import 'package:cinemapedia_app/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: HomeScreen.name,
              builder: (context, state) => const HomeView(),
              routes: [
                GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) =>
                      MovieScreen(movieId: state.pathParameters['id'] ?? '0'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/popular',
              name: PopularView.name,
              builder: (context, state) => const PopularView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: FavoritesView.name,
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: SettingsView.name,
              builder: (context, state) => const SettingsView(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// ShellRoute(
//   builder: (context, state, child) {
//     return HomeScreen(childView: child);
//   },
//   routes: [
//     GoRoute(
//       path: '/',
//       name: HomeScreen.name,
//       builder: (context, state) =>
//           HomeView(movieId: state.pathParameters['id'] ?? '0'),
//       routes: [
//         GoRoute(
//           path: 'movie/:id',
//           name: MovieScreen.name,
//           builder: (context, state) =>
//               MovieScreen(movieId: state.pathParameters['id'] ?? '0'),
//         ),
//       ],
//     ),
//     GoRoute(
//       path: '/favorites',
//       name: FavoritesView.name,
//       builder: (context, state) => FavoritesView(),
//     ),
//   ],
// ),
