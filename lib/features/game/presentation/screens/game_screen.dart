import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/router/router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_providers.dart';
import '../widgets/word_list_widget.dart';
import '../widgets/word_search_grid.dart';
import '../widgets/confetti_celebration.dart';

/// Main game screen with word search grid
class GameScreen extends ConsumerStatefulWidget {
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
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  Timer? _timer;
  late final AsyncGameStateNotifierProvider _gameStateProvider;
  bool _showCompletionCelebration = false;
  bool _timerStarted = false;
  bool _completionDialogShown = false;
  bool _isRestarting = false;

  @override
  void initState() {
    super.initState();
    _gameStateProvider = asyncGameStateNotifierProvider(
      difficulty: widget.difficulty,
      category: widget.category,
      gameMode: widget.gameMode,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timerStarted) return;
    _timerStarted = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final asyncState = ref.read(_gameStateProvider);
      final gameState = asyncState.valueOrNull;
      if (gameState == null || gameState.isPaused || gameState.isCompleted) {
        if (gameState?.isCompleted == true && !_completionDialogShown) {
          _showCompletionDialog();
        }
        return;
      }
      
      ref.read(_gameStateProvider.notifier).updateElapsedTime(
        gameState.elapsedSeconds + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncGameState = ref.watch(_gameStateProvider);
    
    return asyncGameState.when(
      loading: () => _buildLoadingScreen(),
      error: (error, stack) => _buildErrorScreen(error),
      data: (gameState) => _buildGameScreen(gameState),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated puzzle icon
              Text(
                '🧩',
                style: const TextStyle(fontSize: 64),
              )
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
                'Building your puzzle...',
                style: AppTypography.titleMedium,
              )
                  .animate()
                  .fadeIn(duration: 300.ms),
              AppSpacing.vGapMd,
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 300.ms),
              ),
              AppSpacing.vGapMd,
              Text(
                '${widget.category.displayName} • ${widget.difficulty.displayName}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 300.ms),
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
                const Text(
                  '😕',
                  style: TextStyle(fontSize: 64),
                ),
                AppSpacing.vGapLg,
                Text(
                  'Oops! Something went wrong',
                  style: AppTypography.titleLarge,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vGapMd,
                Text(
                  'We couldn\'t generate your puzzle.\nPlease try again.',
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
    // Start timer when game loads (for timed mode)
    if (widget.gameMode == GameMode.timed && !_timerStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer();
      });
    }
    
    // Show completion dialog when game is completed
    // Don't show if we're in the middle of restarting
    if (gameState.isCompleted && !_showCompletionCelebration && !_completionDialogShown && !_isRestarting) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_completionDialogShown && !_isRestarting && mounted) {
          setState(() => _showCompletionCelebration = true);
          _showCompletionDialog();
        }
      });
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: AppIconButton(
              icon: Icons.close_rounded,
              onPressed: () => _showExitDialog(context),
              backgroundColor: Colors.transparent,
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.category.emoji),
                AppSpacing.hGapSm,
                Text(widget.difficulty.displayName),
              ],
            ),
            actions: [
              if (widget.gameMode == GameMode.timed)
                Padding(
                  padding: AppSpacing.horizontalMd,
                  child: Center(
                    child: Text(
                      _formatTime(
                        widget.difficulty.timeLimit > 0
                            ? (widget.difficulty.timeLimit - gameState.elapsedSeconds).clamp(0, widget.difficulty.timeLimit)
                            : gameState.elapsedSeconds,
                      ),
                      style: AppTypography.timer.copyWith(
                        color: widget.difficulty.timeLimit > 0 &&
                                (widget.difficulty.timeLimit - gameState.elapsedSeconds) < 30
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              if (AppConstants.devMode)
                AppIconButton(
                  icon: Icons.auto_awesome_rounded,
                  onPressed: () {
                    ref.read(_gameStateProvider.notifier).autoComplete();
                  },
                  backgroundColor: Colors.transparent,
                  tooltip: 'Dev: Auto-complete',
                ),
              AppIconButton(
                icon: Icons.lightbulb_outline_rounded,
                onPressed: () => ref.read(_gameStateProvider.notifier).useHint(),
                backgroundColor: Colors.transparent,
                tooltip: 'Hint (${widget.difficulty.hints - gameState.hintsUsed} left)',
              ),
              AppIconButton(
                icon: gameState.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                onPressed: () {
                  ref.read(_gameStateProvider.notifier).togglePause();
                  if (widget.gameMode == GameMode.timed) {
                    if (gameState.isPaused) {
                      _timer?.cancel();
                      _timerStarted = false;
                    } else {
                      _startTimer();
                    }
                  }
                },
                backgroundColor: Colors.transparent,
                tooltip: gameState.isPaused ? 'Resume' : 'Pause',
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  // Game grid
                  Expanded(
                    flex: 3,
                    child: WordSearchGrid(
                      difficulty: widget.difficulty,
                      category: widget.category,
                      gameMode: widget.gameMode,
                    ),
                  ),
                  AppSpacing.vGapLg,
                  // Word list
                  Expanded(
                    flex: 1,
                    child: WordListWidget(
                      difficulty: widget.difficulty,
                      category: widget.category,
                      gameMode: widget.gameMode,
                    ),
                  ),
                ],
              ),
            ),
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
              context.go(AppRoutes.home);
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

  void _restartGame() {
    // Set restarting flag to prevent dialog from showing during transition
    setState(() {
      _isRestarting = true;
      _completionDialogShown = false;
      _timerStarted = false;
      _showCompletionCelebration = false;
    });
    
    // Cancel timer
    _timer?.cancel();
    _timer = null;
    
    // Invalidate the provider to generate a new puzzle
    ref.invalidate(_gameStateProvider);
    
    // Reset restarting flag after a brief delay to allow new state to load
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isRestarting = false;
        });
      }
    });
  }

  void _showCompletionDialog() {
    // Prevent multiple dialogs from showing or showing during restart
    if (_completionDialogShown || _isRestarting) return;
    
    final asyncState = ref.read(_gameStateProvider);
    final gameState = asyncState.valueOrNull;
    if (gameState == null || !gameState.isCompleted) return;
    
    _completionDialogShown = true;
    _timer?.cancel();
    
    // Pick a random bright happy color for the barrier
    final random = math.Random();
    final brightColors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent1,
      AppColors.accent2,
      AppColors.accent3,
      AppColors.accent4,
      AppColors.accent5,
      AppColors.accent6,
      AppColors.success,
    ];
    final barrierColor = brightColors[random.nextInt(brightColors.length)]
        .withOpacity(0.7); // Semi-transparent for visibility
    
    // Show confetti first, then dialog
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      // Double-check that dialog hasn't been shown already
      if (_completionDialogShown) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent, // Start transparent, will fade in
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) {
            return _CompletionDialog(
              gameState: gameState,
              onHome: () {
                Navigator.pop(context);
                context.go(AppRoutes.home);
              },
              onPlayAgain: () {
                Navigator.pop(context);
                _restartGame();
              },
            );
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            // Fade in the barrier color
            final barrierAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeIn),
            );
            
            return Stack(
              children: [
                // Animated barrier covering entire screen
                Positioned.fill(
                  child: FadeTransition(
                    opacity: barrierAnimation,
                    child: Container(
                      color: barrierColor,
                    ),
                  ),
                ),
                // Dialog content with fade and scale animation
                Center(
                  child: FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    });
  }
}

