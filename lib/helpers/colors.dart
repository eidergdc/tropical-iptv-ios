part of 'helpers.dart';

// Primary Colors - Tropical Play Theme (Based on Logo)
const Color kColorPrimary = Color(0xFFFDB813); // Vibrant Yellow/Gold
const Color kColorSecondary = Color(0xFFFF8C00); // Orange
const Color kColorTertiary = Color(0xFFD2691E); // Dark Orange/Brown

// Modern Dark Background Colors
const Color kColorBackground = Color(0xFF0A0A0A); // Deep Black
const Color kColorSurface = Color(0xFF121212); // Material Dark Surface
const Color kColorCard = Color(0xFF1E1E1E); // Elevated Card
const Color kColorCardLight = Color(0xFF252525); // Light Card

// Elevated Surfaces (Material Design 3)
const Color kColorElevated1 = Color(0xFF1E1E1E); // Level 1
const Color kColorElevated2 = Color(0xFF232323); // Level 2
const Color kColorElevated3 = Color(0xFF282828); // Level 3

// Text Colors
const Color kColorText = Color(0xFFFFFFFF); // Pure White
const Color kColorTextSecondary = Color(0xFFB3B3B3); // Light Gray
const Color kColorTextTertiary = Color(0xFF666666); // Medium Gray
const Color kColorTextDisabled = Color(0xFF404040); // Dark Gray
const Color kColorTextBlack = Color(0xFF000000); // Black (for logo text)

// Accent Colors (More Vibrant)
const Color kColorAccent = Color(0xFFFDB813); // Gold (same as primary)
const Color kColorSuccess = Color(0xFF00C853); // Vibrant Green
const Color kColorWarning = Color(0xFFFFAB00); // Vibrant Orange
const Color kColorError = Color(0xFFFF1744); // Vibrant Red
const Color kColorInfo = Color(0xFF00B0FF); // Vibrant Blue

// Dividers and Borders
const Color kColorDivider = Color(0xFF2C2C2C);
const Color kColorBorder = Color(0xFF333333);

// Overlay Colors
final Color kColorOverlay = const Color(0xFF000000).withOpacity(0.7);
final Color kColorOverlayLight = const Color(0xFF000000).withOpacity(0.5);

// Background Decoration - Modern Dark
BoxDecoration kDecorBackground = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A0A0A), // Deep Black
      Color(0xFF121212), // Material Dark
      Color(0xFF0F0F0F), // Slightly lighter
    ],
  ),
);

// Card Decoration - Modern with subtle shadow
BoxDecoration kDecorCard = BoxDecoration(
  color: kColorCard,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(
    color: kColorBorder,
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: -5,
    ),
  ],
);

// Elevated Card Decoration
BoxDecoration kDecorCardElevated = BoxDecoration(
  color: kColorElevated2,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(
    color: kColorBorder,
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: -8,
    ),
  ],
);

// Tropical Sunset Gradient (Primary)
BoxDecoration kDecorTropical = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFDB813), // Yellow
      Color(0xFFFF8C00), // Orange
    ],
  ),
);

// Tropical Radial Gradient (like the logo) - Darker background
BoxDecoration kDecorTropicalRadial = const BoxDecoration(
  gradient: RadialGradient(
    colors: [
      Color(0xFF1A1A1A), // Dark center
      Color(0xFF0F0F0F), // Darker mid
      Color(0xFF0A0A0A), // Deep black edge
    ],
    center: Alignment.center,
    radius: 1.5,
  ),
);

// Modern Dark Gradient for backgrounds
BoxDecoration kDecorModernDark = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0A0A), // Deep Black
      Color(0xFF1A1A1A), // Lighter Black
      Color(0xFF0F0F0F), // Medium Black
    ],
  ),
);

// Gradient Colors for use in widgets
final kGradientPrimary = LinearGradient(
  colors: [
    Color(0xFFFDB813), // Yellow
    Color(0xFFFF8C00), // Orange
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final kGradientSecondary = LinearGradient(
  colors: [
    Color(0xFFFF8C00), // Orange
    Color(0xFFD2691E), // Dark Orange
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Tropical Sunset Gradient (for splash/hero sections)
final kGradientTropical = LinearGradient(
  colors: [
    Color(0xFFFDB813), // Bright Yellow
    Color(0xFFFFAA00), // Yellow-Orange
    Color(0xFFFF8C00), // Orange
    Color(0xFFFF6B00), // Dark Orange
    Color(0xFFD2691E), // Brown-Orange
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Radial Gradient (like the logo)
final kGradientRadial = RadialGradient(
  colors: [
    Color(0xFFFDB813), // Center Yellow
    Color(0xFFFF8C00), // Mid Orange
    Color(0xFFD2691E), // Edge Dark Orange
  ],
  center: Alignment.center,
  radius: 1.0,
);

// Modern Dark Radial Gradient
final kGradientModernDarkRadial = RadialGradient(
  colors: [
    Color(0xFF1A1A1A), // Center
    Color(0xFF0F0F0F), // Mid
    Color(0xFF0A0A0A), // Edge
  ],
  center: Alignment.center,
  radius: 1.5,
);

// Glassmorphism effect
BoxDecoration kDecorGlass = BoxDecoration(
  color: Colors.white.withOpacity(0.05),
  borderRadius: BorderRadius.circular(16),
  border: Border.all(
    color: Colors.white.withOpacity(0.1),
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ],
);
