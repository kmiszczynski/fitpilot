import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'storage_service.dart';

class AuthService {
  // Cognito Configuration
  static const String _userPoolId = 'eu-central-1_EfYTI7jjG';
  static const String _clientId = '2shdbguj378ps6489iso16csfp';
  static const String _region = 'eu-central-1';
  static const String _cognitoDomain = 'https://eu-central-1efyti7jjg.auth.eu-central-1.amazoncognito.com';
  static const String _redirectUri = 'fitpilot://oauth/callback';

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
        return {
          'success': true,
          'message': 'Registration successful! You can now sign in.',
          'userConfirmed': true,
        };
      } else {
        return {
          'success': true,
          'message': 'Registration successful! Please check your email to confirm your account.',
          'userConfirmed': false,
          'userSub': signUpResult.userSub,
        };
      }
    } on CognitoClientException catch (e) {
      return {
        'success': false,
        'message': _getReadableErrorMessage(e.message ?? 'Registration failed'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
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
        return {
          'success': false,
          'message': 'Authentication failed',
        };
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

      return {
        'success': true,
        'message': 'Login successful!',
        'accessToken': accessToken,
        'idToken': idToken,
        'refreshToken': refreshToken,
      };
    } on CognitoClientException catch (e) {
      return {
        'success': false,
        'message': _getReadableErrorMessage(e.message ?? 'Login failed'),
      };
    } on CognitoUserException catch (e) {
      return {
        'success': false,
        'message': _getReadableErrorMessage(e.message ?? 'Login failed'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  /// Login with Facebook using Cognito Hosted UI
  /// This uses OAuth flow and returns Cognito tokens
  Future<Map<String, dynamic>> loginWithFacebook() async {
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
        // Save tokens securely
        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
        );

        return {
          'success': true,
          'message': 'Facebook login successful!',
          'accessToken': result.accessToken,
          'idToken': result.idToken,
          'refreshToken': result.refreshToken,
        };
      } else {
        return {
          'success': false,
          'message': 'Facebook login was cancelled',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Facebook login error: ${e.toString()}',
      };
    }
  }

  /// Login with Google using Cognito Hosted UI
  /// This uses OAuth flow and returns Cognito tokens
  Future<Map<String, dynamic>> loginWithGoogle() async {
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
        // Save tokens securely
        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
        );

        return {
          'success': true,
          'message': 'Google login successful!',
          'accessToken': result.accessToken,
          'idToken': result.idToken,
          'refreshToken': result.refreshToken,
        };
      } else {
        return {
          'success': false,
          'message': 'Google login was cancelled',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Google login error: ${e.toString()}',
      };
    }
  }

  /// Login with Cognito Hosted UI (all identity providers)
  /// This allows users to choose from any configured identity provider
  Future<Map<String, dynamic>> loginWithHostedUI() async {
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
        // Save tokens securely
        await StorageService.saveTokens(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
        );

        return {
          'success': true,
          'message': 'Login successful!',
          'accessToken': result.accessToken,
          'idToken': result.idToken,
          'refreshToken': result.refreshToken,
        };
      } else {
        return {
          'success': false,
          'message': 'Login was cancelled',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Login error: ${e.toString()}',
      };
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

  /// Resend confirmation code
  Future<Map<String, dynamic>> resendConfirmationCode(String email) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.resendConfirmationCode();
      return {
        'success': true,
        'message': 'Confirmation code sent to your email',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to resend confirmation code: ${e.toString()}',
      };
    }
  }

  /// Confirm user registration with code
  Future<Map<String, dynamic>> confirmRegistration({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmRegistration(confirmationCode);
      return {
        'success': true,
        'message': 'Account confirmed successfully! You can now sign in.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Confirmation failed: ${e.toString()}',
      };
    }
  }

  /// Forgot password - initiate password reset
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.forgotPassword();
      return {
        'success': true,
        'message': 'Password reset code sent to your email',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to initiate password reset: ${e.toString()}',
      };
    }
  }

  /// Confirm new password with reset code
  Future<Map<String, dynamic>> confirmPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      await cognitoUser.confirmPassword(confirmationCode, newPassword);
      return {
        'success': true,
        'message': 'Password reset successful! You can now sign in with your new password.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Password reset failed: ${e.toString()}',
      };
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