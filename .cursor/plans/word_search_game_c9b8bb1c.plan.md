---
name: Word Search Game
overview: Build a Flutter word search game targeting iOS (iPhone + iPad) and Web with playful aesthetics, multiple game modes, cloud sync, and in-app purchases.
todos:
  - id: setup-flutter
    content: Initialize Flutter project with iOS + Web platform configs
    status: completed
  - id: theme-system
    content: Create playful theme with colors, typography, animations
    status: completed
  - id: navigation
    content: Set up go_router navigation structure
    status: completed
  - id: grid-algorithm
    content: Implement word search grid generation algorithm
    status: completed
  - id: touch-selection
    content: Build touch/drag selection system for letter grid
    status: completed
  - id: game-state
    content: Implement game state management with Riverpod
    status: completed
  - id: word-lists
    content: Create word lists for all 8 categories
    status: pending
  - id: game-modes
    content: Implement casual, timed, and difficulty modes
    status: pending
  - id: local-storage
    content: Set up Hive for local persistence
    status: pending
  - id: daily-puzzle
    content: Build daily puzzle system with streaks
    status: pending
  - id: firebase-auth
    content: Integrate Firebase auth (email, Apple, Google)
    status: pending
  - id: cloud-sync
    content: Implement Firestore cloud sync for user data
    status: pending
  - id: leaderboards
    content: Build leaderboard system
    status: pending
  - id: achievements
    content: Create achievements/badges system
    status: pending
  - id: iap
    content: Integrate in-app purchases
    status: pending
  - id: audio
    content: Add sound effects and background music
    status: pending
  - id: responsive
    content: Optimize layouts for iPhone, iPad, and Web
    status: pending
---

# Word Search Game - Flutter Implementation Plan

## Summary of Requirements

| Feature | Selection ||---------|-----------|| Platforms | iOS (iPhone + iPad), Web || Word Directions | All 8 (horizontal, vertical, diagonal + reverses) || Difficulty | Easy (8x8), Medium (12x12), Hard (15x15) || Game Modes | Casual, Timed, Daily Puzzle || Word Source | Built-in themed categories || Theme | Playful / Colorful with animations || Hints | Reveal first letter, Highlight word (limited per puzzle) || Storage | Local + Cloud sync with accounts || Scoring | Time tracking, Streaks, Leaderboards, Achievements, Stats || Categories | Animals, Food, Countries, Sports, Nature, Science, Movies, Holidays || Monetization | In-app purchases (hints, themes, categories) || Audio | Sound effects + background music |---

## Architecture

```mermaid
graph TB
    subgraph presentation [Presentation Layer]
        Screens[Screens]
        Widgets[Widgets]
        Animations[Animations]
    end

    subgraph domain [Domain Layer]
        Models[Models]
        UseCases[Use Cases]
        Repositories[Repository Interfaces]
    end

    subgraph data [Data Layer]
        LocalStorage[Local Storage - Hive]
        CloudSync[Cloud Sync - Firebase]
        AudioService[Audio Service]
        IAPService[IAP Service]
    end

    presentation --> domain
    domain --> data
```

---

## Project Structure

```javascript
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── extensions/
├── features/
│   ├── game/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── screens/
│   │       ├── widgets/
│   │       ├── providers/
│   │       └── animations/
│   ├── daily_puzzle/
│   ├── settings/
│   ├── stats/
│   ├── leaderboard/
│   ├── achievements/
│   └── auth/
├── services/
│   ├── audio_service.dart
│   ├── iap_service.dart
│   └── analytics_service.dart
└── data/
    └── word_lists/
        ├── animals.dart
        ├── food.dart
        └── ... (other categories)
```

---

## Key Dependencies

| Package | Purpose ||---------|---------|| `flutter_riverpod` | State management || `hive_flutter` | Local storage || `firebase_core`, `firebase_auth`, `cloud_firestore` | Cloud sync + auth || `in_app_purchase` | Monetization || `audioplayers` | Sound effects + music || `go_router` | Navigation || `freezed` + `json_serializable` | Immutable models || `flutter_animate` | Playful animations |---

## Core Game Logic

### Grid Generation Algorithm

1. Create empty NxN grid based on difficulty
2. For each word in the puzzle:

- Pick random direction (8 options)
- Find valid starting positions
- Place word if it fits (can overlap on matching letters)

3. Fill remaining cells with random letters
4. Store word positions for validation

### Touch/Selection System

```mermaid
sequenceDiagram
    participant User
    participant Grid
    participant GameState
    participant AudioService

    User->>Grid: Touch start
    Grid->>GameState: Begin selection
    User->>Grid: Drag across letters
    Grid->>GameState: Update selection path
    User->>Grid: Release touch
    GameState->>GameState: Validate word
    alt Word found
        GameState->>AudioService: Play success sound
        GameState->>Grid: Mark word complete
    else Not a word
        GameState->>AudioService: Play error sound
        GameState->>Grid: Clear selection
    end
```

---

## Screens

1. **Home** - Mode selection, daily puzzle banner, stats preview
2. **Category Select** - Grid of themed categories with lock states for IAP
3. **Difficulty Select** - Easy/Medium/Hard with grid previews
4. **Game** - Main puzzle grid, word list, timer, hints, pause
5. **Pause Menu** - Resume, restart, settings, quit
6. **Results** - Time, score, achievements unlocked, share
7. **Daily Puzzle** - Calendar view, streak display
8. **Stats** - Personal statistics, graphs
9. **Leaderboard** - Global/Friends rankings
10. **Achievements** - Badge collection with progress
11. **Settings** - Sound, music, theme, account, restore purchases
12. **Auth** - Sign in/up for cloud sync

---

## Data Models

```dart
// Core game entities
class Puzzle { grid, words, difficulty, category, timeLimit }
class Word { text, startPos, endPos, direction, isFound }
class GameSession { puzzle, foundWords, elapsedTime, hintsUsed, score }
class UserProfile { id, displayName, stats, achievements, purchases }
class DailyPuzzle { date, puzzle, completed, streak }
```

---

## Implementation Phases

### Phase 1: Foundation

- Flutter project setup with platform configs
- Core theme system (playful colors, typography, spacing)
- Navigation structure with go_router
- Base widget library (buttons, cards, grid cell)

### Phase 2: Core Game

- Grid generation algorithm
- Touch selection system
- Word validation
- Game state management with Riverpod
- Basic game screen UI

### Phase 3: Game Modes

- Casual mode (untimed)
- Timed mode with countdown
- Difficulty levels (grid sizes)
- Category system with word lists

### Phase 4: Persistence

- Hive local storage setup
- Game progress saving
- Stats tracking
- Settings persistence

### Phase 5: Daily Puzzle

- Daily puzzle generation (seeded random)
- Streak system
- Calendar view

### Phase 6: Cloud Sync

- Firebase setup
- Authentication (email, Apple, Google)
- Cloud Firestore for user data
- Cross-device sync

### Phase 7: Scoring System

- Leaderboards (Firebase)
- Achievements system
- Stats dashboard

### Phase 8: Monetization

- In-app purchase setup
- Premium categories
- Hint packs
- Ad removal option (if adding ads later)

### Phase 9: Audio

- Sound effects integration
- Background music
- Audio settings

### Phase 10: Polish

- Animations (word found, level complete, achievements)