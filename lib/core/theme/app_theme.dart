import 'package:flutter/material.dart';

/// Centralized theme configuration
/// Design Concept: "Electric Performance" - Bold, energetic fitness aesthetic
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================================================
  // LIGHT THEME COLORS - Fresh, energizing, like early morning training
  // ============================================================================

  /// Athletic Teal - Strong, confident primary with excellent contrast on white
  static const Color _lightPrimary = Color(0xFF00796B);

  /// Energy Orange - Warm, motivating accent that radiates vitality
  static const Color _lightSecondary = Color(0xFFFF6F00);

  /// Deep Teal - Rich shade for containers and emphasis
  static const Color _lightPrimaryContainer = Color(0xFF00695C);

  /// Cool White - Clean, fresh background
  static const Color _lightBackground = Color(0xFFF8FAFB);

  /// Soft Gray - Subtle surface color with depth
  static const Color _lightSurface = Color(0xFFF1F4F7);

  /// Performance Yellow - Achievement and intensity accent
  static const Color _lightTertiary = Color(0xFFFFA726);

  // ============================================================================
  // DARK THEME COLORS - Bold, powerful, like focused late-night workouts
  // ============================================================================

  /// Neon Teal - Glowing primary that pops against darkness
  static const Color _darkPrimary = Color(0xFF26FFC6);

  /// Flame Orange - Intense warm accent for dark backgrounds
  static const Color _darkSecondary = Color(0xFFFF9E40);

  /// Bright Teal - Vibrant shade for containers
  static const Color _darkPrimaryContainer = Color(0xFF00BFA5);

  /// Deep Charcoal - Rich, performance-oriented background
  static const Color _darkBackground = Color(0xFF0A0E12);

  /// Slate Blue - Surface with subtle blue undertone
  static const Color _darkSurface = Color(0xFF1A1F28);

  /// Electric Yellow - High visibility accent for achievements
  static const Color _darkTertiary = Color(0xFFFFD54F);

  // ============================================================================
  // SEMANTIC COLORS - Consistent across themes
  // ============================================================================

  /// Success/Beginner - Fresh green for positive actions
  static const Color success = Color(0xFF00E676);

  /// Warning/Intermediate - Vibrant amber for caution
  static const Color warning = Color(0xFFFFAB00);

  /// Error/Advanced - Bold red for errors and high intensity
  static const Color error = Color(0xFFFF3D00);

  /// Info - Cool blue for informational content
  static const Color info = Color(0xFF00B0FF);

  /// Light theme configuration
  static ThemeData lightTheme() {
    const textPrimary = Color(0xFF1A1A1A);
    const textSecondary = Color(0xFF4A5568);
    const textMuted = Color(0xFF6B7280);
    const iconColor = Color(0xFF6B7280);
    const dividerColor = Color(0xFFCCD5DD);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _lightPrimary,
        onPrimary: Colors.white,
        primaryContainer: _lightPrimaryContainer,
        onPrimaryContainer: Colors.white,
        secondary: _lightSecondary,
        onSecondary: Colors.white,
        tertiary: _lightTertiary,
        onTertiary: Color(0xFF1A1A1A),
        error: error,
        onError: Colors.white,
        surface: _lightSurface,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        surfaceContainerHighest: Color(0xFFE3E8ED),
        outline: dividerColor,
        outlineVariant: Color(0xFFE3E8ED),
        inversePrimary: _lightPrimary.withOpacity(0.15),
      ),
      scaffoldBackgroundColor: _lightBackground,
      iconTheme: IconThemeData(color: iconColor),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textMuted),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFCCD5DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFCCD5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightPrimary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFE3E8ED), width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _lightSurface,
        selectedColor: _lightPrimary,
        labelStyle: TextStyle(color: Color(0xFF1A1A1A)),
        side: BorderSide(color: Color(0xFFCCD5DD)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: Color(0xFF6B7280),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData darkTheme() {
    const textPrimary = Color(0xFFE8EAED);
    const textSecondary = Color(0xFFB8BCC4);
    const textMuted = Color(0xFF8B92A0);
    const iconColor = Color(0xFFB8BCC4);
    const dividerColor = Color(0xFF3D4654);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _darkPrimary,
        onPrimary: Color(0xFF0A0E12),
        primaryContainer: _darkPrimaryContainer,
        onPrimaryContainer: Colors.white,
        secondary: _darkSecondary,
        onSecondary: Color(0xFF0A0E12),
        tertiary: _darkTertiary,
        onTertiary: Color(0xFF0A0E12),
        error: error,
        onError: Colors.white,
        surface: _darkSurface,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        surfaceContainerHighest: Color(0xFF262C36),
        outline: dividerColor,
        outlineVariant: Color(0xFF262C36),
        inversePrimary: _darkPrimary.withOpacity(0.15),
      ),
      scaffoldBackgroundColor: _darkBackground,
      iconTheme: IconThemeData(color: iconColor),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _darkSurface,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textMuted),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Color(0xFF0A0E12),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: Color(0xFF0A0E12),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF3D4654)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF3D4654)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkPrimary, width: 2),
        ),
        filled: true,
        fillColor: Color(0xFF141922),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFF262C36), width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF262C36),
        selectedColor: _darkPrimary,
        labelStyle: TextStyle(color: Color(0xFFE8EAED)),
        side: BorderSide(color: Color(0xFF3D4654)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: Color(0xFF8B92A0),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS - For consistent colors across the app
  // ============================================================================

  /// Get color for difficulty level
  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return success;
      case 'intermediate':
        return warning;
      case 'advanced':
        return error;
      default:
        return info;
    }
  }

  /// Get theme-aware muted text color (for subtitles, descriptions)
  /// Use this instead of Colors.grey[600]
  static Color getMutedTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  /// Get theme-aware icon color
  /// Use this instead of Colors.grey[400]
  static Color getIconColor(BuildContext context) {
    return Theme.of(context).iconTheme.color ?? Theme.of(context).colorScheme.onSurfaceVariant;
  }

  /// Get theme-aware divider color
  /// Use this instead of Colors.grey[300]
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).colorScheme.outline;
  }

  /// Get theme-aware placeholder/disabled color
  /// Use this instead of Colors.grey[200]
  static Color getPlaceholderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Color(0xFF262C36) : Color(0xFFE3E8ED);
  }

  /// Get theme-aware error color for icons/illustrations
  /// Use this instead of Colors.red[300]
  static Color getErrorIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? error.withOpacity(0.8) : error.withOpacity(0.7);
  }
}
