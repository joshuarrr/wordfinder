import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Main game screen with word search grid
/// This is a placeholder that will be fully implemented in Phase 2
class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
    required this.gameMode,
    required this.category,
    required this.difficulty,
  });

  final GameMode gameMode;
  final WordCategory category;
  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icons.close_rounded,
          onPressed: () => _showExitDialog(context),
          backgroundColor: Colors.transparent,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.emoji),
            AppSpacing.hGapSm,
            Text(difficulty.displayName),
          ],
        ),
        actions: [
          if (gameMode == GameMode.timed)
            Padding(
              padding: AppSpacing.horizontalMd,
              child: Center(
                child: Text(
                  _formatTime(difficulty.timeLimit),
                  style: AppTypography.timer,
                ),
              ),
            ),
          AppIconButton(
            icon: Icons.lightbulb_outline_rounded,
            onPressed: () {
              // TODO: Implement hints
            },
            backgroundColor: Colors.transparent,
            tooltip: 'Hint',
          ),
          AppIconButton(
            icon: Icons.pause_rounded,
            onPressed: () {
              // TODO: Implement pause
            },
            backgroundColor: Colors.transparent,
            tooltip: 'Pause',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              // Game grid placeholder
              Expanded(
                flex: 3,
                child: _buildGridPlaceholder(),
              ),
              AppSpacing.vGapLg,
              // Word list placeholder
              Expanded(
                flex: 1,
                child: _buildWordListPlaceholder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridPlaceholder() {
    return Center(
      child: Container(
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grid_on_rounded,
              size: 64,
              color: AppColors.textHint,
            ),
            AppSpacing.vGapMd,
            Text(
              'Game Grid',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.vGapXs,
            Text(
              '${difficulty.gridSize} × ${difficulty.gridSize}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
            AppSpacing.vGapMd,
            Text(
              'Coming in Phase 2',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms)
          .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutCubic),
    );
  }

  Widget _buildWordListPlaceholder() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Words to Find',
            style: AppTypography.titleMedium,
          ),
          AppSpacing.vGapSm,
          Expanded(
            child: Center(
              child: Text(
                '${difficulty.wordCount} words will appear here',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.2, curve: Curves.easeOutCubic);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Game?'),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: Text(
              'Exit',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

