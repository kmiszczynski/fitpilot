// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fitness_test_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FitnessTestResultModel _$FitnessTestResultModelFromJson(
    Map<String, dynamic> json) {
  return _FitnessTestResultModel.fromJson(json);
}

/// @nodoc
mixin _$FitnessTestResultModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pushups_type')
  String get pushupsType => throw _privateConstructorUsedError;
  FitnessTestResults get results => throw _privateConstructorUsedError;

  /// Serializes this FitnessTestResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FitnessTestResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FitnessTestResultModelCopyWith<FitnessTestResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FitnessTestResultModelCopyWith<$Res> {
  factory $FitnessTestResultModelCopyWith(FitnessTestResultModel value,
          $Res Function(FitnessTestResultModel) then) =
      _$FitnessTestResultModelCopyWithImpl<$Res, FitnessTestResultModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'pushups_type') String pushupsType,
      FitnessTestResults results});

  $FitnessTestResultsCopyWith<$Res> get results;
}

/// @nodoc
class _$FitnessTestResultModelCopyWithImpl<$Res,
        $Val extends FitnessTestResultModel>
    implements $FitnessTestResultModelCopyWith<$Res> {
  _$FitnessTestResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FitnessTestResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushupsType = null,
    Object? results = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pushupsType: null == pushupsType
          ? _value.pushupsType
          : pushupsType // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as FitnessTestResults,
    ) as $Val);
  }

  /// Create a copy of FitnessTestResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FitnessTestResultsCopyWith<$Res> get results {
    return $FitnessTestResultsCopyWith<$Res>(_value.results, (value) {
      return _then(_value.copyWith(results: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FitnessTestResultModelImplCopyWith<$Res>
    implements $FitnessTestResultModelCopyWith<$Res> {
  factory _$$FitnessTestResultModelImplCopyWith(
          _$FitnessTestResultModelImpl value,
          $Res Function(_$FitnessTestResultModelImpl) then) =
      __$$FitnessTestResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'pushups_type') String pushupsType,
      FitnessTestResults results});

  @override
  $FitnessTestResultsCopyWith<$Res> get results;
}

/// @nodoc
class __$$FitnessTestResultModelImplCopyWithImpl<$Res>
    extends _$FitnessTestResultModelCopyWithImpl<$Res,
        _$FitnessTestResultModelImpl>
    implements _$$FitnessTestResultModelImplCopyWith<$Res> {
  __$$FitnessTestResultModelImplCopyWithImpl(
      _$FitnessTestResultModelImpl _value,
      $Res Function(_$FitnessTestResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FitnessTestResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushupsType = null,
    Object? results = null,
  }) {
    return _then(_$FitnessTestResultModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pushupsType: null == pushupsType
          ? _value.pushupsType
          : pushupsType // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as FitnessTestResults,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FitnessTestResultModelImpl implements _FitnessTestResultModel {
  const _$FitnessTestResultModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'pushups_type') required this.pushupsType,
      required this.results});

  factory _$FitnessTestResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FitnessTestResultModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'pushups_type')
  final String pushupsType;
  @override
  final FitnessTestResults results;

  @override
  String toString() {
    return 'FitnessTestResultModel(userId: $userId, pushupsType: $pushupsType, results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FitnessTestResultModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushupsType, pushupsType) ||
                other.pushupsType == pushupsType) &&
            (identical(other.results, results) || other.results == results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, pushupsType, results);

  /// Create a copy of FitnessTestResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FitnessTestResultModelImplCopyWith<_$FitnessTestResultModelImpl>
      get copyWith => __$$FitnessTestResultModelImplCopyWithImpl<
          _$FitnessTestResultModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FitnessTestResultModelImplToJson(
      this,
    );
  }
}

abstract class _FitnessTestResultModel implements FitnessTestResultModel {
  const factory _FitnessTestResultModel(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'pushups_type') required final String pushupsType,
          required final FitnessTestResults results}) =
      _$FitnessTestResultModelImpl;

  factory _FitnessTestResultModel.fromJson(Map<String, dynamic> json) =
      _$FitnessTestResultModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'pushups_type')
  String get pushupsType;
  @override
  FitnessTestResults get results;

  /// Create a copy of FitnessTestResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FitnessTestResultModelImplCopyWith<_$FitnessTestResultModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FitnessTestResults _$FitnessTestResultsFromJson(Map<String, dynamic> json) {
  return _FitnessTestResults.fromJson(json);
}

