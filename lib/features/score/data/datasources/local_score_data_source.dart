import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/game_score.dart';
import '../../domain/entities/score_stats.dart';
import '../../../../core/constants/app_constants.dart';

/// Local data source for score persistence using shared_preferences
class LocalScoreDataSource {
  static const String _keyTotalLifetimeScore = 'total_lifetime_score';
  static const String _keyTotalGamesPlayed = 'total_games_played';
  static const String _keyTotalWordsFound = 'total_words_found';
  static const String _keyHighScores = 'high_scores';
  static const String _keyRecentGames = 'recent_games';
  static const String _keyDifficultyStats = 'difficulty_stats';
  static const String _keyBestStreakHighScore = 'best_streak_high_score';
  static const String _keyBestStreakDays = 'best_streak_days';
  static const String _keyBestStreakGames = 'best_streak_games';
  static const String _keyBestStreakPerfect = 'best_streak_perfect';
  static const String _keyLastPlayDate = 'last_play_date';

  final SharedPreferences _prefs;

  LocalScoreDataSource(this._prefs);

  /// Get total lifetime score
  Future<int> getTotalLifetimeScore() async {
    return _prefs.getInt(_keyTotalLifetimeScore) ?? 0;
  }

  /// Set total lifetime score
  Future<void> setTotalLifetimeScore(int score) async {
    await _prefs.setInt(_keyTotalLifetimeScore, score);
  }

  /// Get total games played
  Future<int> getTotalGamesPlayed() async {
    return _prefs.getInt(_keyTotalGamesPlayed) ?? 0;
  }

  /// Increment total games played
  Future<void> incrementTotalGamesPlayed() async {
    final current = await getTotalGamesPlayed();
    await _prefs.setInt(_keyTotalGamesPlayed, current + 1);
  }

  /// Get total words found
  Future<int> getTotalWordsFound() async {
    return _prefs.getInt(_keyTotalWordsFound) ?? 0;
  }

  /// Add to total words found
  Future<void> addToTotalWordsFound(int count) async {
    final current = await getTotalWordsFound();
    await _prefs.setInt(_keyTotalWordsFound, current + count);
  }

  /// Get high scores map
  Future<Map<Difficulty, int>> getHighScores() async {
    final json = _prefs.getString(_keyHighScores);
    if (json == null) return {};
    
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map.map((key, value) {
        final difficulty = Difficulty.values.firstWhere(
          (d) => d.name == key,
          orElse: () => Difficulty.easy,
        );
        return MapEntry(difficulty, value as int);
      });
    } catch (e) {
      return {};
    }
  }

  /// Set high scores map
  Future<void> setHighScores(Map<Difficulty, int> scores) async {
    final map = scores.map((key, value) => MapEntry(key.name, value));
    await _prefs.setString(_keyHighScores, jsonEncode(map));
  }

  /// Get recent games list
  Future<List<GameScore>> getRecentGames({int limit = 50}) async {
    final json = _prefs.getString(_keyRecentGames);
    if (json == null) return [];
    
    try {
      final list = jsonDecode(json) as List<dynamic>;
      final games = list
          .map((e) => GameScore.fromJson(e as Map<String, dynamic>))
          .toList();
      return games.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add game to recent games list (rotates if > 50)
  Future<void> addRecentGame(GameScore game) async {
    final games = await getRecentGames(limit: 100);
    games.insert(0, game);
    final limited = games.take(50).toList();
    
    final json = jsonEncode(
      limited.map((g) => g.toJson()).toList(),
    );
    await _prefs.setString(_keyRecentGames, json);
  }

  /// Get difficulty stats map
  Future<Map<Difficulty, DifficultyStats>> getDifficultyStats() async {
    final json = _prefs.getString(_keyDifficultyStats);
    if (json == null) return {};
    
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map.map((key, value) {
        final difficulty = Difficulty.values.firstWhere(
          (d) => d.name == key,
          orElse: () => Difficulty.easy,
        );
        return MapEntry(
          difficulty,
          DifficultyStats.fromJson(value as Map<String, dynamic>),
        );
      });
    } catch (e) {
      return {};
    }
  }

  /// Set difficulty stats map
  Future<void> setDifficultyStats(
    Map<Difficulty, DifficultyStats> stats,
  ) async {
    final map = stats.map((key, value) => MapEntry(key.name, value.toJson()));
    await _prefs.setString(_keyDifficultyStats, jsonEncode(map));
  }

  /// Get best streak (high score)
  Future<int> getBestStreakHighScore() async {
    return _prefs.getInt(_keyBestStreakHighScore) ?? 0;
  }

  /// Set best streak (high score)
  Future<void> setBestStreakHighScore(int streak) async {
    await _prefs.setInt(_keyBestStreakHighScore, streak);
  }

  /// Get best streak (days)
  Future<int> getBestStreakDays() async {
    return _prefs.getInt(_keyBestStreakDays) ?? 0;
  }

  /// Set best streak (days)
  Future<void> setBestStreakDays(int streak) async {
    await _prefs.setInt(_keyBestStreakDays, streak);
  }

  /// Get best streak (games)
  Future<int> getBestStreakGames() async {
    return _prefs.getInt(_keyBestStreakGames) ?? 0;
  }

  /// Set best streak (games)
  Future<void> setBestStreakGames(int streak) async {
    await _prefs.setInt(_keyBestStreakGames, streak);
  }

  /// Get best streak (perfect)
  Future<int> getBestStreakPerfect() async {
    return _prefs.getInt(_keyBestStreakPerfect) ?? 0;
  }

  /// Set best streak (perfect)
  Future<void> setBestStreakPerfect(int streak) async {
    await _prefs.setInt(_keyBestStreakPerfect, streak);
  }

  /// Get last play date
  Future<DateTime?> getLastPlayDate() async {
    final dateString = _prefs.getString(_keyLastPlayDate);
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Set last play date
  Future<void> setLastPlayDate(DateTime date) async {
    await _prefs.setString(_keyLastPlayDate, date.toIso8601String());
  }

  /// Clear all score data
  Future<void> clearAll() async {
    await _prefs.remove(_keyTotalLifetimeScore);
    await _prefs.remove(_keyTotalGamesPlayed);
    await _prefs.remove(_keyTotalWordsFound);
    await _prefs.remove(_keyHighScores);
    await _prefs.remove(_keyRecentGames);
    await _prefs.remove(_keyDifficultyStats);
    await _prefs.remove(_keyBestStreakHighScore);
    await _prefs.remove(_keyBestStreakDays);
    await _prefs.remove(_keyBestStreakGames);
    await _prefs.remove(_keyBestStreakPerfect);
    await _prefs.remove(_keyLastPlayDate);
  }
}

