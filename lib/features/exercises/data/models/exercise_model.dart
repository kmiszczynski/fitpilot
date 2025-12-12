import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/exercise.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
class ExerciseModel with _$ExerciseModel {
  const ExerciseModel._();

  const factory ExerciseModel({
    required String exerciseId,
    required String name,
    required String description,
    required String difficultyLevel,
    required String imageUrl,
    required String thumbnailImageUrl,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  /// Convert model to domain entity
  Exercise toEntity() {
    return Exercise(
      exerciseId: exerciseId,
      name: name,
      description: description,
      difficultyLevel: difficultyLevel,
      imageUrl: imageUrl,
      thumbnailImageUrl: thumbnailImageUrl,
    );
  }

  /// Create model from domain entity
  factory ExerciseModel.fromEntity(Exercise entity) {
    return ExerciseModel(
      exerciseId: entity.exerciseId,
      name: entity.name,
      description: entity.description,
      difficultyLevel: entity.difficultyLevel,
      imageUrl: entity.imageUrl,
      thumbnailImageUrl: entity.thumbnailImageUrl,
    );
  }
}