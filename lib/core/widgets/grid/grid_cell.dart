import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Individual cell in the word search grid
class GridCell extends StatelessWidget {
  const GridCell({
    super.key,
    required this.letter,
    required this.row,
    required this.col,
    this.isSelected = false,
    this.isFound = false,
    this.isCelebrating = false,
    this.selectionColor,
    this.cellSize = 40,
    this.isShaking = false,
  });

  final String letter;
  final int row;
  final int col;
  final bool isSelected;
  final bool isFound;
  final bool isCelebrating;
  final Color? selectionColor;
  final double cellSize;
  final bool isShaking;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    Widget cell = AnimatedContainer(
      duration: Duration(milliseconds: isCelebrating ? 300 : 100),
      curve: isCelebrating ? Curves.easeOutBack : Curves.easeOutCubic,
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppSpacing.borderRadiusSm,
        boxShadow: isCelebrating
            ? AppShadows.cellCelebration
            : isSelected
            ? AppShadows.cellSelected(selectionColor ?? AppColors.primary)
            : AppShadows.cell,
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: isCelebrating ? 300 : 100),
          style: AppTypography.gridLetter.copyWith(
            color: textColor,
            fontSize: cellSize * 0.5,
            decoration: isFound && !isCelebrating
                ? TextDecoration.lineThrough
                : null,
            decorationColor: AppColors.success,
            decorationThickness: 2,
          ),
          child: Text(letter),
        ),
      ),
    );

    // Apply shaking animation if needed
    if (isShaking) {
      cell = _ShakeWidget(child: cell);
    }

    // Apply celebration scale animation
    if (isCelebrating && isFound) {
      cell = _CelebrationWidget(child: cell);
    }

    return cell;
  }

  Color _getBackgroundColor() {
    if (isCelebrating && isFound) {
      return AppColors.success;
    }
    if (isSelected) {
      return selectionColor ?? AppColors.primary;
    }
    if (isFound) {
      return AppColors.surfaceVariant.withValues(alpha: 0.5);
    }
    return AppColors.surface;
  }

  Color _getTextColor() {
    if (isCelebrating && isFound) {
      return AppColors.white;
    }
    if (isSelected) {
      return AppColors.letterSelected;
    }
    if (isFound) {
      return AppColors.letterFound.withValues(alpha: 0.4);
    }
    return AppColors.letterDefault;
  }
}

/// Shake and fade animation widget for invalid selections
class _ShakeWidget extends StatefulWidget {
  const _ShakeWidget({required this.child});

  final Widget child;

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Total duration: 300ms shake + 200ms fade = 500ms
  static const _totalDuration = Duration(milliseconds: 500);
  static const _shakePortion = 0.6; // 60% shake, 40% fade

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _totalDuration, vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;

        // Shake phase (0 to _shakePortion)
        double shakeOffset = 0;
        if (progress < _shakePortion) {
          final shakeProgress = progress / _shakePortion;
          final intensity = (1 - shakeProgress) * 8;
          shakeOffset = intensity * math.sin(shakeProgress * math.pi * 8);
        }

        // Fade phase (_shakePortion to 1.0)
        double opacity = 1.0;
        if (progress >= _shakePortion) {
          final fadeProgress = (progress - _shakePortion) / (1 - _shakePortion);
          opacity = 1.0 - Curves.easeOut.transform(fadeProgress);
        }

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(shakeOffset, 0),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Celebration animation widget for completion
class _CelebrationWidget extends StatefulWidget {
  const _CelebrationWidget({required this.child});

  final Widget child;

  @override
  State<_CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<_CelebrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
