/// Base exception class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Server exception - API errors
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.statusCode,
  });
}

/// Network exception - connection issues
class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection',
  });
}

/// Cache exception - local storage issues
class CacheException extends AppException {
  CacheException({
    super.message = 'Cache error',
  });
}

/// Authentication exception
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.statusCode,
  });
}
