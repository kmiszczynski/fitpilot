import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/splash_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/email_confirm_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/profile_form_screen.dart';
import '../../screens/profile_form_step2_screen.dart';
import '../../screens/profile_form_step3_screen.dart';
import '../../services/storage_service.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: _redirect,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(title: 'FitPilot'),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/confirm-email',
        name: 'confirmEmail',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final password = state.uri.queryParameters['password'] ?? '';
          return EmailConfirmScreen(
            email: email,
            password: password,
          );
        },
      ),

      // Profile Setup Routes
      GoRoute(
        path: '/profile/setup/step1',
        name: 'profileStep1',
        builder: (context, state) => const ProfileFormScreen(),
      ),
      GoRoute(
        path: '/profile/setup/step2',
        name: 'profileStep2',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProfileFormStep2Screen(
            name: extra?['name'] ?? '',
            age: extra?['age'] ?? 0,
            sex: extra?['sex'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/profile/setup/step3',
        name: 'profileStep3',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProfileFormStep3Screen(
            name: extra?['name'] ?? '',
            age: extra?['age'] ?? 0,
            sex: extra?['sex'] ?? '',
            trainingFrequency: extra?['trainingFrequency'] ?? 0,
            target: extra?['target'] ?? '',
          );
        },
      ),

      // Dashboard
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Redirect logic for auth guards
  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    // Check if user has valid tokens
    final hasAuth = await StorageService.hasValidTokens();
    final isOnAuthPage = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/confirm-email';

    // If not authenticated and trying to access protected routes
    if (!hasAuth && !isOnAuthPage && state.matchedLocation != '/') {
      return '/login';
    }

    // If authenticated and on auth pages, redirect to dashboard
    if (hasAuth && isOnAuthPage) {
      return '/dashboard';
    }

    return null;
  }
}
