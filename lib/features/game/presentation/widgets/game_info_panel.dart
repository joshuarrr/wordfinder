import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../score/presentation/widgets/puzzle_score_widget.dart';
import '../providers/game_providers.dart';
import 'word_list_widget.dart';

/// Panel displaying puzzle score and words to find
class GameInfoPanel extends ConsumerWidget {
  const GameInfoPanel({
    super.key,
    required this.difficulty,
    required this.category,
    required this.gameMode,
  });

  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateProvider = asyncGameStateNotifierProvider(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );

    final asyncGameState = ref.watch(gameStateProvider);

    return asyncGameState.when(
      loading: () => _buildLoadingContainer(),
      error: (e, st) => _buildErrorContainer(e),
      data: (gameState) => Container(
        width: double.infinity,
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          children: [
            // Puzzle score at the top (compact for panel)
            PuzzleScoreWidget(gameState: gameState, compact: true),
            AppSpacing.vGapSm,
            // Word list below
            Expanded(
              child: WordListWidget(gameState: gameState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContainer() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppShadows.soft,
      ),
      child: Center(
        child: Text(
          'Loading...',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContainer(Object error) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppShadows.soft,
      ),
      child: Center(
        child: Text(
          'Error loading game info',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
