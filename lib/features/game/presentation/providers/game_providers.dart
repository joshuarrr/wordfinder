import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/puzzle_generator.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/puzzle.dart';

part 'game_providers.g.dart';

/// Provider for puzzle generator
@riverpod
PuzzleGenerator puzzleGenerator(Ref ref) {
  return PuzzleGenerator();
}

/// Async provider for puzzle generation - runs in isolate to avoid blocking UI
@riverpod
Future<Puzzle> puzzleAsync(
  Ref ref, {
  required Difficulty difficulty,
  required WordCategory category,
  required GameMode gameMode,
}) async {
  final generator = PuzzleGenerator();
  return generator.generateAsync(
    difficulty: difficulty,
    category: category,
    gameMode: gameMode,
  );
}

/// Async game state notifier - handles loading state properly
@riverpod
class AsyncGameStateNotifier extends _$AsyncGameStateNotifier {
  @override
  Future<GameState> build({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) async {
    // Generate puzzle asynchronously in isolate
    final generator = PuzzleGenerator();
    final puzzle = await generator.generateAsync(
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
    final current = state.valueOrNull;
    if (current == null || current.isPaused || current.isCompleted) return;

    state = AsyncData(
      current.copyWith(selectedPath: [(row, col)], hasError: false),
    );
  }

  /// Add cell to selection path - recalculates entire path as a straight line
  /// Supports dragging backwards to deselect letters
  void addToSelection(int row, int col) {
    final current = state.valueOrNull;
    if (current == null || current.isPaused || current.isCompleted) return;
    if (current.selectedPath.isEmpty) {
      startSelection(row, col);
      return;
    }

    final startPos = current.selectedPath.first;
    final endPos = (row, col);

    // Same cell as start? Reset to just start
    if (startPos == endPos) {
      state = AsyncData(
        current.copyWith(selectedPath: [startPos], hasError: false),
      );
      return;
    }

    // Calculate the line from start to end
    final newPath = _calculateLinePath(startPos, endPos);

    if (newPath == null) return; // Invalid path

    // Check if the new end is along the same line as current path
    final currentPath = current.selectedPath;
    final isSameLine = _isOnSameLine(currentPath, endPos);

    if (isSameLine) {
      // Dragging along the same line - check if moving forward or backward
      final currentEndIndex = currentPath.length - 1;
      final newEndIndex = _findPositionInPath(currentPath, endPos);

      if (newEndIndex != null) {
        // End position is already in the path - truncate to that point
        if (newEndIndex < currentEndIndex) {
          // Dragging backwards - truncate path
          state = AsyncData(
            current.copyWith(
              selectedPath: currentPath.sublist(0, newEndIndex + 1),
              hasError: false,
            ),
          );
        } else if (newEndIndex == currentEndIndex) {
          // Same end position - no change needed
          return;
        }
        // If newEndIndex > currentEndIndex, we'd extend, but that shouldn't happen
        // since we're checking if it's in the path
      } else {
        // End position extends beyond current path - check if it's a valid extension
        final direction = _getPathDirection(currentPath);
        if (direction != null &&
            _isValidExtension(currentPath, endPos, direction)) {
          // Extend the path
          final extendedPath = _extendPath(currentPath, endPos, direction);
          if (extendedPath != null) {
            state = AsyncData(
              current.copyWith(selectedPath: extendedPath, hasError: false),
            );
          }
        }
      }
    } else {
      // Different line - recalculate from start to new end
      // Allow both longer and shorter paths (user can drag backwards to a different line)
      state = AsyncData(
        current.copyWith(selectedPath: newPath, hasError: false),
      );
    }
  }

  /// Check if a position is on the same line as the current path
  bool _isOnSameLine(List<(int, int)> path, (int, int) pos) {
    if (path.length < 2) return false;

    final start = path.first;
    final end = path.last;

    // Check if pos is on the line from start to end
    final linePath = _calculateLinePath(start, end);
    if (linePath == null) return false;

    return linePath.contains(pos);
  }

  /// Find the index of a position in a path, or null if not found
  int? _findPositionInPath(List<(int, int)> path, (int, int) pos) {
    for (int i = 0; i < path.length; i++) {
      if (path[i] == pos) return i;
    }
    return null;
  }

  /// Get the direction vector of a path
  (int, int)? _getPathDirection(List<(int, int)> path) {
    if (path.length < 2) return null;

    final start = path.first;
    final end = path.last;

    final rowDiff = end.$1 - start.$1;
    final colDiff = end.$2 - start.$2;

    if (rowDiff == 0 && colDiff == 0) return null;

    final rowDir = rowDiff == 0 ? 0 : rowDiff ~/ rowDiff.abs();
    final colDir = colDiff == 0 ? 0 : colDiff ~/ colDiff.abs();

    return (rowDir, colDir);
  }

  /// Check if a position is a valid extension of the path in the given direction
  bool _isValidExtension(
    List<(int, int)> path,
    (int, int) pos,
    (int, int) direction,
  ) {
    if (path.isEmpty) return false;

    final last = path.last;
    final (rowDir, colDir) = direction;

    // Check if pos is the next cell in the direction
    final expectedRow = last.$1 + rowDir;
    final expectedCol = last.$2 + colDir;

    return pos == (expectedRow, expectedCol);
  }

  /// Extend a path to include a new end position
  List<(int, int)>? _extendPath(
    List<(int, int)> path,
    (int, int) endPos,
    (int, int) direction,
  ) {
    if (path.isEmpty) return null;

    final extended = List<(int, int)>.from(path);
    final (rowDir, colDir) = direction;

    var current = path.last;
    while (current != endPos) {
      final nextRow = current.$1 + rowDir;
      final nextCol = current.$2 + colDir;
      current = (nextRow, nextCol);
      extended.add(current);

      // Safety check to prevent infinite loops
      if (extended.length > 100) return null;
    }

    return extended;
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
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(selectedPath: [], hasError: false));
  }

  /// Validate and submit selection
  void submitSelection() {
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
          isCelebrating: allWordsFound, // Start celebration if all words found
          hasError: false,
          lastFoundWord: wordPosition.word,
        ),
      );

