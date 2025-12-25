import 'package:flutter/material.dart';

/// Material 3 breakpoint values
abstract final class Breakpoints {
  /// Mobile breakpoint: 0-599dp
  static const double mobile = 0;
  
  /// Tablet breakpoint: 600-839dp
  static const double tablet = 600;
  
  /// Desktop breakpoint: 840dp+
  static const double desktop = 840;
}

/// Utility functions for responsive design using Material 3 breakpoints
abstract final class BreakpointUtils {
  /// Check if current screen width is mobile (< 600dp)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.tablet;
  }

  /// Check if current screen width is tablet (600-839dp)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.tablet && width < Breakpoints.desktop;
  }

  /// Check if current screen width is desktop (>= 840dp)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.desktop;
  }

  /// Check if current screen width is mobile using constraints
  static bool isMobileFromConstraints(BoxConstraints constraints) {
    return constraints.maxWidth < Breakpoints.tablet;
  }

  /// Check if current screen width is tablet using constraints
  static bool isTabletFromConstraints(BoxConstraints constraints) {
    return constraints.maxWidth >= Breakpoints.tablet &&
        constraints.maxWidth < Breakpoints.desktop;
  }

  /// Check if current screen width is desktop using constraints
  static bool isDesktopFromConstraints(BoxConstraints constraints) {
    return constraints.maxWidth >= Breakpoints.desktop;
  }

  /// Get current breakpoint category from context
  static BreakpointCategory getCategory(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) {
      return BreakpointCategory.desktop;
    } else if (width >= Breakpoints.tablet) {
      return BreakpointCategory.tablet;
    } else {
      return BreakpointCategory.mobile;
    }
  }

  /// Get current breakpoint category from constraints
  static BreakpointCategory getCategoryFromConstraints(BoxConstraints constraints) {
    if (constraints.maxWidth >= Breakpoints.desktop) {
      return BreakpointCategory.desktop;
    } else if (constraints.maxWidth >= Breakpoints.tablet) {
      return BreakpointCategory.tablet;
    } else {
      return BreakpointCategory.mobile;
    }
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get screen width from context
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height from context
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

/// Breakpoint categories
enum BreakpointCategory {
  mobile,
  tablet,
  desktop,
}

