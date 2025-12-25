# Material 3 Responsive Design Best Practices

## Breakpoints

Material 3 defines standard breakpoints for responsive layouts:

- **Mobile**: 0–599dp
- **Tablet**: 600–839dp  
- **Desktop**: 840dp+

## Core Principles

### 1. Adaptive Layouts
- Use flexible grids and responsive components that adjust to screen size
- Leverage `LayoutBuilder` and `MediaQuery` to detect breakpoints
- Design layouts that work across all device categories

### 2. Typography Scaling
- Material 3 typography uses fixed sizes (not fluid by default)
- Scale typography based on breakpoints for better readability
- Use `MediaQuery.textScaleFactor` to respect user accessibility settings

### 3. Touch Targets
- Maintain minimum 48dp touch targets on all screen sizes
- Ensure adequate spacing between interactive elements
- Consider larger targets on tablet/desktop for better usability

### 4. Component Adaptation
- Adapt component layouts (e.g., navigation, cards, grids) per breakpoint
- Use different layouts for mobile vs tablet/desktop when appropriate
- Consider orientation changes (portrait/landscape)

### 5. Testing
- Test across device categories (mobile, tablet, desktop)
- Verify both portrait and landscape orientations
- Check with different text scale factors

## Flutter Implementation

### Using BreakpointUtils

The app includes a `BreakpointUtils` utility class (`lib/core/utils/breakpoints.dart`) that provides consistent breakpoint checking:

```dart
import 'package:wordfinder/core/utils/breakpoints.dart';

// Check breakpoint from context
if (BreakpointUtils.isMobile(context)) {
  return MobileLayout();
} else if (BreakpointUtils.isTablet(context)) {
  return TabletLayout();
} else {
  return DesktopLayout();
}

// Check breakpoint from LayoutBuilder constraints
LayoutBuilder(
  builder: (context, constraints) {
    if (BreakpointUtils.isDesktopFromConstraints(constraints)) {
      return DesktopLayout();
    } else if (BreakpointUtils.isTabletFromConstraints(constraints)) {
      return TabletLayout();
    }
    return MobileLayout();
  },
)

// Get breakpoint category
final category = BreakpointUtils.getCategory(context);
switch (category) {
  case BreakpointCategory.mobile:
    return MobileLayout();
  case BreakpointCategory.tablet:
    return TabletLayout();
  case BreakpointCategory.desktop:
    return DesktopLayout();
}

// Orientation helpers
if (BreakpointUtils.isLandscape(context)) {
  return LandscapeLayout();
}
```

### Breakpoint Values

Access Material 3 breakpoint constants directly:

```dart
import 'package:wordfinder/core/utils/breakpoints.dart';

// Material 3 breakpoints
Breakpoints.mobile   // 0
Breakpoints.tablet   // 600
Breakpoints.desktop  // 840
```

## References

- [Material Design 3](https://m3.material.io)
- Material 3 emphasizes adaptive design for consistent UX across devices