      // If all words found, complete after celebration animation (keep cells green)
      if (allWordsFound) {
        Future.delayed(const Duration(milliseconds: 800), () {
          final latestState = state.valueOrNull;
          if (latestState != null && latestState.isCelebrating) {
            state = AsyncData(latestState.copyWith(isCompleted: true));
          }
        });
      }
    } else {
      // Invalid selection - trigger error state (shake + fade animation)
      state = AsyncData(current.copyWith(hasError: true));
      // Clear after shake + fade animation completes (500ms total)
      Future.delayed(const Duration(milliseconds: 500), () {
        final latestState = state.valueOrNull;
        if (latestState != null) {
          state = AsyncData(
            latestState.copyWith(selectedPath: [], hasError: false),
          );
        }
      });
    }
  }

  /// Update elapsed time
  void updateElapsedTime(int seconds) {
    final current = state.valueOrNull;
    if (current == null || current.isPaused || current.isCompleted) return;

    var newState = current.copyWith(elapsedSeconds: seconds);

    // Check if time limit exceeded (for timed mode)
    if (current.puzzle.gameMode == GameMode.timed &&
        current.puzzle.difficulty.timeLimit > 0 &&
        seconds >= current.puzzle.difficulty.timeLimit) {
      newState = newState.copyWith(isCompleted: true);
    }

    state = AsyncData(newState);
  }

  /// Toggle pause
  void togglePause() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(isPaused: !current.isPaused));
  }

  /// Clear the last found word (after animation completes)
  void clearLastFoundWord() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(lastFoundWord: null));
  }

  /// Use a hint
  void useHint() {
    final current = state.valueOrNull;
    if (current == null ||
        current.isPaused ||
        current.isCompleted ||
        current.hintsUsed >= current.puzzle.difficulty.hints) {
      return;
    }

    // Find a random unfound word
    final remainingWords = current.remainingWords;
    if (remainingWords.isEmpty) return;

    // TODO: Implement hint logic (reveal first letter or highlight word)
    state = AsyncData(current.copyWith(hintsUsed: current.hintsUsed + 1));
  }

  /// Dev mode: Auto-complete the puzzle by marking all words as found
  void autoComplete() {
    final current = state.valueOrNull;
    if (current == null || current.isCompleted || current.isCelebrating) return;

    // Mark all words as found and start celebration
    final allWords = current.puzzle.words.map((wp) => wp.word).toSet();

    state = AsyncData(
      current.copyWith(
        foundWords: allWords,
        selectedPath: [],
        isCelebrating: true,
        hasError: false,
      ),
    );

    // Complete after celebration animation (keep cells green)
    Future.delayed(const Duration(milliseconds: 800), () {
      final latestState = state.valueOrNull;
      if (latestState != null && latestState.isCelebrating) {
        state = AsyncData(latestState.copyWith(isCompleted: true));
      }
    });
  }
}
