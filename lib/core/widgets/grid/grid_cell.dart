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
  });

  final String letter;
  final int row;
  final int col;
  final bool isSelected;
  final bool isFound;
  final Color? selectionColor;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
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
          duration: const Duration(milliseconds: 150),
          style: AppTypography.gridLetter.copyWith(
            color: textColor,
            fontSize: cellSize * 0.5,
          ),
          child: Text(letter),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return selectionColor ?? AppColors.primary;
    }
    if (isFound) {
      return AppColors.surfaceVariant;
    }
    return AppColors.surface;
  }

  Color _getTextColor() {
    if (isSelected) {
      return AppColors.letterSelected;
    }
    if (isFound) {
      return AppColors.letterFound;
    }
    return AppColors.letterDefault;
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

