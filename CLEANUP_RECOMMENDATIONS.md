# Cleanup Recommendations

## Executive Summary

After refactoring, you have **legacy code that coexists with new architecture**. Here's what can be cleaned up and what should be kept.

## Files Status Analysis (43 total files)

### ✅ Active & Keep (32 files)

#### New Architecture (22 files) - **KEEP ALL**
```
lib/core/                                    # All new - keep
├── config/app_config.dart                   ✅ In use by new architecture
├── error/exceptions.dart                    ✅ In use by repositories
├── error/failures.dart                      ✅ In use by repositories
├── network/dio_client.dart                  ✅ HTTP client singleton
├── network/dio_interceptors.dart            ✅ Auth/logging/error handling
├── router/app_router.dart                   ✅ GoRouter config
└── theme/app_theme.dart                     ✅ Theme configuration

lib/features/                                # All new - keep
├── auth/domain/entities/
│   ├── auth_result.dart                     ✅ Union type for auth
│   ├── auth_result.freezed.dart             ✅ Generated
│   ├── auth_tokens.dart                     ✅ Token model
│   ├── auth_tokens.freezed.dart             ✅ Generated
│   └── auth_tokens.g.dart                   ✅ Generated
└── profile/
    ├── data/
    │   ├── datasources/profile_remote_datasource.dart  ✅ API calls
    │   ├── models/user_profile_model.dart              ✅ Data model
    │   ├── models/user_profile_model.freezed.dart      ✅ Generated
    │   ├── models/user_profile_model.g.dart            ✅ Generated
    │   └── repositories/profile_repository_impl.dart   ✅ Repository impl
    └── domain/
        ├── entities/user_profile.dart                  ✅ Domain entity
        ├── entities/user_profile.freezed.dart          ✅ Generated
        ├── entities/user_profile.g.dart                ✅ Generated
        └── repositories/profile_repository.dart        ✅ Repository interface
```

#### Legacy But Still Active (10 files) - **KEEP FOR NOW**
```
lib/screens/                                 # Still in use - keep until migrated
├── dashboard_screen.dart                    ✅ Active (not migrated yet)
├── email_confirm_screen.dart                ✅ Active (used by router)
├── login_screen.dart                        ✅ Active (used by router)
├── profile_form_screen.dart                 ✅ Active (used by router)
├── profile_form_step2_screen.dart           ✅ Active (used by router)
├── profile_form_step3_screen.dart           ✅ Active (used by router)
├── register_screen.dart                     ✅ Active (used by router)
└── splash_screen.dart                       ✅ Active (used by router)

lib/widgets/                                 # Reusable - keep
├── app_logo.dart                            ✅ Used in login/register
├── custom_text_field.dart                   ✅ Used in forms
├── loading_button.dart                      ✅ Used in forms
├── loading_overlay.dart                     ✅ Used in screens
└── social_login_button.dart                 ✅ Used in login

lib/constants/
└── app_constants.dart                       ✅ Used by widgets/screens

lib/services/
├── auth_service.dart                        ✅ STILL USED by screens
└── storage_service.dart                     ✅ STILL USED by everything

lib/main.dart                                ✅ Active entry point
```

### ⚠️ Deprecated - Can Be Removed (3 files)

#### Legacy Services (2 files) - **CAN REMOVE AFTER MIGRATION**

1. **`lib/services/http_client_service.dart`**
   - ❌ **DEPRECATED** - Replaced by `DioClient`
   - Used by: `profile_service.dart` only
   - Status: **Can be removed once ProfileService is replaced**

2. **`lib/services/api_logger.dart`**
   - ❌ **DEPRECATED** - Replaced by Dio's `LoggingInterceptor`
   - Used by: `http_client_service.dart`, `auth_service.dart`, `profile_service.dart`
   - Status: **Can be removed once services are migrated**

#### Legacy Utils (1 file) - **CAN REMOVE AFTER MIGRATION**

3. **`lib/utils/navigation_helper.dart`**
   - ❌ **DEPRECATED** - Replaced by GoRouter navigation
   - Used by: `login_screen.dart`, `email_confirm_screen.dart`, `splash_screen.dart`
   - Status: **Can be removed once screens use context.go()**

### ⚠️ Partially Deprecated (1 file)

4. **`lib/services/profile_service.dart`**
   - ⚠️ **PARTIALLY DEPRECATED** - Replaced by `ProfileRepository`
   - Used by: `navigation_helper.dart`, `profile_form_step3_screen.dart`
   - Status: **Still needed by legacy screens**
   - Action: **Replace with ProfileRepository once screens migrated**

