import 'package:freezed_annotation/freezed_annotation.dart';

part 'fitness_test_result_model.freezed.dart';
part 'fitness_test_result_model.g.dart';

/// Fitness test results model for API submission
@freezed
class FitnessTestResultModel with _$FitnessTestResultModel {
  const factory FitnessTestResultModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'pushups_type') required String pushupsType,
    required FitnessTestResults results,
  }) = _FitnessTestResultModel;

  factory FitnessTestResultModel.fromJson(Map<String, dynamic> json) =>
      _$FitnessTestResultModelFromJson(json);
}

/// Individual test results
@freezed
class FitnessTestResults with _$FitnessTestResults {
  const factory FitnessTestResults({
    @JsonKey(name: 'max_push_ups') required int maxPushUps,
    @JsonKey(name: 'max_squats') required int maxSquats,
    @JsonKey(name: 'max_reverse_snow_angels_45s')
    required int maxReverseSnowAngels45s,
    @JsonKey(name: 'plank_max_time_seconds') required int plankMaxTimeSeconds,
    @JsonKey(name: 'mountain_climbers_45s') required int mountainClimbers45s,
  }) = _FitnessTestResults;

  factory FitnessTestResults.fromJson(Map<String, dynamic> json) =>
      _$FitnessTestResultsFromJson(json);
}
