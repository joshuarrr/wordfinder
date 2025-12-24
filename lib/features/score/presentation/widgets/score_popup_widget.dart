import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/score_formatter.dart';
import '../../../../core/theme/theme.dart';

/// Popup widget showing points earned when a word is found
class ScorePopupWidget extends StatefulWidget {
  const ScorePopupWidget({
    super.key,
    required this.points,
    required this.position,
  });

  final int points;
  final Offset position;

  @override
  State<ScorePopupWidget> createState() => _ScorePopupWidgetState();
}

class _ScorePopupWidgetState extends State<ScorePopupWidget> {
  @override
  void initState() {
    super.initState();
    // Auto-remove after animation
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        // Widget will be removed by parent
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: Material(
        color: Colors.transparent,
        child: Text(
          '+${ScoreFormatter.formatScore(widget.points)}',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: AppColors.success.withValues(alpha: 0.5),
                blurRadius: 4,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.2, 1.2),
              duration: 300.ms,
              curve: Curves.elasticOut,
            )
            .then()
            .fadeOut(duration: 500.ms)
            .scale(
              begin: const Offset(1.2, 1.2),
              end: const Offset(1.5, 1.5),
              duration: 500.ms,
            )
            .moveY(begin: 0, end: -30, duration: 500.ms),
      ),
    );
  }
}

