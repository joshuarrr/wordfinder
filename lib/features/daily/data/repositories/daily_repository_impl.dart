import '../../domain/entities/daily_puzzle_progress.dart';
import '../../domain/entities/daily_puzzle_state.dart';
import '../../domain/repositories/daily_repository.dart';
import '../datasources/local_daily_data_source.dart';

/// Implementation of DailyRepository using local storage
class DailyRepositoryImpl implements DailyRepository {
  final LocalDailyDataSource _dataSource;

  DailyRepositoryImpl(this._dataSource);

  @override
  Future<DailyPuzzleProgress?> getDailyProgress(DateTime date) async {
    return await _dataSource.getDailyProgress(date);
  }

  @override
  Future<void> saveProgress(DailyPuzzleProgress progress) async {
    await _dataSource.saveDailyProgress(progress);
  }

  @override
  Future<DailyPuzzleStats> completeDailyPuzzle(int score) async {
    return await _dataSource.completeDailyPuzzle(score);
  }

  @override
  Future<DailyPuzzleStats> getDailyStats() async {
    return await _dataSource.getDailyStats();
  }

  @override
  Future<int> getCurrentStreak() async {
    return await _dataSource.getCurrentStreak();
  }

  @override
  Future<bool> isTodayCompleted() async {
    return await _dataSource.isTodayCompleted();
  }

  @override
  Future<void> cleanupOldProgress() async {
    await _dataSource.cleanupOldProgress();
  }
}

