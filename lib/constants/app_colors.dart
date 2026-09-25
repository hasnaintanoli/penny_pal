import 'package:flutter/material.dart';

/// Centralized color palette for PennyPal design system (Material 3).
class AppColors {
  AppColors._();

  /// Primary Brand Blue (extracted from wallet emblem / CTA button #2563EB)
  static const Color primaryBlue = Color(0xFF2563EB);

  /// Vibrant Accent Blue
  static const Color secondaryBlue = Color(0xFF0077F6);

  /// Secondary Vibrant Green (extracted from sprout leaf accent)
  static const Color accentGreen = Color(0xFF10B981);

  /// Mascot Coin Gold / Amber
  static const Color coinGold = Color(0xFFFFB800);

  /// Soft sky tint matching the splash background canvas
  static const Color splashCanvas = Color(0xFFF0F7FE);

  /// Clean light background for screens (#F5F7FA / #F9FBFE)
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// Pure white for cards and surface layers
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// Feature icon container background
  static const Color featureIconBackground = Color(0xFFEBF4FE);

  /// Feature icon container border
  static const Color featureIconBorder = Color(0xFFDBEAFE);

  /// Dark navy text for titles and main headings
  static const Color textPrimary = Color(0xFF0F172A);

  /// Muted blue-gray for body text, subtitles, and descriptions
  static const Color textSecondary = Color(0xFF64748B);

  /// Soft border line color for dividers and inputs
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Placeholder hint text color
  static const Color textHint = Color(0xFF94A3B8);

  /// Input field background fill
  static const Color inputFill = Color(0xFFFFFFFF);

  /// Input field focus border color
  static const Color inputFocus = Color(0xFF2563EB);

  /// Error color for form validation and expense text
  static const Color error = Color(0xFFEF4444);

  /// Quick Action background tints
  static const Color actionGreenBg = Color(0xFFECFDF5);
  static const Color actionRedBg = Color(0xFFFEF2F2);
  static const Color actionBlueBg = Color(0xFFEFF6FF);
  static const Color actionPurpleBg = Color(0xFFF5F3FF);
  static const Color actionAmberBg = Color(0xFFFFFBEB);
  static const Color actionSkyBg = Color(0xFFF0F9FF);

  /// Quick Action icon colors
  static const Color actionGreenIcon = Color(0xFF10B981);
  static const Color actionRedIcon = Color(0xFFEF4444);
  static const Color actionBlueIcon = Color(0xFF2563EB);
  static const Color actionPurpleIcon = Color(0xFF8B5CF6);
  static const Color actionAmberIcon = Color(0xFFF59E0B);
  static const Color actionSkyIcon = Color(0xFF0EA5E9);

  /// Spending Category Colors for Charts & Tags
  static const Color categoryFood = Color(0xFF0077F6);
  static const Color categoryTransport = Color(0xFF10B981);
  static const Color categoryShopping = Color(0xFFF59E0B);
  static const Color categoryEducation = Color(0xFF8B5CF6);
  static const Color categoryOthers = Color(0xFFA78BFA);

  /// Savings Goal Card Palette
  static const Color savingsCardBg = Color(0xFFF0FDF4);
  static const Color savingsCardBorder = Color(0xFFDCFCE7);
  static const Color savingsTrack = Color(0xFFD1FAE5);
  static const Color savingsProgress = Color(0xFF10B981);
}
