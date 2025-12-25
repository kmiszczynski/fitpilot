import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_profile_model.dart';

/// Profile remote data source
/// Handles API calls for profile operations
abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> createProfile(UserProfileModel profile);
  Future<UserProfileModel> updateProfile(UserProfileModel profile);
  Future<void> deleteProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final response = await _dioClient.get('/profile');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Debug: Print the raw response
        print('📥 GET /profile response:');
        print('   Raw data: $data');

        // Check if response contains an error field (API returns {error: "..."})
        if (data.containsKey('error')) {
          // Profile not found - throw 404 exception
          throw ServerException(
            message: data['error'].toString(),
            statusCode: 404,
          );
        }

        try {
          return UserProfileModel.fromJson(data);
        } catch (e) {
          print('❌ Error parsing profile JSON: $e');
          print('   This usually means the API response format doesn\'t match the model');
          rethrow;
        }
      } else if (response.statusCode == 404) {
        throw ServerException(
          message: 'Profile not found',
          statusCode: 404,
        );
      } else {
        throw ServerException(
          message: 'Failed to fetch profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors (network, timeout, bad response)
      if (e.response != null) {
        // Server responded with error status code
        final statusCode = e.response!.statusCode ?? 0;
        String message = 'Failed to fetch profile';

        // Extract error message from response if available
        if (e.response!.data is Map<String, dynamic>) {
          final data = e.response!.data as Map<String, dynamic>;
          if (data.containsKey('error')) {
            message = data['error'].toString();
          } else if (data.containsKey('message')) {
            message = data['message'].toString();
          }
        }

        throw ServerException(
          message: message,
          statusCode: statusCode,
        );
      } else {
        // Network error (no response from server)
        throw NetworkException(
          message: e.message ?? 'Network error occurred',
        );
      }
    } on ServerException {
      // Re-throw server exceptions
      rethrow;
    } on NetworkException {
      // Re-throw network exceptions
      rethrow;
    } catch (e) {
      // Unexpected error
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> createProfile(UserProfileModel profile) async {
    try {
      final jsonData = profile.toJson();
      print('DEBUG - Sending profile data to API:');
      print('  JSON: $jsonData');

      final response = await _dioClient.post(
        '/profile',
        data: jsonData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // API returns minimal response, just return the profile we sent
        // (since API doesn't return the profile data back)
        return profile;
      } else {
        throw ServerException(
          message: 'Failed to create profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        final statusCode = e.response!.statusCode ?? 0;
        String message = 'Failed to create profile';

        if (e.response!.data is Map<String, dynamic>) {
          final data = e.response!.data as Map<String, dynamic>;
          if (data.containsKey('error')) {
            message = data['error'].toString();
          } else if (data.containsKey('message')) {
            message = data['message'].toString();
          }
        }

        throw ServerException(
          message: message,
          statusCode: statusCode,
        );
      } else {
        throw NetworkException(
          message: e.message ?? 'Network error occurred',
        );
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    try {
      final response = await _dioClient.put(
        '/profile',
        data: profile.toJson(),
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteProfile() async {
    try {
      final response = await _dioClient.delete('/profile');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete profile',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
