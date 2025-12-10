/// Application configuration
/// Centralized configuration for API endpoints, Cognito settings, etc.
class AppConfig {
  // API Configuration
  static const String apiBaseUrl =
      'https://xd0yevn0y2.execute-api.eu-central-1.amazonaws.com/prod';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // AWS Cognito Configuration
  static const String cognitoUserPoolId = 'eu-central-1_EfYTI7jjG';
  static const String cognitoClientId = '2shdbguj378ps6489iso16csfp';
  static const String cognitoRegion = 'eu-central-1';
  static const String cognitoDomain =
      'https://eu-central-1efyti7jjg.auth.eu-central-1.amazoncognito.com';
  static const String cognitoRedirectUri = 'fitpilot://oauth/callback';

  // Prevent instantiation
  AppConfig._();
}
