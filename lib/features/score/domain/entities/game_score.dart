import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';

part 'game_score.freezed.dart';
part 'game_score.g.dart';

/// Represents a completed game score
@freezed
class GameScore with _$GameScore {
  const factory GameScore({
    required int score,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _difficultyFromJson, toJson: _difficultyToJson)
    required Difficulty difficulty,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
    required WordCategory category,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _gameModeFromJson, toJson: _gameModeToJson)
    required GameMode gameMode,
    required int elapsedSeconds,
    required int wordsFound,
    required int totalWords,
    required int hintsUsed,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime completedAt,
    @Default(false) bool isPerfectGame,
  }) = _GameScore;

  factory GameScore.fromJson(Map<String, dynamic> json) =>
      _$GameScoreFromJson(json);
}

Difficulty _difficultyFromJson(String name) =>
    Difficulty.values.firstWhere((d) => d.name == name);
String _difficultyToJson(Difficulty difficulty) => difficulty.name;

WordCategory _categoryFromJson(String name) =>
    WordCategory.values.firstWhere((c) => c.name == name);
String _categoryToJson(WordCategory category) => category.name;

GameMode _gameModeFromJson(String name) =>
    GameMode.values.firstWhere((m) => m.name == name);
String _gameModeToJson(GameMode gameMode) => gameMode.name;

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