### 📝 Not Used Yet (1 file)

5. **`lib/main_new.dart`**
   - 📝 **NOT ACTIVE** - New entry point with GoRouter
   - Status: **Waiting to be activated**
   - Action: **Switch when ready to migrate**

## Cleanup Strategy

### Option 1: Aggressive Cleanup (Recommended After Full Migration)

**When**: After all screens are migrated to use repositories and GoRouter

**Remove These Files** (5 files):
```bash
# Services
rm lib/services/http_client_service.dart
rm lib/services/api_logger.dart
rm lib/services/profile_service.dart

# Utils
rm lib/utils/navigation_helper.dart

# If utils directory is empty
rmdir lib/utils
```

**Benefits**:
- Clean codebase
- No confusion about which code to use
- Reduced bundle size

**Risk**: Medium - if migration isn't complete

### Option 2: Safe Archive (Recommended Now)

**When**: Now - keep legacy code as backup

**Create Archive Directory**:
```bash
mkdir lib/_legacy
mv lib/services/http_client_service.dart lib/_legacy/
mv lib/services/api_logger.dart lib/_legacy/
mv lib/utils/navigation_helper.dart lib/_legacy/
```

**Benefits**:
- Files preserved but out of the way
- Easy to reference if needed
- Clear signal that code is deprecated
- Can still be recovered if needed

**Risk**: Low - code is preserved

### Option 3: Keep Everything (Current State)

**When**: Now - until migration is complete

**Action**: No changes

**Benefits**:
- Zero risk
- App continues to work
- Gradual migration possible

**Risk**: None, but code duplication exists

## Detailed File Analysis

### 1. lib/services/http_client_service.dart

**Status**: ❌ DEPRECATED

**Replaced By**: `lib/core/network/dio_client.dart`

**Current Usage**:
```dart
// Only used by profile_service.dart:
import 'http_client_service.dart';
```

**Migration Path**:
```dart
// Old
await HttpClientService.get(Uri.parse(url), headers: headers);

// New
await DioClient.instance.get('/profile');
```

**When to Remove**: After `profile_service.dart` is replaced

---

### 2. lib/services/api_logger.dart

**Status**: ❌ DEPRECATED

**Replaced By**: `lib/core/network/dio_interceptors.dart` (LoggingInterceptor)

**Current Usage**:
- `auth_service.dart` - 15+ usages
- `http_client_service.dart` - 5 usages
- `profile_service.dart` - 10 usages

**Migration Path**:
```dart
// Old
ApiLogger.logRequest(operation: 'login', url: url, headers: headers);
ApiLogger.logResponse(operation: 'login', response: response, duration: duration);

// New
// Automatic logging via LoggingInterceptor in DioClient
// No manual logging needed
```

**When to Remove**: After auth and profile services are migrated

---

### 3. lib/utils/navigation_helper.dart

**Status**: ❌ DEPRECATED

**Replaced By**: GoRouter's declarative navigation

**Current Usage**:
- `login_screen.dart:97` - After successful login
- `email_confirm_screen.dart` - After email confirmation
- `splash_screen.dart` - Initial navigation

**Migration Path**:
```dart
// Old
await NavigationHelper.navigateAfterLogin(context);

// New
// Check profile in splash or add to router redirect logic
final hasProfile = await checkProfileExists();
if (hasProfile) {
  context.go('/dashboard');
} else {
  context.go('/profile/setup/step1');
}
```

**When to Remove**: After login, splash, and email confirm screens are updated

---

### 4. lib/services/profile_service.dart

**Status**: ⚠️ PARTIALLY DEPRECATED

**Replaced By**: `lib/features/profile/data/repositories/profile_repository_impl.dart`

**Current Usage**:
- `navigation_helper.dart` - Profile check after login
- `profile_form_step3_screen.dart` - Create profile

**Migration Path**:
```dart
// Old
final result = await ProfileService.getProfile();
if (result['success']) {
  // Handle success
}

// New
final repository = ProfileRepositoryImpl(
  ProfileRemoteDataSourceImpl(DioClient.instance),
);
final result = await repository.getProfile();
result.fold(
  (failure) => handleError(failure),
  (profile) => handleSuccess(profile),
);
```

**When to Remove**: After profile screens are migrated

---

### 5. lib/main_new.dart

**Status**: 📝 NOT USED YET

**Purpose**: New entry point using GoRouter

