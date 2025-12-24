import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/word_lists/word_lists.dart';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/word_position.dart';

/// Parameters for puzzle generation (needed for compute isolate)
class PuzzleGeneratorParams {
  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;

  const PuzzleGeneratorParams({
    required this.difficulty,
    required this.category,
    required this.gameMode,
  });
}

/// Top-level function for compute isolate
Puzzle generatePuzzleIsolate(PuzzleGeneratorParams params) {
  return PuzzleGenerator()._generateSync(
    difficulty: params.difficulty,
    category: params.category,
    gameMode: params.gameMode,
  );
}

/// Generates word search puzzles
class PuzzleGenerator {
  final Random _random = Random();

  /// Generate a puzzle asynchronously in an isolate
  Future<Puzzle> generateAsync({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) {
    return compute(
      generatePuzzleIsolate,
      PuzzleGeneratorParams(
        difficulty: difficulty,
        category: category,
        gameMode: gameMode,
      ),
    );
  }

  /// Generate a puzzle synchronously (called from isolate)
  Puzzle _generateSync({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) {
    final gridSize = difficulty.gridSize;
    final wordCount = difficulty.wordCount;
    
    // Get words for this category - filter by length to fit grid
    final allWords = WordLists.getWordsForCategory(category);
    
    // Filter words that can fit in the grid
    // For a grid of size N, a word can be at most N characters
    // But prefer shorter words for easier placement
    final maxWordLength = gridSize;
    final preferredMaxLength = (gridSize * 0.8).ceil(); // Prefer words up to 80% of grid size
    
    final availableWords = allWords
        .where((word) => word.length <= maxWordLength && word.length >= 3) // At least 3 letters
        .toList()
      ..shuffle(_random);
    
    // Sort by length (shorter first for easier placement)
    availableWords.sort((a, b) => a.length.compareTo(b.length));
    
    // Create empty grid
    final grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => ''),
    );
    
    final placedWords = <WordPosition>[];
    final usedWords = <String>{};
    
    // Try to place words - use a more systematic approach
    for (final word in availableWords) {
      if (placedWords.length >= wordCount) break;
      if (usedWords.contains(word)) continue;
      
      // Try placing this word
      final position = _tryPlaceWord(grid, word, gridSize);
      if (position != null) {
        placedWords.add(position);
        usedWords.add(word);
        _placeWordInGrid(grid, position);
      }
    }
    
    // If we still don't have enough words, try with even shorter words
    if (placedWords.length < wordCount) {
      final shortWords = availableWords
          .where((word) => word.length <= preferredMaxLength)
          .where((word) => !usedWords.contains(word))
          .toList();
      
      for (final word in shortWords) {
        if (placedWords.length >= wordCount) break;
        
        final position = _tryPlaceWord(grid, word, gridSize);
        if (position != null) {
          placedWords.add(position);
          usedWords.add(word);
          _placeWordInGrid(grid, position);
        }
      }
    }
    
    // If we still don't have enough, try placing words more aggressively
    // by allowing overlaps on matching letters
    if (placedWords.length < wordCount) {
      final remainingWords = availableWords
          .where((word) => !usedWords.contains(word))
          .where((word) => word.length >= 3 && word.length <= gridSize)
          .take(wordCount * 2)
          .toList();
      
      for (final word in remainingWords) {
        if (placedWords.length >= wordCount) break;
        
        final position = _tryPlaceWordAggressive(grid, word, gridSize);
        if (position != null) {
          placedWords.add(position);
          usedWords.add(word);
          _placeWordInGrid(grid, position);
        }
      }
    }
    
    // Fill remaining cells with random letters
    _fillEmptyCells(grid, gridSize);
    
    return Puzzle(
      grid: grid,
      words: placedWords,
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );
  }

