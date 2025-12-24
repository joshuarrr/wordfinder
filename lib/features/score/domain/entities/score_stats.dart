import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import 'game_score.dart';

part 'score_stats.freezed.dart';
part 'score_stats.g.dart';

/// Aggregated score statistics
@freezed
class ScoreStats with _$ScoreStats {
  const factory ScoreStats({
    required int totalLifetimeScore,
    required int totalGamesPlayed,
    required int totalWordsFound,
    required double averageScore,
    required int bestStreakHighScore,
    required int bestStreakDays,
    required int bestStreakGames,
    required int bestStreakPerfect,
    // ignore: invalid_annotation_target
    @JsonKey(
      fromJson: _highScoresFromJson,
      toJson: _highScoresToJson,
    )
    required Map<Difficulty, int> highScores,
    // ignore: invalid_annotation_target
    @JsonKey(
      fromJson: _difficultyStatsFromJson,
      toJson: _difficultyStatsToJson,
    )
    required Map<Difficulty, DifficultyStats> difficultyStats,
    required List<GameScore> recentGames,
  }) = _ScoreStats;

  factory ScoreStats.fromJson(Map<String, dynamic> json) =>
      _$ScoreStatsFromJson(json);
}

/// Statistics for a specific difficulty level
@freezed
class DifficultyStats with _$DifficultyStats {
  const factory DifficultyStats({
    required int gamesPlayed,
    required int totalScore,
    required double averageScore,
    required int highScore,
    required int bestStreakHighScore,
    required int bestStreakPerfect,
    required int? bestTimeSeconds,
  }) = _DifficultyStats;

  factory DifficultyStats.fromJson(Map<String, dynamic> json) =>
      _$DifficultyStatsFromJson(json);
}

Map<Difficulty, int> _highScoresFromJson(Map<String, dynamic> json) {
  return json.map((key, value) {
    final difficulty = Difficulty.values.firstWhere(
      (d) => d.name == key,
      orElse: () => Difficulty.easy,
    );
    return MapEntry(difficulty, value as int);
  });
}

Map<String, dynamic> _highScoresToJson(Map<Difficulty, int> scores) {
  return scores.map((key, value) => MapEntry(key.name, value));
}

Map<Difficulty, DifficultyStats> _difficultyStatsFromJson(
  Map<String, dynamic> json,
) {
  return json.map((key, value) {
    final difficulty = Difficulty.values.firstWhere(
      (d) => d.name == key,
      orElse: () => Difficulty.easy,
    );
    return MapEntry(
      difficulty,
      DifficultyStats.fromJson(value as Map<String, dynamic>),
    );
  });
}

Map<String, dynamic> _difficultyStatsToJson(
  Map<Difficulty, DifficultyStats> stats,
) {
  return stats.map((key, value) => MapEntry(key.name, value.toJson()));
}

