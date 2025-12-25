import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// User Profile Model - extends domain entity
/// Used for data layer serialization
@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @JsonKey(name: 'user_id') String? userId,
    String? name,
    String? email,
    int? age,
    String? sex,
    @JsonKey(name: 'training_frequency') int? trainingFrequency,
    String? target,
    @Default([]) List<String> equipment,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Convert model to domain entity
  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      name: name,
      email: email,
      age: age,
      sex: sex,
      trainingFrequency: trainingFrequency,
      target: target,
      equipment: equipment,
    );
  }

  /// Create model from domain entity
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      age: entity.age,
      sex: entity.sex,
      trainingFrequency: entity.trainingFrequency,
      target: entity.target,
      equipment: entity.equipment,
    );
  }
}
