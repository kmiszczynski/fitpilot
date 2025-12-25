import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for secure storage of authentication tokens
class StorageService {
  static const _storage = FlutterSecureStorage();

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyIdToken = 'id_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserId = 'user_id';

  /// Save authentication tokens
  static Future<void> saveTokens({
    String? accessToken,
    String? idToken,
    String? refreshToken,
    String? userEmail,
    String? userId,
  }) async {
    if (accessToken != null) {
      await _storage.write(key: _keyAccessToken, value: accessToken);
      print('🔑 Saved Access Token (length: ${accessToken.length})');
    }
    if (idToken != null) {
      await _storage.write(key: _keyIdToken, value: idToken);
      print('🔑 Saved ID Token (length: ${idToken.length})');
      // Check if it's a valid JWT format (should have 3 parts separated by dots)
      final parts = idToken.split('.');
      if (parts.length == 3) {
        print('   ✅ ID Token format is valid JWT (3 parts)');
      } else {
        print('   ⚠️ WARNING: ID Token does NOT look like a JWT! (${parts.length} parts)');
      }
    }
    if (refreshToken != null) {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
      print('🔑 Saved Refresh Token (length: ${refreshToken.length})');
    }
    if (userEmail != null) {
      await _storage.write(key: _keyUserEmail, value: userEmail);
    }
    if (userId != null) {
      await _storage.write(key: _keyUserId, value: userId);
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Get ID token
  static Future<String?> getIdToken() async {
    final token = await _storage.read(key: _keyIdToken);
    if (token != null) {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('⚠️ WARNING: Retrieved ID token is NOT a valid JWT format!');
        print('   Token length: ${token.length}');
        print('   Parts: ${parts.length} (expected 3)');
        print('   First 50 chars: ${token.substring(0, token.length > 50 ? 50 : token.length)}');
      }
    }
    return token;
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
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
      'userId': await getUserId(),
    };
  }

  /// Clear all stored tokens (logout)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyIdToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUserId);
  }

  /// Clear all storage
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}