import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

/// Profile repository interface
/// Defines the contract for profile data operations
abstract class ProfileRepository {
  /// Get user profile
  Future<Either<Failure, UserProfile>> getProfile();

  /// Create user profile
  Future<Either<Failure, UserProfile>> createProfile(UserProfile profile);

  /// Update user profile
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile);

  /// Delete user profile
  Future<Either<Failure, void>> deleteProfile();
}
