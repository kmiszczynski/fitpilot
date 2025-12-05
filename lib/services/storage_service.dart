import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for secure storage of authentication tokens
class StorageService {
  static const _storage = FlutterSecureStorage();

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyIdToken = 'id_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserEmail = 'user_email';

  /// Save authentication tokens
  static Future<void> saveTokens({
    String? accessToken,
    String? idToken,
    String? refreshToken,
    String? userEmail,
  }) async {
    if (accessToken != null) {
      await _storage.write(key: _keyAccessToken, value: accessToken);
    }
    if (idToken != null) {
      await _storage.write(key: _keyIdToken, value: idToken);
    }
    if (refreshToken != null) {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    }
    if (userEmail != null) {
      await _storage.write(key: _keyUserEmail, value: userEmail);
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Get ID token
  static Future<String?> getIdToken() async {
    return await _storage.read(key: _keyIdToken);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Check if user has valid tokens
  static Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final idToken = await getIdToken();
    return accessToken != null && idToken != null;
  }

  /// Get all tokens
  static Future<Map<String, String?>> getAllTokens() async {
    return {
      'accessToken': await getAccessToken(),
      'idToken': await getIdToken(),
      'refreshToken': await getRefreshToken(),
      'userEmail': await getUserEmail(),
    };
  }

  /// Clear all stored tokens (logout)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyIdToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserEmail);
  }

  /// Clear all storage
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}