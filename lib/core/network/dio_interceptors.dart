import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../services/storage_service.dart';

/// Logging interceptor for debugging API calls
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🌐 REQUEST [${options.method}] ${options.uri}');
      print('Headers: ${options.headers}');
      if (options.data != null) {
        print('Data: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('Query Parameters: ${options.queryParameters}');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('✅ RESPONSE [${response.statusCode}] ${response.requestOptions.uri}');
      print('Data: ${response.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ ERROR [${err.response?.statusCode}] ${err.requestOptions.uri}');
      print('Type: ${err.type}');
      print('Message: ${err.message}');
      if (err.response != null) {
        print('Response: ${err.response?.data}');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onError(err, handler);
  }
}

/// Auth interceptor - adds authorization token to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get ID token from secure storage
    final idToken = await StorageService.getIdToken();

    if (idToken != null) {
      options.headers['Authorization'] = 'Bearer $idToken';
    }

    super.onRequest(options, handler);
  }
}

/// Error interceptor - handles token refresh on 401
class ErrorInterceptor extends Interceptor {
  static bool _isRefreshing = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token refresh
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        // Attempt to refresh token
        final refreshToken = await StorageService.getRefreshToken();

        if (refreshToken != null) {
          // Import AuthService lazily to avoid circular dependency
          // Note: This is a simplified version. In production, you'd want
          // a dedicated token refresh service.
          if (kDebugMode) {
            print('🔄 Attempting to refresh token...');
          }

          // TODO: Implement token refresh logic here
          // For now, we'll let the error pass through
          // You should call your auth service's refresh method here
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Token refresh failed: $e');
        }
      } finally {
        _isRefreshing = false;
      }
    }

    super.onError(err, handler);
  }
}
