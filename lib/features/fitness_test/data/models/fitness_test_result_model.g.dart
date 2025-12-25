// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_test_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FitnessTestResultModelImpl _$$FitnessTestResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FitnessTestResultModelImpl(
      userId: json['user_id'] as String,
      results:
          FitnessTestResults.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FitnessTestResultModelImplToJson(
        _$FitnessTestResultModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'results': instance.results,
    };

_$FitnessTestResultsImpl _$$FitnessTestResultsImplFromJson(
        Map<String, dynamic> json) =>
    _$FitnessTestResultsImpl(
      maxPushUps: (json['max_push_ups'] as num).toInt(),
      maxSquats: (json['max_squats'] as num).toInt(),
      maxReverseSnowAngels45s:
          (json['max_reverse_snow_angels_45s'] as num).toInt(),
      plankMaxTimeSeconds: (json['plank_max_time_seconds'] as num).toInt(),
      mountainClimbers45s: (json['mountain_climbers_45s'] as num).toInt(),
    );

Map<String, dynamic> _$$FitnessTestResultsImplToJson(
        _$FitnessTestResultsImpl instance) =>
    <String, dynamic>{
      'max_push_ups': instance.maxPushUps,
      'max_squats': instance.maxSquats,
      'max_reverse_snow_angels_45s': instance.maxReverseSnowAngels45s,
      'plank_max_time_seconds': instance.plankMaxTimeSeconds,
      'mountain_climbers_45s': instance.mountainClimbers45s,
    };
