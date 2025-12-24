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
    this.selectionColor,
    this.cellSize = 40,
    this.isShaking = false,
  });

  final String letter;
  final int row;
  final int col;
  final bool isSelected;
  final bool isFound;
  final Color? selectionColor;
  final double cellSize;
  final bool isShaking;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    Widget cell = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppSpacing.borderRadiusSm,
        boxShadow: isSelected ? AppShadows.cellSelected(selectionColor ?? AppColors.primary) : AppShadows.cell,
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          style: AppTypography.gridLetter.copyWith(
            color: textColor,
            fontSize: cellSize * 0.5,
            decoration: isFound ? TextDecoration.lineThrough : null,
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

    return cell;
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      // Solid color background for selection
      return selectionColor ?? AppColors.primary;
    }
    if (isFound) {
      // Dimmed background for found words
      return AppColors.surfaceVariant.withValues(alpha: 0.5);
    }
    return AppColors.surface;
  }

  Color _getTextColor() {
    if (isSelected) {
      return AppColors.letterSelected;
    }
    if (isFound) {
      // Dimmed text color for found words
      return AppColors.letterFound.withValues(alpha: 0.4);
    }
    return AppColors.letterDefault;
  }
}

/// Shake animation widget
class _ShakeWidget extends StatefulWidget {
  const _ShakeWidget({required this.child});

  final Widget child;

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
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
      animation: _animation,
      builder: (context, child) {
        // Shake with decreasing intensity
        final progress = _animation.value;
        final intensity = (1 - progress) * 8;
        final shakeOffset = intensity * (math.sin(progress * math.pi * 10) * 0.5);
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// A mini grid preview for difficulty selection
class GridPreview extends StatelessWidget {
  const GridPreview({
    super.key,
    required this.size,
    this.cellSize = 8,
    this.color,
  });

  final int size;
  final double cellSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          size.clamp(0, 6), // Max 6 rows for preview
          (row) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              size.clamp(0, 6), // Max 6 cols for preview
              (col) => Container(
                width: cellSize,
                height: cellSize,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: (row + col) % 3 == 0
                      ? effectiveColor.withValues(alpha: 0.3)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