/// @nodoc
mixin _$FitnessTestResults {
  @JsonKey(name: 'max_push_ups')
  int get maxPushUps => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_squats')
  int get maxSquats => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_reverse_snow_angels_45s')
  int get maxReverseSnowAngels45s => throw _privateConstructorUsedError;
  @JsonKey(name: 'plank_max_time_seconds')
  int get plankMaxTimeSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'mountain_climbers_45s')
  int get mountainClimbers45s => throw _privateConstructorUsedError;

  /// Serializes this FitnessTestResults to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FitnessTestResults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FitnessTestResultsCopyWith<FitnessTestResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FitnessTestResultsCopyWith<$Res> {
  factory $FitnessTestResultsCopyWith(
          FitnessTestResults value, $Res Function(FitnessTestResults) then) =
      _$FitnessTestResultsCopyWithImpl<$Res, FitnessTestResults>;
  @useResult
  $Res call(
      {@JsonKey(name: 'max_push_ups') int maxPushUps,
      @JsonKey(name: 'max_squats') int maxSquats,
      @JsonKey(name: 'max_reverse_snow_angels_45s') int maxReverseSnowAngels45s,
      @JsonKey(name: 'plank_max_time_seconds') int plankMaxTimeSeconds,
      @JsonKey(name: 'mountain_climbers_45s') int mountainClimbers45s});
}

/// @nodoc
class _$FitnessTestResultsCopyWithImpl<$Res, $Val extends FitnessTestResults>
    implements $FitnessTestResultsCopyWith<$Res> {
  _$FitnessTestResultsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FitnessTestResults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxPushUps = null,
    Object? maxSquats = null,
    Object? maxReverseSnowAngels45s = null,
    Object? plankMaxTimeSeconds = null,
    Object? mountainClimbers45s = null,
  }) {
    return _then(_value.copyWith(
      maxPushUps: null == maxPushUps
          ? _value.maxPushUps
          : maxPushUps // ignore: cast_nullable_to_non_nullable
              as int,
      maxSquats: null == maxSquats
          ? _value.maxSquats
          : maxSquats // ignore: cast_nullable_to_non_nullable
              as int,
      maxReverseSnowAngels45s: null == maxReverseSnowAngels45s
          ? _value.maxReverseSnowAngels45s
          : maxReverseSnowAngels45s // ignore: cast_nullable_to_non_nullable
              as int,
      plankMaxTimeSeconds: null == plankMaxTimeSeconds
          ? _value.plankMaxTimeSeconds
          : plankMaxTimeSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      mountainClimbers45s: null == mountainClimbers45s
          ? _value.mountainClimbers45s
          : mountainClimbers45s // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FitnessTestResultsImplCopyWith<$Res>
    implements $FitnessTestResultsCopyWith<$Res> {
  factory _$$FitnessTestResultsImplCopyWith(_$FitnessTestResultsImpl value,
          $Res Function(_$FitnessTestResultsImpl) then) =
      __$$FitnessTestResultsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'max_push_ups') int maxPushUps,
      @JsonKey(name: 'max_squats') int maxSquats,
      @JsonKey(name: 'max_reverse_snow_angels_45s') int maxReverseSnowAngels45s,
      @JsonKey(name: 'plank_max_time_seconds') int plankMaxTimeSeconds,
      @JsonKey(name: 'mountain_climbers_45s') int mountainClimbers45s});
}

