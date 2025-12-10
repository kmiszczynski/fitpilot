import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../network/dio_client.dart';

/// Navigation utility for handling post-login routing
class NavigationUtils {
  /// Navigate to the appropriate screen after successful login
  /// - Checks if user has a profile
  /// - Routes to profile setup if no profile found
  /// - Routes to dashboard if profile exists
  static Future<void> navigateAfterLogin(BuildContext context) async {
    if (!context.mounted) return;

    if (kDebugMode) {
      print('[NavigationUtils] Checking profile after login...');
    }

    try {
      final repository = ProfileRepositoryImpl(
        ProfileRemoteDataSourceImpl(DioClient.instance),
      );

      final result = await repository.getProfile();

      if (!context.mounted) return;

      result.fold(
        (failure) {
          if (kDebugMode) {
            print('[NavigationUtils] Profile check failed: ${failure.message}');
            print('[NavigationUtils] Status code: ${failure.statusCode}');
          }

          // Profile not found (404) or doesn't exist, go to profile setup
          if (failure.statusCode == 404 ||
              failure.message.toLowerCase().contains('not found') ||
              failure.message.toLowerCase().contains('no profile')) {
            if (kDebugMode) {
              print('[NavigationUtils] → Navigating to profile setup');
            }
            context.go('/profile/setup/step1');
          } else {
            if (kDebugMode) {
              print('[NavigationUtils] → Other error, navigating to dashboard');
            }
            // Other errors (network, server, etc.) - go to dashboard
            // User can try to access profile from dashboard
            context.go('/dashboard');
          }
        },
        (profile) {
          if (kDebugMode) {
            print('[NavigationUtils] Profile found: ${profile.name}');
            print('[NavigationUtils] → Navigating to dashboard');
          }
          // Profile exists, go to dashboard
          context.go('/dashboard');
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('[NavigationUtils] Unexpected error: $e');
        print('[NavigationUtils] → Navigating to dashboard (fallback)');
      }
      // Unexpected error, default to dashboard
      if (context.mounted) {
        context.go('/dashboard');
      }
    }
  }
}