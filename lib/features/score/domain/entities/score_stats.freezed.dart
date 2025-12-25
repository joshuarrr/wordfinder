// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScoreStats _$ScoreStatsFromJson(Map<String, dynamic> json) {
  return _ScoreStats.fromJson(json);
}

/// @nodoc
mixin _$ScoreStats {
  int get totalLifetimeScore => throw _privateConstructorUsedError;
  int get totalGamesPlayed => throw _privateConstructorUsedError;
  int get totalWordsFound => throw _privateConstructorUsedError;
  double get averageScore => throw _privateConstructorUsedError;
  int get bestStreakHighScore => throw _privateConstructorUsedError;
  int get bestStreakDays => throw _privateConstructorUsedError;
  int get bestStreakGames => throw _privateConstructorUsedError;
  int get bestStreakPerfect =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _highScoresFromJson, toJson: _highScoresToJson)
  Map<Difficulty, int> get highScores => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _difficultyStatsFromJson, toJson: _difficultyStatsToJson)
  Map<Difficulty, DifficultyStats> get difficultyStats =>
      throw _privateConstructorUsedError;
  List<GameScore> get recentGames => throw _privateConstructorUsedError;

  /// Serializes this ScoreStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoreStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreStatsCopyWith<ScoreStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreStatsCopyWith<$Res> {
  factory $ScoreStatsCopyWith(
    ScoreStats value,
    $Res Function(ScoreStats) then,
  ) = _$ScoreStatsCopyWithImpl<$Res, ScoreStats>;
  @useResult
  $Res call({
    int totalLifetimeScore,
    int totalGamesPlayed,
    int totalWordsFound,
    double averageScore,
    int bestStreakHighScore,
    int bestStreakDays,
    int bestStreakGames,
    int bestStreakPerfect,
    @JsonKey(fromJson: _highScoresFromJson, toJson: _highScoresToJson)
    Map<Difficulty, int> highScores,
    @JsonKey(fromJson: _difficultyStatsFromJson, toJson: _difficultyStatsToJson)
    Map<Difficulty, DifficultyStats> difficultyStats,
    List<GameScore> recentGames,
  });
}

