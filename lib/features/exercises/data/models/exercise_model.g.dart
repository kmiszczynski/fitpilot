// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseModelImpl _$$ExerciseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseModelImpl(
      exerciseId: json['exerciseId'] as String,
      name: json['name'] as String,
      difficultyLevel: json['difficultyLevel'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
      thumbnailImageUrlExpiration:
          json['thumbnailImageUrlExpiration'] as String?,
      instructions: json['instructions'] as String?,
      instructionVideoUrl: json['instructionVideoUrl'] as String?,
    );

Map<String, dynamic> _$$ExerciseModelImplToJson(_$ExerciseModelImpl instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'name': instance.name,
      'difficultyLevel': instance.difficultyLevel,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'thumbnailImageUrl': instance.thumbnailImageUrl,
      'thumbnailImageUrlExpiration': instance.thumbnailImageUrlExpiration,
      'instructions': instance.instructions,
      'instructionVideoUrl': instance.instructionVideoUrl,
    };
