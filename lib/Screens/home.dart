import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/common_background.dart';
import 'package:number_crush/Screens/stages.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    const int level = 1;
    const String backgroundStyle = 'Classic';
    return CommonBackground(
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        child: Column(
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
            homeRow(
              context,
              Icons.wallpaper,
              'BACKGROUNDS',
              'Currunt: $backgroundStyle',
            )
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
          SizedBox(
            width: width * 0.2,
            height: width * 0.2,
            child: ElevatedButton(
              onPressed: () {
                if (topic == 'STAGES') {
                  Navigator.pushNamed(context, Stages.route);
                }
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
                if (topic == 'STAGES') {
                  Navigator.pushNamed(context, Stages.route);
                }
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
}
