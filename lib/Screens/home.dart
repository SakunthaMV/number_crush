import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_crush/Screens/Widgets/common_background.dart';
import 'package:number_crush/Screens/settings.dart';
import 'package:number_crush/Screens/stage_home.dart';
import 'package:number_crush/Screens/stages.dart';
import 'package:number_crush/Services/database_functions.dart';
import 'package:number_crush/controllers/audio_controller.dart';
import 'package:number_crush/controllers/vibration_controller.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Future<int> _currentLevel() async {
    DatabaseFunctions db = DatabaseFunctions();
    return await db.lastUnlockLevel();
  }

  late Animation<double> _animation;
  late AnimationController _animationController;
  final MaterialStatesController _buttonController = MaterialStatesController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _buttonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: CommonBackground(
        content: Column(
          children: [
            Center(
              child: Container(
                width: width * 0.5,
                margin: EdgeInsets.only(left: width * 0.2, top: height * 0.1),
                child: Shimmer.fromColors(
                  period: const Duration(milliseconds: 3000),
                  baseColor: colorScheme.secondary,
                  highlightColor: colorScheme.background,
                  child: FittedBox(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.cinzel(
                          fontSize: 50,
                          letterSpacing: 0.4,
                          height: 1,
                          color: colorScheme.onPrimary,
                        ),
                        children: [
                          const TextSpan(
                            text: 'NUMBER',
                          ),
                          TextSpan(
                            text: '\nCRUSH',
                            style: TextStyle(
                              fontSize: 80,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1, vertical: height * 0.15),
              child: FutureBuilder(
                future: _currentLevel(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final int level = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      homeRow(
                        context,
                        Icons.play_arrow,
                        'PLAY',
                        '${level < 2 ? 'Start' : 'Continue'} Your Journey',
                      ),
                      homeRow(
                        context,
                        Icons.event,
                        'STAGES',
                        'Currant Level: $level',
                      ),
                      homeRow(
                        context,
                        Icons.settings,
                        'SETTINGS',
                        'Change Your Preference',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget homeRow(
    BuildContext context,
    IconData icon,
    String topic,
    String subTopic,
  ) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          if (topic == 'PLAY')
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width * 0.2,
                  height: width * 0.2,
                  child: ElevatedButton(
                    onPressed: () {},
                    statesController: _buttonController,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                    ),
                    child: Icon(
                      icon,
                      size: 40,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    return Transform.rotate(
                      angle: -_animation.value,
                      child: CustomPaint(
                        painter: CometAnimate(),
                        size: Size(width * 0.2, width * 0.2),
                      ),
                    );
                  },
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    _buttonController.update(MaterialState.pressed, true);
                    _commonPress(context, topic);
                    await Future.delayed(const Duration(milliseconds: 200));
                    _buttonController.update(MaterialState.pressed, false);
                  },
                  child: Container(
                    width: width * 0.2,
                    height: width * 0.2,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: width * 0.2,
              height: width * 0.2,
              child: ElevatedButton(
                onPressed: () async {
                  _commonPress(context, topic);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                ),
                child: Icon(
                  icon,
                  size: 40,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.05),
            child: InkWell(
              splashColor: Theme.of(context).splashColor,
              highlightColor: Theme.of(context).splashColor,
              onTap: () {
                _commonPress(context, topic);
              },
              child: FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      subTopic,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _commonPress(BuildContext context, String topic) async {
    if (topic == 'STAGES') {
      Navigator.pushNamed(context, Stages.route).then((value) {
        setState(() {});
      });
      await AudioController().play('Normal_Buttons.mp3');
    } else if (topic == 'PLAY') {
      DatabaseFunctions db = DatabaseFunctions();
      final int currantLevel = await db.lastUnlockLevel();
      final int stage = (currantLevel / 50).ceil();
      await AudioController().play('Play_Button.mp3');
      VibrationController().vibrate(amplitude: 70);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        StageHome.route,
        arguments: StageHomeArguments(
          stage,
          currantLevel: currantLevel % 50,
        ),
      ).then((value) {
        setState(() {});
      });
    } else if (topic == 'SETTINGS') {
      Navigator.pushNamed(context, Settings.route);
      await AudioController().play('Normal_Buttons.mp3');
    }
  }
}

class CometAnimate extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint border = Paint();
    border.style = PaintingStyle.stroke;
    border.strokeWidth = 2.0;
    border.shader = SweepGradient(
      colors: [
        const Color(0xFFA8BDF4),
        const Color(0xFFA8BDF4).withAlpha(0),
      ],
      stops: const [0.0, 0.45],
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.drawCircle(size.center(const Offset(0, 0)), size.width / 2, border);

    Paint dot = Paint();
    dot.style = PaintingStyle.fill;
    dot.color = const Color(0xFFA8BDF4);
    canvas.drawCircle(size.centerRight(const Offset(0, 0)), 2.5, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
