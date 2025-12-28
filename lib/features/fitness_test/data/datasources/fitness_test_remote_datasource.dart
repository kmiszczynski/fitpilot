import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/fitness_test_result_model.dart';
import '../models/fitness_test_response_model.dart';

/// Fitness test remote data source
/// Handles API calls for fitness test operations
abstract class FitnessTestRemoteDataSource {
  Future<FitnessTestResponseModel> submitTestResults(
      FitnessTestResultModel results);
}

class FitnessTestRemoteDataSourceImpl implements FitnessTestRemoteDataSource {
  final DioClient _dioClient;

  FitnessTestRemoteDataSourceImpl(this._dioClient);

  @override
  Future<FitnessTestResponseModel> submitTestResults(
      FitnessTestResultModel results) async {
    try {
      final jsonData = results.toJson();
      debugPrint('📤 Submitting fitness test results to API:');
      debugPrint('   JSON: $jsonData');

      final response = await _dioClient.post(
        '/profile/tests/results',
        data: jsonData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Fitness test results submitted successfully');
        debugPrint('   Response: ${response.data}');

        return FitnessTestResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to submit fitness test results',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        final statusCode = e.response!.statusCode ?? 0;
        String message = 'Failed to submit fitness test results';

        if (e.response!.data is Map<String, dynamic>) {
          final data = e.response!.data as Map<String, dynamic>;
          if (data.containsKey('error')) {
            message = data['error'].toString();
          } else if (data.containsKey('message')) {
            message = data['message'].toString();
          }
        }

        debugPrint('❌ Server error: $message (Status: $statusCode)');

        throw ServerException(
          message: message,
          statusCode: statusCode,
        );
      } else {
        debugPrint('❌ Network error: ${e.message}');
        throw NetworkException(
          message: e.message ?? 'Network error occurred',
        );
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      throw ServerException(message: e.toString());
    }
  }
}
