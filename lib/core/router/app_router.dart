import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/game/presentation/screens/game_screen.dart';
import '../../features/category/presentation/screens/category_screen.dart';
import '../../features/difficulty/presentation/screens/difficulty_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/stats/presentation/screens/stats_screen.dart';
import '../constants/app_constants.dart';

/// Route paths
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String category = '/category';
  static const String difficulty = '/difficulty';
  static const String game = '/game';
  static const String daily = '/daily';
  static const String stats = '/stats';
  static const String achievements = '/achievements';
  static const String leaderboard = '/leaderboard';
  static const String settings = '/settings';
}

/// App router configuration
final appRouter = GoRouter(
  // Web goes straight to home, iOS/Android get splash
  initialLocation: kIsWeb ? AppRoutes.home : AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // Splash screen (iOS/Android only)
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    // Home screen
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    // Category selection
    GoRoute(
      path: AppRoutes.category,
      name: 'category',
      pageBuilder: (context, state) {
        final gameMode = state.extra as GameMode? ?? GameMode.casual;
        return MaterialPage<void>(
          key: state.pageKey,
          child: CategoryScreen(gameMode: gameMode),
        );
      },
    ),

    // Difficulty selection
    GoRoute(
      path: AppRoutes.difficulty,
      name: 'difficulty',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return MaterialPage<void>(
          key: state.pageKey,
          child: DifficultyScreen(
            gameMode: args?['gameMode'] as GameMode? ?? GameMode.casual,
            category: args?['category'] as WordCategory? ?? WordCategory.animals,
          ),
        );
      },
    ),

    // Game screen
    GoRoute(
      path: AppRoutes.game,
      name: 'game',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: GameScreen(
            gameMode: args?['gameMode'] as GameMode? ?? GameMode.casual,
            category: args?['category'] as WordCategory? ?? WordCategory.animals,
            difficulty: args?['difficulty'] as Difficulty? ?? Difficulty.easy,
          ),
          transitionsBuilder: _fadeScaleTransition,
        );
      },
    ),

    // Stats screen
    GoRoute(
      path: AppRoutes.stats,
      name: 'stats',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: const StatsScreen(),
      ),
    ),
  ],
);

// Custom page transitions

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
    child: child,
  );
}

Widget _slideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
    child: FadeTransition(
      opacity: CurveTween(curve: Curves.easeIn).animate(animation),
      child: child,
    ),
  );
}

Widget _pushTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  // Slide from right to left (iOS-style push transition)
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
    child: child,
  );
}

Widget _fadeScaleTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeIn).animate(animation),
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(animation),
      child: child,
    ),
  );
}
