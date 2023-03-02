import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/Widgets/common_background.dart';

class Stages extends StatelessWidget {
  static String route = 'stages';
  const Stages({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CommonBackground(
      extend: false,
      content: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: width * 0.025,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _stageContainer(context, index);
        },
      ),
    );
  }

  Container _stageContainer(BuildContext context, int index, {int stars = 0}) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 250,
      margin: EdgeInsets.symmetric(vertical: width * 0.02),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: colorScheme.primaryContainer,
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              CustomPaint(
                painter: StageShape(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: width * 0.1),
                    child: Opacity(
                      opacity: 0.2,
                      child: Text(
                        '${index + 1}',
                        style: textTheme.displayLarge?.copyWith(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StarsRow(
                      size: 30.0,
                      amount: stars,
                    ),
                    StarsRow(
                      size: 30.0,
                      amount: 113,
                      color: colorScheme.primaryContainer,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'STAGE ${index + 1}',
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 30.0,
                        color: colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StageShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.shader = ui.Gradient.linear(
      Offset(0.0, size.height),
      Offset(size.width * 0.7, 0.0),
      [const Color(0xFFA5A4C2), const Color(0xFF5A5261)],
    );
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.lineTo(18.0, 0.0);
    path.lineTo(size.width * 0.32, 35.0);
    path.lineTo(size.width * 0.7, 0.0);
    path.lineTo(size.width * 0.32, size.height);
    path.lineTo(0.0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
