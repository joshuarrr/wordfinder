import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../../core/theme/theme.dart';
import '../providers/score_providers.dart';

/// Widget displaying cumulative lifetime score in app bar
class CumulativeScoreWidget extends ConsumerStatefulWidget {
  const CumulativeScoreWidget({super.key});

  @override
  ConsumerState<CumulativeScoreWidget> createState() =>
      _CumulativeScoreWidgetState();
}

class _CumulativeScoreWidgetState
    extends ConsumerState<CumulativeScoreWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _previousScore = 0;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cumulativeScoreAsync = ref.watch(cumulativeScoreProvider);

    return cumulativeScoreAsync.when(
      data: (score) {
        if (score != _previousScore && _previousScore > 0) {
          _hasAnimated = false;
          _animationController.reset();
          _animationController.forward();
        }
        _previousScore = score;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final displayedScore = _hasAnimated
                ? score
                : (_previousScore +
                        ((score - _previousScore) * _animationController.value)
                            .round())
                    .clamp(0, score);

            if (_animationController.isCompleted) {
              _hasAnimated = true;
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Text(
                  ScoreFormatter.formatScore(displayedScore),
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.9, 0.9), duration: 300.ms);
          },
        );
      },
      loading: () => const SizedBox(
        width: 40,
        height: 20,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

