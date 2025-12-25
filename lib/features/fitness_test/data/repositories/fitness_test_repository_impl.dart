import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/fitness_test_repository.dart';
import '../datasources/fitness_test_remote_datasource.dart';
import '../models/fitness_test_result_model.dart';

/// Fitness test repository implementation
class FitnessTestRepositoryImpl implements FitnessTestRepository {
  final FitnessTestRemoteDataSource _remoteDataSource;

  FitnessTestRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> submitTestResults({
    required String userId,
    required int maxSquats,
    required int maxPushUps,
    required int maxReverseSnowAngels45s,
    required int plankMaxTimeSeconds,
    required int mountainClimbers45s,
  }) async {
    try {
      final model = FitnessTestResultModel(
        userId: userId,
        results: FitnessTestResults(
          maxPushUps: maxPushUps,
          maxSquats: maxSquats,
          maxReverseSnowAngels45s: maxReverseSnowAngels45s,
          plankMaxTimeSeconds: plankMaxTimeSeconds,
          mountainClimbers45s: mountainClimbers45s,
        ),
      );

      await _remoteDataSource.submitTestResults(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
