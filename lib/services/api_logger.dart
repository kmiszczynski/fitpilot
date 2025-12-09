/// API Logger Service
/// Provides comprehensive logging for all API requests and responses
class ApiLogger {
  static const String _tag = '[API]';
  static bool _isEnabled = true;

  /// Enable or disable API logging
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Log an API request
  static void logRequest({
    required String operation,
    Map<String, dynamic>? parameters,
    String? url,
    Map<String, String>? headers,
  }) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final sanitizedParams = _sanitizeData(parameters ?? {});
    final sanitizedHeaders = headers != null ? _sanitizeHeaders(headers) : null;

    final logMessage = '''
$_tag ════════════════════════════════════════════════════════════════
$_tag 📤 API REQUEST
$_tag ════════════════════════════════════════════════════════════
$_tag Timestamp: $timestamp
$_tag Operation: $operation
${url != null ? '$_tag URL: $url' : ''}
${sanitizedHeaders != null ? '$_tag Headers:\n$_tag   ${_formatMap(sanitizedHeaders.cast<String, dynamic>()).replaceAll('\n║   ', '\n$_tag   ')}' : ''}
$_tag Parameters: ${sanitizedParams.isNotEmpty ? '\n$_tag   ${_formatMap(sanitizedParams).replaceAll('\n║   ', '\n$_tag   ')}' : 'None'}
$_tag ════════════════════════════════════════════════════════════
''';

    print(logMessage);
  }

  /// Log an API response
  static void logResponse({
    required String operation,
    required Map<String, dynamic> response,
    required Duration duration,
  }) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final sanitizedResponse = _sanitizeData(response);
    final success = response['success'] == true;

    final logMessage = '''
$_tag ════════════════════════════════════════════════════════════════
$_tag ${success ? '✅' : '❌'} API RESPONSE
$_tag ════════════════════════════════════════════════════════════
$_tag Timestamp: $timestamp
$_tag Operation: $operation
$_tag Duration: ${duration.inMilliseconds}ms
$_tag Status: ${success ? 'SUCCESS' : 'FAILED'}
$_tag Response:
$_tag   ${_formatMap(sanitizedResponse).replaceAll('\n║   ', '\n$_tag   ')}
$_tag ════════════════════════════════════════════════════════════
''';

    print(logMessage);
  }

  /// Log an API error
  static void logError({
    required String operation,
    required dynamic error,
    StackTrace? stackTrace,
    Duration? duration,
  }) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final durationText = duration != null ? '${duration.inMilliseconds}ms' : 'N/A';

    final logMessage = '''
$_tag ════════════════════════════════════════════════════════════════
$_tag 🔴 API ERROR
$_tag ════════════════════════════════════════════════════════════
$_tag Timestamp: $timestamp
$_tag Operation: $operation
$_tag Duration: $durationText
$_tag Error: $error
$_tag Stack Trace: ${stackTrace?.toString() ?? 'N/A'}
$_tag ════════════════════════════════════════════════════════════
''';

    print(logMessage);
  }

  /// Sanitize sensitive data from logs
  static Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};

    for (var entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;

      // List of sensitive field names
      if (key.contains('password') ||
          key.contains('token') ||
          key.contains('secret') ||
          key.contains('key') ||
          key.contains('authorization')) {
        sanitized[entry.key] = _maskValue(value);
      } else if (value is Map<String, dynamic>) {
        sanitized[entry.key] = _sanitizeData(value);
      } else if (value is List) {
        sanitized[entry.key] = value.map((item) {
          if (item is Map<String, dynamic>) {
            return _sanitizeData(item);
          }
          return item;
        }).toList();
      } else {
        sanitized[entry.key] = value;
      }
    }

    return sanitized;
  }

  /// Sanitize headers
  static Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    final sanitized = <String, String>{};

    for (var entry in headers.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;

      // List of sensitive header names
      if (key.contains('authorization') ||
          key.contains('token') ||
          key.contains('api-key') ||
          key.contains('x-api-key') ||
          key.contains('cookie') ||
          key.contains('session')) {
        sanitized[entry.key] = _maskValue(value);
      } else {
        sanitized[entry.key] = value;
      }
    }

    return sanitized;
  }

  /// Mask sensitive values
  static String _maskValue(dynamic value) {
    if (value == null) return 'null';
    final str = value.toString();
    if (str.isEmpty) return '(empty)';
    if (str.length <= 4) return '****';
    return '${str.substring(0, 2)}...${str.substring(str.length - 2)} (${str.length} chars)';
  }

  /// Format a map for logging
  static String _formatMap(Map<String, dynamic> map, {int indent = 0}) {
    if (map.isEmpty) return '{}';

    final buffer = StringBuffer();
    final entries = map.entries.toList();

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final isLast = i == entries.length - 1;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        buffer.write('${entry.key}: ');
        buffer.write(_formatMap(value, indent: indent + 2));
      } else if (value is List) {
        buffer.write('${entry.key}: [');
        if (value.isEmpty) {
          buffer.write(']');
        } else {
          buffer.write('${value.length} items]');
        }
      } else {
        buffer.write('${entry.key}: $value');
      }

      if (!isLast) {
        buffer.write('\n║   ');
      }
    }

    return buffer.toString();
  }

  /// Log a simple info message
  static void info(String message) {
    if (!_isEnabled) return;
    print('$_tag 💬 $message');
  }

  /// Log a warning message
  static void warning(String message) {
    if (!_isEnabled) return;
    print('$_tag ⚠️ $message');
  }
}