import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/router/router.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/breakpoints.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../daily/presentation/providers/daily_providers.dart';
import '../../../score/presentation/widgets/cumulative_score_widget.dart';

/// Home screen with game mode selection
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: const CumulativeScoreWidget(),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use scrollable layout for landscape orientation or constrained height
            final isLandscape = BreakpointUtils.isLandscape(context);
            final isConstrainedHeight = constraints.maxHeight < 500;
            
            if (isLandscape || isConstrainedHeight) {
              return SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTitle(),
                      AppSpacing.vGapLg,
                      _buildGameModes(context, ref),
                      AppSpacing.vGapLg,
                      _buildBottomActions(context),
                    ],
                  ),
                ),
              );
            }
            // Normal layout for larger screens
            return Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  const Spacer(),
                  _buildTitle(),
                  AppSpacing.vGapXxl,
                  _buildGameModes(context, ref),
                  const Spacer(),
                  _buildBottomActions(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Image.asset(
          'assets/images/mind-cookie-White+logo+-+no+background.webp',
          width: 64,
          height: 64,
          fit: BoxFit.contain,
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut),
        AppSpacing.vGapMd,
        Text(
          'Word Search',
          style: AppTypography.displayLarge,
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideY(begin: 0.3, curve: Curves.easeOutCubic),
        AppSpacing.vGapXs,
        Text(
          'Find the hidden words!',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildGameModes(BuildContext context, WidgetRef ref) {
    final audioService = ref.read(audioServiceProvider);
    
    return Column(
      children: [
        // Casual mode
        PrimaryButton(
          label: 'Play',
          icon: Icons.play_arrow_rounded,
          onPressed: () {
            audioService.playButtonClick();
            context.push(
              AppRoutes.category,
              extra: GameMode.casual,
            );
          },
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 400.ms)
            .slideX(begin: -0.2, curve: Curves.easeOutCubic),
        AppSpacing.vGapMd,
        // Timed mode
        SecondaryButton(
          label: 'Timed Challenge',
          icon: Icons.timer_outlined,
          onPressed: () {
            audioService.playButtonClick();
            context.push(
              AppRoutes.category,
              extra: GameMode.timed,
            );
          },
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 400.ms)
            .slideX(begin: 0.2, curve: Curves.easeOutCubic),
        AppSpacing.vGapMd,
        // Daily puzzle
        _buildDailyPuzzleCard(context, ref),
      ],
    );
  }

  Widget _buildDailyPuzzleCard(BuildContext context, WidgetRef ref) {
    final audioService = ref.read(audioServiceProvider);
    final asyncCompleted = ref.watch(isTodayPuzzleCompletedProvider);
    final asyncStreak = ref.watch(dailyStreakProvider);
    final category = ref.watch(todayCategoryProvider);
    
    final isCompleted = asyncCompleted.valueOrNull ?? false;
    final streak = asyncStreak.valueOrNull ?? 0;
    
    return GameCard(
      onTap: () {
        audioService.playButtonClick();
        context.push(AppRoutes.daily);
      },
      color: isCompleted 
          ? AppColors.success.withValues(alpha: 0.2)
          : AppColors.accent1.withValues(alpha: 0.2),
      borderColor: isCompleted ? AppColors.success : AppColors.accent1,
      showShadow: false,
      child: Row(
        children: [
          // Calendar widget with completion badge
          Stack(
            children: [
              CalendarDateWidget(
                backgroundColor: isCompleted ? AppColors.success : AppColors.accent1,
              ),
              if (isCompleted)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Daily Puzzle',
                      style: AppTypography.titleMedium,
                    ),
                    if (streak > 0) ...[
                      AppSpacing.hGapSm,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent1.withValues(alpha: 0.2),
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 10)),
                            const SizedBox(width: 2),
                            Text(
                              '$streak',
                              style: AppTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  isCompleted 
                      ? 'New puzzle tomorrow!'
                      : '${category.emoji} ${category.displayName}',
                  style: AppTypography.bodySmall.copyWith(
                    color: isCompleted ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
            color: isCompleted ? AppColors.success : AppColors.textSecondary,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 700.ms, duration: 400.ms)
        .slideY(begin: 0.2, curve: Curves.easeOutCubic);
  }

  Widget _buildBottomActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIconButton(
          icon: Icons.bar_chart_rounded,
          onPressed: () {
            // TODO: Navigate to stats
          },
          tooltip: 'Statistics',
        ),
        AppSpacing.hGapMd,
        AppIconButton(
          icon: Icons.emoji_events_outlined,
          onPressed: () {
            // TODO: Navigate to achievements
          },
          tooltip: 'Achievements',
        ),
        AppSpacing.hGapMd,
        AppIconButton(
          icon: Icons.leaderboard_outlined,
          onPressed: () {
            // TODO: Navigate to leaderboard
          },
          tooltip: 'Leaderboard',
        ),
        AppSpacing.hGapMd,
        AppIconButton(
          icon: Icons.settings_outlined,
          onPressed: () {
            // TODO: Navigate to settings
          },
          tooltip: 'Settings',
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 400.ms);
  }
}

