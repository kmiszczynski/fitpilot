import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../services/storage_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

/// Profile repository implementation
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final result = await _remoteDataSource.getProfile();
      final entity = result.toEntity();

      debugPrint('📋 Profile loaded and parsed successfully');
      debugPrint('   User ID: ${entity.userId ?? "❌ NOT PROVIDED"}');
      debugPrint('   Name: ${entity.name ?? "❌ NOT PROVIDED"}');
      debugPrint('   Email: ${entity.email ?? "❌ NOT PROVIDED"}');
      debugPrint('   Age: ${entity.age ?? "❌ NOT PROVIDED"}');
      debugPrint('   Sex: ${entity.sex ?? "❌ NOT PROVIDED"}');
      debugPrint('   Training Frequency: ${entity.trainingFrequency ?? "❌ NOT PROVIDED"}');
      debugPrint('   Target: ${entity.target ?? "❌ NOT PROVIDED"}');
      debugPrint('   Equipment: ${entity.equipment}');

      // Save user ID to storage if available
      if (entity.userId != null) {
        await StorageService.saveUserId(entity.userId!);
        debugPrint('✅ User ID saved to storage: ${entity.userId}');
      } else {
        debugPrint('⚠️⚠️⚠️ CRITICAL WARNING ⚠️⚠️⚠️');
        debugPrint('   API did not return "user_id" field!');
        debugPrint('   Your backend GET /profile must return:');
        debugPrint('   {');
        debugPrint('     "user_id": "user123",  ← REQUIRED!');
        debugPrint('     "name": "John Doe",');
        debugPrint('     "email": "john@example.com",');
        debugPrint('     ...');
        debugPrint('   }');
      }

      return Right(entity);
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

  @override
  Future<Either<Failure, UserProfile>> createProfile(
    UserProfile profile,
  ) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final result = await _remoteDataSource.createProfile(model);
      return Right(result.toEntity());
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

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    UserProfile profile,
  ) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final result = await _remoteDataSource.updateProfile(model);
      return Right(result.toEntity());
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

  @override
  Future<Either<Failure, void>> deleteProfile() async {
    try {
      await _remoteDataSource.deleteProfile();
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
