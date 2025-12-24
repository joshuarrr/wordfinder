import 'dart:async';
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
  late final GameStateNotifierProvider _gameStateProvider;
  bool _showCompletionCelebration = false;

  @override
  void initState() {
    super.initState();
    _gameStateProvider = gameStateNotifierProvider(
      difficulty: widget.difficulty,
      category: widget.category,
      gameMode: widget.gameMode,
    );
    
    // Start timer for timed mode
    if (widget.gameMode == GameMode.timed) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final gameState = ref.read(_gameStateProvider);
      if (gameState.isPaused || gameState.isCompleted) return;
      
      ref.read(_gameStateProvider.notifier).updateElapsedTime(
        gameState.elapsedSeconds + 1,
      );
      
      // Check if game is completed
      if (gameState.isCompleted) {
        _showCompletionDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(_gameStateProvider);
    
    // Show completion dialog when game is completed
    if (gameState.isCompleted && !_showCompletionCelebration) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _showCompletionCelebration = true);
        _showCompletionDialog();
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

  void _showCompletionDialog() {
    final gameState = ref.read(_gameStateProvider);
    _timer?.cancel();
    
    // Show confetti first, then dialog
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _CompletionDialog(
          gameState: gameState,
          onHome: () {
            Navigator.pop(context);
            context.go(AppRoutes.home);
          },
          onPlayAgain: () {
            Navigator.pop(context);
            context.go(AppRoutes.home);
            // TODO: Implement proper restart
          },
        ),
      );
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
        TextButton(
          onPressed: widget.onHome,
          child: const Text('Home'),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 300.ms),
        PrimaryButton(
          label: 'Play Again',
          onPressed: widget.onPlayAgain,
          isFullWidth: false,
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 300.ms)
            .scale(begin: const Offset(0.9, 0.9), duration: 300.ms),
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
