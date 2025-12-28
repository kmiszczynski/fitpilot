// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_test_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FitnessTestResponseModelImpl _$$FitnessTestResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FitnessTestResponseModelImpl(
      userLevelsId: json['user_levels_id'] as String,
      testId: json['test_id'] as String,
      levels: FitnessLevels.fromJson(json['levels'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FitnessTestResponseModelImplToJson(
        _$FitnessTestResponseModelImpl instance) =>
    <String, dynamic>{
      'user_levels_id': instance.userLevelsId,
      'test_id': instance.testId,
      'levels': instance.levels,
    };

_$FitnessLevelsImpl _$$FitnessLevelsImplFromJson(Map<String, dynamic> json) =>
    _$FitnessLevelsImpl(
      perCategory: Map<String, String>.from(json['per_category'] as Map),
      globalLevel: json['global_level'] as String,
      globalLevelRawAvgPoints:
          (json['global_level_raw_avg_points'] as num).toDouble(),
    );

Map<String, dynamic> _$$FitnessLevelsImplToJson(_$FitnessLevelsImpl instance) =>
    <String, dynamic>{
      'per_category': instance.perCategory,
      'global_level': instance.globalLevel,
      'global_level_raw_avg_points': instance.globalLevelRawAvgPoints,
    };
