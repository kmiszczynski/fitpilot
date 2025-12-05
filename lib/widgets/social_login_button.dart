import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_constants.dart';

/// Social login button widget
class SocialLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onPressed,
    this.isLoading = false,
  });

  /// Facebook login button
  factory SocialLoginButton.facebook({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      label: 'Continue with Facebook',
      icon: FontAwesomeIcons.facebook,
      backgroundColor: const Color(AppConstants.facebookColor),
      foregroundColor: Colors.white,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  /// Google login button
  factory SocialLoginButton.google({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      label: 'Continue with Google',
      icon: FontAwesomeIcons.google,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: FaIcon(
        icon,
        color: foregroundColor,
        size: 20,
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          side: backgroundColor == Colors.white
              ? BorderSide(color: Colors.grey[300]!)
              : BorderSide.none,
        ),
      ),
    );
  }
}