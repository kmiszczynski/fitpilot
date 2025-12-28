// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fitness_test_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FitnessTestResponseModel _$FitnessTestResponseModelFromJson(
    Map<String, dynamic> json) {
  return _FitnessTestResponseModel.fromJson(json);
}

/// @nodoc
mixin _$FitnessTestResponseModel {
  @JsonKey(name: 'user_levels_id')
  String get userLevelsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'test_id')
  String get testId => throw _privateConstructorUsedError;
  FitnessLevels get levels => throw _privateConstructorUsedError;

  /// Serializes this FitnessTestResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FitnessTestResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FitnessTestResponseModelCopyWith<FitnessTestResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FitnessTestResponseModelCopyWith<$Res> {
  factory $FitnessTestResponseModelCopyWith(FitnessTestResponseModel value,
          $Res Function(FitnessTestResponseModel) then) =
      _$FitnessTestResponseModelCopyWithImpl<$Res, FitnessTestResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_levels_id') String userLevelsId,
      @JsonKey(name: 'test_id') String testId,
      FitnessLevels levels});

  $FitnessLevelsCopyWith<$Res> get levels;
}

/// @nodoc
class _$FitnessTestResponseModelCopyWithImpl<$Res,
        $Val extends FitnessTestResponseModel>
    implements $FitnessTestResponseModelCopyWith<$Res> {
  _$FitnessTestResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FitnessTestResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userLevelsId = null,
    Object? testId = null,
    Object? levels = null,
  }) {
    return _then(_value.copyWith(
      userLevelsId: null == userLevelsId
          ? _value.userLevelsId
          : userLevelsId // ignore: cast_nullable_to_non_nullable
              as String,
      testId: null == testId
          ? _value.testId
          : testId // ignore: cast_nullable_to_non_nullable
              as String,
      levels: null == levels
          ? _value.levels
          : levels // ignore: cast_nullable_to_non_nullable
              as FitnessLevels,
    ) as $Val);
  }

  /// Create a copy of FitnessTestResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FitnessLevelsCopyWith<$Res> get levels {
    return $FitnessLevelsCopyWith<$Res>(_value.levels, (value) {
      return _then(_value.copyWith(levels: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FitnessTestResponseModelImplCopyWith<$Res>
    implements $FitnessTestResponseModelCopyWith<$Res> {
  factory _$$FitnessTestResponseModelImplCopyWith(
          _$FitnessTestResponseModelImpl value,
          $Res Function(_$FitnessTestResponseModelImpl) then) =
      __$$FitnessTestResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_levels_id') String userLevelsId,
      @JsonKey(name: 'test_id') String testId,
      FitnessLevels levels});

  @override
  $FitnessLevelsCopyWith<$Res> get levels;
}

/// @nodoc
class __$$FitnessTestResponseModelImplCopyWithImpl<$Res>
    extends _$FitnessTestResponseModelCopyWithImpl<$Res,
        _$FitnessTestResponseModelImpl>
    implements _$$FitnessTestResponseModelImplCopyWith<$Res> {
  __$$FitnessTestResponseModelImplCopyWithImpl(
      _$FitnessTestResponseModelImpl _value,
      $Res Function(_$FitnessTestResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FitnessTestResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userLevelsId = null,
    Object? testId = null,
    Object? levels = null,
  }) {
    return _then(_$FitnessTestResponseModelImpl(
      userLevelsId: null == userLevelsId
          ? _value.userLevelsId
          : userLevelsId // ignore: cast_nullable_to_non_nullable
              as String,
      testId: null == testId
          ? _value.testId
          : testId // ignore: cast_nullable_to_non_nullable
              as String,
      levels: null == levels
          ? _value.levels
          : levels // ignore: cast_nullable_to_non_nullable
              as FitnessLevels,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FitnessTestResponseModelImpl implements _FitnessTestResponseModel {
  const _$FitnessTestResponseModelImpl(
      {@JsonKey(name: 'user_levels_id') required this.userLevelsId,
      @JsonKey(name: 'test_id') required this.testId,
      required this.levels});

  factory _$FitnessTestResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FitnessTestResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_levels_id')
  final String userLevelsId;
  @override
  @JsonKey(name: 'test_id')
  final String testId;
  @override
  final FitnessLevels levels;

  @override
  String toString() {
    return 'FitnessTestResponseModel(userLevelsId: $userLevelsId, testId: $testId, levels: $levels)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FitnessTestResponseModelImpl &&
            (identical(other.userLevelsId, userLevelsId) ||
                other.userLevelsId == userLevelsId) &&
            (identical(other.testId, testId) || other.testId == testId) &&
            (identical(other.levels, levels) || other.levels == levels));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userLevelsId, testId, levels);

  /// Create a copy of FitnessTestResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FitnessTestResponseModelImplCopyWith<_$FitnessTestResponseModelImpl>
      get copyWith => __$$FitnessTestResponseModelImplCopyWithImpl<
          _$FitnessTestResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FitnessTestResponseModelImplToJson(
      this,
    );
  }
}

abstract class _FitnessTestResponseModel implements FitnessTestResponseModel {
  const factory _FitnessTestResponseModel(
      {@JsonKey(name: 'user_levels_id') required final String userLevelsId,
      @JsonKey(name: 'test_id') required final String testId,
      required final FitnessLevels levels}) = _$FitnessTestResponseModelImpl;

  factory _FitnessTestResponseModel.fromJson(Map<String, dynamic> json) =
      _$FitnessTestResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_levels_id')
  String get userLevelsId;
  @override
  @JsonKey(name: 'test_id')
  String get testId;
  @override
  FitnessLevels get levels;

  /// Create a copy of FitnessTestResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FitnessTestResponseModelImplCopyWith<_$FitnessTestResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FitnessLevels _$FitnessLevelsFromJson(Map<String, dynamic> json) {
  return _FitnessLevels.fromJson(json);
}

/// @nodoc
mixin _$FitnessLevels {
  @JsonKey(name: 'per_category')
  Map<String, String> get perCategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'global_level')
  String get globalLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'global_level_raw_avg_points')
  double get globalLevelRawAvgPoints => throw _privateConstructorUsedError;

  /// Serializes this FitnessLevels to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FitnessLevels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FitnessLevelsCopyWith<FitnessLevels> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FitnessLevelsCopyWith<$Res> {
  factory $FitnessLevelsCopyWith(
          FitnessLevels value, $Res Function(FitnessLevels) then) =
      _$FitnessLevelsCopyWithImpl<$Res, FitnessLevels>;
  @useResult
  $Res call(
      {@JsonKey(name: 'per_category') Map<String, String> perCategory,
      @JsonKey(name: 'global_level') String globalLevel,
      @JsonKey(name: 'global_level_raw_avg_points')
      double globalLevelRawAvgPoints});
}

/// @nodoc
class _$FitnessLevelsCopyWithImpl<$Res, $Val extends FitnessLevels>
    implements $FitnessLevelsCopyWith<$Res> {
  _$FitnessLevelsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FitnessLevels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? perCategory = null,
    Object? globalLevel = null,
    Object? globalLevelRawAvgPoints = null,
  }) {
    return _then(_value.copyWith(
      perCategory: null == perCategory
          ? _value.perCategory
          : perCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      globalLevel: null == globalLevel
          ? _value.globalLevel
          : globalLevel // ignore: cast_nullable_to_non_nullable
              as String,
      globalLevelRawAvgPoints: null == globalLevelRawAvgPoints
          ? _value.globalLevelRawAvgPoints
          : globalLevelRawAvgPoints // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FitnessLevelsImplCopyWith<$Res>
    implements $FitnessLevelsCopyWith<$Res> {
  factory _$$FitnessLevelsImplCopyWith(
          _$FitnessLevelsImpl value, $Res Function(_$FitnessLevelsImpl) then) =
      __$$FitnessLevelsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'per_category') Map<String, String> perCategory,
      @JsonKey(name: 'global_level') String globalLevel,
      @JsonKey(name: 'global_level_raw_avg_points')
      double globalLevelRawAvgPoints});
}

/// @nodoc
class __$$FitnessLevelsImplCopyWithImpl<$Res>
    extends _$FitnessLevelsCopyWithImpl<$Res, _$FitnessLevelsImpl>
    implements _$$FitnessLevelsImplCopyWith<$Res> {
  __$$FitnessLevelsImplCopyWithImpl(
      _$FitnessLevelsImpl _value, $Res Function(_$FitnessLevelsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FitnessLevels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? perCategory = null,
    Object? globalLevel = null,
    Object? globalLevelRawAvgPoints = null,
  }) {
    return _then(_$FitnessLevelsImpl(
      perCategory: null == perCategory
          ? _value._perCategory
          : perCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      globalLevel: null == globalLevel
          ? _value.globalLevel
          : globalLevel // ignore: cast_nullable_to_non_nullable
              as String,
      globalLevelRawAvgPoints: null == globalLevelRawAvgPoints
          ? _value.globalLevelRawAvgPoints
          : globalLevelRawAvgPoints // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FitnessLevelsImpl implements _FitnessLevels {
  const _$FitnessLevelsImpl(
      {@JsonKey(name: 'per_category')
      required final Map<String, String> perCategory,
      @JsonKey(name: 'global_level') required this.globalLevel,
      @JsonKey(name: 'global_level_raw_avg_points')
      required this.globalLevelRawAvgPoints})
      : _perCategory = perCategory;

  factory _$FitnessLevelsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FitnessLevelsImplFromJson(json);

  final Map<String, String> _perCategory;
  @override
  @JsonKey(name: 'per_category')
  Map<String, String> get perCategory {
    if (_perCategory is EqualUnmodifiableMapView) return _perCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_perCategory);
  }

  @override
  @JsonKey(name: 'global_level')
  final String globalLevel;
  @override
  @JsonKey(name: 'global_level_raw_avg_points')
  final double globalLevelRawAvgPoints;

  @override
  String toString() {
    return 'FitnessLevels(perCategory: $perCategory, globalLevel: $globalLevel, globalLevelRawAvgPoints: $globalLevelRawAvgPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FitnessLevelsImpl &&
            const DeepCollectionEquality()
                .equals(other._perCategory, _perCategory) &&
            (identical(other.globalLevel, globalLevel) ||
                other.globalLevel == globalLevel) &&
            (identical(
                    other.globalLevelRawAvgPoints, globalLevelRawAvgPoints) ||
                other.globalLevelRawAvgPoints == globalLevelRawAvgPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_perCategory),
      globalLevel,
      globalLevelRawAvgPoints);

  /// Create a copy of FitnessLevels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FitnessLevelsImplCopyWith<_$FitnessLevelsImpl> get copyWith =>
      __$$FitnessLevelsImplCopyWithImpl<_$FitnessLevelsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FitnessLevelsImplToJson(
      this,
    );
  }
}

abstract class _FitnessLevels implements FitnessLevels {
  const factory _FitnessLevels(
      {@JsonKey(name: 'per_category')
      required final Map<String, String> perCategory,
      @JsonKey(name: 'global_level') required final String globalLevel,
      @JsonKey(name: 'global_level_raw_avg_points')
      required final double globalLevelRawAvgPoints}) = _$FitnessLevelsImpl;

  factory _FitnessLevels.fromJson(Map<String, dynamic> json) =
      _$FitnessLevelsImpl.fromJson;

  @override
  @JsonKey(name: 'per_category')
  Map<String, String> get perCategory;
  @override
  @JsonKey(name: 'global_level')
  String get globalLevel;
  @override
  @JsonKey(name: 'global_level_raw_avg_points')
  double get globalLevelRawAvgPoints;

  /// Create a copy of FitnessLevels
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FitnessLevelsImplCopyWith<_$FitnessLevelsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
