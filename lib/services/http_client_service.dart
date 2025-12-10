import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import 'auth_service.dart';
import 'api_logger.dart';

/// HTTP client wrapper with automatic token refresh on 401 errors
class HttpClientService {
  static final _authService = AuthService();
  static bool _isRefreshing = false;

  /// Make a GET request with automatic token refresh on 401
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    return _makeRequest(
      () => http.get(url, headers: headers),
      'GET',
      url.toString(),
      headers,
    );
  }

  /// Make a POST request with automatic token refresh on 401
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _makeRequest(
      () => http.post(url, headers: headers, body: body),
      'POST',
      url.toString(),
      headers,
      body,
    );
  }

  /// Make a PUT request with automatic token refresh on 401
  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _makeRequest(
      () => http.put(url, headers: headers, body: body),
      'PUT',
      url.toString(),
      headers,
      body,
    );
  }

  /// Make a DELETE request with automatic token refresh on 401
  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    return _makeRequest(
      () => http.delete(url, headers: headers),
      'DELETE',
      url.toString(),
      headers,
    );
  }

  /// Internal method to make request with retry logic
  static Future<http.Response> _makeRequest(
    Future<http.Response> Function() requestFn,
    String method,
    String url,
    Map<String, String>? headers, [
    Object? body,
  ]) async {
    // Make initial request
    http.Response response = await requestFn();

    // If 401 Unauthorized, try to refresh token and retry
    if (response.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        ApiLogger.logRequest(
          operation: 'Token Refresh (401 detected)',
          url: url,
          headers: headers ?? {},
        );

        // Attempt to refresh the token
        final refreshResult = await _authService.refreshAccessToken();

        if (refreshResult['success'] == true) {
          // Get the new token
          final newIdToken = await StorageService.getIdToken();

          if (newIdToken != null && headers != null) {
            // Update authorization header with new token
            final newHeaders = Map<String, String>.from(headers);
            newHeaders['Authorization'] = 'Bearer $newIdToken';

            ApiLogger.logRequest(
              operation: 'Retry $method (with refreshed token)',
              url: url,
              headers: newHeaders,
            );

            // Retry the original request with new token
            if (method == 'GET') {
              response = await http.get(Uri.parse(url), headers: newHeaders);
            } else if (method == 'POST') {
              response = await http.post(
                Uri.parse(url),
                headers: newHeaders,
                body: body,
              );
            } else if (method == 'PUT') {
              response = await http.put(
                Uri.parse(url),
                headers: newHeaders,
                body: body,
              );
            } else if (method == 'DELETE') {
              response = await http.delete(Uri.parse(url), headers: newHeaders);
            }

            ApiLogger.logResponse(
              operation: 'Retry $method',
              response: {
                'statusCode': response.statusCode,
                'success': response.statusCode >= 200 && response.statusCode < 300,
              },
              duration: const Duration(milliseconds: 0),
            );
          }
        } else {
          // Token refresh failed - user needs to log in again
          ApiLogger.logError(
            operation: 'Token Refresh Failed',
            error: Exception('Token refresh failed: ${refreshResult['message']}'),
            stackTrace: StackTrace.current,
            duration: const Duration(milliseconds: 0),
          );

          // Clear tokens to force fresh login
          await StorageService.clearTokens();
        }
      } catch (e, stackTrace) {
        ApiLogger.logError(
          operation: 'Token Refresh Error',
          error: e,
          stackTrace: stackTrace,
          duration: const Duration(milliseconds: 0),
        );
      } finally {
        _isRefreshing = false;
      }
    }

    return response;
  }

  /// Get headers with current ID token
  static Future<Map<String, String>> getAuthHeaders() async {
    final idToken = await StorageService.getIdToken();

    if (idToken == null) {
      throw Exception('No ID token found. Please login first.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
  }
}
