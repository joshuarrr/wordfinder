// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_puzzle_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyPuzzleProgressImpl _$$DailyPuzzleProgressImplFromJson(
  Map<String, dynamic> json,
) => _$DailyPuzzleProgressImpl(
  puzzleDate: _dateTimeFromJson(json['puzzleDate'] as String),
  foundWords: json['foundWords'] == null
      ? const <String>{}
      : _setFromJson(json['foundWords'] as List),
  elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
  startedAt: _dateTimeNullableFromJson(json['startedAt'] as String?),
  isCompleted: json['isCompleted'] as bool? ?? false,
  finalScore: (json['finalScore'] as num?)?.toInt(),
);

Map<String, dynamic> _$$DailyPuzzleProgressImplToJson(
  _$DailyPuzzleProgressImpl instance,
) => <String, dynamic>{
  'puzzleDate': _dateTimeToJson(instance.puzzleDate),
  'foundWords': _setToJson(instance.foundWords),
  'elapsedSeconds': instance.elapsedSeconds,
  'startedAt': _dateTimeNullableToJson(instance.startedAt),
  'isCompleted': instance.isCompleted,
  'finalScore': instance.finalScore,
};
