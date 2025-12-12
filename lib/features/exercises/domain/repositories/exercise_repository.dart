import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, List<Exercise>>> getExercises();
}