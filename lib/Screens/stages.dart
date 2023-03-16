import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/Widgets/common_background.dart';
import 'package:number_crush/Screens/stage_home.dart';
import 'package:number_crush/Services/database_functions.dart';
import 'package:number_crush/controllers/vibration_controller.dart';

import '../Models/stage.dart';
import '../controllers/audio_controller.dart';

class Stages extends StatefulWidget {
  static const String route = 'stages';
  const Stages({super.key});

  @override
  State<Stages> createState() => _StagesState();
}

class _StagesState extends State<Stages> {
  Future<List<Stage>> _details() async {
    DatabaseFunctions db = DatabaseFunctions();
    return await db.getStages();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CommonBackground(
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.1,
          vertical: width * 0.025,
        ),
        child: FutureBuilder(
          future: _details(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            final List<Stage> fullDetails = snapshot.data!;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _stageContainer(context, index, fullDetails);
              },
            );
          },
        ),
      ),
    );
  }

  Container _stageContainer(
    BuildContext context,
    int index,
    List<Stage> details,
  ) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool locked = index == details.length - 1;
    return Container(
      height: 250,
      margin: EdgeInsets.symmetric(vertical: width * 0.03),
      child: InkWell(
        onTap: () async {
          if (locked) {
            VibrationController().vibrate(amplitude: 50);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: appBarTheme.backgroundColor,
                content: Center(
                  child: Text(
                      'You Need ${details[index].forUnlock} More Stars to Unlock This Stage'),
                ),
              ),
            );
          } else {
            await AudioController().play('Normal_Buttons.mp3');
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(
              context,
              StageHome.route,
              arguments: StageHomeArguments(index + 1),
            ).then((value) {
              setState(() {});
            });
          }
        },
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).splashColor,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: colorScheme.onSecondaryContainer,
          elevation: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'STAGE',
                    style: textTheme.displaySmall!.copyWith(
                      color: colorScheme.primary,
                      height: 0.8,
                    ),
                  ),
                  if (!locked)
                    Text(
                      '${index + 1}',
                      style: textTheme.displayMedium!.copyWith(
                        color: colorScheme.primary,
                        height: 0.7,
                      ),
                    )
                  else
                    Icon(
                      Icons.lock,
                      size: 90,
                      color: colorScheme.primary,
                    ),
                  if (!locked)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StarsRow(
                          size: 30,
                          starBoder: colorScheme.tertiary,
                          borderSize: 5.0,
                          amount: details[index].stars,
                        ),
                        const SizedBox.shrink(),
                        StarsRow(
                          size: 30,
                          color: colorScheme.outline,
                          starBoder: colorScheme.primary,
                          borderSize: 5.0,
                          amount: 150 - details[index].stars,
                        ),
                      ],
                    )
                  else
                    StarsRow(
                      size: 30,
                      color: colorScheme.outline,
                      starBoder: colorScheme.tertiary,
                      borderSize: 5.0,
                      amount: details[index].forUnlock,
                    ),
                ],
              ),
              if (locked)
                Container(
                  decoration: BoxDecoration(
                    color: appBarTheme.backgroundColor!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Opacity(
                    opacity: 0.0,
                    child: Text(
                      'STAGE',
                      style: textTheme.displaySmall!.copyWith(
                        color: colorScheme.primary,
                        height: 0.8,
                      ),
                    ),
                  ),
                  if (!locked)
                    Text(
                      '${index + 1}',
                      style: textTheme.displayMedium!.copyWith(
                        color: colorScheme.primary,
                        height: 0.7,
                      ),
                    )
                  else
                    Icon(
                      Icons.lock,
                      size: 90,
                      color: colorScheme.primary,
                    ),
                  if (!locked)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StarsRow(
                          size: 30,
                          starBoder: colorScheme.tertiary,
                          borderSize: 5.0,
                          amount: details[index].stars,
                        ),
                        const SizedBox.shrink(),
                        StarsRow(
                          size: 30,
                          color: colorScheme.outline,
                          starBoder: colorScheme.primary,
                          borderSize: 5.0,
                          amount: 150 - details[index].stars,
                        ),
                      ],
                    )
                  else
                    StarsRow(
                      size: 30,
                      color: colorScheme.outline,
                      starBoder: colorScheme.tertiary,
                      borderSize: 5.0,
                      amount: details[index].forUnlock,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
