import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/daily_puzzle_progress.dart';
import '../../domain/entities/daily_puzzle_state.dart';

/// Local data source for daily puzzle persistence using shared_preferences
class LocalDailyDataSource {
  static const String _keyDailyProgress = 'daily_puzzle_progress';
  static const String _keyDailyStats = 'daily_puzzle_stats';

  final SharedPreferences _prefs;

  LocalDailyDataSource(this._prefs);

  /// Get the date key for today's puzzle
  String _getDateKey(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return '${dateOnly.year}-${dateOnly.month.toString().padLeft(2, '0')}-${dateOnly.day.toString().padLeft(2, '0')}';
  }

  /// Get progress for a specific date's puzzle
  Future<DailyPuzzleProgress?> getDailyProgress(DateTime date) async {
    final key = '${_keyDailyProgress}_${_getDateKey(date)}';
    final json = _prefs.getString(key);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return DailyPuzzleProgress.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Save progress for a specific date's puzzle
  Future<void> saveDailyProgress(DailyPuzzleProgress progress) async {
    final key = '${_keyDailyProgress}_${_getDateKey(progress.puzzleDate)}';
    final json = jsonEncode(progress.toJson());
    await _prefs.setString(key, json);
  }

  /// Clear progress for a specific date (used for cleanup)
  Future<void> clearDailyProgress(DateTime date) async {
    final key = '${_keyDailyProgress}_${_getDateKey(date)}';
    await _prefs.remove(key);
  }

  /// Get daily puzzle stats
  Future<DailyPuzzleStats> getDailyStats() async {
    final json = _prefs.getString(_keyDailyStats);
    if (json == null) return const DailyPuzzleStats();

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return DailyPuzzleStats.fromJson(map);
    } catch (e) {
      return const DailyPuzzleStats();
    }
  }

  /// Save daily puzzle stats
  Future<void> saveDailyStats(DailyPuzzleStats stats) async {
    final json = jsonEncode(stats.toJson());
    await _prefs.setString(_keyDailyStats, json);
  }

  /// Check if today's puzzle is completed
  Future<bool> isTodayCompleted() async {
    final today = DateTime.now();
    final progress = await getDailyProgress(today);
    return progress?.isCompleted ?? false;
  }

  /// Get current streak (calculated from stats)
  Future<int> getCurrentStreak() async {
    final stats = await getDailyStats();
    
    // Check if streak is still valid (last completion was yesterday or today)
    if (stats.lastCompletionDate == null) return 0;
    
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastCompletion = DateTime(
      stats.lastCompletionDate!.year,
      stats.lastCompletionDate!.month,
      stats.lastCompletionDate!.day,
    );
    
    final daysDiff = todayDate.difference(lastCompletion).inDays;
    
    // Streak is valid if completed today or yesterday
    if (daysDiff <= 1) {
      return stats.currentStreak;
    }
    
    // Streak broken
    return 0;
  }

  /// Update stats after completing today's puzzle
  Future<DailyPuzzleStats> completeDailyPuzzle(int score) async {
    final stats = await getDailyStats();
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    // Calculate new streak
    int newStreak = 1;
    if (stats.lastCompletionDate != null) {
      final lastCompletion = DateTime(
        stats.lastCompletionDate!.year,
        stats.lastCompletionDate!.month,
        stats.lastCompletionDate!.day,
      );
      final daysDiff = todayDate.difference(lastCompletion).inDays;
      
      if (daysDiff == 1) {
        // Consecutive day - increment streak
        newStreak = stats.currentStreak + 1;
      } else if (daysDiff == 0) {
        // Same day - keep streak (shouldn't happen with proper guards)
        newStreak = stats.currentStreak;
      }
      // daysDiff > 1 means streak reset to 1
    }
    
    final newBestStreak = newStreak > stats.bestStreak ? newStreak : stats.bestStreak;
    final newBestScore = score > stats.bestScore ? score : stats.bestScore;
    
    final updatedStats = stats.copyWith(
      currentStreak: newStreak,
      bestStreak: newBestStreak,
      totalCompleted: stats.totalCompleted + 1,
      lastCompletionDate: todayDate,
      bestScore: newBestScore,
      totalScore: stats.totalScore + score,
    );
    
    await saveDailyStats(updatedStats);
    return updatedStats;
  }

  /// Clean up old progress entries (keep only last 7 days)
  Future<void> cleanupOldProgress() async {
    final today = DateTime.now();
    final keys = _prefs.getKeys().where((k) => k.startsWith(_keyDailyProgress));
    
    for (final key in keys) {
      // Extract date from key
      final dateStr = key.replaceFirst('${_keyDailyProgress}_', '');
      try {
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          final date = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          
          // Remove if older than 7 days
          if (today.difference(date).inDays > 7) {
            await _prefs.remove(key);
          }
        }
      } catch (e) {
        // Invalid key format, remove it
        await _prefs.remove(key);
      }
    }
  }
}

