// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      name: json['name'] as String,
      email: json['email'] as String,
      age: (json['age'] as num).toInt(),
      sex: json['sex'] as String,
      trainingFrequency: (json['trainingFrequency'] as num).toInt(),
      target: json['target'] as String,
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'age': instance.age,
      'sex': instance.sex,
      'trainingFrequency': instance.trainingFrequency,
      'target': instance.target,
      'equipment': instance.equipment,
    };