class _CompletionDialog extends StatefulWidget {
  const _CompletionDialog({
    required this.gameState,
    required this.onHome,
    required this.onPlayAgain,
  });

  final GameState gameState;
  final VoidCallback onHome;
  final VoidCallback onPlayAgain;

  @override
  State<_CompletionDialog> createState() => _CompletionDialogState();
}

class _CompletionDialogState extends State<_CompletionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _scoreController;
  int _displayedScore = 0;

  @override
  void initState() {
    super.initState();
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scoreController.addListener(() {
      setState(() {
        _displayedScore = (widget.gameState.score * _scoreController.value).round();
      });
    });
    
    _scoreController.forward();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🎉 Puzzle Complete!')
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.8, 0.8), duration: 300.ms, curve: Curves.elasticOut),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatRow(
            label: 'Time',
            value: _formatTime(widget.gameState.elapsedSeconds),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideX(begin: -0.1),
          AppSpacing.vGapSm,
          _StatRow(
            label: 'Score',
            value: '$_displayedScore',
            isHighlight: true,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 300.ms)
              .scale(begin: const Offset(0.9, 0.9), duration: 300.ms, curve: Curves.elasticOut),
          AppSpacing.vGapSm,
          _StatRow(
            label: 'Words Found',
            value: '${widget.gameState.foundWords.length}/${widget.gameState.puzzle.words.length}',
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 300.ms)
              .slideX(begin: -0.1),
        ],
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SecondaryButton(
              label: 'Home',
              onPressed: widget.onHome,
              isFullWidth: false,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms),
            AppSpacing.vGapSm,
            PrimaryButton(
              label: 'Play Again',
              onPressed: widget.onPlayAgain,
              isFullWidth: false,
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 300.ms)
                .scale(begin: const Offset(0.9, 0.9), duration: 300.ms),
          ],
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  final String label;
  final String value;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: isHighlight
              ? AppTypography.titleLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                )
              : AppTypography.bodyLarge,
        ),
      ],
    );
  }
}
