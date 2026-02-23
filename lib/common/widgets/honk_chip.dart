import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A stylised pill showing a status label, with optional colored tint.
///
/// If [countdown] is provided it is shown as secondary text inside the chip.
class HonkChip extends StatelessWidget {
  const HonkChip({
    super.key,
    required this.label,
    this.color,
    this.bgColor,
    this.countdown,
  });

  final String label;
  final Color? color;
  final Color? bgColor;
  final String? countdown;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.brandPurple;
    final bg = bgColor ?? AppColors.statusPurpleBg;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(label),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 4,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.xl),
        ),
        child: countdown != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _labelText(fg),
                  const SizedBox(height: 1),
                  _countdownText(context, countdown!),
                ],
              )
            : _labelText(fg),
      ),
    );
  }

  Widget _labelText(Color fg) {
    return Text(
      label,
      style: GoogleFonts.adventPro(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: fg,
      ),
    );
  }

  Widget _countdownText(BuildContext context, String text) {
    // Near-expiry colouring: turn amber/red based on remaining seconds
    return Text(
      text,
      style: GoogleFonts.adventPro(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: _countdownColor(text),
      ),
    );
  }

  Color _countdownColor(String text) {
    // Detect if < 1 minute
    if (text.endsWith('s') && !text.contains('m')) {
      final seconds = int.tryParse(text.replaceAll('s', '')) ?? 999;
      if (seconds <= 30) return AppColors.countdownDanger;
      return AppColors.countdownWarning;
    }
    return AppColors.countdownNormal;
  }
}

/// A rounded card container used across the app.
class RoundedCard extends StatelessWidget {
  const RoundedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.zero,
      child: Padding(padding: padding, child: child),
    );
  }
}
