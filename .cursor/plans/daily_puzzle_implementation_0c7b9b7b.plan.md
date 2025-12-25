---
name: Daily Puzzle Implementation
overview: Implement a daily puzzle feature with deterministic puzzle generation, progress saving, separate streak tracking, and bonus scoring. The puzzle uses Medium difficulty with rotating categories, no hints, and saves progress for same-day completion.
todos:
  - id: daily-entities
    content: Create daily puzzle domain entities (DailyPuzzleState, DailyPuzzleProgress)
    status: completed
  - id: daily-datasource
    content: Create LocalDailyDataSource for SharedPreferences storage
    status: completed
    dependencies:
      - daily-entities
  - id: daily-repository
    content: Create daily repository interface and implementation
    status: completed
    dependencies:
      - daily-datasource
  - id: deterministic-generation
    content: Add deterministic puzzle generation method to PuzzleGenerator using date seed
    status: completed
  - id: daily-providers
    content: Create Riverpod providers for daily puzzle state and streak
    status: completed
    dependencies:
      - daily-repository
      - deterministic-generation
  - id: daily-screen
    content: Create DailyPuzzleScreen with progress saving and completion handling
    status: completed
    dependencies:
      - daily-providers
  - id: home-screen-updates
    content: Update home screen card to show completion badge and navigate to daily puzzle
    status: completed
    dependencies:
      - daily-providers
  - id: scoring-updates
    content: Update GameState scoring to include daily streak bonus
    status: completed
    dependencies:
      - daily-providers
  - id: game-providers-updates
    content: Update game providers to load/save daily puzzle progress
    status: completed
    dependencies:
      - daily-providers
  - id: router-updates
    content: Add daily puzzle route to app router
    status: completed
    dependencies:
      - daily-screen
---

# Daily Puzzle Implementation Plan

## Overview

Implement a daily puzzle feature where:

- Same puzzle for all users on the same day (deterministic based on date)
- Medium difficulty with category rotating daily

- No hints allowed
- Progress saves and can be resumed same day
- Separate daily puzzle streak counter
- Bonus scoring with streak multiplier

- Completion badge on home screen card
- No replay until next day

## Architecture

```javascript
lib/features/daily/
├── data/
│   ├── datasources/
│   │   └── local_daily_data_source.dart
│   └── repositories/
│       └── daily_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── daily_puzzle_state.dart
│   │   └── daily_puzzle_progress.dart
│   └── repositories/
│       └── daily_repository.dart
├── presentation/
│   ├── providers/
│   │   └── daily_providers.dart
│   └── screens/
│       └── daily_puzzle_screen.dart
```



## Implementation Steps

### 1. Daily Puzzle Data Layer

**Create `lib/features/daily/domain/entities/daily_puzzle_state.dart`**

- Entity to store daily puzzle state: puzzle data, completion status, found words, elapsed time, date
- Use freezed for immutability

**Create `lib/features/daily/domain/entities/daily_puzzle_progress.dart`**

- Entity for in-progress daily puzzle: found words, elapsed seconds, started at

**Create `lib/features/daily/data/datasources/local_daily_data_source.dart`**

- Store daily puzzle state in SharedPreferences

- Keys: `daily_puzzle_state_{date}`, `daily_streak`, `daily_last_completion_date`

- Methods: `getDailyPuzzleState(DateTime date)`, `saveDailyPuzzleState()`, `getDailyStreak()`, `setDailyStreak()`, `getLastCompletionDate()`

**Create `lib/features/daily/domain/repositories/daily_repository.dart`**

- Interface: `getDailyPuzzleState()`, `saveProgress()`, `completeDailyPuzzle()`, `getDailyStreak()`

**Create `lib/features/daily/data/repositories/daily_repository_impl.dart`**

- Implement repository using LocalDailyDataSource

- Handle streak calculation (increment if consecutive days, reset if gap)

### 2. Deterministic Puzzle Generation

**Modify `lib/features/game/data/datasources/puzzle_generator.dart`**

- Add method `generateDailyPuzzle(DateTime date)` that:
- Uses date as seed for Random: `Random(date.millisecondsSinceEpoch)`
- Rotates category based on day of year: `categories[dayOfYear % categories.length]`

- Always uses `Difficulty.medium`
- Always uses `GameMode.daily`
- Ensure same date always produces same puzzle

