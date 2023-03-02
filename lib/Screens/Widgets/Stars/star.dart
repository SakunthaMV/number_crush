import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  final double size;
  final Color color;
  const Star({super.key, this.size = 30.0, this.color = const Color(0xFFFFFF00)});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: (1.0 / 25.0) * size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.star,
            size: 35.0,
            color: Theme.of(context).colorScheme.outline,
          ),
          Icon(
            Icons.star,
            size: 25.0,
            color: color,
          ),
        ],
      ),
    );
  }
}
