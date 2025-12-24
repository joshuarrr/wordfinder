import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../score/domain/entities/game_score.dart';

/// List widget showing recent games
class RecentGamesList extends StatelessWidget {
  const RecentGamesList({
    super.key,
    required this.games,
  });

  final List<GameScore> games;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final gameDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(gameDate).inDays;

    if (diff == 0) {
      return 'Today';
    } else if (diff == 1) {
      return 'Yesterday';
    } else if (diff < 7) {
      return '$diff days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return Center(
        child: Text(
          'No games played yet',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: games.length,
      separatorBuilder: (context, index) => AppSpacing.vGapSm,
      itemBuilder: (context, index) {
        final game = games[index];
        return GameCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          game.category.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        AppSpacing.hGapSm,
                        Text(
                          game.difficulty.displayName,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (game.isPerfectGame) ...[
                          AppSpacing.hGapXs,
                          const Text('✨', style: TextStyle(fontSize: 16)),
                        ],
                      ],
                    ),
                    AppSpacing.vGapXs,
                    Text(
                      _formatDate(game.completedAt),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ScoreFormatter.formatScore(game.score),
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    _formatTime(game.elapsedSeconds),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

