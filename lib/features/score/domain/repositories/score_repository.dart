import '../entities/game_score.dart';
import '../entities/score_stats.dart';
import '../../../../core/constants/app_constants.dart';

/// Repository interface for score management
abstract class ScoreRepository {
  /// Save a completed game score
  Future<void> saveScore(GameScore score);

  /// Get all statistics
  Future<ScoreStats> getStats();

  /// Get cumulative lifetime score
  Future<int> getCumulativeScore();

  /// Get high score for a specific difficulty
  Future<int?> getHighScore(Difficulty difficulty);

  /// Get recent games (default limit: 50)
  Future<List<GameScore>> getRecentGames({int limit = 50});

  /// Clear all score data (for dev/testing)
  Future<void> clearAllScores();
}

