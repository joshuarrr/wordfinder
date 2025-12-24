import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography system using system fonts for instant rendering
abstract final class AppTypography {
  // Use system fonts - no network delay
  static const String _fontFamily = 'SF Pro Display';
  static const String _displayFontFamily = 'SF Pro Rounded';

  // Display styles - for big headlines and game titles
  static TextStyle get displayLarge => const TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // Headline styles
  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Title styles
  static TextStyle get titleLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  // Body styles
  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
      );

  // Label styles
  static TextStyle get labelLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      );

  // Game-specific styles
  static TextStyle get gridLetter => const TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.letterDefault,
      );

  static TextStyle get wordListItem => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get wordListItemFound => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.textHint,
        decoration: TextDecoration.lineThrough,
        decorationColor: AppColors.primary,
        decorationThickness: 2,
      );

  static TextStyle get timer => const TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get score => const TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle get button => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );

  /// Create the complete text theme for Material
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
