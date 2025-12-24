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
  return SharedPreferences.getInstance();
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
  final repository = await ref.watch(scoreRepositoryProvider.future);
  return repository.getCumulativeScore();
}

/// Provider for all score statistics
@riverpod
Future<ScoreStats> scoreStats(ScoreStatsRef ref) async {
  final repository = await ref.watch(scoreRepositoryProvider.future);
  return repository.getStats();
}

/// Provider for high score by difficulty
@riverpod
Future<int?> highScore(
  HighScoreRef ref,
  Difficulty difficulty,
) async {
  final repository = await ref.watch(scoreRepositoryProvider.future);
  return repository.getHighScore(difficulty);
}

