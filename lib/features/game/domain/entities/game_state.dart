import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import 'puzzle.dart';

part 'game_state.freezed.dart';

/// Represents the current state of a game session
@freezed
class GameState with _$GameState {
  const factory GameState({
    required Puzzle puzzle,
    required Set<String> foundWords,
    required List<(int, int)> selectedPath,
    required int elapsedSeconds,
    required int hintsUsed,
    required bool isPaused,
    required bool isCompleted,
    required bool hasError,
    @Default(false) bool isCelebrating,
    DateTime? startedAt,
    String? lastFoundWord,
    (int, int)? hintedCell,
  }) = _GameState;

  const GameState._();

  /// Get remaining words to find
  List<String> get remainingWords {
    return puzzle.words
        .map((wp) => wp.word)
        .where((word) => !foundWords.contains(word))
        .toList();
  }

  /// Check if a word is found
  bool isWordFound(String word) => foundWords.contains(word);

  /// Get progress percentage (0.0 to 1.0)
  double get progress {
    if (puzzle.words.isEmpty) return 1.0;
    return foundWords.length / puzzle.words.length;
  }

  /// Calculate score
  int get score {
    if (puzzle.words.isEmpty) return 0;
    
    final baseScore = foundWords.length * AppConstants.basePointsPerWord;
    final hintPenalty = hintsUsed * AppConstants.hintPenalty;
    
    // Time bonus (only for timed mode)
    int timeBonus = 0;
    if (puzzle.gameMode == GameMode.timed && puzzle.difficulty.timeLimit > 0) {
      final remainingTime = puzzle.difficulty.timeLimit - elapsedSeconds;
      if (remainingTime > 0) {
        timeBonus = remainingTime * AppConstants.timeBonus;
      }
    }
    
    return (baseScore + timeBonus - hintPenalty).clamp(0, double.infinity).toInt();
  }

  /// Get current selection as word string
  String get selectedWord {
    return selectedPath
        .map((pos) => puzzle.getLetter(pos.$1, pos.$2))
        .join();
  }
}

