// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreStatsImpl _$$ScoreStatsImplFromJson(Map<String, dynamic> json) =>
    _$ScoreStatsImpl(
      totalLifetimeScore: (json['totalLifetimeScore'] as num).toInt(),
      totalGamesPlayed: (json['totalGamesPlayed'] as num).toInt(),
      totalWordsFound: (json['totalWordsFound'] as num).toInt(),
      averageScore: (json['averageScore'] as num).toDouble(),
      bestStreakHighScore: (json['bestStreakHighScore'] as num).toInt(),
      bestStreakDays: (json['bestStreakDays'] as num).toInt(),
      bestStreakGames: (json['bestStreakGames'] as num).toInt(),
      bestStreakPerfect: (json['bestStreakPerfect'] as num).toInt(),
      highScores: _highScoresFromJson(
        json['highScores'] as Map<String, dynamic>,
      ),
      difficultyStats: _difficultyStatsFromJson(
        json['difficultyStats'] as Map<String, dynamic>,
      ),
      recentGames: (json['recentGames'] as List<dynamic>)
          .map((e) => GameScore.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScoreStatsImplToJson(_$ScoreStatsImpl instance) =>
    <String, dynamic>{
      'totalLifetimeScore': instance.totalLifetimeScore,
      'totalGamesPlayed': instance.totalGamesPlayed,
      'totalWordsFound': instance.totalWordsFound,
      'averageScore': instance.averageScore,
      'bestStreakHighScore': instance.bestStreakHighScore,
      'bestStreakDays': instance.bestStreakDays,
      'bestStreakGames': instance.bestStreakGames,
      'bestStreakPerfect': instance.bestStreakPerfect,
      'highScores': _highScoresToJson(instance.highScores),
      'difficultyStats': _difficultyStatsToJson(instance.difficultyStats),
      'recentGames': instance.recentGames,
    };

_$DifficultyStatsImpl _$$DifficultyStatsImplFromJson(
  Map<String, dynamic> json,
) => _$DifficultyStatsImpl(
  gamesPlayed: (json['gamesPlayed'] as num).toInt(),
  totalScore: (json['totalScore'] as num).toInt(),
  averageScore: (json['averageScore'] as num).toDouble(),
  highScore: (json['highScore'] as num).toInt(),
  bestStreakHighScore: (json['bestStreakHighScore'] as num).toInt(),
  bestStreakPerfect: (json['bestStreakPerfect'] as num).toInt(),
  bestTimeSeconds: (json['bestTimeSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$$DifficultyStatsImplToJson(
  _$DifficultyStatsImpl instance,
) => <String, dynamic>{
  'gamesPlayed': instance.gamesPlayed,
  'totalScore': instance.totalScore,
  'averageScore': instance.averageScore,
  'highScore': instance.highScore,
  'bestStreakHighScore': instance.bestStreakHighScore,
  'bestStreakPerfect': instance.bestStreakPerfect,
  'bestTimeSeconds': instance.bestTimeSeconds,
};
