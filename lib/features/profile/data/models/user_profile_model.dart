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
    required String name,
    required String email,
    required int age,
    required String sex,
    required int trainingFrequency,
    required String target,
    @Default([]) List<String> equipment,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Convert model to domain entity
  UserProfile toEntity() {
    return UserProfile(
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
