import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../services/storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';

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
  static final List<_RequestQueueItem> _requestQueue = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token refresh
    if (err.response?.statusCode == 401) {
      final refreshToken = await StorageService.getRefreshToken();

      // If no refresh token, let the error pass through (user needs to login)
      if (refreshToken == null) {
        if (kDebugMode) {
          print('❌ No refresh token available. User needs to login.');
        }
        return super.onError(err, handler);
      }

      // If already refreshing, queue this request
      if (_isRefreshing) {
        if (kDebugMode) {
          print('⏳ Token refresh in progress, queuing request...');
        }
        _requestQueue.add(_RequestQueueItem(err.requestOptions, handler));
        return;
      }

      // Start refresh process
      _isRefreshing = true;

      try {
        if (kDebugMode) {
          print('🔄 Attempting to refresh token...');
        }

        // Refresh the token
        final authDataSource = AuthRemoteDataSourceImpl();
        final newTokens = await authDataSource.refreshToken();

        if (kDebugMode) {
          print('✅ Token refreshed successfully!');
        }

        // Retry the original request with new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${newTokens.idToken}';

        // Create a new Dio instance to avoid interceptor loops
        final dio = Dio();
        final response = await dio.fetch(options);

        // Resolve the original handler
        handler.resolve(response);

        // Process queued requests
        if (_requestQueue.isNotEmpty) {
          if (kDebugMode) {
            print('🔄 Processing ${_requestQueue.length} queued requests...');
          }

          final queueCopy = List<_RequestQueueItem>.from(_requestQueue);
          _requestQueue.clear();

          for (final item in queueCopy) {
            try {
              item.options.headers['Authorization'] =
                  'Bearer ${newTokens.idToken}';
              final queuedResponse = await dio.fetch(item.options);
              item.handler.resolve(queuedResponse);
            } catch (e) {
              item.handler.reject(
                DioException(
                  requestOptions: item.options,
                  error: e,
                ),
              );
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Token refresh failed: $e');
        }

        // Clear tokens on refresh failure
        await StorageService.clearTokens();

        // Reject the original request
        handler.reject(err);

        // Reject all queued requests
        for (final item in _requestQueue) {
          item.handler.reject(
            DioException(
              requestOptions: item.options,
              error: 'Token refresh failed',
            ),
          );
        }
        _requestQueue.clear();
      } finally {
        _isRefreshing = false;
      }

      return;
    }

    super.onError(err, handler);
  }
}

/// Helper class to queue requests during token refresh
class _RequestQueueItem {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RequestQueueItem(this.options, this.handler);
}
