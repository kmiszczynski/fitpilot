import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint('🌐 [DataSource] Calling GET /exercises...');
      final response = await _dioClient.get('/exercises');

      if (response.statusCode == 200) {
        debugPrint('✅ [DataSource] Response received with status 200');
        final data = response.data as Map<String, dynamic>;

        // Check if response is successful
        if (data['success'] == true && data.containsKey('data')) {
          debugPrint('✅ [DataSource] Response has success=true and data field');
          final exercisesData = data['data'] as Map<String, dynamic>;

          if (exercisesData.containsKey('exercises')) {
            final exercisesList = exercisesData['exercises'] as List<dynamic>;
            debugPrint('✅ [DataSource] Found ${exercisesList.length} exercises in response');

            final List<ExerciseModel> models = [];
            for (int i = 0; i < exercisesList.length; i++) {
              try {
                debugPrint('🔄 [DataSource] Parsing exercise $i...');
                final json = exercisesList[i] as Map<String, dynamic>;
                debugPrint('   Exercise data: $json');
                final model = ExerciseModel.fromJson(json);
                models.add(model);
                debugPrint('✅ [DataSource] Successfully parsed exercise $i: ${model.name}');
              } catch (e, stackTrace) {
                debugPrint('');
                debugPrint('🔴 [DataSource] Failed to parse exercise $i');
                debugPrint('Exercise JSON: ${exercisesList[i]}');
                debugPrint('Error: $e');
                debugPrint('Stack trace:\n$stackTrace');
                debugPrint('');
                rethrow;
              }
            }

            debugPrint('✅ [DataSource] Successfully parsed all ${models.length} exercises');
            return models;
          }
        }

        debugPrint('');
        debugPrint('🔴 [DataSource] Invalid response format');
        debugPrint('Response data: $data');
        debugPrint('');

        throw ServerException(
          message: 'Invalid response format',
          statusCode: response.statusCode,
        );
      } else {
        debugPrint('🔴 [DataSource] Non-200 status code: ${response.statusCode}');
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