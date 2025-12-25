import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../game/data/datasources/puzzle_generator.dart';
import '../../../game/domain/entities/game_state.dart';
import '../../data/datasources/local_daily_data_source.dart';
import '../../data/repositories/daily_repository_impl.dart';
import '../../domain/entities/daily_puzzle_progress.dart';
import '../../domain/entities/daily_puzzle_state.dart';
import '../../domain/repositories/daily_repository.dart';

part 'daily_providers.g.dart';

/// Provider for LocalDailyDataSource
@riverpod
Future<LocalDailyDataSource> localDailyDataSource(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalDailyDataSource(prefs);
}

/// Provider for DailyRepository
@riverpod
Future<DailyRepository> dailyRepository(Ref ref) async {
  final dataSource = await ref.watch(localDailyDataSourceProvider.future);
  return DailyRepositoryImpl(dataSource);
}

/// Provider for current daily streak
@riverpod
Future<int> dailyStreak(Ref ref) async {
  try {
    final repository = await ref.watch(dailyRepositoryProvider.future);
    return await repository.getCurrentStreak();
  } catch (e) {
    return 0;
  }
}

/// Provider for daily puzzle stats
@riverpod
Future<DailyPuzzleStats> dailyStats(Ref ref) async {
  try {
    final repository = await ref.watch(dailyRepositoryProvider.future);
    return await repository.getDailyStats();
  } catch (e) {
    return const DailyPuzzleStats();
  }
}

/// Provider for checking if today's puzzle is completed
@riverpod
Future<bool> isTodayPuzzleCompleted(Ref ref) async {
  try {
    final repository = await ref.watch(dailyRepositoryProvider.future);
    return await repository.isTodayCompleted();
  } catch (e) {
    return false;
  }
}

/// Provider for today's category
@riverpod
WordCategory todayCategory(Ref ref) {
  return PuzzleGenerator.getCategoryForDate(DateTime.now());
}

/// Provider for today's puzzle progress
@riverpod
Future<DailyPuzzleProgress?> todayProgress(Ref ref) async {
  try {
    final repository = await ref.watch(dailyRepositoryProvider.future);
    return await repository.getDailyProgress(DateTime.now());
  } catch (e) {
    return null;
  }
}

/// Async notifier for daily puzzle game state
@riverpod
class DailyGameStateNotifier extends _$DailyGameStateNotifier {
  @override
  Future<GameState> build() async {
    final today = DateTime.now();
    final repository = await ref.watch(dailyRepositoryProvider.future);
    
    // Check for existing progress
    final existingProgress = await repository.getDailyProgress(today);
    
    // Generate today's puzzle (deterministic based on date)
    final generator = PuzzleGenerator.forDaily(today);
    final puzzle = generator.generateDailySync(today);
    
    // If we have existing progress and puzzle isn't completed, restore it
    if (existingProgress != null && !existingProgress.isCompleted) {
      return GameState(
        puzzle: puzzle,
        foundWords: existingProgress.foundWords,
        selectedPath: [],
        elapsedSeconds: existingProgress.elapsedSeconds,
        hintsUsed: 0, // Daily puzzles have no hints
        isPaused: false,
        isCompleted: false,
        hasError: false,
        startedAt: existingProgress.startedAt ?? DateTime.now(),
        lastFoundWord: null,
        hintedCell: null,
      );
    }
    
    // If completed, return completed state
    if (existingProgress != null && existingProgress.isCompleted) {
      return GameState(
        puzzle: puzzle,
        foundWords: existingProgress.foundWords,
        selectedPath: [],
        elapsedSeconds: existingProgress.elapsedSeconds,
        hintsUsed: 0,
        isPaused: false,
        isCompleted: true,
        hasError: false,
        startedAt: existingProgress.startedAt,
        lastFoundWord: null,
        hintedCell: null,
      );
    }
    
    // New puzzle
    return GameState(
      puzzle: puzzle,
      foundWords: {},
      selectedPath: [],
      elapsedSeconds: 0,
      hintsUsed: 0,
      isPaused: false,
      isCompleted: false,
      hasError: false,
      startedAt: DateTime.now(),
      lastFoundWord: null,
      hintedCell: null,
    );
  }

