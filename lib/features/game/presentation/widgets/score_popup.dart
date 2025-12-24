import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';

/// Score popup that appears when a word is found
class ScorePopup extends StatefulWidget {
  const ScorePopup({
    super.key,
    required this.word,
    required this.score,
    required this.position,
    required this.onComplete,
  });

  final String word;
  final int score;
  final Offset position;
  final VoidCallback onComplete;

  @override
  State<ScorePopup> createState() => _ScorePopupState();
}

class _ScorePopupState extends State<ScorePopup> {
  @override
  void initState() {
    super.initState();
    // Auto-dismiss after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 40,
      top: widget.position.dy - 30,
      child: IgnorePointer(
        child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: AppSpacing.borderRadiusMd,
            boxShadow: AppShadows.medium,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+${widget.score}',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.word,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.5, 0.5), duration: 300.ms, curve: Curves.elasticOut)
            .then()
            .fadeOut(duration: 300.ms)
            .slideY(begin: 0, end: -0.5, duration: 300.ms),
        ),
      ),
    );
  }
}

