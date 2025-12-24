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
    final minWordLength = difficulty.minWordLength;
    final maxWordLength = difficulty.maxWordLength;
    
    // Get words for this category - filter by difficulty-based length constraints
    final allWords = WordLists.getWordsForCategory(category);
    
    // Filter words based on difficulty word length constraints
    // Also ensure words fit in the grid (word length can't exceed grid size)
    final effectiveMaxLength = maxWordLength.clamp(minWordLength, gridSize);
    
    // Filter and deduplicate words - ensure each word appears only once
    final availableWords = allWords
        .where((word) => word.length >= minWordLength && word.length <= effectiveMaxLength)
        .toSet() // Remove duplicates
        .toList();
    
    // Shuffle to ensure randomness
    availableWords.shuffle(_random);
    
    // Group words by length, then shuffle within each group
    // This ensures variety while still preferring shorter words
    final wordsByLength = <int, List<String>>{};
    for (final word in availableWords) {
      wordsByLength.putIfAbsent(word.length, () => []).add(word);
    }
    
    // Create a randomized list that prefers shorter words but maintains variety
    final randomizedWords = <String>[];
    for (int len = minWordLength; len <= effectiveMaxLength; len++) {
      if (wordsByLength.containsKey(len)) {
        final words = wordsByLength[len]!..shuffle(_random);
        randomizedWords.addAll(words);
      }
    }
    
    // Create empty grid
    final grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => ''),
    );
    
    final placedWords = <WordPosition>[];
    final usedWords = <String>{};
    
    // Try to place words with better randomization
    // Use weighted random selection: prefer shorter words but allow longer ones
    // For easier difficulties, prefer shorter words; for harder, allow more length variety
    final preferredMaxLengthForSelection = difficulty == Difficulty.easy
        ? effectiveMaxLength
        : (effectiveMaxLength * 0.75).ceil();
    
    final wordsToTry = <String>[];
    for (int len = minWordLength; len <= preferredMaxLengthForSelection; len++) {
      if (wordsByLength.containsKey(len)) {
        final words = List<String>.from(wordsByLength[len]!)..shuffle(_random);
        wordsToTry.addAll(words.take(wordCount * 2)); // Take more candidates
      }
    }
    // Add some longer words for variety (especially for medium/hard)
    for (int len = preferredMaxLengthForSelection + 1; len <= effectiveMaxLength; len++) {
      if (wordsByLength.containsKey(len)) {
        final words = List<String>.from(wordsByLength[len]!)..shuffle(_random);
        wordsToTry.addAll(words.take(wordCount)); // Fewer longer words
      }
    }
    // Final shuffle to mix lengths
    wordsToTry.shuffle(_random);
    
    // Try placing words
    for (final word in wordsToTry) {
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
    
    // If we still don't have enough words, try with remaining words
    if (placedWords.length < wordCount) {
      final remainingWords = randomizedWords
          .where((word) => !usedWords.contains(word))
          .toList()
        ..shuffle(_random);
      
      for (final word in remainingWords) {
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
      final remainingWords = randomizedWords
          .where((word) => !usedWords.contains(word))
          .where((word) => word.length >= minWordLength && word.length <= effectiveMaxLength)
          .toList()
        ..shuffle(_random);
      
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
    
    // Fill remaining cells with random letters, avoiding duplicate words
    _fillEmptyCellsSafely(grid, gridSize, placedWords);
    
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

  /// Fill empty cells with random letters, ensuring no duplicate findable words are created
  void _fillEmptyCellsSafely(
    List<List<String>> grid,
    int gridSize,
    List<WordPosition> placedWords,
  ) {
    // Get all findable words (forward and reverse since words can be found both ways)
    final findableWords = <String>{};
    for (final wp in placedWords) {
      findableWords.add(wp.word);
      findableWords.add(wp.word.split('').reversed.join());
    }

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col].isEmpty) {
          // Try random letters until we find one that doesn't create a duplicate word
          final shuffledAlphabet = AppConstants.alphabet.split('')..shuffle(_random);
          
          String chosenLetter = shuffledAlphabet.first;
          for (final letter in shuffledAlphabet) {
            if (!_wouldCreateDuplicateWord(grid, row, col, letter, gridSize, placedWords, findableWords)) {
              chosenLetter = letter;
              break;
            }
          }
          
          grid[row][col] = chosenLetter;
        }
      }
    }
  }

  /// Check if placing a letter at (row, col) would create a duplicate of any findable word
  bool _wouldCreateDuplicateWord(
    List<List<String>> grid,
    int row,
    int col,
    String letter,
    int gridSize,
    List<WordPosition> placedWords,
    Set<String> findableWords,
  ) {
    // Temporarily place the letter
    final originalValue = grid[row][col];
    grid[row][col] = letter;

    // Check all directions from this cell
    for (final direction in AppConstants.directions) {
      for (final word in findableWords) {
        // Check if this cell could be any position in the word
        for (int posInWord = 0; posInWord < word.length; posInWord++) {
          if (_checkWordAtPosition(grid, row, col, direction, word, posInWord, gridSize, placedWords)) {
            // Found a duplicate - restore and return true
            grid[row][col] = originalValue;
            return true;
          }
        }
      }
    }

    // Restore original value
    grid[row][col] = originalValue;
    return false;
  }

  /// Check if a word exists at a position where (row, col) is at posInWord index
  bool _checkWordAtPosition(
    List<List<String>> grid,
    int row,
    int col,
    (int, int) direction,
    String word,
    int posInWord,
    int gridSize,
    List<WordPosition> placedWords,
  ) {
    final (rowDelta, colDelta) = direction;
    
    // Calculate where the word would start
    final startRow = row - (rowDelta * posInWord);
    final startCol = col - (colDelta * posInWord);
    
    // Calculate where it would end
    final endRow = startRow + (rowDelta * (word.length - 1));
    final endCol = startCol + (colDelta * (word.length - 1));
    
    // Check bounds
    if (startRow < 0 || startRow >= gridSize || startCol < 0 || startCol >= gridSize) {
      return false;
    }
    if (endRow < 0 || endRow >= gridSize || endCol < 0 || endCol >= gridSize) {
      return false;
    }
    
    // Check if the word matches at this position
    for (int i = 0; i < word.length; i++) {
      final checkRow = startRow + (rowDelta * i);
      final checkCol = startCol + (colDelta * i);
      final cell = grid[checkRow][checkCol];
      
      // Empty cells can't form a complete word
      if (cell.isEmpty) return false;
      
      if (cell != word[i]) return false;
    }
    
    // Word matches! Check if this is the original placed position (which is allowed)
    for (final wp in placedWords) {
      if (wp.word == word || wp.word == word.split('').reversed.join()) {
        // Check if this is the exact same position as the placed word
        final wpEndRow = wp.startRow + (wp.direction.$1 * (wp.word.length - 1));
        final wpEndCol = wp.startCol + (wp.direction.$2 * (wp.word.length - 1));
        
        // Same position forward
        if (wp.startRow == startRow && wp.startCol == startCol &&
            wp.direction == direction) {
          return false; // This is the original placement, not a duplicate
        }
        // Same position but checking reversed word
        if (wpEndRow == startRow && wpEndCol == startCol &&
            wp.direction.$1 == -rowDelta && wp.direction.$2 == -colDelta) {
          return false; // This is the original placement read backwards
        }
      }
    }
    
    // This is a duplicate word at a different position
    return true;
  }
}