/// @nodoc
class __$$FitnessTestResultsImplCopyWithImpl<$Res>
    extends _$FitnessTestResultsCopyWithImpl<$Res, _$FitnessTestResultsImpl>
    implements _$$FitnessTestResultsImplCopyWith<$Res> {
  __$$FitnessTestResultsImplCopyWithImpl(_$FitnessTestResultsImpl _value,
      $Res Function(_$FitnessTestResultsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FitnessTestResults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxPushUps = null,
    Object? maxSquats = null,
    Object? maxReverseSnowAngels45s = null,
    Object? plankMaxTimeSeconds = null,
    Object? mountainClimbers45s = null,
  }) {
    return _then(_$FitnessTestResultsImpl(
      maxPushUps: null == maxPushUps
          ? _value.maxPushUps
          : maxPushUps // ignore: cast_nullable_to_non_nullable
              as int,
      maxSquats: null == maxSquats
          ? _value.maxSquats
          : maxSquats // ignore: cast_nullable_to_non_nullable
              as int,
      maxReverseSnowAngels45s: null == maxReverseSnowAngels45s
          ? _value.maxReverseSnowAngels45s
          : maxReverseSnowAngels45s // ignore: cast_nullable_to_non_nullable
              as int,
      plankMaxTimeSeconds: null == plankMaxTimeSeconds
          ? _value.plankMaxTimeSeconds
          : plankMaxTimeSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      mountainClimbers45s: null == mountainClimbers45s
          ? _value.mountainClimbers45s
          : mountainClimbers45s // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FitnessTestResultsImpl implements _FitnessTestResults {
  const _$FitnessTestResultsImpl(
      {@JsonKey(name: 'max_push_ups') required this.maxPushUps,
      @JsonKey(name: 'max_squats') required this.maxSquats,
      @JsonKey(name: 'max_reverse_snow_angels_45s')
      required this.maxReverseSnowAngels45s,
      @JsonKey(name: 'plank_max_time_seconds')
      required this.plankMaxTimeSeconds,
      @JsonKey(name: 'mountain_climbers_45s')
      required this.mountainClimbers45s});

  factory _$FitnessTestResultsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FitnessTestResultsImplFromJson(json);

  @override
  @JsonKey(name: 'max_push_ups')
  final int maxPushUps;
  @override
  @JsonKey(name: 'max_squats')
  final int maxSquats;
  @override
  @JsonKey(name: 'max_reverse_snow_angels_45s')
  final int maxReverseSnowAngels45s;
  @override
  @JsonKey(name: 'plank_max_time_seconds')
  final int plankMaxTimeSeconds;
  @override
  @JsonKey(name: 'mountain_climbers_45s')
  final int mountainClimbers45s;

  @override
  String toString() {
    return 'FitnessTestResults(maxPushUps: $maxPushUps, maxSquats: $maxSquats, maxReverseSnowAngels45s: $maxReverseSnowAngels45s, plankMaxTimeSeconds: $plankMaxTimeSeconds, mountainClimbers45s: $mountainClimbers45s)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FitnessTestResultsImpl &&
            (identical(other.maxPushUps, maxPushUps) ||
                other.maxPushUps == maxPushUps) &&
            (identical(other.maxSquats, maxSquats) ||
                other.maxSquats == maxSquats) &&
            (identical(
                    other.maxReverseSnowAngels45s, maxReverseSnowAngels45s) ||
                other.maxReverseSnowAngels45s == maxReverseSnowAngels45s) &&
            (identical(other.plankMaxTimeSeconds, plankMaxTimeSeconds) ||
                other.plankMaxTimeSeconds == plankMaxTimeSeconds) &&
            (identical(other.mountainClimbers45s, mountainClimbers45s) ||
                other.mountainClimbers45s == mountainClimbers45s));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, maxPushUps, maxSquats,
      maxReverseSnowAngels45s, plankMaxTimeSeconds, mountainClimbers45s);

  /// Create a copy of FitnessTestResults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FitnessTestResultsImplCopyWith<_$FitnessTestResultsImpl> get copyWith =>
      __$$FitnessTestResultsImplCopyWithImpl<_$FitnessTestResultsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FitnessTestResultsImplToJson(
      this,
    );
  }
}

abstract class _FitnessTestResults implements FitnessTestResults {
  const factory _FitnessTestResults(
      {@JsonKey(name: 'max_push_ups') required final int maxPushUps,
      @JsonKey(name: 'max_squats') required final int maxSquats,
      @JsonKey(name: 'max_reverse_snow_angels_45s')
      required final int maxReverseSnowAngels45s,
      @JsonKey(name: 'plank_max_time_seconds')
      required final int plankMaxTimeSeconds,
      @JsonKey(name: 'mountain_climbers_45s')
      required final int mountainClimbers45s}) = _$FitnessTestResultsImpl;

  factory _FitnessTestResults.fromJson(Map<String, dynamic> json) =
      _$FitnessTestResultsImpl.fromJson;

  @override
  @JsonKey(name: 'max_push_ups')
  int get maxPushUps;
  @override
  @JsonKey(name: 'max_squats')
  int get maxSquats;
  @override
  @JsonKey(name: 'max_reverse_snow_angels_45s')
  int get maxReverseSnowAngels45s;
  @override
  @JsonKey(name: 'plank_max_time_seconds')
  int get plankMaxTimeSeconds;
  @override
  @JsonKey(name: 'mountain_climbers_45s')
  int get mountainClimbers45s;

  /// Create a copy of FitnessTestResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FitnessTestResultsImplCopyWith<_$FitnessTestResultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
