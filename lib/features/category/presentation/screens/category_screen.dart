import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/router/router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Screen for selecting word category
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required this.gameMode,
  });

  final GameMode gameMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
          backgroundColor: Colors.transparent,
        ),
        title: Text(gameMode.displayName),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a Category',
                style: AppTypography.headlineMedium,
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.1, curve: Curves.easeOutCubic),
              AppSpacing.vGapXs,
              Text(
                'Select the theme for your word search puzzle',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms),
              AppSpacing.vGapLg,
              Expanded(
                child: _buildCategoryGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
      ),
      itemCount: WordCategory.values.length,
      itemBuilder: (context, index) {
        final category = WordCategory.values[index];
        final delay = (index * 50).ms;
        final color = AppColors.cellColors[index % AppColors.cellColors.length];

        return CategoryCard(
          emoji: category.emoji,
          label: category.displayName,
          color: color,
          onTap: () => context.push(
            AppRoutes.difficulty,
            extra: {
              'gameMode': gameMode,
              'category': category,
            },
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms + delay, duration: 400.ms)
            .scale(
              begin: const Offset(0.8, 0.8),
              delay: 200.ms + delay,
              duration: 400.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }
}

