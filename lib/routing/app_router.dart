import 'package:capybara/account/account_screen.dart';
import 'package:capybara/details/details_page.dart';
import 'package:capybara/login/login_screen.dart';
import 'package:capybara/home/home_screen.dart';
import 'package:capybara/search/search_screen.dart';
import 'package:capybara/services/study_class.dart';
import 'package:capybara/trials/trials_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute { search, account, signIn, trials, details, home }

final goRouterProvider = Provider<GoRouter>((ref) {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorHomeKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  final _shellNavigatorSearchKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
  final _shellNavigatorTrialKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellTrial');
  final _shellNavigatorAccountKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellAccount');
  final _shellNavigatorDetailsKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellDetails');

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggingIn = state.uri.path == '/login';

      if (user == null && !isLoggingIn) {
        return '/login'; // Redirect to login if not authenticated
      }

      if (user != null && isLoggingIn) {
        return '/'; // Redirect authenticated users to home
      }

      return null; // Proceed as normal
    },
    routes: [
      /// **🏠 Main Navigation Shell**
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          // 📌 Home Screen
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                name: AppRoute.home.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          // 📌 Search Screen
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: '/search',
                name: AppRoute.search.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: SearchScreen(),
                ),
              ),
            ],
          ),
          // 📌 Saved Trials
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTrialKey,
            routes: [
              GoRoute(
                path: '/trials',
                name: AppRoute.trials.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: SavedTrialsScreen(),
                ),
              ),
            ],
          ),
          // 📌 Account
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAccountKey,
            routes: [
              GoRoute(
                path: '/account',
                name: AppRoute.account.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: AccountScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDetailsKey,
            routes: [
              GoRoute(
                path: '/details',
                name: AppRoute.details.name,
                builder: (context, state) {
                  return StudyDetailPage(study: state.extra! as Studies);
                },
              ),
            ],
          ),
        ],
      ),
      // 🔑 **Login Route**
      GoRoute(
        path: '/login',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      // 📌 **Details Page (Top-Level Route)**
    ],
  );
});

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
          indicatorColor: Colors.teal,
          backgroundColor: Colors.white,
          selectedIndex: navigationShell.currentIndex,
          destinations: const [
            NavigationDestination(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            NavigationDestination(
              label: 'Search',
              icon: Icon(Icons.search),
            ),
            NavigationDestination(
              label: 'Saved Trials',
              icon: Icon(Icons.biotech_sharp),
            ),
            NavigationDestination(
              label: 'My Account',
              icon: Icon(Icons.person),
            ),
          ],
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }
}
