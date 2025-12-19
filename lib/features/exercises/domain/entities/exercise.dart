import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String exerciseId,
    required String name,
    required String description,
    required String difficultyLevel,
    String? imageUrl,
    String? thumbnailImageUrl,
    required String instructions,
    String? instructionVideoUrl,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}