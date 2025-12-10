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
    required String id,
    required String name,
    required int age,
    required String sex,
    required double height,
    required double weight,
    required String activityLevel,
    required String goal,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Convert model to domain entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      age: age,
      sex: sex,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
      goal: goal,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from domain entity
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      sex: entity.sex,
      height: entity.height,
      weight: entity.weight,
      activityLevel: entity.activityLevel,
      goal: entity.goal,
      email: entity.email,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
