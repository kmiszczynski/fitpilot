import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
      );
      return Right(result.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(result.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithFacebook() async {
    try {
      final result = await _remoteDataSource.loginWithFacebook();
      return Right(result.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithGoogle() async {
    try {
      final result = await _remoteDataSource.loginWithGoogle();
      return Right(result.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _remoteDataSource.isAuthenticated();
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    try {
      final result = await _remoteDataSource.refreshToken();
      return Right(result.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendConfirmationCode(String email) async {
    try {
      final message = await _remoteDataSource.resendConfirmationCode(email);
      return Right(message);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> confirmRegistration({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      final message = await _remoteDataSource.confirmRegistration(
        email: email,
        confirmationCode: confirmationCode,
      );
      return Right(message);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final message = await _remoteDataSource.forgotPassword(email);
      return Right(message);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> confirmPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    try {
      final message = await _remoteDataSource.confirmPassword(
        email: email,
        confirmationCode: confirmationCode,
        newPassword: newPassword,
      );
      return Right(message);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}