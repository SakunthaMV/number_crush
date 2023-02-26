import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/Stars/star.dart';

class StarsRow extends StatelessWidget {
  final int amount;
  const StarsRow({super.key, this.amount = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Star(size: 20),
        Text(
          '$amount',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
