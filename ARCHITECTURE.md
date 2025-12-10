# FitPilot Architecture

## Overview

FitPilot now follows **Clean Architecture** principles with a feature-based modular structure.

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────┐    │
│  │   Screens   │  │   Widgets   │  │  State Management │    │
│  │  (Flutter)  │  │  (Flutter)  │  │   (setState)      │    │
│  └─────────────┘  └─────────────┘  └──────────────────┘    │
└────────────────────────────┬────────────────────────────────┘
                             │ uses
┌────────────────────────────▼────────────────────────────────┐
│                       Domain Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Entities   │  │ Repositories │  │  Use Cases   │      │
│  │  (Models)    │  │ (Interfaces) │  │  (Business)  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────────┬────────────────────────────────┘
                             │ implements
┌────────────────────────────▼────────────────────────────────┐
│                        Data Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │    Models    │  │ Repositories │  │ Data Sources │      │
│  │  (Freezed)   │  │    (Impl)    │  │ (API/Cache)  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────────┬────────────────────────────────┘
                             │ uses
┌────────────────────────────▼────────────────────────────────┐
│                      Core/Infrastructure                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Dio Client  │  │    Router    │  │    Theme     │      │
│  │ (Network)    │  │  (GoRouter)  │  │  (Material)  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── core/                              # Core utilities & infrastructure
│   ├── config/
│   │   └── app_config.dart           # API URLs, Cognito config, constants
│   ├── error/
│   │   ├── exceptions.dart           # Data layer exceptions
│   │   └── failures.dart             # Domain/Presentation failures
│   ├── network/
│   │   ├── dio_client.dart           # Singleton HTTP client
│   │   └── dio_interceptors.dart     # Auth, logging, error handling
│   ├── router/
│   │   └── app_router.dart           # Route configuration & guards
│   └── theme/
│       └── app_theme.dart            # Light/dark themes
│
├── features/                          # Feature modules (Clean Architecture)
│   ├── auth/                         # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/          # API calls, local storage
│   │   │   ├── models/               # JSON models (Freezed)
│   │   │   └── repositories/         # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/             # Pure Dart objects
│   │   │   │   ├── auth_tokens.dart
│   │   │   │   └── auth_result.dart  # Union type (success/failure/loading)
│   │   │   ├── repositories/         # Repository interfaces
│   │   │   └── usecases/             # Business logic (optional)
│   │   └── presentation/
│   │       ├── pages/                # Full screens
│   │       ├── widgets/              # Reusable components
│   │       └── state/                # State management (if using Bloc/Riverpod)
│   │
│   └── profile/                      # Profile feature
│       ├── data/
│       │   ├── datasources/
│       │   │   └── profile_remote_datasource.dart  # API calls via Dio
│       │   ├── models/
│       │   │   └── user_profile_model.dart         # Freezed model
│       │   └── repositories/
│       │       └── profile_repository_impl.dart    # Repository implementation
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_profile.dart               # Domain entity
│       │   └── repositories/
│       │       └── profile_repository.dart         # Repository interface
│       └── presentation/
│           ├── pages/                # Profile screens
│           └── widgets/              # Profile-specific widgets
│
├── screens/                          # LEGACY - To be migrated to features
├── services/                         # LEGACY - To be replaced by repositories
├── widgets/                          # LEGACY - To be moved to shared/
└── main.dart                         # App entry point
```

## Data Flow

### Example: Fetch User Profile

```
┌────────────┐
│   Screen   │ 1. User opens profile screen
└──────┬─────┘
       │
       │ 2. Call repository
       ▼
┌────────────────────┐
│ ProfileRepository  │ 3. Repository orchestrates data fetching
└──────┬─────────────┘
       │
       │ 4. Fetch from API
       ▼
┌──────────────────────────┐
│ ProfileRemoteDataSource  │ 5. Make HTTP request via Dio
└──────┬───────────────────┘
       │
       │ 6. Dio interceptors add auth token
       ▼
┌──────────────┐
│  Dio Client  │ 7. HTTP GET /profile
└──────┬───────┘
       │
       │ 8. Response received
       ▼
┌──────────────────────────┐
│ ProfileRemoteDataSource  │ 9. Parse JSON to UserProfileModel
└──────┬───────────────────┘
       │
       │ 10. Convert model to entity
       ▼
┌────────────────────┐
│ ProfileRepository  │ 11. Return Either<Failure, UserProfile>
└──────┬─────────────┘
       │
       │ 12. Handle success/failure
       ▼
┌────────────┐
│   Screen   │ 13. Display profile or error
└────────────┘
```

## Key Components

### 1. Dio Client (HTTP)

**Location**: `lib/core/network/dio_client.dart`

**Features**:
- Singleton pattern
- Base URL configuration
- Timeout configuration
- Three interceptors:
  1. **AuthInterceptor** - Adds Bearer token automatically
  2. **LoggingInterceptor** - Logs requests/responses in debug mode
  3. **ErrorInterceptor** - Handles 401 with automatic token refresh

**Usage**:
```dart
final response = await DioClient.instance.get('/profile');
```

### 2. Repository Pattern

**Purpose**: Abstracts data sources from business logic

**Structure**:
```
Domain Layer (Interface)
  └── ProfileRepository (abstract)
        ├── getProfile()
        ├── createProfile()
        ├── updateProfile()
        └── deleteProfile()

Data Layer (Implementation)
  └── ProfileRepositoryImpl
        └── Uses ProfileRemoteDataSource
              └── Uses DioClient
