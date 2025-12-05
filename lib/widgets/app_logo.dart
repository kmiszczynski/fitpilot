import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Theme-aware app logo widget
/// Displays logo_dark.png in dark theme and logo_light.png in light theme
class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;

  const AppLogo({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Image.asset(
      isDark ? AppConstants.logoDark : AppConstants.logoLight,
      height: height ?? AppConstants.logoHeight,
      width: width ?? AppConstants.logoWidth,
      fit: BoxFit.contain,
    );
  }
}