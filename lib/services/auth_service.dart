import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import 'api_logger.dart';

class AuthService {
  // Cognito Configuration
  static const String _userPoolId = 'eu-central-1_EfYTI7jjG';
  static const String _clientId = '2shdbguj378ps6489iso16csfp';
  static const String _region = 'eu-central-1';
  static const String _cognitoDomain = 'https://eu-central-1efyti7jjg.auth.eu-central-1.amazoncognito.com';
  static const String _redirectUri = 'fitpilot://oauth/callback';

  // Cognito API Base URL
  static const String _cognitoApiUrl = 'https://cognito-idp.$_region.amazonaws.com/';

  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  final CognitoUserPool _userPool = CognitoUserPool(
    _userPoolId,
    _clientId,
  );

  CognitoUser? _currentUser;

  /// Register a new user with email and password
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'register',
      url: _cognitoApiUrl,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.SignUp',
      },
      parameters: {
        'email': email,
        'password': password,
      },
    );

    try {
      final userAttributes = [
        AttributeArg(name: 'email', value: email),
      ];

      final signUpResult = await _userPool.signUp(
        email,
        password,
        userAttributes: userAttributes,
      );

      final response = signUpResult.userConfirmed ?? false
          ? {
              'success': true,
              'message': 'Registration successful! You can now sign in.',
              'userConfirmed': true,
            }
          : {
              'success': true,
              'message': 'Registration successful! Please check your email to confirm your account.',
              'userConfirmed': false,
              'userSub': signUpResult.userSub,
            };

      ApiLogger.logResponse(
        operation: 'register',
        response: response,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } on CognitoClientException catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': _getReadableErrorMessage(e.message ?? 'Registration failed'),
      };

      ApiLogger.logError(
        operation: 'register',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'register',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'login',
      url: _cognitoApiUrl,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.InitiateAuth',
      },
      parameters: {
        'email': email,
        'password': password,
      },
    );

    try {
      _currentUser = CognitoUser(
        email,
        _userPool,
      );

      final authDetails = AuthenticationDetails(
        username: email,
        password: password,
      );

      final session = await _currentUser!.authenticateUser(authDetails);

      if (session == null) {
        final response = {
          'success': false,
          'message': 'Authentication failed',
        };

        ApiLogger.logResponse(
          operation: 'login',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      }

      final accessToken = session.getAccessToken().getJwtToken();
      final idToken = session.getIdToken().getJwtToken();
      final refreshToken = session.getRefreshToken()?.getToken();

      // Save tokens securely
      await StorageService.saveTokens(
        accessToken: accessToken,
        idToken: idToken,
        refreshToken: refreshToken,
        userEmail: email,
      );

      final response = {
        'success': true,
        'message': 'Login successful!',
        'accessToken': accessToken,
        'idToken': idToken,
        'refreshToken': refreshToken,
      };

      ApiLogger.logResponse(
        operation: 'login',
        response: response,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } on CognitoClientException catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': _getReadableErrorMessage(e.message ?? 'Login failed'),
      };

      ApiLogger.logError(
        operation: 'login',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } on CognitoUserException catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': _getReadableErrorMessage(e.message ?? 'Login failed'),
      };

      ApiLogger.logError(
        operation: 'login',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'login',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Login with Facebook using Cognito Hosted UI
  /// This uses OAuth flow and returns Cognito tokens
  Future<Map<String, dynamic>> loginWithFacebook() async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'loginWithFacebook',
      url: '$_cognitoDomain/oauth2/authorize',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      parameters: {
        'provider': 'Facebook',
        'scopes': ['openid', 'profile'],
        'client_id': _clientId,
        'redirect_uri': _redirectUri,
        'response_type': 'code',
        'identity_provider': 'Facebook',
      },
    );

    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: '$_cognitoDomain/oauth2/authorize',
            tokenEndpoint: '$_cognitoDomain/oauth2/token',
          ),
          scopes: ['openid', 'profile'],
          additionalParameters: {
            'identity_provider': 'Facebook',
          },
        ),
      );

      if (result != null) {
        // Extract email from ID token
        final email = _extractEmailFromIdToken(result.idToken);

        // Save tokens securely
        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
          userEmail: email,
        );

        final response = {
          'success': true,
          'message': 'Facebook login successful!',
          'accessToken': result.accessToken,
          'idToken': result.idToken,
          'refreshToken': result.refreshToken,
        };

        ApiLogger.logResponse(
          operation: 'loginWithFacebook',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      } else {
        final response = {
          'success': false,
          'message': 'Facebook login was cancelled',
        };

        ApiLogger.logResponse(
          operation: 'loginWithFacebook',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      }
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Facebook login error: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'loginWithFacebook',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Login with Google using Cognito Hosted UI
  /// This uses OAuth flow and returns Cognito tokens
  Future<Map<String, dynamic>> loginWithGoogle() async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'loginWithGoogle',
      url: '$_cognitoDomain/oauth2/authorize',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      parameters: {
        'provider': 'Google',
        'scopes': ['openid', 'profile', 'email'],
        'client_id': _clientId,
        'redirect_uri': _redirectUri,
        'response_type': 'code',
        'identity_provider': 'Google',
      },
    );

    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: '$_cognitoDomain/oauth2/authorize',
            tokenEndpoint: '$_cognitoDomain/oauth2/token',
          ),
          scopes: ['openid', 'profile', 'email'],
          additionalParameters: {
            'identity_provider': 'Google',
          },
        ),
      );

      if (result != null) {
        // Extract email from ID token
        final email = _extractEmailFromIdToken(result.idToken);

        // Save tokens securely
        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
          userEmail: email,
        );

        final response = {
          'success': true,
          'message': 'Google login successful!',
          'accessToken': result.accessToken,
          'idToken': result.idToken,
          'refreshToken': result.refreshToken,
        };

        ApiLogger.logResponse(
          operation: 'loginWithGoogle',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      } else {
        final response = {
          'success': false,
          'message': 'Google login was cancelled',
        };

        ApiLogger.logResponse(
          operation: 'loginWithGoogle',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      }
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Google login error: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'loginWithGoogle',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Login with Cognito Hosted UI (all identity providers)
  /// This allows users to choose from any configured identity provider
  Future<Map<String, dynamic>> loginWithHostedUI() async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'loginWithHostedUI',
      url: '$_cognitoDomain/oauth2/authorize',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      parameters: {
        'scopes': ['email', 'openid', 'profile'],
        'client_id': _clientId,
        'redirect_uri': _redirectUri,
        'response_type': 'code',
      },
    );

    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: '$_cognitoDomain/oauth2/authorize',
            tokenEndpoint: '$_cognitoDomain/oauth2/token',
          ),
          scopes: ['email', 'openid', 'profile'],
        ),
      );

      if (result != null) {
        // Extract email from ID token
        final email = _extractEmailFromIdToken(result.idToken);

        // Save tokens securely
        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
          userEmail: email,
        );

        final response = {
          'success': true,
          'message': 'Login successful!',
          'accessToken': result.accessToken,
          'idToken': result.idToken,
          'refreshToken': result.refreshToken,
        };

        ApiLogger.logResponse(
          operation: 'loginWithHostedUI',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      } else {
        final response = {
          'success': false,
          'message': 'Login was cancelled',
        };

        ApiLogger.logResponse(
          operation: 'loginWithHostedUI',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      }
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Login error: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'loginWithHostedUI',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Logout the current user and clear stored tokens
  Future<void> logout() async {
    if (_currentUser != null) {
      await _currentUser!.signOut();
      _currentUser = null;
    }
    // Clear stored tokens
    await StorageService.clearTokens();
  }

  /// Check if user has stored authentication
  Future<bool> hasStoredAuth() async {
    return await StorageService.hasValidTokens();
  }

  /// Get the current authenticated user session
  Future<CognitoUserSession?> getCurrentSession() async {
    if (_currentUser == null) {
      return null;
    }
    try {
      return await _currentUser!.getSession();
    } catch (e) {
      return null;
    }
  }

  /// Check if user is currently logged in
  Future<bool> isLoggedIn() async {
    final session = await getCurrentSession();
    return session != null && session.isValid();
  }

  /// Refresh access token using refresh token
  /// Works for both email/password and OAuth users
  Future<Map<String, dynamic>> refreshAccessToken() async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'refreshAccessToken',
      url: _cognitoApiUrl,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.InitiateAuth',
      },
      parameters: {'AuthFlow': 'REFRESH_TOKEN_AUTH'},
    );

    try {
      final refreshToken = await StorageService.getRefreshToken();

      if (refreshToken == null) {
        final response = {
          'success': false,
          'message': 'No refresh token found',
        };

        ApiLogger.logResponse(
          operation: 'refreshAccessToken',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      }

      // Try email/password flow first (if _currentUser exists)
      if (_currentUser != null) {
        try {
          final session = await _currentUser!.refreshSession(
            CognitoRefreshToken(refreshToken),
          );

          if (session != null) {
            final newAccessToken = session.getAccessToken().getJwtToken();
            final newIdToken = session.getIdToken().getJwtToken();

            // Save new tokens
            await StorageService.saveTokens(
              accessToken: newAccessToken,
              idToken: newIdToken,
              refreshToken: refreshToken,
            );

            final response = {
              'success': true,
              'message': 'Token refreshed successfully',
              'accessToken': newAccessToken,
              'idToken': newIdToken,
            };

            ApiLogger.logResponse(
              operation: 'refreshAccessToken',
              response: response,
              duration: DateTime.now().difference(startTime),
            );

            return response;
          }
        } catch (e) {
          // Fall through to OAuth flow if email/password refresh fails
        }
      }

      // OAuth flow - use Cognito token endpoint directly
      final tokenEndpoint = '$_cognitoDomain/oauth2/token';
      final tokenResponse = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'client_id': _clientId,
          'refresh_token': refreshToken,
        },
      );

      if (tokenResponse.statusCode == 200) {
        final tokenData = json.decode(tokenResponse.body);
        final newAccessToken = tokenData['access_token'] as String;
        final newIdToken = tokenData['id_token'] as String;

        // Extract email from new ID token
        final email = _extractEmailFromIdToken(newIdToken);

        // Save new tokens
        await StorageService.saveTokens(
          accessToken: newAccessToken,
          idToken: newIdToken,
          refreshToken: refreshToken,
          userEmail: email,
        );

        final response = {
          'success': true,
          'message': 'Token refreshed successfully',
          'accessToken': newAccessToken,
          'idToken': newIdToken,
        };

        ApiLogger.logResponse(
          operation: 'refreshAccessToken',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      } else {
        final response = {
          'success': false,
          'message': 'Token refresh failed',
          'statusCode': tokenResponse.statusCode,
        };

        ApiLogger.logResponse(
          operation: 'refreshAccessToken',
          response: response,
          duration: DateTime.now().difference(startTime),
        );

        return response;
      }
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Token refresh error: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'refreshAccessToken',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Resend confirmation code
  Future<Map<String, dynamic>> resendConfirmationCode(String email) async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'resendConfirmationCode',
      url: _cognitoApiUrl,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.ResendConfirmationCode',
      },
      parameters: {'email': email},
    );

    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.resendConfirmationCode();

      final response = {
        'success': true,
        'message': 'Confirmation code sent to your email',
      };

      ApiLogger.logResponse(
        operation: 'resendConfirmationCode',
        response: response,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Failed to resend confirmation code: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'resendConfirmationCode',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Confirm user registration with code
  Future<Map<String, dynamic>> confirmRegistration({
    required String email,
    required String confirmationCode,
  }) async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'confirmRegistration',
      url: _cognitoApiUrl,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.ConfirmSignUp',
      },
      parameters: {
        'email': email,
        'confirmationCode': confirmationCode,
      },
    );

    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmRegistration(confirmationCode);

      final response = {
        'success': true,
        'message': 'Account confirmed successfully! You can now sign in.',
      };

      ApiLogger.logResponse(
        operation: 'confirmRegistration',
        response: response,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Confirmation failed: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'confirmRegistration',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Forgot password - initiate password reset
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'forgotPassword',
      url: _cognitoApiUrl,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.ForgotPassword',
      },
      parameters: {'email': email},
    );

    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.forgotPassword();

      final response = {
        'success': true,
        'message': 'Password reset code sent to your email',
      };

      ApiLogger.logResponse(
        operation: 'forgotPassword',
        response: response,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Failed to initiate password reset: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'forgotPassword',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Confirm new password with reset code
  Future<Map<String, dynamic>> confirmPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    final startTime = DateTime.now();

    ApiLogger.logRequest(
      operation: 'confirmPassword',
      url: _cognitoApiUrl,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.ConfirmForgotPassword',
      },
      parameters: {
        'email': email,
        'confirmationCode': confirmationCode,
        'newPassword': newPassword,
      },
    );

    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmPassword(confirmationCode, newPassword);

      final response = {
        'success': true,
        'message': 'Password reset successful! You can now sign in with your new password.',
      };

      ApiLogger.logResponse(
        operation: 'confirmPassword',
        response: response,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    } catch (e, stackTrace) {
      final response = {
        'success': false,
        'message': 'Password reset failed: ${e.toString()}',
      };

      ApiLogger.logError(
        operation: 'confirmPassword',
        error: e,
        stackTrace: stackTrace,
        duration: DateTime.now().difference(startTime),
      );

      return response;
    }
  }

  /// Helper method to extract email from ID token JWT
  String? _extractEmailFromIdToken(String? idToken) {
    if (idToken == null) return null;

    try {
      // JWT format: header.payload.signature
      final parts = idToken.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (second part)
      final payload = parts[1];
      // Add padding if needed for base64 decoding
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      // Extract email from payload
      return payloadMap['email'] as String?;
    } catch (e) {
      // If extraction fails, return null
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