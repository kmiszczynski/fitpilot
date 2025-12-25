// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  @JsonKey(name: 'user_id')
  String? get userId =>
      throw _privateConstructorUsedError; // User ID from backend (snake_case in API)
  String? get name =>
      throw _privateConstructorUsedError; // Nullable to handle API responses without profile data
  String? get email =>
      throw _privateConstructorUsedError; // Nullable to handle API responses without profile data
  int? get age =>
      throw _privateConstructorUsedError; // Nullable to handle API responses without profile data
  String? get sex =>
      throw _privateConstructorUsedError; // Nullable to handle API responses without profile data
  @JsonKey(name: 'training_frequency')
  int? get trainingFrequency =>
      throw _privateConstructorUsedError; // Nullable, snake_case in API
  String? get target =>
      throw _privateConstructorUsedError; // Nullable to handle API responses without profile data
  List<String> get equipment => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String? userId,
      String? name,
      String? email,
      int? age,
      String? sex,
      @JsonKey(name: 'training_frequency') int? trainingFrequency,
      String? target,
      List<String> equipment});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? age = freezed,
    Object? sex = freezed,
    Object? trainingFrequency = freezed,
    Object? target = freezed,
    Object? equipment = null,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      sex: freezed == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String?,
      trainingFrequency: freezed == trainingFrequency
          ? _value.trainingFrequency
          : trainingFrequency // ignore: cast_nullable_to_non_nullable
              as int?,
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String? userId,
      String? name,
      String? email,
      int? age,
      String? sex,
      @JsonKey(name: 'training_frequency') int? trainingFrequency,
      String? target,
      List<String> equipment});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? age = freezed,
    Object? sex = freezed,
    Object? trainingFrequency = freezed,
    Object? target = freezed,
    Object? equipment = null,
  }) {
    return _then(_$UserProfileImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      sex: freezed == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String?,
      trainingFrequency: freezed == trainingFrequency
          ? _value.trainingFrequency
          : trainingFrequency // ignore: cast_nullable_to_non_nullable
              as int?,
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: null == equipment
          ? _value._equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {@JsonKey(name: 'user_id') this.userId,
      this.name,
      this.email,
      this.age,
      this.sex,
      @JsonKey(name: 'training_frequency') this.trainingFrequency,
      this.target,
      final List<String> equipment = const []})
      : _equipment = equipment;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String? userId;
// User ID from backend (snake_case in API)
  @override
  final String? name;
// Nullable to handle API responses without profile data
  @override
  final String? email;
// Nullable to handle API responses without profile data
  @override
  final int? age;
// Nullable to handle API responses without profile data
  @override
  final String? sex;
// Nullable to handle API responses without profile data
  @override
  @JsonKey(name: 'training_frequency')
  final int? trainingFrequency;
// Nullable, snake_case in API
  @override
  final String? target;
// Nullable to handle API responses without profile data
  final List<String> _equipment;
// Nullable to handle API responses without profile data
  @override
  @JsonKey()
  List<String> get equipment {
    if (_equipment is EqualUnmodifiableListView) return _equipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipment);
  }

  @override
  String toString() {
    return 'UserProfile(userId: $userId, name: $name, email: $email, age: $age, sex: $sex, trainingFrequency: $trainingFrequency, target: $target, equipment: $equipment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.trainingFrequency, trainingFrequency) ||
                other.trainingFrequency == trainingFrequency) &&
            (identical(other.target, target) || other.target == target) &&
            const DeepCollectionEquality()
                .equals(other._equipment, _equipment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      name,
      email,
      age,
      sex,
      trainingFrequency,
      target,
      const DeepCollectionEquality().hash(_equipment));

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {@JsonKey(name: 'user_id') final String? userId,
      final String? name,
      final String? email,
      final int? age,
      final String? sex,
      @JsonKey(name: 'training_frequency') final int? trainingFrequency,
      final String? target,
      final List<String> equipment}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String? get userId; // User ID from backend (snake_case in API)
  @override
  String? get name; // Nullable to handle API responses without profile data
  @override
  String? get email; // Nullable to handle API responses without profile data
  @override
  int? get age; // Nullable to handle API responses without profile data
  @override
  String? get sex; // Nullable to handle API responses without profile data
  @override
  @JsonKey(name: 'training_frequency')
  int? get trainingFrequency; // Nullable, snake_case in API
  @override
  String? get target; // Nullable to handle API responses without profile data
  @override
  List<String> get equipment;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
