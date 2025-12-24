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

  /// Add cell to selection path - recalculates entire path as a straight line
  void addToSelection(int row, int col) {
    final current = state;
    if (current.isPaused || current.isCompleted) return;
    if (current.selectedPath.isEmpty) {
      startSelection(row, col);
      return;
    }

    final startPos = current.selectedPath.first;
    final endPos = (row, col);
    
    // Same cell as start? Ignore
    if (startPos == endPos) return;

    // Calculate the line from start to end
    final newPath = _calculateLinePath(startPos, endPos);
    
    // Only update if we got a valid path
    if (newPath != null && newPath.length > current.selectedPath.length) {
      state = current.copyWith(
        selectedPath: newPath,
        hasError: false,
      );
    }
  }

  /// Calculate a straight line path between two cells
  /// Returns null if the cells don't form a valid line (horizontal, vertical, or 45° diagonal)
  List<(int, int)>? _calculateLinePath((int, int) start, (int, int) end) {
    final (startRow, startCol) = start;
    final (endRow, endCol) = end;
    
    final rowDiff = endRow - startRow;
    final colDiff = endCol - startCol;
    
    // Check if it's a valid straight line
    // Valid: horizontal (rowDiff == 0), vertical (colDiff == 0), 
    // or diagonal (|rowDiff| == |colDiff|)
    if (rowDiff != 0 && colDiff != 0 && rowDiff.abs() != colDiff.abs()) {
      return null; // Not a valid straight line
    }
    
    // Calculate direction
    final rowDir = rowDiff == 0 ? 0 : rowDiff ~/ rowDiff.abs();
    final colDir = colDiff == 0 ? 0 : colDiff ~/ colDiff.abs();
    
    // Build the path
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
