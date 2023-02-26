import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  final double size;
  const Star({super.key, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: (1.0 / 30.0) * size,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Icon(
            Icons.star,
            size: 35.0,
            color: Color(0xFFB3B334),
          ),
          Icon(
            Icons.star,
            size: 30,
            color: Color(0xFFFFFF00),
          ),
        ],
      ),
    );
  }
}
