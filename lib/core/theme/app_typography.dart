import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system using Nunito for a playful, rounded feel
/// with Fredoka One for display/game elements
abstract final class AppTypography {
  // Base font family
  static String get _fontFamily => GoogleFonts.nunito().fontFamily!;
  static String get _displayFontFamily => GoogleFonts.fredoka().fontFamily!;

  // Display styles - for big headlines and game titles
  static TextStyle get displayLarge => TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // Headline styles
  static TextStyle get headlineLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Title styles
  static TextStyle get titleLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  // Body styles
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
      );

  // Label styles
  static TextStyle get labelLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      );

  // Game-specific styles
  static TextStyle get gridLetter => TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.letterDefault,
      );

  static TextStyle get wordListItem => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get wordListItemFound => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.textHint,
        decoration: TextDecoration.lineThrough,
        decorationColor: AppColors.primary,
        decorationThickness: 2,
      );

  static TextStyle get timer => TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get score => TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle get button => TextStyle(
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