**Migration Path**:
```bash
# When ready to switch:
mv lib/main.dart lib/main_old.dart
mv lib/main_new.dart lib/main.dart
flutter run
```

**When to Activate**: After verifying new architecture works

## Recommendation: 3-Phase Cleanup

### Phase 1: Immediate (Safe) - Do Now ✅

**Archive deprecated files to _legacy folder**:
```bash
mkdir -p lib/_legacy/services
mkdir -p lib/_legacy/utils

# Move deprecated files
mv lib/services/http_client_service.dart lib/_legacy/services/
mv lib/services/api_logger.dart lib/_legacy/services/
mv lib/utils/navigation_helper.dart lib/_legacy/utils/

# Update imports in profile_service.dart to point to _legacy folder
# This keeps app working while marking code as deprecated
```

**Benefits**:
- ✅ Zero risk (app still works)
- ✅ Clear signal that files are deprecated
- ✅ Easy to rollback if needed
- ✅ Forces awareness during development

### Phase 2: After Screen Migration - Do Later ⏳

**Remove archived files after screens are migrated**:
```bash
# After all screens use GoRouter and repositories
rm -rf lib/_legacy
rm lib/services/profile_service.dart  # Once replaced by repository
```

**Benefits**:
- ✅ Clean codebase
- ✅ No dead code
- ✅ Smaller bundle size

### Phase 3: Final Cleanup - Do Last 🏁

**Switch to new main.dart**:
```bash
mv lib/main.dart lib/_old_main_backup.dart
mv lib/main_new.dart lib/main.dart
```

**Benefits**:
- ✅ Using new architecture completely
- ✅ GoRouter active
- ✅ Clean entry point

## Files to NEVER Remove

These are still actively used:

```
lib/services/
└── storage_service.dart              ✅ Used by everything for token storage

lib/services/
└── auth_service.dart                 ✅ Still used by all auth screens

lib/constants/
└── app_constants.dart                ✅ Used by widgets for spacing/styling

lib/widgets/                          ✅ All still used by screens
├── app_logo.dart
├── custom_text_field.dart
├── loading_button.dart
├── loading_overlay.dart
└── social_login_button.dart

lib/screens/                          ✅ All active (not migrated yet)
└── (all 8 screen files)
```

## Quick Win Cleanup Actions

### Action 1: Add Deprecation Comments (5 minutes)

Add clear deprecation notices:

```dart
// lib/services/http_client_service.dart
/// @deprecated Use `DioClient` from `lib/core/network/dio_client.dart` instead.
/// This file will be removed in a future version.
class HttpClientService { ... }

// lib/services/api_logger.dart
/// @deprecated Use Dio's `LoggingInterceptor` instead.
/// Logging is now automatic via `lib/core/network/dio_interceptors.dart`.
class ApiLogger { ... }

// lib/utils/navigation_helper.dart
/// @deprecated Use GoRouter navigation with `context.go()` instead.
/// See `lib/core/router/app_router.dart` for route configuration.
class NavigationHelper { ... }
```

### Action 2: Create Cleanup TODO List (2 minutes)

Add to your project's TODO:
```dart
// TODO: Migrate screens to use GoRouter
// TODO: Replace ProfileService with ProfileRepository
// TODO: Remove deprecated files from lib/_legacy/
// TODO: Switch to main_new.dart
```

### Action 3: Document in README (5 minutes)

Add to README.md:
```markdown
## Legacy Code

The following files are deprecated and will be removed:
- `lib/_legacy/` - Archived deprecated code
- `lib/services/profile_service.dart` - Use ProfileRepository instead
- `lib/main_new.dart` - New entry point (not active yet)
```

## Summary

### Current State
- ✅ 32 files actively used
- ⚠️ 3 files deprecated but still needed
- ❌ 3 files can be safely archived
- 📝  1 file waiting to be activated

### Recommended Actions

**Now** (Phase 1):
1. ✅ Archive 3 deprecated files to `lib/_legacy/`
2. ✅ Add deprecation comments
3. ✅ Document in README

**After Screen Migration** (Phase 2):
1. ⏳ Remove `lib/_legacy/`
2. ⏳ Remove `profile_service.dart`
3. ⏳ Clean up imports

**After Full Migration** (Phase 3):
1. 🏁 Activate `main_new.dart`
2. 🏁 Remove `main_old.dart` backup
3. 🏁 Celebrate! 🎉

---

*Created: 2025-12-10*
*Status: Legacy code coexists with new architecture*
*Risk Level: Low (app fully functional)*
