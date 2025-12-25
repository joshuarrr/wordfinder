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
    // Preload button click sound for instant playback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).preloadButtonClick();
    });
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
    
    return GameCard(
      onTap: () {
        audioService.playButtonClick();
        // TODO: Navigate to daily puzzle
      },
      color: AppColors.accent1.withValues(alpha: 0.2),
      borderColor: AppColors.accent1,
      showShadow: false,
      child: Row(
        children: [
          CalendarDateWidget(
            backgroundColor: AppColors.accent1,
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Puzzle',
                  style: AppTypography.titleMedium,
                ),
                Text(
                  'New puzzle every day!',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
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

