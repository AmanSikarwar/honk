import 'package:flutter/material.dart';

/// Central color palette for the Honk design system.
abstract final class AppColors {
  // Brand
  static const brandPurple = Color(0xFF7C3AED); // violet-600
  static const brandPurpleLight = Color(0xFFA78BFA); // violet-400
  static const brandPurpleDark = Color(0xFF5B21B6); // violet-700
  static const accentFuchsia = Color(0xFFD946EF); // fuchsia-500

  // Gradient stops
  static const gradientStart = Color(0xFF4C1D95); // violet-900
  static const gradientMid = Color(0xFF7C3AED); // violet-600
  static const gradientEnd = Color(0xFFD946EF); // fuchsia-500

  // Surfaces
  static const surface = Color(0xFFFAF5FF); // violet-50
  static const surfaceDark = Color(0xFF1A0A2E);
  static const cardDark = Color(0xFF2A1550); // elevated purple-tinted dark card

  // Status chip palette
  static const statusGreen = Color(0xFF22C55E);
  static const statusGreenBg = Color(0xFFDCFCE7);
  static const statusAmber = Color(0xFFF59E0B);
  static const statusAmberBg = Color(0xFFFEF3C7);
  static const statusRed = Color(0xFFEF4444);
  static const statusRedBg = Color(0xFFFEE2E2);
  static const statusPurple = Color(0xFF7C3AED);
  static const statusPurpleBg = Color(0xFFEDE9FE);

  // Creator / participant role badge
  static const creatorBadge = Color(0xFFFDE68A); // amber-200
  static const creatorBadgeFg = Color(0xFF92400E); // amber-800

  // Countdown warning colours
  static const countdownNormal = Color(0xFF7C3AED);
  static const countdownWarning = Color(0xFFF59E0B);
  static const countdownDanger = Color(0xFFEF4444);

  // Comic UI palette (new mock design)
  static const comicLavender = Color(0xFFE0AEEB);
  static const comicPanel = Color(0xFFBB61CF);
  static const comicPanelDark = Color(0xFF8B3D9B);
  static const comicPanelSoft = Color(0xFFF3D9F4);
  static const comicInk = Color(0xFF120212);
  static const comicDanger = Color(0xFFFF5555);
  static const comicSuccess = Color(0xFFA954D5);

  // Semantic tokens
  static const snackBarDark = Color(0xFF3D1F6E);
}
