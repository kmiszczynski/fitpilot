import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// Fitness test repository interface
abstract class FitnessTestRepository {
  Future<Either<Failure, void>> submitTestResults({
    required String userId,
    required String pushupsType,
    required int maxSquats,
    required int maxPushUps,
    required int maxReverseSnowAngels45s,
    required int plankMaxTimeSeconds,
    required int mountainClimbers45s,
  });
}
