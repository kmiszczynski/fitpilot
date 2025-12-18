import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../services/storage_service.dart';
import '../models/auth_tokens_model.dart';

/// Authentication remote data source
/// Handles AWS Cognito authentication operations
abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> register({
    required String email,
    required String password,
  });

  Future<AuthTokensModel> login({
    required String email,
    required String password,
  });

  Future<AuthTokensModel> loginWithFacebook();
  Future<AuthTokensModel> loginWithGoogle();
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<AuthTokensModel> refreshToken();
  Future<String> resendConfirmationCode(String email);
  Future<String> confirmRegistration({
    required String email,
    required String confirmationCode,
  });
  Future<String> forgotPassword(String email);
  Future<String> confirmPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FlutterAppAuth _appAuth;
  final CognitoUserPool _userPool;
  CognitoUser? _currentUser;

  AuthRemoteDataSourceImpl()
      : _appAuth = const FlutterAppAuth(),
        _userPool = CognitoUserPool(
          AppConfig.cognitoUserPoolId,
          AppConfig.cognitoClientId,
        );

  @override
  Future<AuthTokensModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final userAttributes = [
        AttributeArg(name: 'email', value: email),
      ];

      final signUpResult = await _userPool.signUp(
        email,
        password,
        userAttributes: userAttributes,
      );

      if (signUpResult.userConfirmed ?? false) {
        // If auto-confirmed, login immediately
        return await login(email: email, password: password);
      } else {
        // Return empty tokens - user needs to confirm email
        throw AuthException(
          message: 'Registration successful! Please check your email to confirm your account.',
        );
      }
    } on CognitoClientException catch (e) {
      throw AuthException(
        message: _getReadableErrorMessage(e.message ?? 'Registration failed'),
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _currentUser = CognitoUser(email, _userPool);

      final authDetails = AuthenticationDetails(
        username: email,
        password: password,
      );

      final session = await _currentUser!.authenticateUser(authDetails);

      if (session == null) {
        throw AuthException(message: 'Authentication failed');
      }

      final accessToken = session.getAccessToken().getJwtToken();
      final idToken = session.getIdToken().getJwtToken();
      final refreshToken = session.getRefreshToken()?.getToken();

      final tokens = AuthTokensModel(
        accessToken: accessToken!,
        idToken: idToken!,
        refreshToken: refreshToken,
        email: email,
      );

      // Save tokens
      await StorageService.saveTokens(
        accessToken: accessToken,
        idToken: idToken,
        refreshToken: refreshToken,
        userEmail: email,
      );

      return tokens;
    } on CognitoClientException catch (e) {
      throw AuthException(
        message: _getReadableErrorMessage(e.message ?? 'Login failed'),
      );
    } on CognitoUserException catch (e) {
      throw AuthException(
        message: _getReadableErrorMessage(e.message ?? 'Login failed'),
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<AuthTokensModel> loginWithFacebook() async {
    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AppConfig.cognitoClientId,
          AppConfig.cognitoRedirectUri,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: '${AppConfig.cognitoDomain}/oauth2/authorize',
            tokenEndpoint: '${AppConfig.cognitoDomain}/oauth2/token',
          ),
          scopes: ['openid', 'profile'],
          additionalParameters: {
            'identity_provider': 'Facebook',
          },
        ),
      );

      if (result != null) {
        final email = _extractEmailFromIdToken(result.idToken);

        final tokens = AuthTokensModel(
          accessToken: result.accessToken!,
          idToken: result.idToken!,
          refreshToken: result.refreshToken,
          email: email,
        );

        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
          userEmail: email,
        );

        return tokens;
      } else {
        throw AuthException(message: 'Facebook login was cancelled');
      }
    } catch (e) {
      throw AuthException(message: 'Facebook login error: ${e.toString()}');
    }
  }

  @override
  Future<AuthTokensModel> loginWithGoogle() async {
    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AppConfig.cognitoClientId,
          AppConfig.cognitoRedirectUri,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: '${AppConfig.cognitoDomain}/oauth2/authorize',
            tokenEndpoint: '${AppConfig.cognitoDomain}/oauth2/token',
          ),
          scopes: ['openid', 'profile', 'email'],
          additionalParameters: {
            'identity_provider': 'Google',
          },
        ),
      );

      if (result != null) {
        final email = _extractEmailFromIdToken(result.idToken);

        final tokens = AuthTokensModel(
          accessToken: result.accessToken!,
          idToken: result.idToken!,
          refreshToken: result.refreshToken,
          email: email,
        );

        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
          userEmail: email,
        );

        return tokens;
      } else {
        throw AuthException(message: 'Google login was cancelled');
      }
    } catch (e) {
      throw AuthException(message: 'Google login error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    if (_currentUser != null) {
      await _currentUser!.signOut();
      _currentUser = null;
    }
    await StorageService.clearTokens();
  }

  @override
  Future<bool> isAuthenticated() async {
    return await StorageService.hasValidTokens();
  }

  @override
  Future<AuthTokensModel> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();

      if (refreshToken == null) {
        throw AuthException(message: 'No refresh token found');
      }

      final userEmail = await StorageService.getUserEmail();

      // Try Cognito SDK refresh first (only if we have the current user)
      if (_currentUser != null) {
        try {
          final session = await _currentUser!.refreshSession(
            CognitoRefreshToken(refreshToken),
          );

          if (session != null) {
            final newAccessToken = session.getAccessToken().getJwtToken();
            final newIdToken = session.getIdToken().getJwtToken();

            final tokens = AuthTokensModel(
              accessToken: newAccessToken!,
              idToken: newIdToken!,
              refreshToken: refreshToken,
              email: userEmail,
            );

            await StorageService.saveTokens(
              accessToken: newAccessToken,
              idToken: newIdToken,
              refreshToken: refreshToken,
              userEmail: userEmail,
            );

            return tokens;
          }
        } catch (e) {
          // Fall through to OAuth refresh
        }
      } else if (userEmail != null) {
        // If _currentUser is null but we have email, try to restore user session
        try {
          _currentUser = CognitoUser(userEmail, _userPool);
          final session = await _currentUser!.refreshSession(
            CognitoRefreshToken(refreshToken),
          );

          if (session != null) {
            final newAccessToken = session.getAccessToken().getJwtToken();
            final newIdToken = session.getIdToken().getJwtToken();

            final tokens = AuthTokensModel(
              accessToken: newAccessToken!,
              idToken: newIdToken!,
              refreshToken: refreshToken,
              email: userEmail,
            );

            await StorageService.saveTokens(
              accessToken: newAccessToken,
              idToken: newIdToken,
              refreshToken: refreshToken,
              userEmail: userEmail,
            );

            return tokens;
          }
        } catch (e) {
          // Fall through to OAuth refresh
        }
      }

      // OAuth refresh (fallback)
      final dio = Dio();
      final tokenEndpoint = '${AppConfig.cognitoDomain}/oauth2/token';
      final tokenResponse = await dio.post(
        tokenEndpoint,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'grant_type': 'refresh_token',
          'client_id': AppConfig.cognitoClientId,
          'refresh_token': refreshToken,
        },
      );

      if (tokenResponse.statusCode == 200) {
        final tokenData = tokenResponse.data;
        final newAccessToken = tokenData['access_token'] as String;
        final newIdToken = tokenData['id_token'] as String;

        final email = _extractEmailFromIdToken(newIdToken) ?? userEmail;

        final tokens = AuthTokensModel(
          accessToken: newAccessToken,
          idToken: newIdToken,
          refreshToken: refreshToken,
          email: email,
        );

        await StorageService.saveTokens(
          accessToken: newAccessToken,
          idToken: newIdToken,
          refreshToken: refreshToken,
          userEmail: email,
        );

        return tokens;
      } else {
        throw AuthException(message: 'Token refresh failed');
      }
    } catch (e) {
      throw AuthException(message: 'Token refresh error: ${e.toString()}');
    }
  }

  @override
  Future<String> resendConfirmationCode(String email) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.resendConfirmationCode();
      return 'Confirmation code sent to your email';
    } catch (e) {
      throw AuthException(
        message: 'Failed to resend confirmation code: ${e.toString()}',
      );
    }
  }

  @override
  Future<String> confirmRegistration({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmRegistration(confirmationCode);
      return 'Account confirmed successfully! You can now sign in.';
    } catch (e) {
      throw AuthException(message: 'Confirmation failed: ${e.toString()}');
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.forgotPassword();
      return 'Password reset code sent to your email';
    } catch (e) {
      throw AuthException(
        message: 'Failed to initiate password reset: ${e.toString()}',
      );
    }
  }

  @override
  Future<String> confirmPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmPassword(confirmationCode, newPassword);
      return 'Password reset successful! You can now sign in with your new password.';
    } catch (e) {
      throw AuthException(message: 'Password reset failed: ${e.toString()}');
    }
  }

  /// Helper method to extract email from ID token JWT
  String? _extractEmailFromIdToken(String? idToken) {
    if (idToken == null) return null;

    try {
      final parts = idToken.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      return payloadMap['email'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Helper method to convert Cognito error messages to user-friendly messages
  String _getReadableErrorMessage(String error) {
    if (error.contains('User does not exist')) {
      return 'No account found with this email';
    } else if (error.contains('Incorrect username or password')) {
      return 'Invalid email or password';
    } else if (error.contains('User is not confirmed')) {
      return 'Please confirm your email before signing in';
    } else if (error.contains('Invalid verification code')) {
      return 'Invalid confirmation code';
    } else if (error.contains('Password did not conform')) {
      return 'Password must be at least 8 characters and contain uppercase, lowercase, numbers, and special characters';
    } else if (error.contains('UsernameExistsException')) {
      return 'An account with this email already exists';
    } else if (error.contains('LimitExceededException')) {
      return 'Too many attempts. Please try again later';
    } else if (error.contains('InvalidParameterException')) {
      return 'Invalid input. Please check your entries';
    } else if (error.contains('NetworkError') || error.contains('Network')) {
      return 'Network error. Please check your internet connection';
    }
    return error;
  }
}