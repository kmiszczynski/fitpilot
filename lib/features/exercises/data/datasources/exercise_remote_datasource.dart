import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/exercise_model.dart';

/// Exercise remote data source
/// Handles API calls for exercise operations
abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercises();
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final DioClient _dioClient;

  ExerciseRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ExerciseModel>> getExercises() async {
    try {
      final response = await _dioClient.get('/exercises');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check if response is successful
        if (data['success'] == true && data.containsKey('data')) {
          final exercisesData = data['data'] as Map<String, dynamic>;

          if (exercisesData.containsKey('exercises')) {
            final exercisesList = exercisesData['exercises'] as List<dynamic>;

            return exercisesList
                .map((json) => ExerciseModel.fromJson(json as Map<String, dynamic>))
                .toList();
          }
        }

        throw ServerException(
          message: 'Invalid response format',
          statusCode: response.statusCode,
        );
      } else {
        throw ServerException(
          message: 'Failed to fetch exercises',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode ?? 0;
        String message = 'Failed to fetch exercises';

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
}