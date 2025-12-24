import 'package:flutter/foundation.dart';

/// App-wide constants
abstract final class AppConstants {
  // App info
  static const String appName = 'Word Finder';
  static const String appVersion = '1.0.0';
  
  // Dev mode (only enabled in debug builds)
  static const bool devMode = kDebugMode;

  // Grid sizes by difficulty
  static const int gridSizeEasy = 8;
  static const int gridSizeMedium = 12;
  static const int gridSizeHard = 15;

  // Word count by difficulty
  static const int wordCountEasy = 6;
  static const int wordCountMedium = 10;
  static const int wordCountHard = 15;

  // Time limits (in seconds) - 0 means unlimited
  static const int timeLimitCasual = 0;
  static const int timeLimitEasy = 180;    // 3 minutes
  static const int timeLimitMedium = 300;  // 5 minutes
  static const int timeLimitHard = 420;    // 7 minutes

  // Hints
  static const int hintsPerPuzzleEasy = 5;
  static const int hintsPerPuzzleMedium = 3;
  static const int hintsPerPuzzleHard = 2;

  // Scoring
  static const int basePointsPerWord = 100;
  static const int timeBonus = 10; // Points per second remaining
  static const int hintPenalty = 50; // Points deducted per hint used
  static const int streakMultiplier = 5; // Bonus per day in streak

  // Animation durations (in milliseconds)
  static const int animationFast = 150;
  static const int animationNormal = 300;
  static const int animationSlow = 500;
  static const int animationVerySlow = 800;

  // Alphabet for filling empty cells
  static const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // Directions for word placement
  static const List<(int, int)> directions = [
    (0, 1),   // Right
    (0, -1),  // Left
    (1, 0),   // Down
    (-1, 0),  // Up
    (1, 1),   // Down-Right (diagonal)
    (1, -1),  // Down-Left (diagonal)
    (-1, 1),  // Up-Right (diagonal)
    (-1, -1), // Up-Left (diagonal)
  ];

  // Direction names for display
  static const Map<(int, int), String> directionNames = {
    (0, 1): 'Right',
    (0, -1): 'Left',
    (1, 0): 'Down',
    (-1, 0): 'Up',
    (1, 1): 'Diagonal ↘',
    (1, -1): 'Diagonal ↙',
    (-1, 1): 'Diagonal ↗',
    (-1, -1): 'Diagonal ↖',
  };
}

/// Difficulty levels
enum Difficulty {
  easy(
    gridSize: AppConstants.gridSizeEasy,
    wordCount: AppConstants.wordCountEasy,
    timeLimit: AppConstants.timeLimitEasy,
    hints: AppConstants.hintsPerPuzzleEasy,
  ),
  medium(
    gridSize: AppConstants.gridSizeMedium,
    wordCount: AppConstants.wordCountMedium,
    timeLimit: AppConstants.timeLimitMedium,
    hints: AppConstants.hintsPerPuzzleMedium,
  ),
  hard(
    gridSize: AppConstants.gridSizeHard,
    wordCount: AppConstants.wordCountHard,
    timeLimit: AppConstants.timeLimitHard,
    hints: AppConstants.hintsPerPuzzleHard,
  );

  const Difficulty({
    required this.gridSize,
    required this.wordCount,
    required this.timeLimit,
    required this.hints,
  });

  final int gridSize;
  final int wordCount;
  final int timeLimit;
  final int hints;

  String get displayName => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.medium => 'Medium',
        Difficulty.hard => 'Hard',
      };

  String get description => switch (this) {
        Difficulty.easy => '${gridSize}x$gridSize grid • $wordCount words',
        Difficulty.medium => '${gridSize}x$gridSize grid • $wordCount words',
        Difficulty.hard => '${gridSize}x$gridSize grid • $wordCount words',
      };
}

/// Game modes
enum GameMode {
  casual,
  timed,
  daily;

  String get displayName => switch (this) {
        GameMode.casual => 'Casual',
        GameMode.timed => 'Timed',
        GameMode.daily => 'Daily',
      };

  String get description => switch (this) {
        GameMode.casual => 'Play at your own pace',
        GameMode.timed => 'Race against the clock',
        GameMode.daily => 'New puzzle every day',
      };
}

/// Word categories
enum WordCategory {
  animals('Animals', '🐾'),
  food('Food & Drinks', '🍕'),
  countries('Countries & Cities', '🌍'),
  sports('Sports', '⚽'),
  nature('Nature', '🌿'),
  science('Science & Tech', '🔬'),
  movies('Movies & Entertainment', '🎬'),
  holidays('Holidays & Seasons', '🎄');

  const WordCategory(this.displayName, this.emoji);

  final String displayName;
  final String emoji;
}

