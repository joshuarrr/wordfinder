import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_puzzle_state.freezed.dart';
part 'daily_puzzle_state.g.dart';

/// Statistics and streak information for daily puzzles
@freezed
class DailyPuzzleStats with _$DailyPuzzleStats {
  const factory DailyPuzzleStats({
    /// Current daily puzzle streak (consecutive days completed)
    @Default(0) int currentStreak,
    
    /// Best daily puzzle streak ever
    @Default(0) int bestStreak,
    
    /// Total daily puzzles completed
    @Default(0) int totalCompleted,
    
    /// Last completion date (for streak calculation)
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
    DateTime? lastCompletionDate,
    
    /// Best score on daily puzzles
    @Default(0) int bestScore,
    
    /// Total score from all daily puzzles
    @Default(0) int totalScore,
  }) = _DailyPuzzleStats;

  factory DailyPuzzleStats.fromJson(Map<String, dynamic> json) =>
      _$DailyPuzzleStatsFromJson(json);
}

// JSON converters
DateTime? _dateTimeNullableFromJson(String? date) => 
    date == null ? null : DateTime.parse(date);
String? _dateTimeNullableToJson(DateTime? date) => 
    date?.toIso8601String();