/// @nodoc
class _$ScoreStatsCopyWithImpl<$Res, $Val extends ScoreStats>
    implements $ScoreStatsCopyWith<$Res> {
  _$ScoreStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoreStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalLifetimeScore = null,
    Object? totalGamesPlayed = null,
    Object? totalWordsFound = null,
    Object? averageScore = null,
    Object? bestStreakHighScore = null,
    Object? bestStreakDays = null,
    Object? bestStreakGames = null,
    Object? bestStreakPerfect = null,
    Object? highScores = null,
    Object? difficultyStats = null,
    Object? recentGames = null,
  }) {
    return _then(
      _value.copyWith(
            totalLifetimeScore: null == totalLifetimeScore
                ? _value.totalLifetimeScore
                : totalLifetimeScore // ignore: cast_nullable_to_non_nullable
                      as int,
            totalGamesPlayed: null == totalGamesPlayed
                ? _value.totalGamesPlayed
                : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
            totalWordsFound: null == totalWordsFound
                ? _value.totalWordsFound
                : totalWordsFound // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            bestStreakHighScore: null == bestStreakHighScore
                ? _value.bestStreakHighScore
                : bestStreakHighScore // ignore: cast_nullable_to_non_nullable
                      as int,
            bestStreakDays: null == bestStreakDays
                ? _value.bestStreakDays
                : bestStreakDays // ignore: cast_nullable_to_non_nullable
                      as int,
            bestStreakGames: null == bestStreakGames
                ? _value.bestStreakGames
                : bestStreakGames // ignore: cast_nullable_to_non_nullable
                      as int,
            bestStreakPerfect: null == bestStreakPerfect
                ? _value.bestStreakPerfect
                : bestStreakPerfect // ignore: cast_nullable_to_non_nullable
                      as int,
            highScores: null == highScores
                ? _value.highScores
                : highScores // ignore: cast_nullable_to_non_nullable
                      as Map<Difficulty, int>,
            difficultyStats: null == difficultyStats
                ? _value.difficultyStats
                : difficultyStats // ignore: cast_nullable_to_non_nullable
                      as Map<Difficulty, DifficultyStats>,
            recentGames: null == recentGames
                ? _value.recentGames
                : recentGames // ignore: cast_nullable_to_non_nullable
                      as List<GameScore>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoreStatsImplCopyWith<$Res>
    implements $ScoreStatsCopyWith<$Res> {
  factory _$$ScoreStatsImplCopyWith(
    _$ScoreStatsImpl value,
    $Res Function(_$ScoreStatsImpl) then,
  ) = __$$ScoreStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalLifetimeScore,
    int totalGamesPlayed,
    int totalWordsFound,
    double averageScore,
    int bestStreakHighScore,
    int bestStreakDays,
    int bestStreakGames,
    int bestStreakPerfect,
    @JsonKey(fromJson: _highScoresFromJson, toJson: _highScoresToJson)
    Map<Difficulty, int> highScores,
    @JsonKey(fromJson: _difficultyStatsFromJson, toJson: _difficultyStatsToJson)
    Map<Difficulty, DifficultyStats> difficultyStats,
    List<GameScore> recentGames,
  });
}

/// @nodoc
class __$$ScoreStatsImplCopyWithImpl<$Res>
    extends _$ScoreStatsCopyWithImpl<$Res, _$ScoreStatsImpl>
    implements _$$ScoreStatsImplCopyWith<$Res> {
  __$$ScoreStatsImplCopyWithImpl(
    _$ScoreStatsImpl _value,
    $Res Function(_$ScoreStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoreStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalLifetimeScore = null,
    Object? totalGamesPlayed = null,
    Object? totalWordsFound = null,
    Object? averageScore = null,
    Object? bestStreakHighScore = null,
    Object? bestStreakDays = null,
    Object? bestStreakGames = null,
    Object? bestStreakPerfect = null,
    Object? highScores = null,
    Object? difficultyStats = null,
    Object? recentGames = null,
  }) {
    return _then(
      _$ScoreStatsImpl(
        totalLifetimeScore: null == totalLifetimeScore
            ? _value.totalLifetimeScore
            : totalLifetimeScore // ignore: cast_nullable_to_non_nullable
                  as int,
        totalGamesPlayed: null == totalGamesPlayed
            ? _value.totalGamesPlayed
            : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
        totalWordsFound: null == totalWordsFound
            ? _value.totalWordsFound
            : totalWordsFound // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        bestStreakHighScore: null == bestStreakHighScore
            ? _value.bestStreakHighScore
            : bestStreakHighScore // ignore: cast_nullable_to_non_nullable
                  as int,
        bestStreakDays: null == bestStreakDays
            ? _value.bestStreakDays
            : bestStreakDays // ignore: cast_nullable_to_non_nullable
                  as int,
        bestStreakGames: null == bestStreakGames
            ? _value.bestStreakGames
            : bestStreakGames // ignore: cast_nullable_to_non_nullable
                  as int,
        bestStreakPerfect: null == bestStreakPerfect
            ? _value.bestStreakPerfect
            : bestStreakPerfect // ignore: cast_nullable_to_non_nullable
                  as int,
        highScores: null == highScores
            ? _value._highScores
            : highScores // ignore: cast_nullable_to_non_nullable
                  as Map<Difficulty, int>,
        difficultyStats: null == difficultyStats
            ? _value._difficultyStats
            : difficultyStats // ignore: cast_nullable_to_non_nullable
                  as Map<Difficulty, DifficultyStats>,
        recentGames: null == recentGames
            ? _value._recentGames
            : recentGames // ignore: cast_nullable_to_non_nullable
                  as List<GameScore>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreStatsImpl implements _ScoreStats {
  const _$ScoreStatsImpl({
    required this.totalLifetimeScore,
    required this.totalGamesPlayed,
    required this.totalWordsFound,
    required this.averageScore,
    required this.bestStreakHighScore,
    required this.bestStreakDays,
    required this.bestStreakGames,
    required this.bestStreakPerfect,
    @JsonKey(fromJson: _highScoresFromJson, toJson: _highScoresToJson)
    required final Map<Difficulty, int> highScores,
    @JsonKey(fromJson: _difficultyStatsFromJson, toJson: _difficultyStatsToJson)
    required final Map<Difficulty, DifficultyStats> difficultyStats,
    required final List<GameScore> recentGames,
  }) : _highScores = highScores,
       _difficultyStats = difficultyStats,
       _recentGames = recentGames;

  factory _$ScoreStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreStatsImplFromJson(json);

  @override
  final int totalLifetimeScore;
  @override
  final int totalGamesPlayed;
  @override
  final int totalWordsFound;
  @override
  final double averageScore;
  @override
  final int bestStreakHighScore;
  @override
  final int bestStreakDays;
  @override
  final int bestStreakGames;
  @override
  final int bestStreakPerfect;
  // ignore: invalid_annotation_target
  final Map<Difficulty, int> _highScores;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _highScoresFromJson, toJson: _highScoresToJson)
  Map<Difficulty, int> get highScores {
    if (_highScores is EqualUnmodifiableMapView) return _highScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_highScores);
  }

  // ignore: invalid_annotation_target
  final Map<Difficulty, DifficultyStats> _difficultyStats;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _difficultyStatsFromJson, toJson: _difficultyStatsToJson)
  Map<Difficulty, DifficultyStats> get difficultyStats {
    if (_difficultyStats is EqualUnmodifiableMapView) return _difficultyStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_difficultyStats);
  }

  final List<GameScore> _recentGames;
  @override
  List<GameScore> get recentGames {
    if (_recentGames is EqualUnmodifiableListView) return _recentGames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentGames);
  }

  @override
  String toString() {
    return 'ScoreStats(totalLifetimeScore: $totalLifetimeScore, totalGamesPlayed: $totalGamesPlayed, totalWordsFound: $totalWordsFound, averageScore: $averageScore, bestStreakHighScore: $bestStreakHighScore, bestStreakDays: $bestStreakDays, bestStreakGames: $bestStreakGames, bestStreakPerfect: $bestStreakPerfect, highScores: $highScores, difficultyStats: $difficultyStats, recentGames: $recentGames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreStatsImpl &&
            (identical(other.totalLifetimeScore, totalLifetimeScore) ||
                other.totalLifetimeScore == totalLifetimeScore) &&
            (identical(other.totalGamesPlayed, totalGamesPlayed) ||
                other.totalGamesPlayed == totalGamesPlayed) &&
            (identical(other.totalWordsFound, totalWordsFound) ||
                other.totalWordsFound == totalWordsFound) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.bestStreakHighScore, bestStreakHighScore) ||
                other.bestStreakHighScore == bestStreakHighScore) &&
            (identical(other.bestStreakDays, bestStreakDays) ||
                other.bestStreakDays == bestStreakDays) &&
            (identical(other.bestStreakGames, bestStreakGames) ||
                other.bestStreakGames == bestStreakGames) &&
            (identical(other.bestStreakPerfect, bestStreakPerfect) ||
                other.bestStreakPerfect == bestStreakPerfect) &&
            const DeepCollectionEquality().equals(
              other._highScores,
              _highScores,
            ) &&
            const DeepCollectionEquality().equals(
              other._difficultyStats,
              _difficultyStats,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentGames,
              _recentGames,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalLifetimeScore,
    totalGamesPlayed,
    totalWordsFound,
    averageScore,
    bestStreakHighScore,
    bestStreakDays,
    bestStreakGames,
    bestStreakPerfect,
    const DeepCollectionEquality().hash(_highScores),
    const DeepCollectionEquality().hash(_difficultyStats),
    const DeepCollectionEquality().hash(_recentGames),
  );

  /// Create a copy of ScoreStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreStatsImplCopyWith<_$ScoreStatsImpl> get copyWith =>
      __$$ScoreStatsImplCopyWithImpl<_$ScoreStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreStatsImplToJson(this);
  }
}

