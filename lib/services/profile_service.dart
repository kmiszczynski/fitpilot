import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import 'api_logger.dart';

/// Profile API Service
/// Handles all profile-related API calls to the backend
class ProfileService {
  static const String _baseUrl = 'https://xd0yevn0y2.execute-api.eu-central-1.amazonaws.com/prod';
  static const String _profileEndpoint = '/profile';

  /// Get the full profile URL
  static String get _profileUrl => '$_baseUrl$_profileEndpoint';

  /// Get authorization headers with the stored ID token
  static Future<Map<String, String>> _getHeaders() async {
    final idToken = await StorageService.getIdToken();

    if (idToken == null) {
      throw Exception('No ID token found. Please login first.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
  }

  /// GET - Fetch user profile
  /// Returns the user's profile data
  static Future<Map<String, dynamic>> getProfile() async {
    final startTime = DateTime.now();

    try {
      final headers = await _getHeaders();

      ApiLogger.logRequest(
        operation: 'GET /profile',
        url: _profileUrl,
        headers: headers,
      );

      final response = await http.get(
        Uri.parse(_profileUrl),
        headers: headers,
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final duration = DateTime.now().difference(startTime);

      if (response.statusCode == 200) {
        final result = {
          'success': true,
          'message': 'Profile fetched successfully',
          'data': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'GET /profile',
          response: result,
          duration: duration,
        );

        return result;
      } else {
        final result = {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch profile',
          'data': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'GET /profile',
          response: result,
          duration: duration,
        );

        return result;
      }
    } catch (e, stackTrace) {
      final result = {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'GET /profile',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return result;
    }
  }

  /// POST - Create user profile
  /// Creates a new profile with the provided data
  static Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData) async {
    final startTime = DateTime.now();

    try {
      final headers = await _getHeaders();

      ApiLogger.logRequest(
        operation: 'POST /profile',
        url: _profileUrl,
        headers: headers,
        parameters: profileData,
      );

      final response = await http.post(
        Uri.parse(_profileUrl),
        headers: headers,
        body: json.encode(profileData),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final duration = DateTime.now().difference(startTime);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = {
          'success': true,
          'message': 'Profile created successfully',
          'data': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'POST /profile',
          response: result,
          duration: duration,
        );

        return result;
      } else {
        final result = {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create profile',
          'error': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'POST /profile',
          response: result,
          duration: duration,
        );

        return result;
      }
    } catch (e, stackTrace) {
      final result = {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'POST /profile',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return result;
    }
  }

  /// PUT - Update user profile
  /// Updates the existing profile with the provided data
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    final startTime = DateTime.now();

    try {
      final headers = await _getHeaders();

      ApiLogger.logRequest(
        operation: 'PUT /profile',
        url: _profileUrl,
        headers: headers,
        parameters: profileData,
      );

      final response = await http.put(
        Uri.parse(_profileUrl),
        headers: headers,
        body: json.encode(profileData),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final duration = DateTime.now().difference(startTime);

      if (response.statusCode == 200) {
        final result = {
          'success': true,
          'message': 'Profile updated successfully',
          'data': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'PUT /profile',
          response: result,
          duration: duration,
        );

        return result;
      } else {
        final result = {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update profile',
          'error': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'PUT /profile',
          response: result,
          duration: duration,
        );

        return result;
      }
    } catch (e, stackTrace) {
      final result = {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'PUT /profile',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return result;
    }
  }

  /// DELETE - Delete user profile
  /// Deletes the user's profile
  static Future<Map<String, dynamic>> deleteProfile() async {
    final startTime = DateTime.now();

    try {
      final headers = await _getHeaders();

      ApiLogger.logRequest(
        operation: 'DELETE /profile',
        url: _profileUrl,
        headers: headers,
      );

      final response = await http.delete(
        Uri.parse(_profileUrl),
        headers: headers,
      );

      final duration = DateTime.now().difference(startTime);

      // DELETE might return empty body or JSON
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          responseData = json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          // If response body is not JSON, that's okay for DELETE
          responseData = {'message': response.body};
        }
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        final result = {
          'success': true,
          'message': 'Profile deleted successfully',
          'data': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'DELETE /profile',
          response: result,
          duration: duration,
        );

        return result;
      } else {
        final result = {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete profile',
          'error': responseData,
          'statusCode': response.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'DELETE /profile',
          response: result,
          duration: duration,
        );

        return result;
      }
    } catch (e, stackTrace) {
      final result = {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'DELETE /profile',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return result;
    }
  }
}