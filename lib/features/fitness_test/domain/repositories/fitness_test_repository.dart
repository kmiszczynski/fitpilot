import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/fitness_test_response_model.dart';

/// Fitness test repository interface
abstract class FitnessTestRepository {
  Future<Either<Failure, FitnessTestResponseModel>> submitTestResults({
    required String userId,
    required String pushupsType,
    required int maxSquats,
    required int maxPushUps,
    required int maxReverseSnowAngels45s,
    required int plankMaxTimeSeconds,
    required int mountainClimbers45s,
  });
}
