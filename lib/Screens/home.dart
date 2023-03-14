import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/common_background.dart';
import 'package:number_crush/Screens/stage_home.dart';
import 'package:number_crush/Screens/stages.dart';
import 'package:number_crush/Services/databaseFunctions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Future<int> _currnetLevel() async {
    DatabaseFunctions db = DatabaseFunctions();
    return await db.lastUnlockLevel();
  }

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CommonBackground(
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        child: FutureBuilder(
          future: _currnetLevel(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final int level = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
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
                  'Currunt Level: $level',
                ),
              ],
            );
          },
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
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return Container(
                  width: width * 0.2,
                  height: width * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: _animation.value,
                        spreadRadius: _animation.value,
                        color: colorScheme.secondary.withOpacity(0.25),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
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
                );
              },
            )
          else
            SizedBox(
              width: width * 0.2,
              height: width * 0.2,
              child: ElevatedButton(
                onPressed: () {
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
      Navigator.pushNamed(context, Stages.route);
    } else if (topic == 'PLAY') {
      DatabaseFunctions db = DatabaseFunctions();
      final int curruntLevel = await db.lastUnlockLevel();
      final int stage = (curruntLevel / 50).ceil();
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        StageHome.route,
        arguments: StageHomeArguments(
          stage,
          curruntLevel: curruntLevel % 50,
        ),
      );
    }
  }
}
