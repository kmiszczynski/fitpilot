// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_tokens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthTokensModelImpl _$$AuthTokensModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthTokensModelImpl(
      accessToken: json['accessToken'] as String,
      idToken: json['idToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$AuthTokensModelImplToJson(
        _$AuthTokensModelImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'idToken': instance.idToken,
      'refreshToken': instance.refreshToken,
      'email': instance.email,
    };