  /// Save current progress
  Future<void> _saveProgress() async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    try {
      final repository = await ref.read(dailyRepositoryProvider.future);
      final progress = DailyPuzzleProgress(
        puzzleDate: DateTime.now(),
        foundWords: current.foundWords,
        elapsedSeconds: current.elapsedSeconds,
        startedAt: current.startedAt,
        isCompleted: current.isCompleted,
        finalScore: current.isCompleted ? current.score : null,
      );
      await repository.saveProgress(progress);
    } catch (e) {
      // Silently handle errors
    }
  }

  /// Start selection at a cell
  void startSelection(int row, int col) {
    final current = state.valueOrNull;
    if (current == null || current.isPaused || current.isCompleted) return;

    state = AsyncData(
      current.copyWith(selectedPath: [(row, col)], hasError: false),
    );
  }

  /// Add cell to selection path
  void addToSelection(int row, int col) {
    final current = state.valueOrNull;
    if (current == null || current.isPaused || current.isCompleted) return;
    if (current.selectedPath.isEmpty) {
      startSelection(row, col);
      return;
    }

    final startPos = current.selectedPath.first;
    final endPos = (row, col);

    if (startPos == endPos) {
      state = AsyncData(
        current.copyWith(selectedPath: [startPos], hasError: false),
      );
      return;
    }

    final newPath = _calculateLinePath(startPos, endPos);
    if (newPath == null) return;

    state = AsyncData(
      current.copyWith(selectedPath: newPath, hasError: false),
    );
  }

  /// Calculate a straight line path between two cells
  List<(int, int)>? _calculateLinePath((int, int) start, (int, int) end) {
    final (startRow, startCol) = start;
    final (endRow, endCol) = end;

    final rowDiff = endRow - startRow;
    final colDiff = endCol - startCol;

    if (rowDiff != 0 && colDiff != 0 && rowDiff.abs() != colDiff.abs()) {
      return null;
    }

    final rowDir = rowDiff == 0 ? 0 : rowDiff ~/ rowDiff.abs();
    final colDir = colDiff == 0 ? 0 : colDiff ~/ colDiff.abs();

    final path = <(int, int)>[];
    var currentRow = startRow;
    var currentCol = startCol;

    while (true) {
      path.add((currentRow, currentCol));
      if (currentRow == endRow && currentCol == endCol) break;
      currentRow += rowDir;
      currentCol += colDir;
    }

    return path;
  }

  /// Clear selection
  void clearSelection() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(selectedPath: [], hasError: false));
  }

  /// Validate and submit selection
  Future<void> submitSelection() async {
    final current = state.valueOrNull;
    if (current == null) return;

    if (current.selectedPath.length < 2) {
      clearSelection();
      return;
    }

    final wordPosition = current.puzzle.validatePath(current.selectedPath);

    if (wordPosition != null &&
        !current.foundWords.contains(wordPosition.word)) {
      // Word found!
      final allWordsFound =
          current.foundWords.length + 1 >= current.puzzle.words.length;

      state = AsyncData(
        current.copyWith(
          foundWords: {...current.foundWords, wordPosition.word},
          selectedPath: [],
          isCelebrating: allWordsFound,
          hasError: false,
          lastFoundWord: wordPosition.word,
        ),
      );

      // Save progress after each word found
      await _saveProgress();

      if (allWordsFound) {
        // Complete the puzzle
        await Future.delayed(const Duration(milliseconds: 800));
        final latestState = state.valueOrNull;
        if (latestState != null && latestState.isCelebrating) {
          state = AsyncData(latestState.copyWith(isCompleted: true));
          await _completeDailyPuzzle();
        }
      }
    } else {
      state = AsyncData(current.copyWith(hasError: true));
      await Future.delayed(const Duration(milliseconds: 500));
      final latestState = state.valueOrNull;
      if (latestState != null) {
        state = AsyncData(
          latestState.copyWith(selectedPath: [], hasError: false),
        );
      }
    }
  }

  /// Complete the daily puzzle and update stats
  Future<void> _completeDailyPuzzle() async {
    final current = state.valueOrNull;
    if (current == null || !current.isCompleted) return;

    try {
      final repository = await ref.read(dailyRepositoryProvider.future);
      
      // Get current streak for bonus calculation
      final currentStreak = await repository.getCurrentStreak();
      
      // Calculate score with streak bonus
      final baseScore = current.foundWords.length * AppConstants.basePointsPerWord;
      final streakBonus = AppConstants.streakMultiplier * (currentStreak + 1);
      final totalScore = baseScore + streakBonus;
      
      // Save final progress
      final progress = DailyPuzzleProgress(
        puzzleDate: DateTime.now(),
        foundWords: current.foundWords,
        elapsedSeconds: current.elapsedSeconds,
        startedAt: current.startedAt,
        isCompleted: true,
        finalScore: totalScore,
      );
      await repository.saveProgress(progress);
      
      // Update stats and streak
      await repository.completeDailyPuzzle(totalScore);
      
      // Invalidate providers to trigger updates
      ref.invalidate(dailyStreakProvider);
      ref.invalidate(dailyStatsProvider);
      ref.invalidate(isTodayPuzzleCompletedProvider);
    } catch (e) {
      // Silently handle errors
    }
  }

  /// Update elapsed time
  void updateElapsedTime(int seconds) {
    final current = state.valueOrNull;
    if (current == null || current.isPaused || current.isCompleted) return;

    state = AsyncData(current.copyWith(elapsedSeconds: seconds));
  }

  /// Toggle pause
  void togglePause() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(isPaused: !current.isPaused));
    
    // Save progress when pausing
    if (current.isPaused == false) {
      _saveProgress();
    }
  }

  /// Clear the last found word
  void clearLastFoundWord() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(lastFoundWord: null));
  }
}

