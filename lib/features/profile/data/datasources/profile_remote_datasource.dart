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
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to fetch profile',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> createProfile(UserProfileModel profile) async {
    try {
      final response = await _dioClient.post(
        '/profile',
        data: profile.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to create profile',
          statusCode: response.statusCode,
        );
      }
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
