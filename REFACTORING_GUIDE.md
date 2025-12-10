# FitPilot Refactoring Guide

## Overview

This document describes the comprehensive refactoring applied to the FitPilot Flutter application to follow Flutter best practices and modern architecture patterns.

## What Changed

### 1. Package Dependencies

#### Added Required Packages:
- **dio** (^5.7.0) - HTTP client (replaces `http` package)
- **go_router** (^14.6.2) - Declarative routing
- **freezed** & **freezed_annotation** - Immutable data models
- **json_annotation** & **json_serializable** - JSON serialization
- **build_runner** - Code generation
- **hive** & **hive_flutter** - Local caching
- **dartz** (^0.10.1) - Functional programming (Either type)
- **equatable** (^2.0.7) - Value equality

#### Dev Dependencies Added:
- **freezed** (^2.5.7)
- **json_serializable** (^6.8.0)
- **hive_generator** (^2.0.1)

### 2. Architecture Changes

#### Old Structure:
```
lib/
├── constants/
├── screens/
├── services/
├── utils/
└── widgets/
```

#### New Structure:
```
lib/
├── core/                      # Core functionality
│   ├── config/
│   │   └── app_config.dart    # Centralized configuration
│   ├── error/
│   │   ├── exceptions.dart    # Exception classes
│   │   └── failures.dart      # Failure classes
│   ├── network/
│   │   ├── dio_client.dart    # Dio HTTP client singleton
│   │   └── dio_interceptors.dart  # Auth, logging, error interceptors
│   ├── router/
│   │   └── app_router.dart    # GoRouter configuration
│   └── theme/
│       └── app_theme.dart     # Theme configuration
├── features/                  # Feature modules
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   └── profile/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── profile_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_profile_model.dart
│       │   └── repositories/
│       │       └── profile_repository_impl.dart
│       └── domain/
│           ├── entities/
│           │   └── user_profile.dart
│           └── repositories/
│               └── profile_repository.dart
├── screens/                   # Legacy screens (to be migrated)
├── services/                  # Legacy services (to be migrated)
├── widgets/                   # Legacy widgets (to be migrated)
└── main.dart
```

### 3. Key Improvements

#### HTTP Client Migration (http → Dio)

**Before:**
```dart
import 'package:http/http.dart' as http;

final response = await http.get(
  Uri.parse(url),
  headers: headers,
);
```

**After:**
```dart
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';

final response = await DioClient.instance.get(
  '/profile',
);
```

**Benefits:**
- Automatic token injection via interceptors
- Request/response logging
- Automatic token refresh on 401
- Better error handling
- Request cancellation support

#### Data Models with Freezed

**Before:**
```dart
class UserProfile {
  final String id;
  final String name;

  UserProfile({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
    );
  }
}
```

**After:**
```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required int age,
    required String sex,
    // ... more fields
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
```

**Benefits:**
- Immutable by default
- Automatic `copyWith` method
- Automatic `==` and `hashCode`
- JSON serialization generated
- Union types support
- Pattern matching

#### Repository Pattern

**Before:**
```dart
class ProfileService {
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(url);
      return {
        'success': true,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
```

**After:**
```dart
abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final result = await _remoteDataSource.getProfile();
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

**Benefits:**
- Clear separation of concerns
- Testable (easy to mock)
- Type-safe error handling with Either
- Abstracts data sources
- Single responsibility

#### Navigation (Navigator → GoRouter)

**Before:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProfileScreen(userId: '123'),
  ),
);
```

**After:**
```dart
context.go('/profile/123');
// or
context.goNamed('profile', pathParameters: {'id': '123'});
```

**Benefits:**
- Declarative routing
- Deep linking support
- URL-based navigation
- Centralized route configuration
- Type-safe navigation
- Easy authentication guards

#### Error Handling

**New error hierarchy:**
```dart
// Exceptions (data layer)
- ServerException
- NetworkException
- CacheException
- AuthException

// Failures (domain/presentation layer)
- ServerFailure
- NetworkFailure
- CacheFailure
- AuthFailure
- ValidationFailure
- UnknownFailure
```

**Usage:**
```dart
final result = await repository.getProfile();

result.fold(
  (failure) {
    // Handle error
    if (failure is NetworkFailure) {
      showError('No internet connection');
    } else {
      showError(failure.message);
    }
  },
  (profile) {
    // Handle success
    displayProfile(profile);
  },
);
```

