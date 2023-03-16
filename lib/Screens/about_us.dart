import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/common_appbar.dart';

class AboutUs extends StatelessWidget {
  static const String route = 'about-us';
  const AboutUs({super.key});

  static const Map<dynamic, dynamic> content = {
    'headline': 'Welcome to Number Crush!',
    1: 'Number Crush is a fun and addictive game that plays with numbers. '
        'Our game is suitable for both Android and iOS devices and is designed '
        'to be enjoyed by anyone who loves numbers and mathematical operations.',
    2: 'The goal of Number Crush is to solve as many math problems as you can '
        'while earning stars based on your performance. You\'ll receive stars '
        'for each level you complete, with a maximum of three stars available '
        'for each level. Your stars will depend on how quickly you solve the '
        'problems and how accurate your answers are. With unlimited stages and '
        'levels to play, you\'ll never run out of new challenges to keep you '
        'entertained and engaged.',
    3: 'Number Crush has unlimited stages and levels to play, so you will never '
        'run out of new challenges. We use seven types of mathematical operators '
        'throughout the game, including',
    'bullets': [
      'Addition',
      'Subtraction',
      'Multiplication',
      'Division',
      'Power of 2',
      'Square Root',
      'Logarithm Functions',
    ],
    4: 'This means that players will never get bored and can continue to '
        'learn and practice their math skills',
    5: 'Our game is suitable for anyone who knows about numbers and operators. '
        'Whether you\'re a math enthusiast looking for a fun way to practice '
        'your skills, a student looking for a way to improve your math grades, '
        'or just someone who enjoys a good puzzle game, Number Crush is perfect '
        'for you.',
    6: 'Number Crush was developed by a team of two undergraduate engineers - '
        'Sakuntha Hansaka and Thamindu Manodya. Sakuntha is a student at the '
        'Faculty of Engineering, University of Peradeniya, while Thamindu is a '
        'student at the Faculty of Engineering, University of Moratuwa. We are '
        'passionate about creating fun and educational games that challenge and '
        'engage users.',
    7: 'If you have any questions, comments, or suggestions, please do not '
        'hesitate to contact us. You can reach us at',
    'contact': [
      'Sakuntha Hansaka :\n    sakunthasugathadasa@gmail.com',
      'Thamindu Manodya :\n    thamindumanodya285@gmail.com',
      'MHDEVELOPER :\n    magichackers0101@gmail.com'
    ],
    8: 'We would love to hear from you!',
    9: 'Thank you for playing Number Crush.',
  };
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CommonAppBar(),
      backgroundColor: colorScheme.background,
      body: ListView(
        padding: EdgeInsets.all(width * 0.05),
        children: content
            .map(
              (key, value) {
                if (key == 'headline') {
                  return MapEntry(
                    key,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: FittedBox(
                        child: Text(
                          value,
                          style: textTheme.headlineSmall!.copyWith(
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (key == 'bullets' || key == 'contact') {
                  final List<String> bullets = value;
                  return MapEntry(
                    key,
                    Padding(
                      padding: EdgeInsets.only(
                        left: key == 'contact' ? 0.0 : width * 0.1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: bullets.map((e) {
                          return Text(
                            '\u2022  $e',
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
                return MapEntry(
                  key,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      value,
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                );
              },
            )
            .values
            .toList(),
      ),
    );
  }
}
