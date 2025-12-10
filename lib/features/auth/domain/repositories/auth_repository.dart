import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';

/// Authentication repository interface
/// Defines the contract for all authentication operations
abstract class AuthRepository {
  /// Register a new user with email and password
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
  });

  /// Login with email and password
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  /// Login with Facebook OAuth
  Future<Either<Failure, AuthTokens>> loginWithFacebook();

  /// Login with Google OAuth
  Future<Either<Failure, AuthTokens>> loginWithGoogle();

  /// Logout and clear stored tokens
  Future<Either<Failure, void>> logout();

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated();

  /// Refresh access token using refresh token
  Future<Either<Failure, AuthTokens>> refreshToken();

  /// Resend email confirmation code
  Future<Either<Failure, String>> resendConfirmationCode(String email);

  /// Confirm user registration with code
  Future<Either<Failure, String>> confirmRegistration({
    required String email,
    required String confirmationCode,
  });

  /// Initiate forgot password flow
  Future<Either<Failure, String>> forgotPassword(String email);

  /// Confirm new password with reset code
  Future<Either<Failure, String>> confirmPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  });
}