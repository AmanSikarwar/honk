import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Central theme factory for Honk.
/// Uses Material 3 with a custom electric-violet palette and Advent Pro font.
abstract final class AppTheme {
  static ThemeData get light => _build(brightness: Brightness.light);
  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.brandPurple,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.brandPurple,
          onPrimary: Colors.white,
          secondary: AppColors.accentFuchsia,
          onSecondary: Colors.white,
          surface: isDark ? AppColors.surfaceDark : Colors.white,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
    );

    // Typography — Advent Pro for display/headlines, Advent Pro for body
    final textTheme = _buildTextTheme(base.textTheme, colorScheme);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.comicLavender,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.comicInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.adventPro(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.comicInk,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.comicCard),
          side: const BorderSide(color: AppColors.comicInk, width: 2),
        ),
        color: AppColors.comicPanel,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.comicInk, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.comicInk, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.comicInk, width: 2.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.comicPanelDark,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.comicInk, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.adventPro(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.comicInk, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.adventPro(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.adventPro(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.comicPanelDark,
        foregroundColor: Colors.white,
        extendedTextStyle: GoogleFonts.adventPro(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.comicInk, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? AppColors.snackBarDark
            : colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: isDark ? Colors.white : colorScheme.onInverseSurface,
          fontFamily: GoogleFonts.adventPro().fontFamily,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        labelStyle: GoogleFonts.adventPro(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      dividerTheme: const DividerThemeData(space: 1, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, ColorScheme cs) {
    final body = GoogleFonts.adventProTextTheme(base);
    return body.copyWith(
      displayLarge: GoogleFonts.adventPro(
        fontSize: 57,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      displayMedium: GoogleFonts.adventPro(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      displaySmall: GoogleFonts.adventPro(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        color: cs.onSurface,
      ),
      headlineLarge: GoogleFonts.adventPro(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      headlineMedium: GoogleFonts.adventPro(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: cs.onSurface,
      ),
      headlineSmall: GoogleFonts.adventPro(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: cs.onSurface,
      ),
      titleLarge: GoogleFonts.adventPro(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: cs.onSurface,
      ),
      titleMedium: GoogleFonts.adventPro(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
      ),
      titleSmall: GoogleFonts.adventPro(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
      ),
      bodyLarge: GoogleFonts.adventPro(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
      ),
      bodyMedium: GoogleFonts.adventPro(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
      ),
      bodySmall: GoogleFonts.adventPro(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: cs.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.adventPro(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
      ),
      labelMedium: GoogleFonts.adventPro(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
      ),
      labelSmall: GoogleFonts.adventPro(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
