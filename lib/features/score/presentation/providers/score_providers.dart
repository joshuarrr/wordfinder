import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local_score_data_source.dart';
import '../../data/repositories/score_repository_impl.dart';
import '../../domain/repositories/score_repository.dart';
import '../../domain/entities/score_stats.dart';
import '../../../../core/constants/app_constants.dart';

part 'score_providers.g.dart';

/// Provider for SharedPreferences instance
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  try {
    return await SharedPreferences.getInstance();
  } catch (e) {
    // If SharedPreferences channel is unavailable (e.g., during app close/navigation),
    // return a cached instance or handle gracefully
    // This prevents crashes when the platform channel is disconnected
    rethrow;
  }
}

/// Provider for LocalScoreDataSource
@riverpod
Future<LocalScoreDataSource> localScoreDataSource(
  LocalScoreDataSourceRef ref,
) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return LocalScoreDataSource(prefs);
}

/// Provider for ScoreRepository
@riverpod
Future<ScoreRepository> scoreRepository(ScoreRepositoryRef ref) async {
  final dataSource = await ref.watch(localScoreDataSourceProvider.future);
  return ScoreRepositoryImpl(dataSource);
}

/// Provider for cumulative score
@riverpod
Future<int> cumulativeScore(CumulativeScoreRef ref) async {
  try {
    final repository = await ref.watch(scoreRepositoryProvider.future);
    return await repository.getCumulativeScore();
  } catch (e) {
    // Return 0 if SharedPreferences is unavailable
    return 0;
  }
}

/// Provider for all score statistics
@riverpod
Future<ScoreStats> scoreStats(ScoreStatsRef ref) async {
  try {
    final repository = await ref.watch(scoreRepositoryProvider.future);
    return await repository.getStats();
  } catch (e) {
    // Return empty stats if SharedPreferences is unavailable
    return const ScoreStats(
      totalLifetimeScore: 0,
      totalGamesPlayed: 0,
      totalWordsFound: 0,
      averageScore: 0.0,
      bestStreakHighScore: 0,
      bestStreakDays: 0,
      bestStreakGames: 0,
      bestStreakPerfect: 0,
      highScores: {},
      difficultyStats: {},
      recentGames: [],
    );
  }
}

/// Provider for high score by difficulty
@riverpod
Future<int?> highScore(
  HighScoreRef ref,
  Difficulty difficulty,
) async {
  try {
    final repository = await ref.watch(scoreRepositoryProvider.future);
    return await repository.getHighScore(difficulty);
  } catch (e) {
    // Return null if SharedPreferences is unavailable
    return null;
  }
}

