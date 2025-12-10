# FitPilot Migration Checklist

## ✅ Completed Refactoring Tasks

### Dependencies & Setup
- [x] Added Dio (5.9.0) for HTTP requests
- [x] Added GoRouter (14.8.1) for navigation
- [x] Added Freezed (2.5.7) for data models
- [x] Added Hive (2.2.3) for local caching
- [x] Added Dartz (0.10.1) for functional programming
- [x] Added all required dev dependencies
- [x] Ran `flutter pub get` successfully
- [x] Ran `build_runner` successfully (78 files generated)
- [x] All new code passes `flutter analyze` with 0 issues

### Core Architecture
- [x] Created `lib/core/config/app_config.dart` - Centralized configuration
- [x] Created `lib/core/network/dio_client.dart` - Dio HTTP client singleton
- [x] Created `lib/core/network/dio_interceptors.dart` - Auth, logging, error interceptors
- [x] Created `lib/core/error/failures.dart` - Failure type hierarchy
- [x] Created `lib/core/error/exceptions.dart` - Exception type hierarchy
- [x] Created `lib/core/router/app_router.dart` - GoRouter configuration
- [x] Created `lib/core/theme/app_theme.dart` - Centralized theme

### Feature Modules - Profile
- [x] Created domain entities: `UserProfile`
- [x] Created domain repository interface: `ProfileRepository`
- [x] Created data models: `UserProfileModel` (with Freezed)
- [x] Created data source: `ProfileRemoteDataSource`
- [x] Created repository implementation: `ProfileRepositoryImpl`

### Feature Modules - Auth
- [x] Created domain entities: `AuthTokens`, `AuthResult`
- [x] Both with Freezed code generation

### Documentation
- [x] Created `REFACTORING_GUIDE.md` - Complete technical guide
- [x] Created `MIGRATION_CHECKLIST.md` - This checklist
- [x] Inline documentation in all new files

## ⚠️ Pending Migration Tasks

### 1. Update Main Entry Point
```bash
# When ready to use new architecture completely:
mv lib/main.dart lib/main_old.dart
mv lib/main_new.dart lib/main.dart
flutter run
```

### 2. Migrate Auth Service
- [ ] Create `AuthRepository` interface in `lib/features/auth/domain/repositories/`
- [ ] Create `AuthRemoteDataSource` in `lib/features/auth/data/datasources/`
- [ ] Create `AuthRepositoryImpl` in `lib/features/auth/data/repositories/`
- [ ] Migrate all auth methods to use Dio instead of http/Cognito SDK directly
- [ ] Update screens to use `AuthRepository` instead of `AuthService`
- [ ] Test all auth flows (login, register, OAuth, token refresh)

### 3. Migrate Screens to Use GoRouter
Update each screen:
- [ ] `lib/screens/login_screen.dart`
  - Replace `Navigator.push` with `context.go('/register')`
  - Replace navigation helper with `context.go('/dashboard')`
- [ ] `lib/screens/register_screen.dart`
  - Replace `Navigator.push` with `context.go()`
- [ ] `lib/screens/email_confirm_screen.dart`
  - Replace navigation with GoRouter
- [ ] `lib/screens/profile_form_screen.dart`
  - Replace `Navigator.push` with `context.go()`
- [ ] `lib/screens/profile_form_step2_screen.dart`
  - Replace `Navigator.push` with `context.go()`
- [ ] `lib/screens/profile_form_step3_screen.dart`
  - Replace navigation with GoRouter
  - Update to use `ProfileRepository` instead of `ProfileService`

### 4. Clean Up Legacy Code
Once migration is complete:
- [ ] Delete `lib/services/http_client_service.dart`
- [ ] Delete or archive `lib/services/auth_service.dart`
- [ ] Delete `lib/services/profile_service.dart`
- [ ] Delete `lib/utils/navigation_helper.dart`
- [ ] Delete `lib/services/api_logger.dart` (replaced by Dio logging interceptor)

### 5. Testing
- [ ] Write unit tests for `ProfileRepository`
- [ ] Write unit tests for `ProfileRemoteDataSource`
- [ ] Write unit tests for `AuthRepository` (once migrated)
- [ ] Write widget tests for key screens
- [ ] Test all navigation flows
- [ ] Test token refresh flow
- [ ] Test offline scenarios

