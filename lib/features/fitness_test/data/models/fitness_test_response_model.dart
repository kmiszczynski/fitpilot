import 'package:freezed_annotation/freezed_annotation.dart';

part 'fitness_test_response_model.freezed.dart';
part 'fitness_test_response_model.g.dart';

/// Fitness test response model from API
@freezed
class FitnessTestResponseModel with _$FitnessTestResponseModel {
  const factory FitnessTestResponseModel({
    @JsonKey(name: 'user_levels_id') required String userLevelsId,
    @JsonKey(name: 'test_id') required String testId,
    required FitnessLevels levels,
  }) = _FitnessTestResponseModel;

  factory FitnessTestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FitnessTestResponseModelFromJson(json);
}

/// Fitness levels data
@freezed
class FitnessLevels with _$FitnessLevels {
  const factory FitnessLevels({
    @JsonKey(name: 'per_category') required Map<String, String> perCategory,
    @JsonKey(name: 'global_level') required String globalLevel,
    @JsonKey(name: 'global_level_raw_avg_points')
    required double globalLevelRawAvgPoints,
  }) = _FitnessLevels;

  factory FitnessLevels.fromJson(Map<String, dynamic> json) =>
      _$FitnessLevelsFromJson(json);
}
