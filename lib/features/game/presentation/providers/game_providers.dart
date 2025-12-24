import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/puzzle_generator.dart';
import '../../domain/entities/game_state.dart';

part 'game_providers.g.dart';

/// Provider for puzzle generator
@riverpod
PuzzleGenerator puzzleGenerator(Ref ref) {
  return PuzzleGenerator();
}

/// Game state notifier
@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  GameState build({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) {
    // Generate puzzle synchronously for now
    final generator = PuzzleGenerator();
    final puzzle = generator.generate(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );

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
    );
  }

  /// Start selection at a cell
  void startSelection(int row, int col) {
    final current = state;
    if (current.isPaused || current.isCompleted) return;
    
    state = current.copyWith(
      selectedPath: [(row, col)],
      hasError: false,
    );
  }

  /// Add cell to selection path
  void addToSelection(int row, int col) {
    final current = state;
    if (current.isPaused || current.isCompleted) return;
    if (current.selectedPath.isEmpty) {
      startSelection(row, col);
      return;
    }

    final lastPos = current.selectedPath.last;
    final newPos = (row, col);

    // Check if the new position is adjacent and in a valid direction
    if (_isValidNextCell(lastPos, newPos, current.selectedPath)) {
      state = current.copyWith(
        selectedPath: [...current.selectedPath, newPos],
        hasError: false,
      );
    }
  }

  /// Check if a cell is a valid next cell in the selection
  bool _isValidNextCell(
    (int, int) lastPos,
    (int, int) newPos,
    List<(int, int)> currentPath,
  ) {
    final (lastRow, lastCol) = lastPos;
    final (newRow, newCol) = newPos;

    // Must be adjacent (including diagonal)
    final rowDiff = (newRow - lastRow).abs();
    final colDiff = (newCol - lastCol).abs();
    
    if (rowDiff > 1 || colDiff > 1 || (rowDiff == 0 && colDiff == 0)) {
      return false;
    }

    // If path has more than one cell, must continue in same direction
    if (currentPath.length > 1) {
      final (prevRow, prevCol) = currentPath[currentPath.length - 2];
      final prevDirection = (lastRow - prevRow, lastCol - prevCol);
      final newDirection = (newRow - lastRow, newCol - lastCol);
      
      return prevDirection == newDirection;
    }

    return true;
  }

  /// Clear selection
  void clearSelection() {
    state = state.copyWith(
      selectedPath: [],
      hasError: false,
    );
  }

  /// Validate and submit selection
  void submitSelection() {
    final current = state;
    if (current.selectedPath.length < 2) {
      clearSelection();
      return;
    }

    final wordPosition = current.puzzle.validatePath(current.selectedPath);
    
    if (wordPosition != null && !current.foundWords.contains(wordPosition.word)) {
      // Word found!
      state = current.copyWith(
        foundWords: {...current.foundWords, wordPosition.word},
        selectedPath: [],
        isCompleted: current.foundWords.length + 1 >= current.puzzle.words.length,
        hasError: false,
        lastFoundWord: wordPosition.word,
      );
    } else {
      // Invalid selection - trigger error state
      state = current.copyWith(hasError: true);
      // Clear after shake animation
      Future.delayed(const Duration(milliseconds: 400), () {
        final latestState = state;
        state = latestState.copyWith(
          selectedPath: [],
          hasError: false,
        );
      });
    }
  }

  /// Update elapsed time
  void updateElapsedTime(int seconds) {
    final current = state;
    if (current.isPaused || current.isCompleted) return;
    
    state = current.copyWith(elapsedSeconds: seconds);
    
    // Check if time limit exceeded (for timed mode)
    if (current.puzzle.gameMode == GameMode.timed &&
        current.puzzle.difficulty.timeLimit > 0 &&
        seconds >= current.puzzle.difficulty.timeLimit) {
      state = state.copyWith(isCompleted: true);
    }
  }

  /// Toggle pause
  void togglePause() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  /// Use a hint
  void useHint() {
    final current = state;
    if (current.isPaused || 
        current.isCompleted || 
        current.hintsUsed >= current.puzzle.difficulty.hints) {
      return;
    }

    // Find a random unfound word
    final remainingWords = current.remainingWords;
    if (remainingWords.isEmpty) return;

    // TODO: Implement hint logic (reveal first letter or highlight word)
    state = current.copyWith(hintsUsed: current.hintsUsed + 1);
  }
}