### 6. Optional Enhancements
- [ ] Add state management (Riverpod recommended)
- [ ] Add localization (easy_localization)
- [ ] Add analytics (Firebase Analytics)
- [ ] Add crash reporting (Firebase Crashlytics)
- [ ] Add in-app notifications
- [ ] Add app update checker
- [ ] Improve error messages with user-friendly text
- [ ] Add loading states management
- [ ] Add pull-to-refresh functionality
- [ ] Add offline mode with Hive caching

## Quick Start Guide

### Using the New HTTP Client

**Old Way:**
```dart
import 'package:http/http.dart' as http;

final response = await http.get(
  Uri.parse('$baseUrl/profile'),
  headers: await getAuthHeaders(),
);
```

**New Way:**
```dart
import '../core/network/dio_client.dart';

final response = await DioClient.instance.get('/profile');
// Token is automatically added by AuthInterceptor
// Logging is automatic via LoggingInterceptor
// 401 errors trigger automatic token refresh
```

### Using the New Repository Pattern

**Old Way:**
```dart
final result = await ProfileService.getProfile();
if (result['success']) {
  final data = result['data'];
  // Handle success
} else {
  final error = result['message'];
  // Handle error
}
```

**New Way:**
```dart
final repository = ProfileRepositoryImpl(
  ProfileRemoteDataSourceImpl(DioClient.instance),
);

final result = await repository.getProfile();
result.fold(
  (failure) {
    // Handle error - type safe!
    if (failure is NetworkFailure) {
      showSnackbar('No internet connection');
    } else {
      showSnackbar(failure.message);
    }
  },
  (profile) {
    // Handle success - type safe UserProfile object!
    displayProfile(profile);
  },
);
```

### Using GoRouter Navigation

**Old Way:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProfileScreen(userId: '123'),
  ),
);

Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => DashboardScreen()),
);
```

**New Way:**
```dart
// Simple navigation
context.go('/profile/123');

// Named routes (type-safe)
context.goNamed('profile', pathParameters: {'id': '123'});

// With extra data
context.goNamed(
  'profileStep2',
  extra: {
    'name': 'John',
    'age': 25,
    'sex': 'male',
  },
);

// Replace current route
context.replace('/dashboard');

// Go back
context.pop();
```

## Testing Checklist

Before deploying to production:

### Functionality Tests
- [ ] User can register with email/password
- [ ] User can login with email/password
- [ ] User can login with Google OAuth
- [ ] User can login with Facebook OAuth
- [ ] Email confirmation flow works
- [ ] Profile creation (3-step form) works
- [ ] Profile is saved to backend
- [ ] Token refresh happens automatically on 401
- [ ] User stays logged in after app restart
- [ ] Logout clears all data

### Navigation Tests
- [ ] Deep links work (if configured)
- [ ] Back button behavior is correct
- [ ] Auth guards prevent unauthorized access
- [ ] Logged-in users can't access login/register
- [ ] Logged-out users can't access dashboard

### Error Handling Tests
- [ ] Network errors show appropriate message
- [ ] Server errors (500) show appropriate message
- [ ] Invalid credentials show appropriate message
- [ ] Validation errors are clear
- [ ] App doesn't crash on any error

### Performance Tests
- [ ] App starts quickly
- [ ] Navigation is smooth
- [ ] API calls are fast
- [ ] No memory leaks
- [ ] Images load efficiently

## Rollback Plan

If issues occur after migration:

```bash
# Revert to old main.dart
mv lib/main.dart lib/main_new.dart
mv lib/main_old.dart lib/main.dart

# Keep new architecture for future use
# Legacy code still works as-is
```

## Support Resources

- **Technical Documentation**: See `REFACTORING_GUIDE.md`
- **Dio Docs**: https://pub.dev/packages/dio
- **Freezed Docs**: https://pub.dev/packages/freezed
- **GoRouter Docs**: https://pub.dev/packages/go_router
- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

## Status Summary

✅ **Core Architecture**: Complete (0 issues)
✅ **HTTP Client**: Dio configured with interceptors
✅ **Data Models**: Freezed models with code generation
✅ **Error Handling**: Either pattern implemented
✅ **Navigation**: GoRouter configured
⚠️ **Screen Migration**: Pending (legacy screens still use Navigator)
⚠️ **Auth Migration**: Pending (still uses old AuthService)
⚠️ **Testing**: Not started

**Current Progress: 60% Complete**
**Estimated Time to Full Migration: 4-6 hours**

---

*Last Updated: 2025-12-10*
*Status: Refactoring Complete, Migration Pending*
