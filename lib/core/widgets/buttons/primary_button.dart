import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../theme/theme.dart';

/// Primary action button with playful styling and press animation
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = ButtonSize.medium,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonSize size;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  double get _height => switch (widget.size) {
        ButtonSize.small => AppSpacing.buttonHeightSm,
        ButtonSize.medium => AppSpacing.buttonHeightMd,
        ButtonSize.large => AppSpacing.buttonHeightLg,
      };

  double get _fontSize => switch (widget.size) {
        ButtonSize.small => 14,
        ButtonSize.medium => 16,
        ButtonSize.large => 18,
      };

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppConstants.animationFast),
        curve: Curves.easeOutCubic,
        height: _height,
        width: widget.isFullWidth ? double.infinity : null,
        padding: widget.isFullWidth ? null : AppSpacing.horizontalLg,
        decoration: BoxDecoration(
          color: isEnabled ? color : color.withValues(alpha: 0.5),
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: _isPressed
              ? AppShadows.buttonPressed
              : AppShadows.primaryGlow(color),
        ),
        transform: Matrix4.identity()
          ..setTranslationRaw(0.0, _isPressed ? 2.0 : 0.0, 0.0),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(AppColors.textOnPrimary),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: AppColors.textOnPrimary,
                        size: _fontSize + 4,
                      ),
                      AppSpacing.hGapSm,
                    ],
                    Text(
                      widget.label,
                      style: AppTypography.button.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: _fontSize,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Secondary button with outline style
class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.isFullWidth = true,
    this.size = ButtonSize.medium,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool isFullWidth;
  final ButtonSize size;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isPressed = false;

  double get _height => switch (widget.size) {
        ButtonSize.small => AppSpacing.buttonHeightSm,
        ButtonSize.medium => AppSpacing.buttonHeightMd,
        ButtonSize.large => AppSpacing.buttonHeightLg,
      };

  double get _fontSize => switch (widget.size) {
        ButtonSize.small => 14,
        ButtonSize.medium => 16,
        ButtonSize.large => 18,
      };

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppConstants.animationFast),
        curve: Curves.easeOutCubic,
        height: _height,
        width: widget.isFullWidth ? double.infinity : null,
        padding: widget.isFullWidth ? null : AppSpacing.horizontalLg,
        decoration: BoxDecoration(
          color: _isPressed ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(
            color: isEnabled ? color : color.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: isEnabled ? color : color.withValues(alpha: 0.5),
                  size: _fontSize + 4,
                ),
                AppSpacing.hGapSm,
              ],
              Text(
                widget.label,
                style: AppTypography.button.copyWith(
                  color: isEnabled ? color : color.withValues(alpha: 0.5),
                  fontSize: _fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon button with circular shape and subtle animation
class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 48,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    final iconColor = widget.color ?? AppColors.textPrimary;
    final bgColor = widget.backgroundColor ?? AppColors.surfaceVariant;

    Widget button = GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppConstants.animationFast),
        curve: Curves.easeOutCubic,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _isPressed ? bgColor.withValues(alpha: 0.8) : bgColor,
          shape: BoxShape.circle,
          boxShadow: _isPressed ? AppShadows.none : AppShadows.soft,
        ),
        transform: _isPressed
            ? (Matrix4.identity()..setEntry(0, 0, 0.95)..setEntry(1, 1, 0.95)..setEntry(2, 2, 0.95))
            : Matrix4.identity(),
        child: Center(
          child: Icon(
            widget.icon,
            color: isEnabled ? iconColor : iconColor.withValues(alpha: 0.5),
            size: widget.size * 0.5,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}

enum ButtonSize { small, medium, large }

