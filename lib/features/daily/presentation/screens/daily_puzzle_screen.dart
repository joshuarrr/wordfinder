import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/router/router.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/breakpoints.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../game/domain/entities/game_state.dart';
import '../../../game/presentation/widgets/word_search_grid.dart';
import '../../../game/presentation/widgets/confetti_celebration.dart';
import '../../../game/presentation/widgets/game_sub_header.dart';
import '../../../score/presentation/widgets/cumulative_score_widget.dart';
import '../providers/daily_providers.dart';

/// Daily puzzle screen
class DailyPuzzleScreen extends ConsumerStatefulWidget {
  const DailyPuzzleScreen({super.key});

  @override
  ConsumerState<DailyPuzzleScreen> createState() => _DailyPuzzleScreenState();
}

class _DailyPuzzleScreenState extends ConsumerState<DailyPuzzleScreen> {
  Timer? _timer;
  bool _showCompletionCelebration = false;
  bool _timerStarted = false;
  bool _completionDialogShown = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timerStarted) return;
    _timerStarted = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final asyncState = ref.read(dailyGameStateNotifierProvider);
      final gameState = asyncState.valueOrNull;
      if (gameState == null || gameState.isPaused || gameState.isCompleted) {
        if (gameState?.isCompleted == true && !_completionDialogShown) {
          _showCompletionDialog();
        }
        return;
      }

      ref
          .read(dailyGameStateNotifierProvider.notifier)
          .updateElapsedTime(gameState.elapsedSeconds + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncGameState = ref.watch(dailyGameStateNotifierProvider);

    return asyncGameState.when(
      loading: () => _buildLoadingScreen(),
      error: (error, stack) => _buildErrorScreen(error),
      data: (gameState) => _buildGameScreen(gameState),
    );
  }

  Widget _buildLoadingScreen() {
    final category = ref.watch(todayCategoryProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('📅', style: const TextStyle(fontSize: 64))
                  .animate(onPlay: (c) => c.repeat())
                  .rotate(duration: 2.seconds, curve: Curves.easeInOut)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    duration: 1.seconds,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(0.9, 0.9),
                    duration: 1.seconds,
                    curve: Curves.easeInOut,
                  ),
              AppSpacing.vGapXl,
              Text(
                'Loading Daily Puzzle...',
                style: AppTypography.titleMedium,
              ).animate().fadeIn(duration: 300.ms),
              AppSpacing.vGapMd,
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent1),
                ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
              ),
              AppSpacing.vGapMd,
              Text(
                '${category.displayName} • Medium',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object error) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('😕', style: TextStyle(fontSize: 64)),
                AppSpacing.vGapLg,
                Text(
                  'Oops! Something went wrong',
                  style: AppTypography.titleLarge,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vGapMd,
                Text(
                  'We couldn\'t load today\'s puzzle.\nPlease try again.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vGapXl,
                PrimaryButton(
                  label: 'Go Back',
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.go(AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen(GameState gameState) {
    // Start timer when game loads
    if (!_timerStarted && !gameState.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer();
      });
    }

    // Show completion dialog when game is completed
    if (gameState.isCompleted && !_showCompletionCelebration && !_completionDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_completionDialogShown && mounted) {
          setState(() => _showCompletionCelebration = true);
          _showCompletionDialog();
        }
      });
    }

    final isLandscape = BreakpointUtils.isLandscape(context);
    final category = ref.watch(todayCategoryProvider);
    final today = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d');

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: AppBackButton(
              onPressed: () => _showExitDialog(context),
            ),
            centerTitle: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Daily Puzzle',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  dateFormat.format(today),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              const CumulativeScoreWidget(),
            ],
          ),
          body: Column(
            children: [
              // Daily puzzle info bar
              _buildDailyInfoBar(category, gameState),
              
              // Game sub header with word list
              GameSubHeader(
                category: category,
                gameState: gameState,
              ),
              
              // Grid
              Expanded(
                child: Padding(
                  padding: isLandscape ? AppSpacing.paddingMd : EdgeInsets.zero,
                  child: Center(
                    child: WordSearchGrid(
                      difficulty: Difficulty.medium,
                      category: category,
                      gameMode: GameMode.daily,
                    ),
                  ),
                ),
              ),
              
              // Footer with progress (no hints for daily)
              _buildDailyFooter(gameState),
            ],
          ),
        ),
        if (_showCompletionCelebration)
          ConfettiCelebration(
            onComplete: () {
              setState(() => _showCompletionCelebration = false);
            },
          ),
      ],
    );
  }

  Widget _buildDailyInfoBar(WordCategory category, GameState gameState) {
    final asyncStreak = ref.watch(dailyStreakProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent1.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accent1.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent1,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  category.displayName,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Streak display
          asyncStreak.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (streak) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusSm,
                border: Border.all(
                  color: AppColors.accent1.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '$streak day${streak == 1 ? '' : 's'}',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyFooter(GameState gameState) {
    final progress = gameState.foundWords.length;
    final total = gameState.puzzle.words.length;
    final progressPercent = total > 0 ? progress / total : 0.0;

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.soft,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusSm,
              child: LinearProgressIndicator(
                value: progressPercent,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent1),
                minHeight: 8,
              ),
            ),
            AppSpacing.vGapSm,
            
            // Progress text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$progress / $total words found',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatTime(gameState.elapsedSeconds),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            
            // No hints message
            AppSpacing.vGapSm,
            Text(
              '💡 No hints in Daily Puzzle mode',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Daily Puzzle?'),
        content: const Text('Your progress will be saved. You can continue later today.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    if (_completionDialogShown) return;

    final asyncState = ref.read(dailyGameStateNotifierProvider);
    final gameState = asyncState.valueOrNull;
    if (gameState == null || !gameState.isCompleted) return;

    _completionDialogShown = true;
    _timer?.cancel();

    // Play puzzle completion sound
    ref.read(audioServiceProvider).playPuzzleComplete();

    // Pick a random bright happy color for the barrier
    final random = math.Random();
    final brightColors = [
      AppColors.accent1,
      AppColors.accent2,
      AppColors.accent3,
      AppColors.accent4,
      AppColors.accent5,
      AppColors.accent6,
      AppColors.success,
    ];
    final barrierColor = brightColors[random.nextInt(brightColors.length)]
        .withValues(alpha: 0.7);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return _DailyCompletionDialog(
            gameState: gameState,
            onHome: () async {
              Navigator.pop(dialogContext);
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                // ignore: use_build_context_synchronously
                this.context.go(AppRoutes.home);
              }
            },
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final barrierAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

          return Stack(
            children: [
              Positioned.fill(
                child: FadeTransition(
                  opacity: barrierAnimation,
                  child: Container(color: barrierColor),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class _DailyCompletionDialog extends ConsumerWidget {
  const _DailyCompletionDialog({
    required this.gameState,
    required this.onHome,
  });

  final GameState gameState;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStreak = ref.watch(dailyStreakProvider);
    final today = DateTime.now();
    final dateFormat = DateFormat('MMMM d, yyyy');

    return AlertDialog(
      title: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 48))
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),
          AppSpacing.vGapSm,
          Text(
            'Daily Puzzle Complete!',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date
            Text(
              dateFormat.format(today),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
            
            AppSpacing.vGapLg,
            
            // Score breakdown
            Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Column(
                children: [
                  _buildScoreRow('Words Found', '${gameState.foundWords.length}/${gameState.puzzle.words.length}'),
                  AppSpacing.vGapSm,
                  _buildScoreRow('Time', _formatTime(gameState.elapsedSeconds)),
                  AppSpacing.vGapSm,
                  Divider(color: AppColors.divider),
                  AppSpacing.vGapSm,
                  _buildScoreRow(
                    'Base Score',
                    '+${gameState.foundWords.length * AppConstants.basePointsPerWord}',
                  ),
                  asyncStreak.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (streak) => Column(
                      children: [
                        AppSpacing.vGapSm,
                        _buildScoreRow(
                          'Streak Bonus',
                          '+${AppConstants.streakMultiplier * streak}',
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
            
            AppSpacing.vGapLg,
            
            // Streak celebration
            asyncStreak.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (streak) => Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent1.withValues(alpha: 0.2),
                      AppColors.accent2.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(
                    color: AppColors.accent1,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 32)),
                    AppSpacing.hGapMd,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$streak Day Streak!',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Keep it up!',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 300.ms).scale(
                begin: const Offset(0.9, 0.9),
                duration: 300.ms,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'New puzzle tomorrow!',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 300.ms),
            AppSpacing.vGapMd,
            PrimaryButton(
              label: 'Done',
              onPressed: onHome,
              isFullWidth: false,
            ).animate().fadeIn(delay: 600.ms, duration: 300.ms),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: highlight ? AppColors.accent1 : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: highlight ? AppColors.accent1 : null,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