  /// Try to find a valid position for a word (standard placement)
  WordPosition? _tryPlaceWord(
    List<List<String>> grid,
    String word,
    int gridSize,
  ) {
    // Shuffle directions for randomness
    final directions = List<(int, int)>.from(AppConstants.directions)..shuffle(_random);
    
    // Try each direction
    for (final direction in directions) {
      // Try many starting positions
      final maxAttempts = gridSize * gridSize * 3;
      final triedPositions = <(int, int)>{};
      
      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final startRow = _random.nextInt(gridSize);
        final startCol = _random.nextInt(gridSize);
        final pos = (startRow, startCol);
        
        // Skip if we've tried this position
        if (triedPositions.contains(pos)) {
          if (triedPositions.length >= gridSize * gridSize) break;
          continue;
        }
        triedPositions.add(pos);
        
        if (_canPlaceWord(grid, word, startRow, startCol, direction, gridSize)) {
          return WordPosition(
            word: word,
            startRow: startRow,
            startCol: startCol,
            direction: direction,
          );
        }
      }
    }
    
    return null;
  }

  /// Try to place word more aggressively (allows more overlaps)
  WordPosition? _tryPlaceWordAggressive(
    List<List<String>> grid,
    String word,
    int gridSize,
  ) {
    final directions = List<(int, int)>.from(AppConstants.directions)..shuffle(_random);
    
    for (final direction in directions) {
      final maxAttempts = gridSize * gridSize * 5;
      final triedPositions = <(int, int)>{};
      
      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final startRow = _random.nextInt(gridSize);
        final startCol = _random.nextInt(gridSize);
        final pos = (startRow, startCol);
        
        if (triedPositions.contains(pos)) {
          if (triedPositions.length >= gridSize * gridSize) break;
          continue;
        }
        triedPositions.add(pos);
        
        if (_canPlaceWordAggressive(grid, word, startRow, startCol, direction, gridSize)) {
          return WordPosition(
            word: word,
            startRow: startRow,
            startCol: startCol,
            direction: direction,
          );
        }
      }
    }
    
    return null;
  }

  /// Check if a word can be placed at a position (standard - allows overlaps on matching letters)
  bool _canPlaceWord(
    List<List<String>> grid,
    String word,
    int startRow,
    int startCol,
    (int, int) direction,
    int gridSize,
  ) {
    final (rowDelta, colDelta) = direction;
    
    // Check bounds
    final endRow = startRow + (rowDelta * (word.length - 1));
    final endCol = startCol + (colDelta * (word.length - 1));
    
    if (endRow < 0 || endRow >= gridSize || endCol < 0 || endCol >= gridSize) {
      return false;
    }
    
    // Check if cells are empty or have matching letters (allows overlap)
    for (int i = 0; i < word.length; i++) {
      final row = startRow + (rowDelta * i);
      final col = startCol + (colDelta * i);
      final cell = grid[row][col];
      final letter = word[i];
      
      // Cell must be empty or have the same letter
      if (cell.isNotEmpty && cell != letter) {
        return false;
      }
    }
    
    return true;
  }

  /// More aggressive placement - allows partial overlaps
  bool _canPlaceWordAggressive(
    List<List<String>> grid,
    String word,
    int startRow,
    int startCol,
    (int, int) direction,
    int gridSize,
  ) {
    final (rowDelta, colDelta) = direction;
    
    // Check bounds
    final endRow = startRow + (rowDelta * (word.length - 1));
    final endCol = startCol + (colDelta * (word.length - 1));
    
    if (endRow < 0 || endRow >= gridSize || endCol < 0 || endCol >= gridSize) {
      return false;
    }
    
    // Allow placement if at least half the cells are empty or match
    int matchingCells = 0;
    for (int i = 0; i < word.length; i++) {
      final row = startRow + (rowDelta * i);
      final col = startCol + (colDelta * i);
      final cell = grid[row][col];
      final letter = word[i];
      
      if (cell.isEmpty || cell == letter) {
        matchingCells++;
      }
    }
    
    // Require at least 70% of cells to be available
    return matchingCells >= (word.length * 0.7).ceil();
  }

  /// Place a word in the grid
  void _placeWordInGrid(List<List<String>> grid, WordPosition position) {
    final (rowDelta, colDelta) = position.direction;
    
    for (int i = 0; i < position.word.length; i++) {
      final row = position.startRow + (rowDelta * i);
      final col = position.startCol + (colDelta * i);
      grid[row][col] = position.word[i];
    }
  }

  /// Fill empty cells with random letters
  void _fillEmptyCells(List<List<String>> grid, int gridSize) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col].isEmpty) {
          grid[row][col] = AppConstants.alphabet[_random.nextInt(AppConstants.alphabet.length)];
        }
      }
    }
  }
}
