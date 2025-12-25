import '../../domain/repositories/score_repository.dart';
import '../../domain/entities/game_score.dart';
import '../../domain/entities/score_stats.dart';
import '../datasources/local_score_data_source.dart';
import '../../../../core/constants/app_constants.dart';

/// Implementation of ScoreRepository using local storage
class ScoreRepositoryImpl implements ScoreRepository {
  final LocalScoreDataSource _dataSource;

  ScoreRepositoryImpl(this._dataSource);

  @override
  Future<void> saveScore(GameScore score) async {
    // Update cumulative score
    final currentTotal = await _dataSource.getTotalLifetimeScore();
    await _dataSource.setTotalLifetimeScore(currentTotal + score.score);

    // Increment games played
    await _dataSource.incrementTotalGamesPlayed();

    // Add words found
    await _dataSource.addToTotalWordsFound(score.wordsFound);

    // Update high scores
    final highScores = await _dataSource.getHighScores();
    final currentHigh = highScores[score.difficulty] ?? 0;
    if (score.score > currentHigh) {
      highScores[score.difficulty] = score.score;
      await _dataSource.setHighScores(highScores);
    }

    // Update difficulty stats
    final difficultyStats = await _dataSource.getDifficultyStats();
    final currentDiffStats =
        difficultyStats[score.difficulty] ??
        DifficultyStats(
          gamesPlayed: 0,
          totalScore: 0,
          averageScore: 0.0,
          highScore: 0,
          bestStreakHighScore: 0,
          bestStreakPerfect: 0,
          bestTimeSeconds: null,
        );

    final newGamesPlayed = currentDiffStats.gamesPlayed + 1;
    final newTotalScore = currentDiffStats.totalScore + score.score;
    final newAverageScore = newTotalScore / newGamesPlayed;
    final newHighScore = score.score > currentDiffStats.highScore
        ? score.score
        : currentDiffStats.highScore;

    // Update best time if faster
    int? newBestTime = currentDiffStats.bestTimeSeconds;
    if (newBestTime == null || score.elapsedSeconds < newBestTime) {
      newBestTime = score.elapsedSeconds;
    }

    // Update streaks
    final isNewHighScore = score.score > currentDiffStats.highScore;
    final currentHighScoreStreak = isNewHighScore
        ? currentDiffStats.bestStreakHighScore + 1
        : 0;
    final newBestStreakHighScore =
        currentHighScoreStreak > currentDiffStats.bestStreakHighScore
        ? currentHighScoreStreak
        : currentDiffStats.bestStreakHighScore;

    final currentPerfectStreak = score.isPerfectGame
        ? currentDiffStats.bestStreakPerfect + 1
        : 0;
    final newBestStreakPerfect =
        currentPerfectStreak > currentDiffStats.bestStreakPerfect
        ? currentPerfectStreak
        : currentDiffStats.bestStreakPerfect;

    difficultyStats[score.difficulty] = DifficultyStats(
      gamesPlayed: newGamesPlayed,
      totalScore: newTotalScore,
      averageScore: newAverageScore,
      highScore: newHighScore,
      bestStreakHighScore: newBestStreakHighScore,
      bestStreakPerfect: newBestStreakPerfect,
      bestTimeSeconds: newBestTime,
    );
    await _dataSource.setDifficultyStats(difficultyStats);

    // Update overall streaks - need to track current streaks separately
    // For now, we'll track them per difficulty and update overall best
    // In a real implementation, you'd want to track current streaks separately

    // Update day and games streaks
    final lastPlayDate = await _dataSource.getLastPlayDate();
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    int currentDaysStreak = 0;
    int currentGamesStreak = 0;

    if (lastPlayDate != null) {
      final lastDate = DateTime(
        lastPlayDate.year,
        lastPlayDate.month,
        lastPlayDate.day,
      );
      final daysDiff = todayDate.difference(lastDate).inDays;

      if (daysDiff == 0) {
        // Same day - increment games streak
        currentGamesStreak = await _dataSource.getBestStreakGames() + 1;
        currentDaysStreak = await _dataSource.getBestStreakDays();
      } else if (daysDiff == 1) {
        // Consecutive day - increment both streaks
        currentDaysStreak = await _dataSource.getBestStreakDays() + 1;
        currentGamesStreak = 1;
      } else {
        // Streak broken - reset
        currentDaysStreak = 1;
        currentGamesStreak = 1;
      }
    } else {
      // First game
      currentDaysStreak = 1;
      currentGamesStreak = 1;
    }

    // Update best streaks if current is better
    final bestDaysStreak = await _dataSource.getBestStreakDays();
    if (currentDaysStreak > bestDaysStreak) {
      await _dataSource.setBestStreakDays(currentDaysStreak);
    }

    final bestGamesStreak = await _dataSource.getBestStreakGames();
    if (currentGamesStreak > bestGamesStreak) {
      await _dataSource.setBestStreakGames(currentGamesStreak);
    }

    await _dataSource.setLastPlayDate(today);

    // Update overall high score and perfect streaks
    // Note: These need to track current streaks, not just best
    // For simplicity, we'll update if this is a new high score or perfect game
    if (isNewHighScore) {
      final currentHighScoreStreak = await _dataSource.getBestStreakHighScore();
      await _dataSource.setBestStreakHighScore(currentHighScoreStreak + 1);
    }

    if (score.isPerfectGame) {
      final currentPerfectStreak = await _dataSource.getBestStreakPerfect();
      await _dataSource.setBestStreakPerfect(currentPerfectStreak + 1);
    }

    // Add to recent games
    await _dataSource.addRecentGame(score);
  }

  @override
  Future<ScoreStats> getStats() async {
    final totalLifetimeScore = await _dataSource.getTotalLifetimeScore();
    final totalGamesPlayed = await _dataSource.getTotalGamesPlayed();
    final totalWordsFound = await _dataSource.getTotalWordsFound();
    final averageScore = totalGamesPlayed > 0
        ? totalLifetimeScore / totalGamesPlayed
        : 0.0;
    final bestStreakHighScore = await _dataSource.getBestStreakHighScore();
    final bestStreakDays = await _dataSource.getBestStreakDays();
    final bestStreakGames = await _dataSource.getBestStreakGames();
    final bestStreakPerfect = await _dataSource.getBestStreakPerfect();
    final highScores = await _dataSource.getHighScores();
    final difficultyStats = await _dataSource.getDifficultyStats();
    final recentGames = await _dataSource.getRecentGames();

    return ScoreStats(
      totalLifetimeScore: totalLifetimeScore,
      totalGamesPlayed: totalGamesPlayed,
      totalWordsFound: totalWordsFound,
      averageScore: averageScore,
      bestStreakHighScore: bestStreakHighScore,
      bestStreakDays: bestStreakDays,
      bestStreakGames: bestStreakGames,
      bestStreakPerfect: bestStreakPerfect,
      highScores: highScores,
      difficultyStats: difficultyStats,
      recentGames: recentGames,
    );
  }

  @override
  Future<int> getCumulativeScore() async {
    return await _dataSource.getTotalLifetimeScore();
  }

  @override
  Future<int?> getHighScore(Difficulty difficulty) async {
    final highScores = await _dataSource.getHighScores();
    return highScores[difficulty];
  }

  @override
  Future<List<GameScore>> getRecentGames({int limit = 50}) async {
    return await _dataSource.getRecentGames(limit: limit);
  }

  @override
  Future<void> clearAllScores() async {
    await _dataSource.clearAll();
  }
}
