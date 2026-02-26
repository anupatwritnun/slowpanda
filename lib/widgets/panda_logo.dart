import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PandaLogo extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;

  const PandaLogo({
    super.key,
    this.size = 120,
    this.primaryColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final pandaColor = primaryColor ?? AppColors.textPrimary;
    final goldColor = accentColor ?? AppColors.accentGold;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PandaLogoPainter(
          pandaColor: pandaColor,
          goldColor: goldColor,
        ),
      ),
    );
  }
}

class _PandaLogoPainter extends CustomPainter {
  final Color pandaColor;
  final Color goldColor;

  _PandaLogoPainter({
    required this.pandaColor,
    required this.goldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseSize = size.width;

    // Head (oval)
    final headPaint = Paint()
      ..color = pandaColor
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: baseSize * 0.75,
        height: baseSize * 0.65,
      ),
      headPaint,
    );

    // Ears
    final earPaint = Paint()
      ..color = pandaColor
      ..style = PaintingStyle.fill;

    // Left ear
    canvas.drawCircle(
      Offset(center.dx - baseSize * 0.28, center.dy - baseSize * 0.22),
      baseSize * 0.14,
      earPaint,
    );

    // Right ear
    canvas.drawCircle(
      Offset(center.dx + baseSize * 0.28, center.dy - baseSize * 0.22),
      baseSize * 0.14,
      earPaint,
    );

    // Eye patches (black circles, tilted)
    final eyePatchPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    // Left eye patch
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - baseSize * 0.12, center.dy - baseSize * 0.02),
        width: baseSize * 0.18,
        height: baseSize * 0.12,
      ),
      eyePatchPaint,
    );

    // Right eye patch
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + baseSize * 0.12, center.dy - baseSize * 0.02),
        width: baseSize * 0.18,
        height: baseSize * 0.12,
      ),
      eyePatchPaint,
    );

    // Eyes (small black dots)
    final eyePaint = Paint()
      ..color = pandaColor
      ..style = PaintingStyle.fill;

    // Left eye (sleepy - closed curved line)
    final leftEyePath = Path();
    leftEyePath.moveTo(center.dx - baseSize * 0.18, center.dy);
    leftEyePath.quadraticBezierTo(
      center.dx - baseSize * 0.12,
      center.dy + baseSize * 0.02,
      center.dx - baseSize * 0.06,
      center.dy,
    );
    canvas.drawPath(leftEyePath, Paint()..color = pandaColor..strokeWidth = 2..style = PaintingStyle.stroke);

    // Right eye
    final rightEyePath = Path();
    rightEyePath.moveTo(center.dx + baseSize * 0.06, center.dy);
    rightEyePath.quadraticBezierTo(
      center.dx + baseSize * 0.12,
      center.dy + baseSize * 0.02,
      center.dx + baseSize * 0.18,
      center.dy,
    );
    canvas.drawPath(rightEyePath, Paint()..color = pandaColor..strokeWidth = 2..style = PaintingStyle.stroke);

    // Nose (small triangle/oval)
    final nosePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + baseSize * 0.1),
        width: baseSize * 0.08,
        height: baseSize * 0.05,
      ),
      nosePaint,
    );

    // Mouth (slight smile)
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - baseSize * 0.06, center.dy + baseSize * 0.18);
    mouthPath.quadraticBezierTo(
      center.dx,
      center.dy + baseSize * 0.22,
      center.dx + baseSize * 0.06,
      center.dy + baseSize * 0.18,
    );
    canvas.drawPath(mouthPath, Paint()..color = pandaColor..strokeWidth = 2..style = PaintingStyle.stroke);

    // Gold quotation mark on forehead
    final quotePaint = TextPainter(
      text: TextSpan(
        text: '"',
        style: TextStyle(
          color: goldColor,
          fontSize: baseSize * 0.18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    quotePaint.layout();
    quotePaint.paint(
      canvas,
      Offset(
        center.dx - quotePaint.width / 2,
        center.dy - baseSize * 0.2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
