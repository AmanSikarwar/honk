import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../common/widgets/comic_ui.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _revealTimer;
  bool _showContinue = false;

  @override
  void initState() {
    super.initState();
    _revealTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _showContinue = true);
    });
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final logoWidth = (screen.width * 0.48).clamp(240.0, 480.0);
    final ctaWidth = (screen.width * 0.46).clamp(200.0, 420.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.comicLavender,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Align(
                      alignment: const Alignment(0, 0.03),
                      child: SizedBox(
                        width: logoWidth,
                        child: ComicBurstLogo(width: logoWidth),
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _showContinue ? 1 : 0,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOut,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOut,
                    offset: _showContinue ? Offset.zero : const Offset(0, 0.15),
                    child: _ContinueButton(
                      width: ctaWidth,
                      onPressed: () => const LoginRoute().push(context),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.width, required this.onPressed});

  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.comicPanel,
      borderRadius: BorderRadius.circular(42),
      child: InkWell(
        borderRadius: BorderRadius.circular(42),
        onTap: onPressed,
        child: Ink(
          width: width,
          height: 92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(42),
            border: Border.all(color: AppColors.comicInk, width: 3),
          ),
          child: const Center(
            child: ComicOutlinedIcon(
              icon: FontAwesomeIcons.arrowRightLong,
              strokeColor: AppColors.comicInk,
              size: 52,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
