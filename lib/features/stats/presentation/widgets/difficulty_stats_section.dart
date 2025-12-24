import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../score/domain/entities/score_stats.dart';

/// Section showing stats per difficulty
class DifficultyStatsSection extends StatelessWidget {
  const DifficultyStatsSection({
    super.key,
    required this.difficultyStats,
  });

  final Map<Difficulty, DifficultyStats> difficultyStats;

  String _formatTime(int? seconds) {
    if (seconds == null) return 'N/A';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (difficultyStats.isEmpty) {
      return Center(
        child: Text(
          'No difficulty stats yet',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Stats',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.vGapMd,
        ...Difficulty.values.map((difficulty) {
          final stats = difficultyStats[difficulty];
          if (stats == null || stats.gamesPlayed == 0) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: GameCard(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      difficulty.displayName,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.hGapSm,
                    Text(
                      '${stats.gamesPlayed} games',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapMd,
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: 'High Score',
                        value: ScoreFormatter.formatScore(stats.highScore),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Avg Score',
                        value: ScoreFormatter.formatScore(
                          stats.averageScore.round(),
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapSm,
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: 'Best Time',
                        value: _formatTime(stats.bestTimeSeconds),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Perfect Streak',
                        value: '${stats.bestStreakPerfect}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ),
          );
        }),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.vGapXs,
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

