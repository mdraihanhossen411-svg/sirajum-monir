import 'dart:math' as math;
import 'package:flutter/material.dart';

class CompassWidget extends StatelessWidget {
  final double heading;
  final double qiblaBearing;
  final bool isFacingQibla;

  const CompassWidget({
    super.key,
    required this.heading,
    required this.qiblaBearing,
    required this.isFacingQibla,
  });

  double _normalize(double value) {
    final result = value % 360;
    return result < 0 ? result + 360 : result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    final bg = dark
        ? const Color(0xFF0B1712)
        : const Color(0xFFF7FAF8);

    final surface = dark
        ? const Color(0xFF12241B)
        : Colors.white;

    final gold = const Color(0xFFC9A227);
    final green = const Color(0xFF087A3B);
    final text = dark
        ? Colors.white
        : const Color(0xFF17231C);

    final muted = dark
        ? Colors.white70
        : const Color(0xFF5E6B63);

    final relativeQibla =
        _normalize(qiblaBearing - heading);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: gold.withValues(alpha: dark ? .35 : .28),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            spreadRadius: 1,
            color: Colors.black.withValues(
              alpha: dark ? .28 : .08,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      child: Column(
        children: [
          Text(
            'কিবলার দিক',
            style: TextStyle(
              color: muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: .4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${qiblaBearing.round()}°',
            style: TextStyle(
              color: isFacingQibla ? green : text,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            isFacingQibla
                ? 'কিবলার দিকে মুখ করা হয়েছে'
                : 'ফোনটি ধীরে ঘুরিয়ে কিবলার দিক মিলিয়ে নিন',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isFacingQibla ? green : muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: 310,
            height: 310,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: dark
                          ? const [
                              Color(0xFF193629),
                              Color(0xFF0D1B14),
                            ]
                          : const [
                              Color(0xFFFFFFFF),
                              Color(0xFFEAF4EE),
                            ],
                    ),
                    border: Border.all(
                      color: gold.withValues(alpha: .7),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        spreadRadius: 3,
                        color: gold.withValues(alpha: .10),
                      ),
                    ],
                  ),
                ),

                AnimatedRotation(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  turns: -heading / 360,
                  child: CustomPaint(
                    size: const Size(286, 286),
                    painter: _CompassPainter(
                      dark: dark,
                      gold: gold,
                      green: green,
                      text: text,
                    ),
                  ),
                ),

                Transform.rotate(
                  angle: relativeQibla * math.pi / 180,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: isFacingQibla ? 68 : 58,
                        height: isFacingQibla ? 68 : 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFacingQibla
                              ? green
                              : gold,
                          boxShadow: [
                            BoxShadow(
                              blurRadius:
                                  isFacingQibla ? 22 : 12,
                              spreadRadius:
                                  isFacingQibla ? 4 : 1,
                              color: (isFacingQibla
                                      ? green
                                      : gold)
                                  .withValues(alpha: .32),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '🕋',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: surface.withValues(alpha: .92),
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color: gold.withValues(alpha: .45),
                          ),
                        ),
                        child: Text(
                          'কিবলা',
                          style: TextStyle(
                            color: text,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 4,
                  child: Container(
                    width: 7,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isFacingQibla
                          ? green
                          : gold,
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_rounded,
                size: 17,
                color: green,
              ),
              const SizedBox(width: 6),
              Text(
                'বর্তমান দিক  ${heading.round()}°',
                style: TextStyle(
                  color: muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final bool dark;
  final Color gold;
  final Color green;
  final Color text;

  _CompassPainter({
    required this.dark,
    required this.gold,
    required this.green,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final tickPaint = Paint()
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 72; i++) {
      final angle = i * 5 * math.pi / 180;
      final major = i % 3 == 0;

      final outer = radius - 8;
      final inner = major
          ? radius - 22
          : radius - 16;

      tickPaint
        ..color = major
            ? text.withValues(alpha: .75)
            : text.withValues(alpha: .28)
        ..strokeWidth = major ? 1.7 : 1;

      final p1 = Offset(
        center.dx + math.sin(angle) * inner,
        center.dy - math.cos(angle) * inner,
      );

      final p2 = Offset(
        center.dx + math.sin(angle) * outer,
        center.dy - math.cos(angle) * outer,
      );

      canvas.drawLine(p1, p2, tickPaint);
    }

    final labels = <String, double>{
      'N': 0,
      'E': 90,
      'S': 180,
      'W': 270,
    };

    for (final entry in labels.entries) {
      final angle = entry.value * math.pi / 180;
      final position = Offset(
        center.dx + math.sin(angle) * (radius - 43),
        center.dy - math.cos(angle) * (radius - 43),
      );

      final tp = TextPainter(
        text: TextSpan(
          text: entry.key,
          style: TextStyle(
            color: entry.key == 'N'
                ? green
                : text,
            fontSize: entry.key == 'N' ? 19 : 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        position -
            Offset(tp.width / 2, tp.height / 2),
      );
    }

    final centerPaint = Paint()
      ..color = gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(
      center,
      radius - 29,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) {
    return oldDelegate.dark != dark;
  }
}
