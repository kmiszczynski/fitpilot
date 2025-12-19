import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_datasource.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Exercise>>> getExercises() async {
    try {
      debugPrint('📦 [Repository] Fetching exercises...');
      final exerciseModels = await remoteDataSource.getExercises();
      debugPrint('📦 [Repository] Received ${exerciseModels.length} exercise models');

      debugPrint('📦 [Repository] Converting models to entities...');
      final exercises = exerciseModels.map((model) => model.toEntity()).toList();
      debugPrint('✅ [Repository] Successfully converted ${exercises.length} exercises');

      return Right(exercises);
    } on ServerException catch (e, stackTrace) {
      debugPrint('');
      debugPrint('🔴 [Repository] ServerException caught');
      debugPrint('Message: ${e.message}');
      debugPrint('Status Code: ${e.statusCode}');
      debugPrint('Stack trace:\n$stackTrace');
      debugPrint('');

      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e, stackTrace) {
      debugPrint('');
      debugPrint('🔴 [Repository] NetworkException caught');
      debugPrint('Message: ${e.message}');
      debugPrint('Stack trace:\n$stackTrace');
      debugPrint('');

      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      debugPrint('');
      debugPrint('🔴 [Repository] Unexpected error caught');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error: $e');
      debugPrint('Stack trace:\n$stackTrace');
      debugPrint('');

      return Left(ServerFailure(message: e.toString()));
    }
  }
}