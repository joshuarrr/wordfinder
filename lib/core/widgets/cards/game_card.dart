import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// A playful card widget with subtle shadow and press animation
class GameCard extends StatefulWidget {
  const GameCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.showShadow = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final bool showShadow;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.onTap != null;

    return GestureDetector(
      onTapDown: isInteractive ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isInteractive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isInteractive ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        padding: widget.padding ?? AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.surface,
          borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusLg,
          border: widget.borderColor != null
              ? Border.all(color: widget.borderColor!, width: 2)
              : null,
          boxShadow: widget.showShadow
              ? (_isPressed ? AppShadows.soft : AppShadows.medium)
              : null,
        ),
        transform: _isPressed
            ? (Matrix4.identity()
                ..setTranslationRaw(0.0, 2.0, 0.0)
                ..setEntry(0, 0, 0.98)
                ..setEntry(1, 1, 0.98)
                ..setEntry(2, 2, 0.98))
            : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}

/// Category selection card with emoji and label
class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
    this.isLocked = false,
    this.color,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;
  final bool isLocked;
  final Color? color;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLocked ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: widget.isLocked
              ? AppColors.surfaceVariant
              : (widget.color ?? AppColors.surface),
          borderRadius: AppSpacing.borderRadiusLg,
          boxShadow: _isPressed ? AppShadows.soft : AppShadows.medium,
        ),
        transform: _isPressed
            ? (Matrix4.identity()..setEntry(0, 0, 0.95)..setEntry(1, 1, 0.95)..setEntry(2, 2, 0.95))
            : Matrix4.identity(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isLocked ? '🔒' : widget.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            AppSpacing.vGapSm,
            Text(
              widget.label,
              style: AppTypography.labelLarge.copyWith(
                color: widget.isLocked
                    ? AppColors.textHint
                    : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Difficulty selection card
class DifficultyCard extends StatefulWidget {
  const DifficultyCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gridPreview,
    required this.onTap,
    this.color,
    this.isSelected = false,
  });

  final String title;
  final String subtitle;
  final Widget gridPreview;
  final VoidCallback onTap;
  final Color? color;
  final bool isSelected;

  @override
  State<DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<DifficultyCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: widget.isSelected 
              ? color.withValues(alpha: 0.15) 
              : color.withValues(alpha: 0.05),
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: widget.isSelected ? color : AppColors.divider,
            width: widget.isSelected ? 2 : 1,
          ),
          boxShadow: const [],
        ),
        transform: _isPressed
            ? (Matrix4.identity()..setEntry(0, 0, 0.98)..setEntry(1, 1, 0.98)..setEntry(2, 2, 0.98))
            : Matrix4.identity(),
        child: Row(
          children: [
            // Grid preview on the left
            SizedBox(
              width: 120,
              height: 120,
              child: Center(child: widget.gridPreview),
            ),
            AppSpacing.hGapLg,
            // Text content on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected ? color : AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.vGapXs,
                  Text(
                    widget.subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

