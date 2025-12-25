// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_puzzle_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyPuzzleProgress _$DailyPuzzleProgressFromJson(Map<String, dynamic> json) {
  return _DailyPuzzleProgress.fromJson(json);
}

/// @nodoc
mixin _$DailyPuzzleProgress {
  /// Date of the puzzle (stored as ISO string)
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get puzzleDate => throw _privateConstructorUsedError;

  /// Words that have been found
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _setFromJson, toJson: _setToJson)
  Set<String> get foundWords => throw _privateConstructorUsedError;

  /// Time spent on puzzle in seconds
  int get elapsedSeconds => throw _privateConstructorUsedError;

  /// When the puzzle was started
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
  DateTime? get startedAt => throw _privateConstructorUsedError;

  /// Whether the puzzle is completed
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Final score (only set when completed)
  int? get finalScore => throw _privateConstructorUsedError;

  /// Serializes this DailyPuzzleProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyPuzzleProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPuzzleProgressCopyWith<DailyPuzzleProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPuzzleProgressCopyWith<$Res> {
  factory $DailyPuzzleProgressCopyWith(
    DailyPuzzleProgress value,
    $Res Function(DailyPuzzleProgress) then,
  ) = _$DailyPuzzleProgressCopyWithImpl<$Res, DailyPuzzleProgress>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime puzzleDate,
    @JsonKey(fromJson: _setFromJson, toJson: _setToJson) Set<String> foundWords,
    int elapsedSeconds,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    DateTime? startedAt,
    bool isCompleted,
    int? finalScore,
  });
}

/// @nodoc
class _$DailyPuzzleProgressCopyWithImpl<$Res, $Val extends DailyPuzzleProgress>
    implements $DailyPuzzleProgressCopyWith<$Res> {
  _$DailyPuzzleProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPuzzleProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? puzzleDate = null,
    Object? foundWords = null,
    Object? elapsedSeconds = null,
    Object? startedAt = freezed,
    Object? isCompleted = null,
    Object? finalScore = freezed,
  }) {
    return _then(
      _value.copyWith(
            puzzleDate: null == puzzleDate
                ? _value.puzzleDate
                : puzzleDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            foundWords: null == foundWords
                ? _value.foundWords
                : foundWords // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            elapsedSeconds: null == elapsedSeconds
                ? _value.elapsedSeconds
                : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            finalScore: freezed == finalScore
                ? _value.finalScore
                : finalScore // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyPuzzleProgressImplCopyWith<$Res>
    implements $DailyPuzzleProgressCopyWith<$Res> {
  factory _$$DailyPuzzleProgressImplCopyWith(
    _$DailyPuzzleProgressImpl value,
    $Res Function(_$DailyPuzzleProgressImpl) then,
  ) = __$$DailyPuzzleProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime puzzleDate,
    @JsonKey(fromJson: _setFromJson, toJson: _setToJson) Set<String> foundWords,
    int elapsedSeconds,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    DateTime? startedAt,
    bool isCompleted,
    int? finalScore,
  });
}

/// @nodoc
class __$$DailyPuzzleProgressImplCopyWithImpl<$Res>
    extends _$DailyPuzzleProgressCopyWithImpl<$Res, _$DailyPuzzleProgressImpl>
    implements _$$DailyPuzzleProgressImplCopyWith<$Res> {
  __$$DailyPuzzleProgressImplCopyWithImpl(
    _$DailyPuzzleProgressImpl _value,
    $Res Function(_$DailyPuzzleProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyPuzzleProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? puzzleDate = null,
    Object? foundWords = null,
    Object? elapsedSeconds = null,
    Object? startedAt = freezed,
    Object? isCompleted = null,
    Object? finalScore = freezed,
  }) {
    return _then(
      _$DailyPuzzleProgressImpl(
        puzzleDate: null == puzzleDate
            ? _value.puzzleDate
            : puzzleDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        foundWords: null == foundWords
            ? _value._foundWords
            : foundWords // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        elapsedSeconds: null == elapsedSeconds
            ? _value.elapsedSeconds
            : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        finalScore: freezed == finalScore
            ? _value.finalScore
            : finalScore // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyPuzzleProgressImpl implements _DailyPuzzleProgress {
  const _$DailyPuzzleProgressImpl({
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required this.puzzleDate,
    @JsonKey(fromJson: _setFromJson, toJson: _setToJson)
    final Set<String> foundWords = const <String>{},
    this.elapsedSeconds = 0,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    this.startedAt,
    this.isCompleted = false,
    this.finalScore,
  }) : _foundWords = foundWords;

  factory _$DailyPuzzleProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPuzzleProgressImplFromJson(json);

  /// Date of the puzzle (stored as ISO string)
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime puzzleDate;

  /// Words that have been found
  // ignore: invalid_annotation_target
  final Set<String> _foundWords;

  /// Words that have been found
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _setFromJson, toJson: _setToJson)
  Set<String> get foundWords {
    if (_foundWords is EqualUnmodifiableSetView) return _foundWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_foundWords);
  }

  /// Time spent on puzzle in seconds
  @override
  @JsonKey()
  final int elapsedSeconds;

  /// When the puzzle was started
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
  final DateTime? startedAt;

  /// Whether the puzzle is completed
  @override
  @JsonKey()
  final bool isCompleted;

  /// Final score (only set when completed)
  @override
  final int? finalScore;

  @override
  String toString() {
    return 'DailyPuzzleProgress(puzzleDate: $puzzleDate, foundWords: $foundWords, elapsedSeconds: $elapsedSeconds, startedAt: $startedAt, isCompleted: $isCompleted, finalScore: $finalScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPuzzleProgressImpl &&
            (identical(other.puzzleDate, puzzleDate) ||
                other.puzzleDate == puzzleDate) &&
            const DeepCollectionEquality().equals(
              other._foundWords,
              _foundWords,
            ) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.finalScore, finalScore) ||
                other.finalScore == finalScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    puzzleDate,
    const DeepCollectionEquality().hash(_foundWords),
    elapsedSeconds,
    startedAt,
    isCompleted,
    finalScore,
  );

  /// Create a copy of DailyPuzzleProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPuzzleProgressImplCopyWith<_$DailyPuzzleProgressImpl> get copyWith =>
      __$$DailyPuzzleProgressImplCopyWithImpl<_$DailyPuzzleProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPuzzleProgressImplToJson(this);
  }
}

abstract class _DailyPuzzleProgress implements DailyPuzzleProgress {
  const factory _DailyPuzzleProgress({
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required final DateTime puzzleDate,
    @JsonKey(fromJson: _setFromJson, toJson: _setToJson)
    final Set<String> foundWords,
    final int elapsedSeconds,
    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    final DateTime? startedAt,
    final bool isCompleted,
    final int? finalScore,
  }) = _$DailyPuzzleProgressImpl;

  factory _DailyPuzzleProgress.fromJson(Map<String, dynamic> json) =
      _$DailyPuzzleProgressImpl.fromJson;

  /// Date of the puzzle (stored as ISO string)
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get puzzleDate;

  /// Words that have been found
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _setFromJson, toJson: _setToJson)
  Set<String> get foundWords;

  /// Time spent on puzzle in seconds
  @override
  int get elapsedSeconds;

  /// When the puzzle was started
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
  DateTime? get startedAt;

  /// Whether the puzzle is completed
  @override
  bool get isCompleted;

  /// Final score (only set when completed)
  @override
  int? get finalScore;

  /// Create a copy of DailyPuzzleProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPuzzleProgressImplCopyWith<_$DailyPuzzleProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
