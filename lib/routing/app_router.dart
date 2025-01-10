import 'package:capybara/details/details_page.dart';
import 'package:capybara/search/search_screen.dart';
import 'package:capybara/services/study_class.dart';
import 'package:capybara/trials/trials_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute { search, account, signIn, trials, details }

final goRouterProvider = Provider<GoRouter>((ref) {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorSearchKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
  final _shellNavigatortrialpKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellTrial');

  // final listenable = ref.watch(appRouterListenableProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    navigatorKey: _rootNavigatorKey,
    // refreshListenable: listenable,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // the UI shell
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          // first branch (A)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              // top route inside branch
              GoRoute(
                path: '/',
                name: AppRoute.search.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: SearchScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'details',
                    name: AppRoute.details.name,
                    builder: (context, state) {
                      // final study = state.pathParameters['study']!;
                      return StudyDetailPage(study: state.extra! as Studies);
                    },
                  ),
                ],
              ),
            ],
          ),
          // second branch (B)
          StatefulShellBranch(
            navigatorKey: _shellNavigatortrialpKey,
            routes: [
              // top route inside branch
              GoRoute(
                path: '/trials',
                name: AppRoute.trials.name,
                pageBuilder: (context, state) => MaterialPage(
                  child: TrialsScreen(),
                ),
              ),
            ],
          ),
          // StatefulShellBranch(
          //   navigatorKey: _shellNavigatorCurateKey,
          //   routes: [
          //     // top route inside branch
          //     GoRoute(
          //       path: '/addStory',
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: Curatepage(),
          //       ),
          //       routes: [
          //         // child route
          //       ],
          //     ),
          //   ],
          // ),
          // StatefulShellBranch(
          //   navigatorKey: _shellNavigatorBookmarkKey,
          //   routes: [
          //     // top route inside branch
          //     GoRoute(
          //       path: '/bookmarks',
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: BookmarksPage(),
          //       ),
          //       routes: [
          //         // child route
          //       ],
          //     ),
          //   ],
          // ),
          // StatefulShellBranch(
          //   navigatorKey: _shellNavigatorProfileKey,
          //   routes: [
          //     // top route inside branch
          //     GoRoute(
          //       path: '/profile',
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: Profilepage(),
          //       ),
          //       routes: [
          //         // child route
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    ],
  );
});

// use like this:
// MaterialApp.router(routerConfig: goRouter, ...)
//   GoRoute(
//       path: '/',
//       name: AppRoute.home.name,
//       builder: (context, state) => const HomepageListPage(),
//       routes: [
//         GoRoute(
//           path: 'following',
//           name: AppRoute.following.name,
//           pageBuilder: (context, state) => const MaterialPage(
//             // fullscreenDialog: true,
//             child: FollowingPage(),
//           ),
//         ),
//         GoRoute(
//           path: 'discover',
//           name: AppRoute.discover.name,
//           pageBuilder: (context, state) => const MaterialPage(
//             // fullscreenDialog: true,
//             child: DiscoverPage(),
//           ),
//         ),
//       ])
// ],
// errorBuilder: (context, state) => const NotFoundScreen(),
// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black, width: 0.5)),
        ),
        child: NavigationBar(
          indicatorColor: Colors.red.shade100,
          backgroundColor: Colors.white,
          selectedIndex: navigationShell.currentIndex,
          destinations: const [
            NavigationDestination(label: 'Search', icon: Icon(Icons.search)),
            NavigationDestination(
                label: 'Trials', icon: Icon(Icons.biotech_sharp)),
            NavigationDestination(
                label: 'My Doctors', icon: Icon(Icons.add_box_rounded)),
            // NavigationDestination(label: 'Bookmarks', icon: Icon(Icons.bookmark)),
            NavigationDestination(
                label: 'My Account', icon: Icon(Icons.person)),
          ],
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }
}