```

**Benefits**:
- Easy to mock for testing
- Can switch data sources (API ↔ Cache)
- Clear separation of concerns
- Type-safe error handling

### 3. Freezed Models

**Purpose**: Immutable data classes with code generation

**Features**:
- Immutable by default
- Automatic `copyWith()`
- Automatic `==` and `hashCode`
- JSON serialization
- Union types (e.g., `AuthResult.success()` or `AuthResult.failure()`)

**Example**:
```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required int age,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

// Usage
final profile = UserProfile(id: '1', name: 'John', age: 25);
final updated = profile.copyWith(name: 'Jane');
```

### 4. Error Handling

**Pattern**: `Either<Failure, Success>` from dartz package

**Failures** (Domain/Presentation):
- `ServerFailure` - API errors (400, 500, etc.)
- `NetworkFailure` - No internet connection
- `CacheFailure` - Local storage errors
- `AuthFailure` - Authentication errors
- `ValidationFailure` - Input validation errors
- `UnknownFailure` - Unexpected errors

**Exceptions** (Data Layer):
- `ServerException` - API errors
- `NetworkException` - Connection errors
- `CacheException` - Storage errors
- `AuthException` - Auth errors

**Flow**:
```dart
// Data layer throws exceptions
throw ServerException(message: 'Not found', statusCode: 404);

// Repository catches and converts to failures
return Left(ServerFailure(message: e.message));

// UI handles with fold
result.fold(
  (failure) => showError(failure.message),
  (data) => displayData(data),
);
```

### 5. GoRouter Navigation

**Location**: `lib/core/router/app_router.dart`

**Features**:
- Declarative routing
- Named routes
- Path parameters
- Query parameters
- Auth guards (redirect logic)
- Deep linking support

**Routes**:
```
/                         → SplashScreen
/login                    → LoginScreen
/register                 → RegisterScreen
/confirm-email            → EmailConfirmScreen
/profile/setup/step1      → ProfileFormScreen (Step 1)
/profile/setup/step2      → ProfileFormStep2Screen
/profile/setup/step3      → ProfileFormStep3Screen
/dashboard                → DashboardScreen (protected)
```

**Auth Guard**:
```dart
// Redirect logic in app_router.dart
static Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final hasAuth = await StorageService.hasValidTokens();

  // Redirect to login if not authenticated
  if (!hasAuth && isProtectedRoute) {
    return '/login';
  }

  // Redirect to dashboard if authenticated and on auth page
  if (hasAuth && isAuthPage) {
    return '/dashboard';
  }

  return null;
}
```

## Design Patterns Used

### 1. **Singleton Pattern**
- `DioClient` - Single HTTP client instance
- Ensures consistent configuration

### 2. **Repository Pattern**
- Abstracts data sources
- Clean separation: Domain ↔ Data
- Easy mocking for tests

### 3. **Dependency Injection**
- Repositories receive data sources
- Data sources receive Dio client
- Makes code testable

### 4. **Either Pattern (Functional)**
- Type-safe error handling
- Forces explicit error handling
- No silent failures

### 5. **Interceptor Pattern**
- Dio interceptors for cross-cutting concerns
- Auth, logging, error handling
- Clean separation of concerns

### 6. **Factory Pattern**
- Freezed generates factory constructors
- `.fromJson()` factories
- Union type factories

## State Management

**Current**: Manual `setState()`

**Recommended Upgrades**:
1. **Riverpod** - Most recommended
   - Compile-safe
   - Testable
   - Great DevTools

2. **Bloc/Cubit**
   - Event-driven
   - Predictable state
   - Good for complex flows

3. **Provider** (Simple cases)
   - Easy to learn
   - Good for small apps

## Testing Strategy

### Unit Tests
```dart
// Repository tests
test('should return profile when API call is successful', () async {
  // Arrange
  when(() => mockDataSource.getProfile())
      .thenAnswer((_) async => testProfileModel);

  // Act
  final result = await repository.getProfile();

  // Assert
  expect(result, Right(testProfileModel.toEntity()));
});
```

### Widget Tests
```dart
testWidgets('should display profile data', (tester) async {
  await tester.pumpWidget(ProfileScreen(profile: testProfile));
  expect(find.text('John'), findsOneWidget);
});
```

### Integration Tests
```dart
testWidgets('complete profile creation flow', (tester) async {
  // Navigate through 3-step form
  // Submit profile
  // Verify API call
  // Check dashboard displayed
});
```

## Performance Optimizations

1. **Const Constructors** - Reduce widget rebuilds
2. **Dio Connection Pooling** - Reuse HTTP connections
3. **Hive Caching** - Fast local storage (50,000+ reads/s)
4. **Lazy Loading** - Load data only when needed
5. **Code Splitting** - Separate bundles (if web)

## Security Best Practices

1. **Secure Storage** - Tokens in `flutter_secure_storage`
2. **HTTPS Only** - All API calls encrypted
3. **Token Refresh** - Automatic on 401
4. **No Hardcoded Secrets** - Use environment variables
5. **Input Validation** - Both client and server-side

## Scalability Considerations

1. **Feature Modules** - Easy to add new features
2. **Lazy Loading** - Load features on demand
3. **Code Generation** - Less manual work
4. **Caching Strategy** - Reduce API calls
5. **Error Recovery** - Automatic retry logic

## Next Steps

1. **Migrate screens** to use repositories
2. **Add state management** (Riverpod)
3. **Write tests** (unit, widget, integration)
4. **Add localization** (easy_localization)
5. **Setup CI/CD** (GitHub Actions)
6. **Add analytics** (Firebase)
7. **Performance monitoring** (Firebase Performance)

---

*Architecture follows Clean Architecture by Robert C. Martin*
*Inspired by Reso Coder's Flutter Clean Architecture series*
