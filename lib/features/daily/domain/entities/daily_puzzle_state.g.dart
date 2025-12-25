// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_puzzle_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyPuzzleStatsImpl _$$DailyPuzzleStatsImplFromJson(
  Map<String, dynamic> json,
) => _$DailyPuzzleStatsImpl(
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
  totalCompleted: (json['totalCompleted'] as num?)?.toInt() ?? 0,
  lastCompletionDate: _dateTimeNullableFromJson(
    json['lastCompletionDate'] as String?,
  ),
  bestScore: (json['bestScore'] as num?)?.toInt() ?? 0,
  totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$DailyPuzzleStatsImplToJson(
  _$DailyPuzzleStatsImpl instance,
) => <String, dynamic>{
  'currentStreak': instance.currentStreak,
  'bestStreak': instance.bestStreak,
  'totalCompleted': instance.totalCompleted,
  'lastCompletionDate': _dateTimeNullableToJson(instance.lastCompletionDate),
  'bestScore': instance.bestScore,
  'totalScore': instance.totalScore,
};
