import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/router/router.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Screen for selecting difficulty level
class DifficultyScreen extends ConsumerStatefulWidget {
  const DifficultyScreen({
    super.key,
    required this.gameMode,
    required this.category,
  });

  final GameMode gameMode;
  final WordCategory category;

  @override
  ConsumerState<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends ConsumerState<DifficultyScreen> {
  Difficulty? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return SwipeableScreen(
      onPop: () => context.pop(),
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton(
            onPressed: () => context.pop(),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.category.emoji),
              AppSpacing.hGapSm,
              Text(widget.category.displayName),
            ],
          ),
        ),
        body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Difficulty',
                style: AppTypography.headlineMedium,
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.1, curve: Curves.easeOutCubic),
              AppSpacing.vGapXs,
              Text(
                'Choose how challenging you want it',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms),
              AppSpacing.vGapLg,
              Expanded(
                child: _buildDifficultyList(),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildDifficultyList() {
    final audioService = ref.read(audioServiceProvider);
    final difficulties = Difficulty.values;
    final colors = [
      AppColors.success, // Easy - green
      AppColors.warning, // Medium - orange
      AppColors.primary, // Hard - coral
    ];

    return ListView.separated(
      itemCount: difficulties.length,
      separatorBuilder: (_, __) => AppSpacing.vGapSm,
      itemBuilder: (context, index) {
        final difficulty = difficulties[index];
        final color = colors[index];
        final delay = (index * 100).ms;

        return DifficultyCard(
          title: difficulty.displayName,
          subtitle: difficulty.description,
          color: color,
          isSelected: _selectedDifficulty == difficulty,
          gridPreview: GridPreview(
            size: difficulty.gridSize,
            color: color,
            cellSize: 12,
          ),
          onTap: () {
            audioService.playButtonClick();
            // Auto-start game when difficulty is selected
            context.push(
              AppRoutes.game,
              extra: {
                'gameMode': widget.gameMode,
                'category': widget.category,
                'difficulty': difficulty,
              },
            );
          },
        )
            .animate()
            .fadeIn(delay: 200.ms + delay, duration: 400.ms)
            .slideX(
              begin: index.isEven ? -0.1 : 0.1,
              delay: 200.ms + delay,
              duration: 400.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

}

