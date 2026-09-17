import 'package:flutter/material.dart';

import '../controllers/splash_controller.dart';
import '../../home/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final SplashController _controller = SplashController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  static const Color darkGreen = Color(0xFF063B25);
  static const Color green = Color(0xFF087A3B);
  static const Color gold = Color(0xFFC9A227);
  static const Color softGold = Color(0xFFE8D58A);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    _controller.initialize(() {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreen,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _IslamicPatternPainter(
                color: gold.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    green.withValues(alpha: 0.65),
                    darkGreen.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                    child: Column(
                      children: [
                        const SizedBox(height: 28),
                        const _Ornament(
                          color: gold,
                          width: 150,
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'السلام عليكم ورحمة الله وبركاته',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              height: 1.8,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 205,
                          height: 205,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                softGold,
                                gold,
                                Color(0xFF8F6D12),
                                gold,
                                softGold,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gold.withValues(alpha: 0.35),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                              const BoxShadow(
                                color: Colors.black45,
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: darkGreen,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 185,
                                height: 185,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          green,
                                          darkGreen,
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.mosque,
                                      color: softGold,
                                      size: 92,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Welcome to Sirajum Monir',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            'আহলে সুন্নাত ওয়াল জামাত',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: softGold,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 7,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 9),
                        const Text(
                          'Your Complete Islamic Companion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const Spacer(),
                        const _Ornament(
                          color: gold,
                          width: 130,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Developed by Mohammad Raihan Siddiki',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ornament extends StatelessWidget {
  final Color color;
  final double width;

  const _Ornament({
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: color.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(width: 9),
          Icon(Icons.diamond, color: color, size: 12),
          const SizedBox(width: 7),
          Icon(Icons.star, color: color, size: 15),
          const SizedBox(width: 7),
          Icon(Icons.diamond, color: color, size: 12),
          const SizedBox(width: 9),
          Expanded(
            child: Container(
              height: 1,
              color: color.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

class _IslamicPatternPainter extends CustomPainter {
  final Color color;

  const _IslamicPatternPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    const double spacing = 70;

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        _drawPattern(canvas, Offset(x, y), paint);
      }
    }
  }

  void _drawPattern(
    Canvas canvas,
    Offset center,
    Paint paint,
  ) {
    const double radius = 24;
    const double pi = 3.141592653589793;

    final path = Path();

    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;

      final x1 = center.dx + radius * _cos(angle);
      final y1 = center.dy + radius * _sin(angle);

      final x2 = center.dx + radius * _cos(angle + pi / 4);
      final y2 = center.dy + radius * _sin(angle + pi / 4);

      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
    }

    canvas.drawPath(path, paint);
    canvas.drawCircle(center, 7, paint);
  }

  double _sin(double value) {
    const values = <double>[
      0,
      0.7071,
      1,
      0.7071,
      0,
      -0.7071,
      -1,
      -0.7071,
    ];

    final index = ((value / (2 * 3.141592653589793)) * 8).round() % 8;
    return values[index];
  }

  double _cos(double value) {
    const values = <double>[
      1,
      0.7071,
      0,
      -0.7071,
      -1,
      -0.7071,
      0,
      0.7071,
    ];

    final index = ((value / (2 * 3.141592653589793)) * 8).round() % 8;
    return values[index];
  }

  @override
  bool shouldRepaint(
    covariant _IslamicPatternPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}
