import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFFFF7A00); // Energetic Orange
  static const Color primaryDark = Color(0xFFE05D00);
  static const Color secondary = Color(0xFF00A68C); // Fresh Teal (Success/Done)
  static const Color secondaryLight = Color(0xFFE6F6F4);

  // Backgrounds
  static const Color lightBg = Color(0xFFFAF9F6); // Soft warm off-white
  static const Color darkBg = Color(0xFF0F172A); // Deep slate/navy
  static const Color lightCard = Colors.white;
  static const Color darkCard = Color(0xFF1E293B);

  // Text Colors
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textMutedLight = Color(0xFF64748B);
  static const Color textMutedDark = Color(0xFF94A3B8);

  // Priority Colors
  static const Color priorityHigh = Color(0xFFEF4444); // Red
  static const Color priorityHighBg = Color(0xFFFEE2E2);
  static const Color priorityMedium = Color(0xFFF59E0B); // Amber
  static const Color priorityMediumBg = Color(0xFFFEF3C7);
  static const Color priorityLow = Color(0xFF10B981); // Green
  static const Color priorityLowBg = Color(0xFFD1FAE5);

  // Streak Colors
  static const Color flameWarm = Color(0xFFFF9800);
  static const Color flameHot = Color(0xFFFF5722);
  static const Color flameInferno = Color(0xFFD50000);

  // Hero Card Gradients
  static const List<Color> heroGradient = [
    Color(0xFFFF7A00),
    Color(0xFFFF3D00),
    Color(0xFFFF9100),
  ];

  static const List<Color> heroGradientDark = [
    Color(0xFFC2410C),
    Color(0xFF9A3412),
    Color(0xFFEA580C),
  ];
}

class AppSpacings {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
}

class AppDurations {
  static const Duration checkAnimation = Duration(milliseconds: 450);
  static const Duration strikeThroughAnimation = Duration(milliseconds: 350);
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration long = Duration(milliseconds: 600);
  static const Duration flamePulse = Duration(milliseconds: 1200);
}
