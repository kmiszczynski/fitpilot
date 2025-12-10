import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../core/network/dio_client.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait a bit for splash screen effect
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user is authenticated
    final hasAuth = await StorageService.hasValidTokens();

    if (!hasAuth) {
      // Not authenticated, go to login
      context.go('/login');
      return;
    }

    // Authenticated, check if user has profile
    try {
      final repository = ProfileRepositoryImpl(
        ProfileRemoteDataSourceImpl(DioClient.instance),
      );

      final result = await repository.getProfile();

      if (!mounted) return;

      result.fold(
        (failure) {
          // Profile not found or error, go to profile setup
          if (failure.message.contains('not found') ||
              failure.statusCode == 404) {
            context.go('/profile/setup/step1');
          } else {
            // Other error, go to dashboard anyway
            context.go('/dashboard');
          }
        },
        (profile) {
          // Profile exists, go to dashboard
          context.go('/dashboard');
        },
      );
    } catch (e) {
      // Error checking profile, go to dashboard
      if (mounted) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}