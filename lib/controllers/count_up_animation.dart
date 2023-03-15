import 'package:flutter/material.dart';

class CountUpAnimation extends StatefulWidget {
  final int targetNumber;
  final Duration duration;
  const CountUpAnimation({
    super.key,
    required this.targetNumber,
    required this.duration,
  });

  @override
  State<CountUpAnimation> createState() => _CountUpAnimationState();
}

class _CountUpAnimationState extends State<CountUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentNumber = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.addListener(() {
      setState(() {
        _currentNumber = (_animation.value * widget.targetNumber).floor();
      });
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '+$_currentNumber',
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 27,
            letterSpacing: -1,
            color: Theme.of(context).colorScheme.secondary,
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
