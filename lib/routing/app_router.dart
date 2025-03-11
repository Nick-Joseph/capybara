import 'package:capybara/account/account_screen.dart';
import 'package:capybara/details/details_page.dart';
import 'package:capybara/login/login_screen.dart';
import 'package:capybara/home/home_screen.dart';
import 'package:capybara/login/sign_up_screen.dart';
import 'package:capybara/search/search_screen.dart';
import 'package:capybara/services/study_class.dart';
import 'package:capybara/trials/trials_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute { search, account, signIn, trials, details, home, signUp }

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

  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggingInOrSigningUp =
          state.uri.path == '/login' || state.uri.path == '/signUp';

      // Allow access to home & search without login
      if (user == null &&
          (state.uri.path == '/trials' || state.uri.path == '/account')) {
        return '/login'; // Redirect to login if trying to access restricted features
      }

      if (user != null && isLoggingInOrSigningUp) {
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
          // 📌 Home Screen (Available to Everyone)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          // 📌 Search Screen (Available to Everyone)
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
          // 📌 Saved Trials (Restricted)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTrialKey,
            routes: [
              GoRoute(
                path: '/trials',
                name: AppRoute.trials.name,
                pageBuilder: (context, state) {
                  final user = FirebaseAuth.instance.currentUser;
                  return NoTransitionPage(
                    child: user == null ? LoginScreen() : SavedTrialsScreen(),
                  );
                },
              ),
            ],
          ),
          // 📌 Account/Profile (Restricted)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAccountKey,
            routes: [
              GoRoute(
                path: '/account',
                name: AppRoute.account.name,
                pageBuilder: (context, state) {
                  final user = FirebaseAuth.instance.currentUser;
                  return NoTransitionPage(
                    child: user == null ? LoginScreen() : AccountScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      // 🔑 **Login & Sign-Up Routes**
      GoRoute(
        path: '/login',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signUp',
        name: AppRoute.signUp.name,
        builder: (context, state) => SignUpScreen(),
      ),
      // 📌 **Details Page (Available to Everyone)**
      GoRoute(
        path: '/details',
        name: AppRoute.details.name,
        builder: (context, state) {
          return StudyDetailPage(study: state.extra! as Studies);
        },
      ),
    ],
  );
});

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index, BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (index == 2 || index == 3) {
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please log in to access this feature.")),
        );
        return;
      }
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.teal,
        backgroundColor: Colors.white,
        selectedIndex: navigationShell.currentIndex,
        destinations: [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Search', icon: Icon(Icons.search)),
          NavigationDestination(
            label: 'Saved Trials',
            icon: Icon(Icons.biotech_sharp,
                color: user == null ? Colors.grey : null),
          ),
          NavigationDestination(
            label: user == null
                ? 'Sign In'
                : 'My Account', // 👈 Change label for guest users
            icon: Icon(
              user == null ? Icons.login : Icons.person,
              color: user == null
                  ? Colors.blue
                  : null, // 👈 Highlight login option for guests
            ),
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 3 && user == null) {
            GoRouter.of(context).go('/login'); // 👈 Send guest to login screen
          } else {
            _goBranch(index, context);
          }
        },
      ),
    );
  }
}
