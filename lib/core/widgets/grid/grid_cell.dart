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

  // Generate random letters for preview
  static const String _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  
  String _getRandomLetter(int row, int col) {
    // Use a better hash function for more random-looking distribution
    // Combine row, col, and grid size for better randomization
    var hash = (row * 31 + col * 17 + size * 7);
    hash = hash ^ (hash >> 16);
    hash = hash * 0x85ebca6b;
    hash = hash ^ (hash >> 13);
    hash = hash * 0xc2b2ae35;
    hash = hash ^ (hash >> 16);
    final seed = hash.abs() % _letters.length;
    return _letters[seed];
  }

  @override
  Widget build(BuildContext context) {
    // Show the actual grid size (8x8, 12x12, 15x15)
    final previewSize = size;
    final cellMargin = 0.5;
    final containerPadding = 4.0;
    final borderWidth = color != null ? 2.0 : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate cell size to fit within available space
        // Available space = constraints.maxWidth - (padding * 2) - (border * 2)
        // Each cell takes: actualCellSize + (cellMargin * 2)
        // Total width needed: (actualCellSize + cellMargin * 2) * previewSize
        // Solve for actualCellSize: (availableWidth / previewSize) - (cellMargin * 2)
        final availableWidth = constraints.maxWidth - (containerPadding * 2) - (borderWidth * 2);
        final availableHeight = constraints.maxHeight - (containerPadding * 2) - (borderWidth * 2);
        final actualCellSize = math.max(4.0, math.min(
          (availableWidth / previewSize) - (cellMargin * 2),
          (availableHeight / previewSize) - (cellMargin * 2),
        )).toDouble();

        return Container(
          padding: EdgeInsets.all(containerPadding),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: AppSpacing.borderRadiusSm,
            border: color != null
                ? Border.all(
                    color: color!,
                    width: borderWidth,
                  )
                : null,
            boxShadow: const [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              previewSize,
              (row) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  previewSize,
                  (col) {
                    final letter = _getRandomLetter(row, col);
                    
                    return Container(
                      width: actualCellSize,
                      height: actualCellSize,
                      margin: EdgeInsets.all(cellMargin),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: AppColors.divider.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: AppTypography.gridLetter.copyWith(
                            fontSize: math.max(4, actualCellSize * 0.5),
                            color: AppColors.textSecondary.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
