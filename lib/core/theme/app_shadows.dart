import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Shadow definitions for depth and elevation
abstract final class AppShadows {
  // Soft shadows for cards and containers
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  // Medium elevation for interactive elements
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  // Strong elevation for modals and popovers
  static List<BoxShadow> get strong => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.16),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  // Playful colored shadow for primary elements
  static List<BoxShadow> primaryGlow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // Button pressed state shadow
  static List<BoxShadow> get buttonPressed => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.04),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  // Grid cell shadow
  static List<BoxShadow> get cell => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  // Selected cell glow
  static List<BoxShadow> cellSelected(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.4),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];

  // Celebration cell glow (green success)
  static List<BoxShadow> get cellCelebration => [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.6),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ];

  // No shadow
  static List<BoxShadow> get none => [];
}

