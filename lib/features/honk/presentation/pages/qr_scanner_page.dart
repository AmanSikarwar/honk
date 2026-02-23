import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/join_honk_cubit.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  StreamSubscription<Object?>? _subscription;
  bool _didScan = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(autoStart: false);
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.barcodes.listen(_onBarcode);
    unawaited(_controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_controller.stop());
      case AppLifecycleState.resumed:
        _subscription = _controller.barcodes.listen(_onBarcode);
        unawaited(_controller.start());
    }
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await _controller.dispose();
  }

  void _onBarcode(BarcodeCapture capture) {
    if (_didScan || !mounted) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;
    final code = _extractCode(raw);
    if (code == null) return;
    _didScan = true;
    unawaited(_controller.stop());
    context.read<JoinHonkCubit>().joinByCode(code);
  }

  String? _extractCode(String raw) {
    const prefix = 'https://honkapp.app/join/';
    if (raw.startsWith(prefix)) {
      final code = raw.substring(prefix.length).trim();
      return code.isEmpty ? null : code;
    }
    return raw.trim().isEmpty ? null : raw.trim();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinHonkCubit, JoinHonkState>(
      listener: (ctx, state) {
        state.mapOrNull(
          success: (s) => HonkDetailsRoute(activityId: s.activityId).go(ctx),
          failure: (f) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(f.failure.toString())));
            _didScan = false;
            unawaited(_controller.start());
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<JoinHonkCubit, JoinHonkState>(
          builder: (ctx, state) {
            final isLoading = state.maybeMap(loading: (_) => true, orElse: () => false);
            return Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(controller: _controller, onDetect: _onBarcode),
                _ScanOverlay(),
                // Back button
                Positioned(
                  top: MediaQuery.of(ctx).padding.top + AppSpacing.sm,
                  left: AppSpacing.md,
                  child: _BackBtn(),
                ),
                // Bottom status toast
                if (isLoading)
                  Positioned(
                    bottom: MediaQuery.of(ctx).padding.bottom + AppSpacing.xl,
                    left: AppSpacing.xl,
                    right: AppSpacing.xl,
                    child: const _StatusToast(label: 'Joining…'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Back button ───────────────────────────────────────────────────────────────

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 22),
      ),
    );
  }
}

// ── Status toast ──────────────────────────────────────────────────────────────

class _StatusToast extends StatelessWidget {
  const _StatusToast({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.brandPurple,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── Scan overlay ──────────────────────────────────────────────────────────────

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final side = constraints.maxWidth * 0.68;
        final left = (constraints.maxWidth - side) / 2;
        final top = (constraints.maxHeight - side) / 2 - 40;
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _OverlayPainter(Rect.fromLTWH(left, top, side, side))),
            ),
            Positioned(
              left: left,
              top: top,
              width: side,
              height: side,
              child: const _CornerBrackets(),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: top + side + AppSpacing.lg,
              child: Text(
                'Point camera at a Honk QR code',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  const _OverlayPainter(this.cutout);
  final Rect cutout;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(cutout, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_OverlayPainter old) => old.cutout != cutout;
}

class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets();

  @override
  Widget build(BuildContext context) {
    const len = 28.0;
    const thick = 3.5;
    const color = Colors.white;
    const r = Radius.circular(6);
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: _Bracket(len: len, thick: thick, color: color, radius: r, corner: _Corner.topLeft),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: _Bracket(
            len: len,
            thick: thick,
            color: color,
            radius: r,
            corner: _Corner.topRight,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: _Bracket(
            len: len,
            thick: thick,
            color: color,
            radius: r,
            corner: _Corner.bottomLeft,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _Bracket(
            len: len,
            thick: thick,
            color: color,
            radius: r,
            corner: _Corner.bottomRight,
          ),
        ),
      ],
    );
  }
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

class _Bracket extends StatelessWidget {
  const _Bracket({
    required this.len,
    required this.thick,
    required this.color,
    required this.radius,
    required this.corner,
  });

  final double len;
  final double thick;
  final Color color;
  final Radius radius;
  final _Corner corner;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(len, len),
      painter: _BracketPainter(
        len: len,
        thick: thick,
        color: color,
        radius: radius,
        corner: corner,
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter({
    required this.len,
    required this.thick,
    required this.color,
    required this.radius,
    required this.corner,
  });

  final double len;
  final double thick;
  final Color color;
  final Radius radius;
  final _Corner corner;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    switch (corner) {
      case _Corner.topLeft:
        path.moveTo(0, len);
        path.lineTo(0, radius.x);
        path.arcToPoint(Offset(radius.x, 0), radius: radius);
        path.lineTo(len, 0);
      case _Corner.topRight:
        path.moveTo(0, 0);
        path.lineTo(len - radius.x, 0);
        path.arcToPoint(Offset(len, radius.x), radius: radius);
        path.lineTo(len, len);
      case _Corner.bottomLeft:
        path.moveTo(len, len);
        path.lineTo(radius.x, len);
        path.arcToPoint(Offset(0, len - radius.x), radius: radius);
        path.lineTo(0, 0);
      case _Corner.bottomRight:
        path.moveTo(0, len);
        path.lineTo(len - radius.x, len);
        path.arcToPoint(Offset(len, len - radius.x), radius: radius);
        path.lineTo(len, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => false;
}
