import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../score/presentation/widgets/cumulative_score_widget.dart';
import '../../domain/entities/game_state.dart';
import 'game_footer.dart';

/// Sidebar widget for landscape mode containing all game info
class LandscapeSidebar extends StatelessWidget {
  const LandscapeSidebar({
    super.key,
    required this.difficulty,
    required this.category,
    required this.gameState,
    required this.hintsRemaining,
    required this.onBackPressed,
    required this.onHintPressed,
    this.onPausePressed,
    this.isPaused = false,
    this.showPause = false,
  });

  final Difficulty difficulty;
  final WordCategory category;
  final GameState gameState;
  final int hintsRemaining;
  final VoidCallback onBackPressed;
  final VoidCallback onHintPressed;
  final VoidCallback? onPausePressed;
  final bool isPaused;
  final bool showPause;

  int _getDisplayScore() {
    if (gameState.isCompleted) {
      return gameState.score;
    }
    return gameState.foundWords.length * AppConstants.basePointsPerWord;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border(
          right: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        right: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact header row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  AppBackButton(
                    onPressed: onBackPressed,
                  ),
                  const SizedBox(width: 4),
                  Text(category.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    difficulty.displayName.toUpperCase(),
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const CumulativeScoreWidget(),
                  if (showPause && onPausePressed != null)
                    IconButton(
                      icon: Icon(
                        isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        size: 20,
                      ),
                      onPressed: onPausePressed,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
            // Divider
            Container(height: 1, color: AppColors.divider),
            // Sub-header: category name + score
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    category.displayName,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'SCORE: ',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    ScoreFormatter.formatScore(_getDisplayScore()),
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Container(height: 1, color: AppColors.divider),
            // Word list (expands to fill)
            Expanded(
              child: GameFooter(
                gameState: gameState,
                hintsRemaining: hintsRemaining,
                onHintPressed: onHintPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

