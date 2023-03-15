import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../Services/database_functions.dart';

class OpenSplash extends StatefulWidget {
  static const String route = 'splash';
  const OpenSplash({Key? key}) : super(key: key);

  @override
  State<OpenSplash> createState() => _OpenSplashState();
}

class _OpenSplashState extends State<OpenSplash> {
  void _checkDatabase() async {
    DatabaseFunctions db = DatabaseFunctions();
    final bool exist = await db.isExistDataBase(1);
    if (!exist) {
      await db.insert(1);
    }
  }

  @override
  void initState() {
    _checkDatabase();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamed(context, '/');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 1.0, end: 0.0),
              builder: (context, progress, _) {
                return CustomPaint(
                  painter: FlashPainter(progress),
                  size: Size(width, height),
                );
              },
            ),
            Center(
              child: SizedBox(
                width: width * 0.75,
                child: Shimmer.fromColors(
                  baseColor: colorScheme.secondary,
                  highlightColor: colorScheme.background,
                  child: FittedBox(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.cinzel(
                          fontSize: 50,
                          letterSpacing: 0.4,
                          height: 1,
                          color: colorScheme.onPrimary,
                        ),
                        children: [
                          const TextSpan(
                            text: 'NUMBER',
                          ),
                          TextSpan(
                            text: '\nCRUSH',
                            style: TextStyle(
                              fontSize: 80,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashPainter extends CustomPainter {
  double progress;
  FlashPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Map<String, List<double>> points = {
      'A': [0.15 * w, 0.55 * h],
      'B': [0.7 * w, 0.2 * h],
      'C': [0.55 * w, 0.45 * h],
      'D': [0.85 * w, 0.45 * h],
      'E': [0.3 * w, 0.8 * h],
      'F': [0.45 * w, 0.55 * h],
    };
    Paint firstLine = Paint();
    firstLine.strokeWidth = 2.0;
    firstLine.color = const Color(0xFFA8BDF4);
    canvas.drawLine(
      Offset(points['A']![0], points['A']![1]),
      Offset(
        points['B']![0] - (points['B']![0] - points['A']![0]) * progress,
        points['B']![1] - (points['B']![1] - points['A']![1]) * progress,
      ),
      firstLine,
    );
    canvas.drawLine(
      Offset(points['B']![0], points['B']![1]),
      Offset(
        points['C']![0] - (points['C']![0] - points['B']![0]) * progress,
        points['C']![1] - (points['C']![1] - points['B']![1]) * progress,
      ),
      firstLine,
    );
    canvas.drawLine(
      Offset(points['C']![0], points['C']![1]),
      Offset(
        points['D']![0] - (points['D']![0] - points['C']![0]) * progress,
        points['D']![1] - (points['D']![1] - points['C']![1]) * progress,
      ),
      firstLine,
    );
    canvas.drawLine(
      Offset(points['D']![0], points['D']![1]),
      Offset(
        points['E']![0] - (points['E']![0] - points['D']![0]) * progress,
        points['E']![1] - (points['E']![1] - points['D']![1]) * progress,
      ),
      firstLine,
    );
    canvas.drawLine(
      Offset(points['E']![0], points['E']![1]),
      Offset(
        points['F']![0] - (points['F']![0] - points['E']![0]) * progress,
        points['F']![1] - (points['F']![1] - points['E']![1]) * progress,
      ),
      firstLine,
    );
    canvas.drawLine(
      Offset(points['F']![0], points['F']![1]),
      Offset(
        points['A']![0] - (points['A']![0] - points['F']![0]) * progress,
        points['A']![1] - (points['A']![1] - points['F']![1]) * progress,
      ),
      firstLine,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
