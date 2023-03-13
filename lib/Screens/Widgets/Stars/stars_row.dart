import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_crush/Screens/Widgets/Stars/star.dart';

class StarsRow extends StatelessWidget {
  final int amount;
  final Color color;
  final double size;
  final double borderSize;
  final Color? starBoder;
  const StarsRow({
    super.key,
    this.amount = 0,
    this.color = const Color(0xFFFFFF00),
    this.size = 20.0,
    this.borderSize = 10.0,
    this.starBoder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Star(
          size: size,
          color: color,
          boderColor: starBoder,
          borderSize: borderSize,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            '$amount',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: size,
                  letterSpacing: -1,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }
}
