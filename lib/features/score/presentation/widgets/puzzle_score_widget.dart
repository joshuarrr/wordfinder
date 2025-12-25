import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../../core/theme/theme.dart';
import '../../../game/domain/entities/game_state.dart';
import '../../../../core/constants/app_constants.dart';

/// Widget displaying current puzzle score
class PuzzleScoreWidget extends ConsumerStatefulWidget {
  const PuzzleScoreWidget({
    super.key,
    required this.gameState,
    this.compact = false,
  });

  final GameState gameState;
  final bool compact;

  @override
  ConsumerState<PuzzleScoreWidget> createState() =>
      _PuzzleScoreWidgetState();
}

class _PuzzleScoreWidgetState extends ConsumerState<PuzzleScoreWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _previousScore = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PuzzleScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gameState.isCompleted && !oldWidget.gameState.isCompleted) {
      _isCompleted = true;
      _animationController.reset();
      _animationController.forward();
    } else if (widget.gameState.foundWords.length !=
        oldWidget.gameState.foundWords.length) {
      // Word found - animate score update
      _animationController.reset();
      _animationController.forward();
    }
  }

  int _getDisplayScore() {
    // During gameplay: show base score only
    // At completion: show final calculated score
    if (_isCompleted || widget.gameState.isCompleted) {
      return widget.gameState.score;
    } else {
      // Base score only (100 per word)
      return widget.gameState.foundWords.length *
          AppConstants.basePointsPerWord;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentScore = _getDisplayScore();

    if (currentScore != _previousScore && _previousScore > 0) {
      _animationController.reset();
      _animationController.forward();
    }
    _previousScore = currentScore;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final displayedScore = _previousScore == 0
            ? currentScore
            : (_previousScore +
                    ((currentScore - _previousScore) *
                            _animationController.value)
                        .round())
                .clamp(0, currentScore);

        final textStyle = widget.compact
            ? AppTypography.titleSmall
            : AppTypography.headlineSmall;
        final emojiSize = widget.compact ? 18.0 : 24.0;

        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🏆', style: TextStyle(fontSize: emojiSize)),
              SizedBox(width: widget.compact ? 6 : 8),
              Text(
                'Puzzle Score: ',
                style: textStyle.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                ScoreFormatter.formatScore(displayedScore),
                style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 200.ms)
              .scale(
                begin: const Offset(0.95, 0.95),
                duration: 200.ms,
                curve: Curves.easeOut,
              ),
        );
      },
    );
  }
}

