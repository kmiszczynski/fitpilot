import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../screens/dashboard_screen.dart';
import '../screens/profile_form_screen.dart';

/// Navigation Helper
/// Provides common navigation utilities with profile checking
class NavigationHelper {
  /// Navigate after successful login - checks if user has a profile
  /// and navigates to either ProfileFormScreen or DashboardScreen
  static Future<void> navigateAfterLogin(BuildContext context) async {
    try {
      // Check if user has a profile
      final profileResult = await ProfileService.getProfile();

      if (!context.mounted) return;

      // Check if profile not found
      if (!profileResult['success'] &&
          profileResult['data'] != null &&
          profileResult['data']['error'] == 'Profile not found') {
        // Navigate to profile form
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileFormScreen()),
          (route) => false,
        );
      } else {
        // Profile exists or other error, navigate to dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      // If profile check fails, navigate to dashboard anyway
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    }
  }
}