import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../score/presentation/providers/score_providers.dart';
import '../widgets/stat_card_widget.dart';
import '../widgets/recent_games_list.dart';
import '../widgets/difficulty_stats_section.dart';

/// Stats screen showing advanced statistics
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(scoreStatsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
          backgroundColor: Colors.transparent,
        ),
        title: const Text('Statistics'),
      ),
      body: SafeArea(
        child: statsAsync.when(
          data: (stats) => SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview section
                Text(
                  'Overview',
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.vGapMd,
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.5,
                  children: [
                    StatCardWidget(
                      icon: Icons.games_rounded,
                      label: 'Total Games',
                      value: '${stats.totalGamesPlayed}',
                    ),
                    StatCardWidget(
                      icon: Icons.star_rounded,
                      label: 'Lifetime Score',
                      value: ScoreFormatter.formatScore(
                        stats.totalLifetimeScore,
                      ),
                    ),
                    StatCardWidget(
                      icon: Icons.trending_up_rounded,
                      label: 'Average Score',
                      value: ScoreFormatter.formatScore(
                        stats.averageScore.round(),
                      ),
                    ),
                    StatCardWidget(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Best Streak',
                      value: '${stats.bestStreakGames}',
                      subtitle: 'Consecutive games',
                    ),
                  ],
                ),
                AppSpacing.vGapLg,
                
                // Streak stats
                Text(
                  'Streaks',
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.vGapMd,
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.5,
                  children: [
                    StatCardWidget(
                      icon: Icons.emoji_events_rounded,
                      label: 'High Score Streak',
                      value: '${stats.bestStreakHighScore}',
                    ),
                    StatCardWidget(
                      icon: Icons.calendar_today_rounded,
                      label: 'Days Streak',
                      value: '${stats.bestStreakDays}',
                    ),
                    StatCardWidget(
                      icon: Icons.games_rounded,
                      label: 'Games Streak',
                      value: '${stats.bestStreakGames}',
                    ),
                    StatCardWidget(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Perfect Streak',
                      value: '${stats.bestStreakPerfect}',
                    ),
                  ],
                ),
                AppSpacing.vGapLg,
                
                // Recent games
                Text(
                  'Recent Games',
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.vGapMd,
                RecentGamesList(
                  games: stats.recentGames.take(10).toList(),
                ),
                AppSpacing.vGapLg,
                
                // Difficulty stats
                DifficultyStatsSection(
                  difficultyStats: stats.difficultyStats,
                ),
                AppSpacing.vGapLg,
              ],
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppColors.error,
                ),
                AppSpacing.vGapMd,
                Text(
                  'Failed to load statistics',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
                AppSpacing.vGapSm,
                SecondaryButton(
                  label: 'Retry',
                  onPressed: () {
                    ref.invalidate(scoreStatsProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

