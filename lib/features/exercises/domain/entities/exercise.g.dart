// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      exerciseId: json['exerciseId'] as String,
      name: json['name'] as String,
      difficultyLevel: json['difficultyLevel'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
      instructions: json['instructions'] as String?,
      instructionVideoUrl: json['instructionVideoUrl'] as String?,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'name': instance.name,
      'difficultyLevel': instance.difficultyLevel,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'thumbnailImageUrl': instance.thumbnailImageUrl,
      'instructions': instance.instructions,
      'instructionVideoUrl': instance.instructionVideoUrl,
    };
