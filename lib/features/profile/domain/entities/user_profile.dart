import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') String? userId, // User ID from backend (snake_case in API)
    String? name, // Nullable to handle API responses without profile data
    String? email, // Nullable to handle API responses without profile data
    int? age, // Nullable to handle API responses without profile data
    String? sex, // Nullable to handle API responses without profile data
    @JsonKey(name: 'training_frequency') int? trainingFrequency, // Nullable, snake_case in API
    String? target, // Nullable to handle API responses without profile data
    @Default([]) List<String> equipment,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
