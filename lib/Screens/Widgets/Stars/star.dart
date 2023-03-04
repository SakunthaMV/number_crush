import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  final double size;
  final double borderSize;
  final Color color;
  final Color? boderColor;
  const Star({
    super.key,
    this.size = 30.0,
    this.borderSize = 10.0,
    this.color = const Color(0xFFFFFF00),
    this.boderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: (1.0 / 25.0) * size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.star,
            size: 25.0 + borderSize,
            color: boderColor ?? Theme.of(context).colorScheme.outline,
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