abstract class _ScoreStats implements ScoreStats {
  const factory _ScoreStats({
    required final int totalLifetimeScore,
    required final int totalGamesPlayed,
    required final int totalWordsFound,
    required final double averageScore,
    required final int bestStreakHighScore,
    required final int bestStreakDays,
    required final int bestStreakGames,
    required final int bestStreakPerfect,
    @JsonKey(fromJson: _highScoresFromJson, toJson: _highScoresToJson)
    required final Map<Difficulty, int> highScores,
    @JsonKey(fromJson: _difficultyStatsFromJson, toJson: _difficultyStatsToJson)
    required final Map<Difficulty, DifficultyStats> difficultyStats,
    required final List<GameScore> recentGames,
  }) = _$ScoreStatsImpl;

  factory _ScoreStats.fromJson(Map<String, dynamic> json) =
      _$ScoreStatsImpl.fromJson;

  @override
  int get totalLifetimeScore;
  @override
  int get totalGamesPlayed;
  @override
  int get totalWordsFound;
  @override
  double get averageScore;
  @override
  int get bestStreakHighScore;
  @override
  int get bestStreakDays;
  @override
  int get bestStreakGames;
  @override
  int get bestStreakPerfect; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _highScoresFromJson, toJson: _highScoresToJson)
  Map<Difficulty, int> get highScores; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _difficultyStatsFromJson, toJson: _difficultyStatsToJson)
  Map<Difficulty, DifficultyStats> get difficultyStats;
  @override
  List<GameScore> get recentGames;

  /// Create a copy of ScoreStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreStatsImplCopyWith<_$ScoreStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DifficultyStats _$DifficultyStatsFromJson(Map<String, dynamic> json) {
  return _DifficultyStats.fromJson(json);
}

