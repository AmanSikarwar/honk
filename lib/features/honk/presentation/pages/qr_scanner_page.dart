import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/router/app_router.dart';
import '../cubit/join_honk_cubit.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with WidgetsBindingObserver {
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

  /// Accepts either the bare invite code or the full deep-link URL.
  String? _extractCode(String raw) {
    const prefix = 'https://honkapp.app/join/';
    if (raw.startsWith(prefix)) {
      final code = raw.substring(prefix.length).trim();
      return code.isEmpty ? null : code;
    }
    final trimmed = raw.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinHonkCubit, JoinHonkState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (s) =>
              HonkDetailsRoute(activityId: s.activityId).go(context),
          failure: (f) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(f.failure.toString())));
            // Allow scanning again after a failure.
            _didScan = false;
            unawaited(_controller.start());
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR Code'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder<JoinHonkCubit, JoinHonkState>(
          builder: (context, state) {
            final isLoading = state.maybeMap(
              loading: (_) => true,
              orElse: () => false,
            );
            return Stack(
              children: [
                MobileScanner(controller: _controller, onDetect: _onBarcode),
                // Dimmed overlay with a clear scanning window.
                _ScanOverlay(),
                if (isLoading)
                  const ColoredBox(
                    color: Colors.black54,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Scanning overlay ──────────────────────────────────────────────────────────

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth * 0.68;
        final left = (constraints.maxWidth - side) / 2;
        final top = (constraints.maxHeight - side) / 2 - 40;
        return Stack(
          children: [
            // Dark mask — four rectangles around the cutout.
            Positioned.fill(
              child: CustomPaint(
                painter: _OverlayPainter(Rect.fromLTWH(left, top, side, side)),
              ),
            ),
            // Corner brackets.
            Positioned(
              left: left,
              top: top,
              width: side,
              height: side,
              child: const _CornerBrackets(),
            ),
            // Label below the window.
            Positioned(
              left: 0,
              right: 0,
              top: top + side + 20,
              child: Text(
                'Point camera at a Honk QR code',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter(this.cutout);

  final Rect cutout;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final full = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(full)
      ..addRRect(RRect.fromRectAndRadius(cutout, const Radius.circular(12)))
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
    const len = 24.0;
    const thick = 3.0;
    const color = Colors.white;
    const r = Radius.circular(4);
    return Stack(
      children: [
        // Top-left
        Positioned(
          top: 0,
          left: 0,
          child: _Bracket(
            len: len,
            thick: thick,
            color: color,
            radius: r,
            corner: _Corner.topLeft,
          ),
        ),
        // Top-right
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
        // Bottom-left
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
        // Bottom-right
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
  _BracketPainter({
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
