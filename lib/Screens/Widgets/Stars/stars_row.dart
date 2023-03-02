import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/Stars/star.dart';

class StarsRow extends StatelessWidget {
  final int amount;
  final Color color;
  final double size;
  const StarsRow({
    super.key,
    this.amount = 0,
    this.color = const Color(0xFFFFFF00),
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 3.2,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Star(
            size: size,
            color: color,
          ),
          Text(
            '$amount',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: size,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