/// @nodoc
mixin _$DifficultyStats {
  int get gamesPlayed => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  double get averageScore => throw _privateConstructorUsedError;
  int get highScore => throw _privateConstructorUsedError;
  int get bestStreakHighScore => throw _privateConstructorUsedError;
  int get bestStreakPerfect => throw _privateConstructorUsedError;
  int? get bestTimeSeconds => throw _privateConstructorUsedError;

  /// Serializes this DifficultyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DifficultyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DifficultyStatsCopyWith<DifficultyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DifficultyStatsCopyWith<$Res> {
  factory $DifficultyStatsCopyWith(
    DifficultyStats value,
    $Res Function(DifficultyStats) then,
  ) = _$DifficultyStatsCopyWithImpl<$Res, DifficultyStats>;
  @useResult
  $Res call({
    int gamesPlayed,
    int totalScore,
    double averageScore,
    int highScore,
    int bestStreakHighScore,
    int bestStreakPerfect,
    int? bestTimeSeconds,
  });
}

/// @nodoc
class _$DifficultyStatsCopyWithImpl<$Res, $Val extends DifficultyStats>
    implements $DifficultyStatsCopyWith<$Res> {
  _$DifficultyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DifficultyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gamesPlayed = null,
    Object? totalScore = null,
    Object? averageScore = null,
    Object? highScore = null,
    Object? bestStreakHighScore = null,
    Object? bestStreakPerfect = null,
    Object? bestTimeSeconds = freezed,
  }) {
    return _then(
      _value.copyWith(
            gamesPlayed: null == gamesPlayed
                ? _value.gamesPlayed
                : gamesPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            highScore: null == highScore
                ? _value.highScore
                : highScore // ignore: cast_nullable_to_non_nullable
                      as int,
            bestStreakHighScore: null == bestStreakHighScore
                ? _value.bestStreakHighScore
                : bestStreakHighScore // ignore: cast_nullable_to_non_nullable
                      as int,
            bestStreakPerfect: null == bestStreakPerfect
                ? _value.bestStreakPerfect
                : bestStreakPerfect // ignore: cast_nullable_to_non_nullable
                      as int,
            bestTimeSeconds: freezed == bestTimeSeconds
                ? _value.bestTimeSeconds
                : bestTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DifficultyStatsImplCopyWith<$Res>
    implements $DifficultyStatsCopyWith<$Res> {
  factory _$$DifficultyStatsImplCopyWith(
    _$DifficultyStatsImpl value,
    $Res Function(_$DifficultyStatsImpl) then,
  ) = __$$DifficultyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int gamesPlayed,
    int totalScore,
    double averageScore,
    int highScore,
    int bestStreakHighScore,
    int bestStreakPerfect,
    int? bestTimeSeconds,
  });
}

/// @nodoc
class __$$DifficultyStatsImplCopyWithImpl<$Res>
    extends _$DifficultyStatsCopyWithImpl<$Res, _$DifficultyStatsImpl>
    implements _$$DifficultyStatsImplCopyWith<$Res> {
  __$$DifficultyStatsImplCopyWithImpl(
    _$DifficultyStatsImpl _value,
    $Res Function(_$DifficultyStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DifficultyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gamesPlayed = null,
    Object? totalScore = null,
    Object? averageScore = null,
    Object? highScore = null,
    Object? bestStreakHighScore = null,
    Object? bestStreakPerfect = null,
    Object? bestTimeSeconds = freezed,
  }) {
    return _then(
      _$DifficultyStatsImpl(
        gamesPlayed: null == gamesPlayed
            ? _value.gamesPlayed
            : gamesPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        highScore: null == highScore
            ? _value.highScore
            : highScore // ignore: cast_nullable_to_non_nullable
                  as int,
        bestStreakHighScore: null == bestStreakHighScore
            ? _value.bestStreakHighScore
            : bestStreakHighScore // ignore: cast_nullable_to_non_nullable
                  as int,
        bestStreakPerfect: null == bestStreakPerfect
            ? _value.bestStreakPerfect
            : bestStreakPerfect // ignore: cast_nullable_to_non_nullable
                  as int,
        bestTimeSeconds: freezed == bestTimeSeconds
            ? _value.bestTimeSeconds
            : bestTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DifficultyStatsImpl implements _DifficultyStats {
  const _$DifficultyStatsImpl({
    required this.gamesPlayed,
    required this.totalScore,
    required this.averageScore,
    required this.highScore,
    required this.bestStreakHighScore,
    required this.bestStreakPerfect,
    required this.bestTimeSeconds,
  });

  factory _$DifficultyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DifficultyStatsImplFromJson(json);

  @override
  final int gamesPlayed;
  @override
  final int totalScore;
  @override
  final double averageScore;
  @override
  final int highScore;
  @override
  final int bestStreakHighScore;
  @override
  final int bestStreakPerfect;
  @override
  final int? bestTimeSeconds;

  @override
  String toString() {
    return 'DifficultyStats(gamesPlayed: $gamesPlayed, totalScore: $totalScore, averageScore: $averageScore, highScore: $highScore, bestStreakHighScore: $bestStreakHighScore, bestStreakPerfect: $bestStreakPerfect, bestTimeSeconds: $bestTimeSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DifficultyStatsImpl &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                other.gamesPlayed == gamesPlayed) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.highScore, highScore) ||
                other.highScore == highScore) &&
            (identical(other.bestStreakHighScore, bestStreakHighScore) ||
                other.bestStreakHighScore == bestStreakHighScore) &&
            (identical(other.bestStreakPerfect, bestStreakPerfect) ||
                other.bestStreakPerfect == bestStreakPerfect) &&
            (identical(other.bestTimeSeconds, bestTimeSeconds) ||
                other.bestTimeSeconds == bestTimeSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gamesPlayed,
    totalScore,
    averageScore,
    highScore,
    bestStreakHighScore,
    bestStreakPerfect,
    bestTimeSeconds,
  );

  /// Create a copy of DifficultyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DifficultyStatsImplCopyWith<_$DifficultyStatsImpl> get copyWith =>
      __$$DifficultyStatsImplCopyWithImpl<_$DifficultyStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DifficultyStatsImplToJson(this);
  }
}

abstract class _DifficultyStats implements DifficultyStats {
  const factory _DifficultyStats({
    required final int gamesPlayed,
    required final int totalScore,
    required final double averageScore,
    required final int highScore,
    required final int bestStreakHighScore,
    required final int bestStreakPerfect,
    required final int? bestTimeSeconds,
  }) = _$DifficultyStatsImpl;

  factory _DifficultyStats.fromJson(Map<String, dynamic> json) =
      _$DifficultyStatsImpl.fromJson;

  @override
  int get gamesPlayed;
  @override
  int get totalScore;
  @override
  double get averageScore;
  @override
  int get highScore;
  @override
  int get bestStreakHighScore;
  @override
  int get bestStreakPerfect;
  @override
  int? get bestTimeSeconds;

  /// Create a copy of DifficultyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DifficultyStatsImplCopyWith<_$DifficultyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
