// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameState {
  Puzzle get puzzle => throw _privateConstructorUsedError;
  Set<String> get foundWords => throw _privateConstructorUsedError;
  List<(int, int)> get selectedPath => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get hintsUsed => throw _privateConstructorUsedError;
  bool get isPaused => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  bool get hasError => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  String? get lastFoundWord => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    Puzzle puzzle,
    Set<String> foundWords,
    List<(int, int)> selectedPath,
    int elapsedSeconds,
    int hintsUsed,
    bool isPaused,
    bool isCompleted,
    bool hasError,
    DateTime? startedAt,
    String? lastFoundWord,
  });
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? puzzle = null,
    Object? foundWords = null,
    Object? selectedPath = null,
    Object? elapsedSeconds = null,
    Object? hintsUsed = null,
    Object? isPaused = null,
    Object? isCompleted = null,
    Object? hasError = null,
    Object? startedAt = freezed,
    Object? lastFoundWord = freezed,
  }) {
    return _then(
      _value.copyWith(
            puzzle: null == puzzle
                ? _value.puzzle
                : puzzle // ignore: cast_nullable_to_non_nullable
                      as Puzzle,
            foundWords: null == foundWords
                ? _value.foundWords
                : foundWords // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            selectedPath: null == selectedPath
                ? _value.selectedPath
                : selectedPath // ignore: cast_nullable_to_non_nullable
                      as List<(int, int)>,
            elapsedSeconds: null == elapsedSeconds
                ? _value.elapsedSeconds
                : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            hintsUsed: null == hintsUsed
                ? _value.hintsUsed
                : hintsUsed // ignore: cast_nullable_to_non_nullable
                      as int,
            isPaused: null == isPaused
                ? _value.isPaused
                : isPaused // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasError: null == hasError
                ? _value.hasError
                : hasError // ignore: cast_nullable_to_non_nullable
                      as bool,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastFoundWord: freezed == lastFoundWord
                ? _value.lastFoundWord
                : lastFoundWord // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Puzzle puzzle,
    Set<String> foundWords,
    List<(int, int)> selectedPath,
    int elapsedSeconds,
    int hintsUsed,
    bool isPaused,
    bool isCompleted,
    bool hasError,
    DateTime? startedAt,
    String? lastFoundWord,
  });
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? puzzle = null,
    Object? foundWords = null,
    Object? selectedPath = null,
    Object? elapsedSeconds = null,
    Object? hintsUsed = null,
    Object? isPaused = null,
    Object? isCompleted = null,
    Object? hasError = null,
    Object? startedAt = freezed,
    Object? lastFoundWord = freezed,
  }) {
    return _then(
      _$GameStateImpl(
        puzzle: null == puzzle
            ? _value.puzzle
            : puzzle // ignore: cast_nullable_to_non_nullable
                  as Puzzle,
        foundWords: null == foundWords
            ? _value._foundWords
            : foundWords // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        selectedPath: null == selectedPath
            ? _value._selectedPath
            : selectedPath // ignore: cast_nullable_to_non_nullable
                  as List<(int, int)>,
        elapsedSeconds: null == elapsedSeconds
            ? _value.elapsedSeconds
            : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        hintsUsed: null == hintsUsed
            ? _value.hintsUsed
            : hintsUsed // ignore: cast_nullable_to_non_nullable
                  as int,
        isPaused: null == isPaused
            ? _value.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasError: null == hasError
            ? _value.hasError
            : hasError // ignore: cast_nullable_to_non_nullable
                  as bool,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastFoundWord: freezed == lastFoundWord
            ? _value.lastFoundWord
            : lastFoundWord // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$GameStateImpl extends _GameState {
  const _$GameStateImpl({
    required this.puzzle,
    required final Set<String> foundWords,
    required final List<(int, int)> selectedPath,
    required this.elapsedSeconds,
    required this.hintsUsed,
    required this.isPaused,
    required this.isCompleted,
    required this.hasError,
    this.startedAt,
    this.lastFoundWord,
  }) : _foundWords = foundWords,
       _selectedPath = selectedPath,
       super._();

  @override
  final Puzzle puzzle;
  final Set<String> _foundWords;
  @override
  Set<String> get foundWords {
    if (_foundWords is EqualUnmodifiableSetView) return _foundWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_foundWords);
  }

  final List<(int, int)> _selectedPath;
  @override
  List<(int, int)> get selectedPath {
    if (_selectedPath is EqualUnmodifiableListView) return _selectedPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedPath);
  }

  @override
  final int elapsedSeconds;
  @override
  final int hintsUsed;
  @override
  final bool isPaused;
  @override
  final bool isCompleted;
  @override
  final bool hasError;
  @override
  final DateTime? startedAt;
  @override
  final String? lastFoundWord;

  @override
  String toString() {
    return 'GameState(puzzle: $puzzle, foundWords: $foundWords, selectedPath: $selectedPath, elapsedSeconds: $elapsedSeconds, hintsUsed: $hintsUsed, isPaused: $isPaused, isCompleted: $isCompleted, hasError: $hasError, startedAt: $startedAt, lastFoundWord: $lastFoundWord)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.puzzle, puzzle) || other.puzzle == puzzle) &&
            const DeepCollectionEquality().equals(
              other._foundWords,
              _foundWords,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedPath,
              _selectedPath,
            ) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.hintsUsed, hintsUsed) ||
                other.hintsUsed == hintsUsed) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.lastFoundWord, lastFoundWord) ||
                other.lastFoundWord == lastFoundWord));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    puzzle,
    const DeepCollectionEquality().hash(_foundWords),
    const DeepCollectionEquality().hash(_selectedPath),
    elapsedSeconds,
    hintsUsed,
    isPaused,
    isCompleted,
    hasError,
    startedAt,
    lastFoundWord,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState extends GameState {
  const factory _GameState({
    required final Puzzle puzzle,
    required final Set<String> foundWords,
    required final List<(int, int)> selectedPath,
    required final int elapsedSeconds,
    required final int hintsUsed,
    required final bool isPaused,
    required final bool isCompleted,
    required final bool hasError,
    final DateTime? startedAt,
    final String? lastFoundWord,
  }) = _$GameStateImpl;
  const _GameState._() : super._();

  @override
  Puzzle get puzzle;
  @override
  Set<String> get foundWords;
  @override
  List<(int, int)> get selectedPath;
  @override
  int get elapsedSeconds;
  @override
  int get hintsUsed;
  @override
  bool get isPaused;
  @override
  bool get isCompleted;
  @override
  bool get hasError;
  @override
  DateTime? get startedAt;
  @override
  String? get lastFoundWord;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
