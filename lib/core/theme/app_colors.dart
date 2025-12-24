import 'package:flutter/material.dart';

/// Playful color palette for the Word Search game
/// Designed with vibrant, energetic colors that feel fun and engaging
abstract final class AppColors {
  // Primary palette - Coral/Orange tones
  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryLight = Color(0xFFFF8E8E);
  static const Color primaryDark = Color(0xFFE85555);

  // Secondary palette - Teal/Cyan tones
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryLight = Color(0xFF7EDDD6);
  static const Color secondaryDark = Color(0xFF3DBDB4);

  // Accent colors for variety
  static const Color accent1 = Color(0xFFFFE66D); // Sunny yellow
  static const Color accent2 = Color(0xFFA8E6CF); // Mint green
  static const Color accent3 = Color(0xFFDDA0DD); // Plum
  static const Color accent4 = Color(0xFF88D8B0); // Sea foam
  static const Color accent5 = Color(0xFFFFAB91); // Peach
  static const Color accent6 = Color(0xFF81D4FA); // Sky blue

  // Letter cell colors (used for grid)
  static const List<Color> cellColors = [
    Color(0xFFFFE0E0), // Light coral
    Color(0xFFE0F7FA), // Light cyan
    Color(0xFFFFF9C4), // Light yellow
    Color(0xFFE8F5E9), // Light mint
    Color(0xFFF3E5F5), // Light lavender
    Color(0xFFFFECB3), // Light amber
  ];

  // Word found celebration colors
  static const List<Color> celebrationColors = [
    primary,
    secondary,
    accent1,
    accent2,
    accent3,
    accent4,
  ];

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // Neutral palette
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textHint = Color(0xFFB2BEC3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // Grid specific
  static const Color gridLine = Color(0xFFE8E8E8);
  static const Color letterDefault = Color(0xFF2D3436);
  static const Color letterSelected = Color(0xFFFFFFFF);
  static const Color letterFound = Color(0xFF636E72);

  // Selection highlight
  static const Color selectionStart = Color(0xFFFF6B6B);
  static const Color selectionEnd = Color(0xFF4ECDC4);

  /// Get a random cell background color
  static Color getRandomCellColor(int index) {
    return cellColors[index % cellColors.length];
  }

  /// Get celebration color by index
  static Color getCelebrationColor(int index) {
    return celebrationColors[index % celebrationColors.length];
  }
}

