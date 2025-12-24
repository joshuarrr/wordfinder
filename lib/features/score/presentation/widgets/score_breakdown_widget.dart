import 'package:flutter/material.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../game/domain/entities/game_state.dart';

/// Widget showing score breakdown in completion dialog
class ScoreBreakdownWidget extends StatelessWidget {
  const ScoreBreakdownWidget({
    super.key,
    required this.gameState,
  });

  final GameState gameState;

  int get _baseScore =>
      gameState.foundWords.length * AppConstants.basePointsPerWord;

  int get _timeBonus {
    if (gameState.puzzle.gameMode == GameMode.timed &&
        gameState.puzzle.difficulty.timeLimit > 0) {
      final remainingTime =
          gameState.puzzle.difficulty.timeLimit - gameState.elapsedSeconds;
      if (remainingTime > 0) {
        return remainingTime * AppConstants.timeBonus;
      }
    }
    return 0;
  }

  int get _hintPenalty => gameState.hintsUsed * AppConstants.hintPenalty;

  int get _totalScore => _baseScore + _timeBonus - _hintPenalty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Score Breakdown',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildBreakdownRow(
          'Base Score',
          _baseScore,
          '${gameState.foundWords.length} words × ${AppConstants.basePointsPerWord}',
        ),
        if (_timeBonus > 0) ...[
          const SizedBox(height: 8),
          _buildBreakdownRow(
            'Time Bonus',
            _timeBonus,
            '${((gameState.puzzle.difficulty.timeLimit - gameState.elapsedSeconds) / 60).toStringAsFixed(1)} min remaining',
            color: AppColors.success,
          ),
        ],
        if (_hintPenalty > 0) ...[
          const SizedBox(height: 8),
          _buildBreakdownRow(
            'Hint Penalty',
            -_hintPenalty,
            '${gameState.hintsUsed} hints × ${AppConstants.hintPenalty}',
            color: AppColors.error,
          ),
        ],
        const Divider(height: 24),
        _buildBreakdownRow(
          'Total Score',
          _totalScore,
          null,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(
    String label,
    int score,
    String? subtitle, {
    Color? color,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: color ?? AppColors.textPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Text(
          score >= 0
              ? '+${ScoreFormatter.formatScore(score)}'
              : ScoreFormatter.formatScore(score),
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: color ??
                (isTotal ? AppColors.success : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

