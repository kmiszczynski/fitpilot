import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for caching (if needed)
  // await Hive.initFlutter();

  // Catch all Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('');
    debugPrint('🔴 ========================================');
    debugPrint('🔴 FLUTTER ERROR CAUGHT');
    debugPrint('🔴 ========================================');
    debugPrint('Error: ${details.exception}');
    debugPrint('Stack trace:\n${details.stack}');
    debugPrint('🔴 ========================================');
    debugPrint('');
  };

  // Catch all async errors that weren't caught by Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('');
    debugPrint('🔴 ========================================');
    debugPrint('🔴 ASYNC ERROR CAUGHT');
    debugPrint('🔴 ========================================');
    debugPrint('Error: $error');
    debugPrint('Stack trace:\n$stack');
    debugPrint('🔴 ========================================');
    debugPrint('');
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitPilot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
