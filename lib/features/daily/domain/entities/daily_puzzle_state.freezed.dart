// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_puzzle_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyPuzzleStats _$DailyPuzzleStatsFromJson(Map<String, dynamic> json) {
  return _DailyPuzzleStats.fromJson(json);
}

/// @nodoc
mixin _$DailyPuzzleStats {
  /// Current daily puzzle streak (consecutive days completed)
  int get currentStreak => throw _privateConstructorUsedError;

  /// Best daily puzzle streak ever
  int get bestStreak => throw _privateConstructorUsedError;

  /// Total daily puzzles completed
  int get totalCompleted => throw _privateConstructorUsedError;

  /// Last completion date (for streak calculation)
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
  DateTime? get lastCompletionDate => throw _privateConstructorUsedError;

  /// Best score on daily puzzles
  int get bestScore => throw _privateConstructorUsedError;

  /// Total score from all daily puzzles
  int get totalScore => throw _privateConstructorUsedError;

  /// Serializes this DailyPuzzleStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyPuzzleStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPuzzleStatsCopyWith<DailyPuzzleStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPuzzleStatsCopyWith<$Res> {
  factory $DailyPuzzleStatsCopyWith(
    DailyPuzzleStats value,
    $Res Function(DailyPuzzleStats) then,
  ) = _$DailyPuzzleStatsCopyWithImpl<$Res, DailyPuzzleStats>;
  @useResult
  $Res call({
    int currentStreak,
    int bestStreak,
    int totalCompleted,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    DateTime? lastCompletionDate,
    int bestScore,
    int totalScore,
  });
}

/// @nodoc
class _$DailyPuzzleStatsCopyWithImpl<$Res, $Val extends DailyPuzzleStats>
    implements $DailyPuzzleStatsCopyWith<$Res> {
  _$DailyPuzzleStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPuzzleStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? bestStreak = null,
    Object? totalCompleted = null,
    Object? lastCompletionDate = freezed,
    Object? bestScore = null,
    Object? totalScore = null,
  }) {
    return _then(
      _value.copyWith(
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            bestStreak: null == bestStreak
                ? _value.bestStreak
                : bestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCompleted: null == totalCompleted
                ? _value.totalCompleted
                : totalCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            lastCompletionDate: freezed == lastCompletionDate
                ? _value.lastCompletionDate
                : lastCompletionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            bestScore: null == bestScore
                ? _value.bestScore
                : bestScore // ignore: cast_nullable_to_non_nullable
                      as int,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyPuzzleStatsImplCopyWith<$Res>
    implements $DailyPuzzleStatsCopyWith<$Res> {
  factory _$$DailyPuzzleStatsImplCopyWith(
    _$DailyPuzzleStatsImpl value,
    $Res Function(_$DailyPuzzleStatsImpl) then,
  ) = __$$DailyPuzzleStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStreak,
    int bestStreak,
    int totalCompleted,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    DateTime? lastCompletionDate,
    int bestScore,
    int totalScore,
  });
}

/// @nodoc
class __$$DailyPuzzleStatsImplCopyWithImpl<$Res>
    extends _$DailyPuzzleStatsCopyWithImpl<$Res, _$DailyPuzzleStatsImpl>
    implements _$$DailyPuzzleStatsImplCopyWith<$Res> {
  __$$DailyPuzzleStatsImplCopyWithImpl(
    _$DailyPuzzleStatsImpl _value,
    $Res Function(_$DailyPuzzleStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyPuzzleStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? bestStreak = null,
    Object? totalCompleted = null,
    Object? lastCompletionDate = freezed,
    Object? bestScore = null,
    Object? totalScore = null,
  }) {
    return _then(
      _$DailyPuzzleStatsImpl(
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        bestStreak: null == bestStreak
            ? _value.bestStreak
            : bestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCompleted: null == totalCompleted
            ? _value.totalCompleted
            : totalCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        lastCompletionDate: freezed == lastCompletionDate
            ? _value.lastCompletionDate
            : lastCompletionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        bestScore: null == bestScore
            ? _value.bestScore
            : bestScore // ignore: cast_nullable_to_non_nullable
                  as int,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyPuzzleStatsImpl implements _DailyPuzzleStats {
  const _$DailyPuzzleStatsImpl({
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalCompleted = 0,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    this.lastCompletionDate,
    this.bestScore = 0,
    this.totalScore = 0,
  });

  factory _$DailyPuzzleStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPuzzleStatsImplFromJson(json);

  /// Current daily puzzle streak (consecutive days completed)
  @override
  @JsonKey()
  final int currentStreak;

  /// Best daily puzzle streak ever
  @override
  @JsonKey()
  final int bestStreak;

  /// Total daily puzzles completed
  @override
  @JsonKey()
  final int totalCompleted;

  /// Last completion date (for streak calculation)
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
  final DateTime? lastCompletionDate;

  /// Best score on daily puzzles
  @override
  @JsonKey()
  final int bestScore;

  /// Total score from all daily puzzles
  @override
  @JsonKey()
  final int totalScore;

  @override
  String toString() {
    return 'DailyPuzzleStats(currentStreak: $currentStreak, bestStreak: $bestStreak, totalCompleted: $totalCompleted, lastCompletionDate: $lastCompletionDate, bestScore: $bestScore, totalScore: $totalScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPuzzleStatsImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.bestStreak, bestStreak) ||
                other.bestStreak == bestStreak) &&
            (identical(other.totalCompleted, totalCompleted) ||
                other.totalCompleted == totalCompleted) &&
            (identical(other.lastCompletionDate, lastCompletionDate) ||
                other.lastCompletionDate == lastCompletionDate) &&
            (identical(other.bestScore, bestScore) ||
                other.bestScore == bestScore) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStreak,
    bestStreak,
    totalCompleted,
    lastCompletionDate,
    bestScore,
    totalScore,
  );

  /// Create a copy of DailyPuzzleStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPuzzleStatsImplCopyWith<_$DailyPuzzleStatsImpl> get copyWith =>
      __$$DailyPuzzleStatsImplCopyWithImpl<_$DailyPuzzleStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPuzzleStatsImplToJson(this);
  }
}

abstract class _DailyPuzzleStats implements DailyPuzzleStats {
  const factory _DailyPuzzleStats({
    final int currentStreak,
    final int bestStreak,
    final int totalCompleted,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    final DateTime? lastCompletionDate,
    final int bestScore,
    final int totalScore,
  }) = _$DailyPuzzleStatsImpl;

  factory _DailyPuzzleStats.fromJson(Map<String, dynamic> json) =
      _$DailyPuzzleStatsImpl.fromJson;

  /// Current daily puzzle streak (consecutive days completed)
  @override
  int get currentStreak;

  /// Best daily puzzle streak ever
  @override
  int get bestStreak;

  /// Total daily puzzles completed
  @override
  int get totalCompleted;

  /// Last completion date (for streak calculation)
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
  DateTime? get lastCompletionDate;

  /// Best score on daily puzzles
  @override
  int get bestScore;

  /// Total score from all daily puzzles
  @override
  int get totalScore;

  /// Create a copy of DailyPuzzleStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPuzzleStatsImplCopyWith<_$DailyPuzzleStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
