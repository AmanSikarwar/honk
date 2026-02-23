import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class ComicOutlinedText extends StatelessWidget {
  const ComicOutlinedText(
    this.text, {
    super.key,
    this.style,
    this.fillColor = Colors.white,
    this.strokeColor = AppColors.comicInk,
    this.strokeWidth = 5,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.adventPro(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ).merge(style);

    return Stack(
      children: [
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: baseStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: baseStyle.copyWith(
            color: fillColor,
            shadows: [
              Shadow(
                color: strokeColor.withValues(alpha: 0.35),
                blurRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ComicOutlinedIcon extends StatelessWidget {
  const ComicOutlinedIcon({
    super.key,
    required this.icon,
    required this.size,
    this.fillColor = Colors.white,
    this.strokeColor = AppColors.comicInk,
  });

  final IconData icon;
  final double size;
  final Color fillColor;
  final Color strokeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
          size: size,
          color: strokeColor,
          shadows: [
            Shadow(
              color: strokeColor.withValues(alpha: 0.35),
              blurRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        Positioned(
          left: 1.5,
          top: 1.5,
          child: Icon(
            icon,
            size: size - (size * 0.1),
            color: fillColor,
            shadows: [
              Shadow(
                color: strokeColor.withValues(alpha: 0.35),
                blurRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ComicHornIcon extends StatelessWidget {
  const ComicHornIcon({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    final width = (size * 1.2).clamp(64.0, 170.0);
    return Image.asset(
      'assets/icons/Bhopu.png',
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class ComicCardContainer extends StatelessWidget {
  const ComicCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
    this.backgroundColor = AppColors.comicPanel,
    this.radius = 24,
    this.borderWidth = 2.5,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.comicInk, width: borderWidth),
      ),
      padding: padding,
      child: child,
    );
  }
}

class ComicBrandMark extends StatelessWidget {
  const ComicBrandMark({super.key, this.fontSize = 40});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final width = (fontSize * 2.8).clamp(92.0, 170.0);
    return Image.asset(
      'assets/icons/Honks.png',
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class ComicSettingsIcon extends StatelessWidget {
  const ComicSettingsIcon({super.key, this.size = 42});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/Settings.png',
      width: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class ComicBurstLogo extends StatelessWidget {
  const ComicBurstLogo({super.key, this.width = 280});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/Logo.png',
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
