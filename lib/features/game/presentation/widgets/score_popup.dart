import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';

/// Score popup that appears when a word is found
class ScorePopup extends StatelessWidget {
  const ScorePopup({
    super.key,
    required this.score,
    required this.position,
    required this.onComplete,
  });

  final int score;
  final Offset position;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 24,
      top: position.dy - 40, // Position above the first letter
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: AppSpacing.borderRadiusMd,
              boxShadow: AppShadows.medium,
            ),
            child: Text(
              '+$score',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              .animate()
              // Appear: scale up and fade in
              .fadeIn(duration: 200.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 250.ms,
                curve: Curves.easeOutBack,
              )
              // Float up and fade out (starts immediately after appear)
              .slideY(
                begin: 0,
                end: -1.5,
                duration: 800.ms,
                curve: Curves.easeOut,
              )
              .fadeOut(
                delay: 400.ms,
                duration: 400.ms,
                curve: Curves.easeIn,
              )
              // Notify when complete
              .callback(callback: (_) => onComplete()),
        ),
      ),
    );
  }
}

