// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) {
  return _ExerciseModel.fromJson(json);
}

/// @nodoc
mixin _$ExerciseModel {
  String get exerciseId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get difficultyLevel => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get thumbnailImageUrl => throw _privateConstructorUsedError;
  String? get thumbnailImageUrlExpiration => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  String? get instructionVideoUrl => throw _privateConstructorUsedError;

  /// Serializes this ExerciseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseModelCopyWith<ExerciseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseModelCopyWith<$Res> {
  factory $ExerciseModelCopyWith(
          ExerciseModel value, $Res Function(ExerciseModel) then) =
      _$ExerciseModelCopyWithImpl<$Res, ExerciseModel>;
  @useResult
  $Res call(
      {String exerciseId,
      String name,
      String difficultyLevel,
      String? description,
      String? imageUrl,
      String? thumbnailImageUrl,
      String? thumbnailImageUrlExpiration,
      String? instructions,
      String? instructionVideoUrl});
}

/// @nodoc
class _$ExerciseModelCopyWithImpl<$Res, $Val extends ExerciseModel>
    implements $ExerciseModelCopyWith<$Res> {
  _$ExerciseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? name = null,
    Object? difficultyLevel = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? thumbnailImageUrl = freezed,
    Object? thumbnailImageUrlExpiration = freezed,
    Object? instructions = freezed,
    Object? instructionVideoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailImageUrl: freezed == thumbnailImageUrl
          ? _value.thumbnailImageUrl
          : thumbnailImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailImageUrlExpiration: freezed == thumbnailImageUrlExpiration
          ? _value.thumbnailImageUrlExpiration
          : thumbnailImageUrlExpiration // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      instructionVideoUrl: freezed == instructionVideoUrl
          ? _value.instructionVideoUrl
          : instructionVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseModelImplCopyWith<$Res>
    implements $ExerciseModelCopyWith<$Res> {
  factory _$$ExerciseModelImplCopyWith(
          _$ExerciseModelImpl value, $Res Function(_$ExerciseModelImpl) then) =
      __$$ExerciseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String exerciseId,
      String name,
      String difficultyLevel,
      String? description,
      String? imageUrl,
      String? thumbnailImageUrl,
      String? thumbnailImageUrlExpiration,
      String? instructions,
      String? instructionVideoUrl});
}

/// @nodoc
class __$$ExerciseModelImplCopyWithImpl<$Res>
    extends _$ExerciseModelCopyWithImpl<$Res, _$ExerciseModelImpl>
    implements _$$ExerciseModelImplCopyWith<$Res> {
  __$$ExerciseModelImplCopyWithImpl(
      _$ExerciseModelImpl _value, $Res Function(_$ExerciseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? name = null,
    Object? difficultyLevel = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? thumbnailImageUrl = freezed,
    Object? thumbnailImageUrlExpiration = freezed,
    Object? instructions = freezed,
    Object? instructionVideoUrl = freezed,
  }) {
    return _then(_$ExerciseModelImpl(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailImageUrl: freezed == thumbnailImageUrl
          ? _value.thumbnailImageUrl
          : thumbnailImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailImageUrlExpiration: freezed == thumbnailImageUrlExpiration
          ? _value.thumbnailImageUrlExpiration
          : thumbnailImageUrlExpiration // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      instructionVideoUrl: freezed == instructionVideoUrl
          ? _value.instructionVideoUrl
          : instructionVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseModelImpl extends _ExerciseModel {
  const _$ExerciseModelImpl(
      {required this.exerciseId,
      required this.name,
      required this.difficultyLevel,
      this.description,
      this.imageUrl,
      this.thumbnailImageUrl,
      this.thumbnailImageUrlExpiration,
      this.instructions,
      this.instructionVideoUrl})
      : super._();

  factory _$ExerciseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseModelImplFromJson(json);

  @override
  final String exerciseId;
  @override
  final String name;
  @override
  final String difficultyLevel;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? thumbnailImageUrl;
  @override
  final String? thumbnailImageUrlExpiration;
  @override
  final String? instructions;
  @override
  final String? instructionVideoUrl;

  @override
  String toString() {
    return 'ExerciseModel(exerciseId: $exerciseId, name: $name, difficultyLevel: $difficultyLevel, description: $description, imageUrl: $imageUrl, thumbnailImageUrl: $thumbnailImageUrl, thumbnailImageUrlExpiration: $thumbnailImageUrlExpiration, instructions: $instructions, instructionVideoUrl: $instructionVideoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseModelImpl &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbnailImageUrl, thumbnailImageUrl) ||
                other.thumbnailImageUrl == thumbnailImageUrl) &&
            (identical(other.thumbnailImageUrlExpiration,
                    thumbnailImageUrlExpiration) ||
                other.thumbnailImageUrlExpiration ==
                    thumbnailImageUrlExpiration) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.instructionVideoUrl, instructionVideoUrl) ||
                other.instructionVideoUrl == instructionVideoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      exerciseId,
      name,
      difficultyLevel,
      description,
      imageUrl,
      thumbnailImageUrl,
      thumbnailImageUrlExpiration,
      instructions,
      instructionVideoUrl);

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      __$$ExerciseModelImplCopyWithImpl<_$ExerciseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseModelImplToJson(
      this,
    );
  }
}

abstract class _ExerciseModel extends ExerciseModel {
  const factory _ExerciseModel(
      {required final String exerciseId,
      required final String name,
      required final String difficultyLevel,
      final String? description,
      final String? imageUrl,
      final String? thumbnailImageUrl,
      final String? thumbnailImageUrlExpiration,
      final String? instructions,
      final String? instructionVideoUrl}) = _$ExerciseModelImpl;
  const _ExerciseModel._() : super._();

  factory _ExerciseModel.fromJson(Map<String, dynamic> json) =
      _$ExerciseModelImpl.fromJson;

  @override
  String get exerciseId;
  @override
  String get name;
  @override
  String get difficultyLevel;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get thumbnailImageUrl;
  @override
  String? get thumbnailImageUrlExpiration;
  @override
  String? get instructions;
  @override
  String? get instructionVideoUrl;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
