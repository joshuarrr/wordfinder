import '../entities/daily_puzzle_progress.dart';
import '../entities/daily_puzzle_state.dart';

/// Repository interface for daily puzzle operations
abstract class DailyRepository {
  /// Get progress for today's puzzle (or any specific date)
  Future<DailyPuzzleProgress?> getDailyProgress(DateTime date);

  /// Save progress for today's puzzle
  Future<void> saveProgress(DailyPuzzleProgress progress);

  /// Complete today's puzzle and update stats
  Future<DailyPuzzleStats> completeDailyPuzzle(int score);

  /// Get daily puzzle statistics
  Future<DailyPuzzleStats> getDailyStats();

  /// Get current streak
  Future<int> getCurrentStreak();

  /// Check if today's puzzle is completed
  Future<bool> isTodayCompleted();

  /// Clean up old progress entries
  Future<void> cleanupOldProgress();
}

