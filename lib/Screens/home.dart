import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/common_appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Center(
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
      ),
    );
  }
}
