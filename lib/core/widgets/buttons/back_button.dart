import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../theme/theme.dart';

/// Reusable back button widget styled as a card with circular transparent hit area
class AppBackButton extends StatefulWidget {
  const AppBackButton({
    super.key,
    required this.onPressed,
    this.size = 48,
    this.iconSize = 28,
  });

  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  @override
  State<AppBackButton> createState() => _AppBackButtonState();
}

class _AppBackButtonState extends State<AppBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppConstants.animationFast),
        curve: Curves.easeOutCubic,
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        transform: _isPressed
            ? (Matrix4.identity()..setEntry(0, 0, 0.95)..setEntry(1, 1, 0.95)..setEntry(2, 2, 0.95))
            : Matrix4.identity(),
        child: Center(
          child: Icon(
            Icons.chevron_left,
            size: widget.iconSize,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

