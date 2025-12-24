import 'word_position.dart';
import '../../../../core/constants/app_constants.dart';

/// Represents a complete word search puzzle
class Puzzle {
  const Puzzle({
    required this.grid,
    required this.words,
    required this.difficulty,
    required this.category,
    required this.gameMode,
  });

  final List<List<String>> grid; // 2D grid of letters
  final List<WordPosition> words; // All words to find
  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;

  /// Get the size of the grid (assumes square grid)
  int get size => grid.length;

  /// Get a letter at a specific position
  String getLetter(int row, int col) {
    if (row < 0 || row >= size || col < 0 || col >= size) {
      return '';
    }
    return grid[row][col];
  }

  /// Check if a word is found
  bool isWordFound(String word) {
    return words.any((wp) => wp.word == word);
  }

  /// Get word position for a specific word
  WordPosition? getWordPosition(String word) {
    try {
      return words.firstWhere((wp) => wp.word == word);
    } catch (e) {
      return null;
    }
  }

  /// Validate if a path matches any word
  WordPosition? validatePath(List<(int, int)> path) {
    if (path.isEmpty) return null;
    
    // Build the word from the path
    final word = path.map((pos) => getLetter(pos.$1, pos.$2)).join();
    
    // Check if it matches any word position (forward or reverse)
    for (final wordPos in words) {
      if (wordPos.word == word && wordPos.matchesPath(path)) {
        return wordPos;
      }
      // Check reverse
      final reversedWord = word.split('').reversed.join();
      if (wordPos.word == reversedWord && wordPos.matchesPath(path)) {
        return wordPos;
      }
    }
    
    return null;
  }
}

