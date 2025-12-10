import 'package:freezed_annotation/freezed_annotation.dart';
import 'auth_tokens.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult.success({
    required AuthTokens tokens,
    String? message,
  }) = AuthSuccess;

  const factory AuthResult.failure({
    required String message,
    int? statusCode,
  }) = AuthFailureResult;

  const factory AuthResult.loading() = AuthLoading;
}
