import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/Widgets/common_background.dart';
import 'package:number_crush/Screens/stage_home.dart';

class Stages extends StatelessWidget {
  static const String route = 'stages';
  const Stages({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CommonBackground(
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.1,
          vertical: width * 0.025,
        ),
        child: ListView.builder(
          itemCount: 50,
          itemBuilder: (context, index) {
            return _stageContainer(context, index);
          },
        ),
      ),
    );
  }

  Container _stageContainer(BuildContext context, int index, {int stars = 5}) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool locked = index == 4;
    return Container(
      height: 250,
      margin: EdgeInsets.symmetric(vertical: width * 0.03),
      child: InkWell(
        onTap: () {
          if (locked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: appBarTheme.backgroundColor,
                content: const Center(
                  child: Text('You Need ${135} Stars to Unlock This Stage'),
                ),
              ),
            );
          } else {
            Navigator.pushNamed(
              context,
              StageHome.route,
              arguments: StageHomeArguments(index + 1, 17),
            );
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
                          amount: stars,
                        ),
                        const SizedBox.shrink(),
                        StarsRow(
                          size: 30,
                          color: colorScheme.outline,
                          starBoder: colorScheme.primary,
                          borderSize: 5.0,
                          amount: 150 - stars,
                        ),
                      ],
                    )
                  else
                    StarsRow(
                      size: 30,
                      color: colorScheme.outline,
                      starBoder: colorScheme.tertiary,
                      borderSize: 5.0,
                      amount: 135,
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
                          amount: stars,
                        ),
                        const SizedBox.shrink(),
                        StarsRow(
                          size: 30,
                          color: colorScheme.outline,
                          starBoder: colorScheme.primary,
                          borderSize: 5.0,
                          amount: 150 - stars,
                        ),
                      ],
                    )
                  else
                    StarsRow(
                      size: 30,
                      color: colorScheme.outline,
                      starBoder: colorScheme.tertiary,
                      borderSize: 5.0,
                      amount: 135,
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
