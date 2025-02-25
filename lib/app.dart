import 'package:capybara/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
                home: Center(child: CircularProgressIndicator())); // Loading
          }
          return MaterialApp.router(
            routerConfig: goRouter,
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            theme: ThemeData(
              // * Use this to toggle Material 3 (defaults to true since Flutter 3.16)
              useMaterial3: true,
              primarySwatch: Colors.grey,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
              ),
            ),
          );
        });
  }
}
