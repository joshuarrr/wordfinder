import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../domain/entities/game_state.dart';

/// Sub-header showing category name and puzzle score
class GameSubHeader extends StatelessWidget {
  const GameSubHeader({
    super.key,
    required this.category,
    required this.gameState,
  });

  final WordCategory category;
  final GameState gameState;

  int _getDisplayScore() {
    if (gameState.isCompleted) {
      return gameState.score;
    }
    return gameState.foundWords.length * AppConstants.basePointsPerWord;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Puzzle score
          Text(
            'PUZZLE SCORE: ',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            ScoreFormatter.formatScore(_getDisplayScore()),
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