### 4. Configuration Management

All configuration is now centralized in `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const String apiBaseUrl = 'https://...';
  static const String cognitoUserPoolId = '...';
  static const String cognitoClientId = '...';
  // ... etc
}
```

### 5. Dio Interceptors

Three interceptors are configured:

1. **LoggingInterceptor** - Logs all requests/responses
2. **AuthInterceptor** - Automatically adds Bearer token
3. **ErrorInterceptor** - Handles token refresh on 401

## Migration Steps

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Generate Code

Run build_runner to generate Freezed and JSON serialization code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Update Main Entry Point

Replace `lib/main.dart` with `lib/main_new.dart` once migration is complete.

### Step 4: Migrate Services to Repositories

1. Create data models with Freezed
2. Create repository interfaces in domain layer
3. Implement repositories in data layer
4. Create data sources for API calls using Dio
5. Update screens to use repositories

### Step 5: Migrate Navigation

1. Update all `Navigator.push` to `context.go()`
2. Update all `Navigator.pushReplacement` to `context.replace()`
3. Remove MaterialPageRoute usage

### Step 6: Remove Old Code

Once migration is complete:
1. Delete old `http_client_service.dart`
2. Delete old service files
3. Update remaining screens

## Usage Examples

### Making API Calls

```dart
// 1. Create data model
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

// 2. Create repository interface
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}

// 3. Create data source
class ProductRemoteDataSource {
  final DioClient _dio;

  Future<List<ProductModel>> getProducts() async {
    final response = await _dio.get('/products');
    return (response.data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}

// 4. Implement repository
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await _dataSource.getProducts();
      return Right(products.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}

// 5. Use in UI
final result = await repository.getProducts();
result.fold(
  (failure) => showError(failure.message),
  (products) => displayProducts(products),
);
```

### Navigation

```dart
// Define routes in app_router.dart
GoRoute(
  path: '/product/:id',
  name: 'productDetails',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductDetailsScreen(productId: id);
  },
),

// Navigate
context.goNamed('productDetails', pathParameters: {'id': '123'});

// With query parameters
context.go('/product/123?tab=reviews');

// Go back
context.pop();
```

### Secure Storage

```dart
// Still using flutter_secure_storage
await StorageService.saveTokens(
  accessToken: token,
  idToken: idToken,
  refreshToken: refreshToken,
);

final token = await StorageService.getIdToken();
```

### Caching with Hive

```dart
// Initialize
await Hive.initFlutter();
Hive.registerAdapter(ProductAdapter());

// Open box
final box = await Hive.openBox<Product>('products');

// Store
await box.put('product_123', product);

// Retrieve
final product = box.get('product_123');
```

## Testing

### Repository Testing

```dart
class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

void main() {
  late ProductRepository repository;
  late MockRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRemoteDataSource();
    repository = ProductRepositoryImpl(mockDataSource);
  });

  test('should return products when call is successful', () async {
    // Arrange
    when(() => mockDataSource.getProducts())
        .thenAnswer((_) async => [testProduct]);

    // Act
    final result = await repository.getProducts();

    // Assert
    expect(result, Right([testProduct.toEntity()]));
  });
}
```

## Best Practices

1. **Always use Dio** instead of http package
2. **Use Freezed** for all data models
3. **Implement Repository pattern** for data access
4. **Use Either<Failure, Success>** for error handling
5. **Use GoRouter** for navigation
6. **Store sensitive data** in flutter_secure_storage
7. **Cache non-sensitive data** with Hive
8. **Centralize configuration** in AppConfig
9. **Use const constructors** wherever possible
10. **Follow feature-based architecture**

## Next Steps

1. **Add State Management** - Consider adding Riverpod or Bloc
2. **Add Localization** - Use easy_localization
3. **Add Testing** - Write unit, widget, and integration tests
4. **Add Analytics** - Firebase Analytics or similar
5. **Add Crash Reporting** - Firebase Crashlytics
6. **Improve Offline Support** - Cache management with Hive
7. **Add Code Coverage** - Aim for >80% coverage

## Resources

- [Dio Documentation](https://pub.dev/packages/dio)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Clean Architecture in Flutter](https://medium.com/flutter-community/clean-architecture-in-flutter-a-complete-guide-to-software-architecture-part-1-2d9c0f64cac3)
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)
