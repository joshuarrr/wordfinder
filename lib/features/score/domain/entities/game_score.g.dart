// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameScoreImpl _$$GameScoreImplFromJson(Map<String, dynamic> json) =>
    _$GameScoreImpl(
      score: (json['score'] as num).toInt(),
      difficulty: _difficultyFromJson(json['difficulty'] as String),
      category: _categoryFromJson(json['category'] as String),
      gameMode: _gameModeFromJson(json['gameMode'] as String),
      elapsedSeconds: (json['elapsedSeconds'] as num).toInt(),
      wordsFound: (json['wordsFound'] as num).toInt(),
      totalWords: (json['totalWords'] as num).toInt(),
      hintsUsed: (json['hintsUsed'] as num).toInt(),
      completedAt: _dateTimeFromJson(json['completedAt'] as String),
      isPerfectGame: json['isPerfectGame'] as bool? ?? false,
    );

Map<String, dynamic> _$$GameScoreImplToJson(_$GameScoreImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'difficulty': _difficultyToJson(instance.difficulty),
      'category': _categoryToJson(instance.category),
      'gameMode': _gameModeToJson(instance.gameMode),
      'elapsedSeconds': instance.elapsedSeconds,
      'wordsFound': instance.wordsFound,
      'totalWords': instance.totalWords,
      'hintsUsed': instance.hintsUsed,
      'completedAt': _dateTimeToJson(instance.completedAt),
      'isPerfectGame': instance.isPerfectGame,
    };
