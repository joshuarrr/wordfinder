import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_puzzle_progress.freezed.dart';
part 'daily_puzzle_progress.g.dart';

/// Represents in-progress state of a daily puzzle
@freezed
class DailyPuzzleProgress with _$DailyPuzzleProgress {
  const factory DailyPuzzleProgress({
    /// Date of the puzzle (stored as ISO string)
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime puzzleDate,
    
    /// Words that have been found
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _setFromJson, toJson: _setToJson)
    @Default(<String>{})
    Set<String> foundWords,
    
    /// Time spent on puzzle in seconds
    @Default(0) int elapsedSeconds,
    
    /// When the puzzle was started
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
    DateTime? startedAt,
    
    /// Whether the puzzle is completed
    @Default(false) bool isCompleted,
    
    /// Final score (only set when completed)
    int? finalScore,
  }) = _DailyPuzzleProgress;

  factory DailyPuzzleProgress.fromJson(Map<String, dynamic> json) =>
      _$DailyPuzzleProgressFromJson(json);
}

// JSON converters
DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

DateTime? _dateTimeNullableFromJson(String? date) => 
    date == null ? null : DateTime.parse(date);
String? _dateTimeNullableToJson(DateTime? date) => 
    date?.toIso8601String();

Set<String> _setFromJson(List<dynamic> list) => 
    list.map((e) => e as String).toSet();
List<String> _setToJson(Set<String> set) => set.toList();

