import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_tokens.dart';

part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

/// Auth Tokens Model - extends domain entity
@freezed
class AuthTokensModel with _$AuthTokensModel {
  const AuthTokensModel._();

  const factory AuthTokensModel({
    required String accessToken,
    required String idToken,
    String? refreshToken,
    String? email,
  }) = _AuthTokensModel;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  /// Convert model to domain entity
  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      idToken: idToken,
      refreshToken: refreshToken,
      email: email,
    );
  }

  /// Create model from domain entity
  factory AuthTokensModel.fromEntity(AuthTokens entity) {
    return AuthTokensModel(
      accessToken: entity.accessToken,
      idToken: entity.idToken,
      refreshToken: entity.refreshToken,
      email: entity.email,
    );
  }
}