### 3. Daily Puzzle Providers

**Create `lib/features/daily/presentation/providers/daily_providers.dart`**

- `dailyPuzzleStateProvider`: Async provider that loads or generates today's puzzle

- `dailyStreakProvider`: Provider for current daily streak

- `dailyPuzzleRepositoryProvider`: Provider for repository instance
- Handle puzzle generation, progress loading, completion tracking

### 4. Daily Puzzle Screen

**Create `lib/features/daily/presentation/screens/daily_puzzle_screen.dart`**

- Similar to `GameScreen` but:

- Shows date and category at top
- Displays daily streak
- No hint button (hints disabled)

- Auto-saves progress on word found

- Shows completion screen with bonus score calculation
- Prevents replay after completion
- Reuse `WordSearchGrid` widget with `GameMode.daily`

### 5. Home Screen Updates

**Update `lib/features/home/presentation/screens/home_screen.dart`**

- Update `_buildDailyPuzzleCard()`:

- Check if today's puzzle is completed (show checkmark badge)
- Show "New puzzle tomorrow" text if completed
- Navigate to daily puzzle screen on tap

- Display current daily streak
- Add completion badge overlay when puzzle is done

### 6. Scoring Integration

**Update `lib/features/game/domain/entities/game_state.dart`**

- Modify `score` getter to check for `GameMode.daily`:
- Add bonus: `streakMultiplier * dailyStreak` points

- Time bonus still applies (no time limit but faster = more bonus)

**Update `lib/features/score/data/repositories/score_repository_impl.dart`**

- When saving daily puzzle score, also update daily streak

- Track daily puzzle completion separately

### 7. Router Updates

**Update `lib/core/router/app_router.dart`**

- Add route for `/daily` that navigates to `DailyPuzzleScreen`

- Use appropriate transition

### 8. Game Providers Updates

**Update `lib/features/game/presentation/providers/game_providers.dart`**

- Modify `AsyncGameStateNotifier` to handle `GameMode.daily`:
- Load from daily repository if in progress
- Generate deterministic puzzle if new
- Auto-save progress on state changes

## Key Implementation Details

### Deterministic Generation

```dart
// In PuzzleGenerator
Puzzle generateDailyPuzzle(DateTime date) {
  final dateOnly = DateTime(date.year, date.month, date.day);
  final seed = dateOnly.millisecondsSinceEpoch;
  final random = Random(seed);
  
  // Rotate category based on day of year
  final dayOfYear = dateOnly.difference(DateTime(date.year, 1, 1)).inDays;
  final category = WordCategory.values[dayOfYear % WordCategory.values.length];
  
  return _generateSync(
    difficulty: Difficulty.medium,
    category: category,
    gameMode: GameMode.daily,
    random: random, // Pass seeded random
  );
}
```



### Progress Saving

- Save progress after each word found

- Save on pause/background
- Load progress when screen opens if puzzle exists for today

### Streak Calculation

- Check if last completion was yesterday
- If yes: increment streak
- If no: reset to 1
- Update best streak if current exceeds it

### Bonus Scoring

```dart
// In GameState.score getter
if (puzzle.gameMode == GameMode.daily) {
  final dailyStreak = ref.read(dailyStreakProvider);
  final streakBonus = AppConstants.streakMultiplier * dailyStreak;
  return baseScore + timeBonus - hintPenalty + streakBonus;
}
```



## Files to Create/Modify

**New Files:**

- `lib/features/daily/domain/entities/daily_puzzle_state.dart`
- `lib/features/daily/domain/entities/daily_puzzle_progress.dart`
- `lib/features/daily/domain/repositories/daily_repository.dart`

- `lib/features/daily/data/datasources/local_daily_data_source.dart`
- `lib/features/daily/data/repositories/daily_repository_impl.dart`

- `lib/features/daily/presentation/providers/daily_providers.dart`
- `lib/features/daily/presentation/screens/daily_puzzle_screen.dart`

**Modified Files:**

- `lib/features/game/data/datasources/puzzle_generator.dart` - Add deterministic generation
- `lib/features/game/domain/entities/game_state.dart` - Add daily bonus scoring

- `lib/features/game/presentation/providers/game_providers.dart` - Handle daily mode loading/saving

- `lib/features/home/presentation/screens/home_screen.dart` - Update card with completion status
- `lib/core/router/app_router.dart` - Add daily route