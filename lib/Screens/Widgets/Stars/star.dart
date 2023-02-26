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
        children: [
          Icon(
            Icons.star,
            size: 35.0,
            color: Theme.of(context).colorScheme.outline,
          ),
          Icon(
            Icons.star,
            size: 30,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ],
      ),
    );
  }
}
