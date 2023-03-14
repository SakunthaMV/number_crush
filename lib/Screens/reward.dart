import 'package:flutter/material.dart';
import 'package:number_crush/Models/Level.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/Widgets/common_appbar.dart';
import 'package:number_crush/Services/databaseFunctions.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'Widgets/Stars/star.dart';

class Reward extends StatelessWidget {
  static const String route = 'reward';
  final RewardArguments args;
  const Reward(this.args, {super.key});

  Future<double> _data() async {
    DatabaseFunctions db = DatabaseFunctions();
    return await db.getDoubleStar(args.level);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CommonAppBar(
        stageNo: args.stage,
        level: args.level,
      ),
      backgroundColor: colorScheme.primary,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: _detailColumn(context),
          ),
        ],
      ),
    );
  }

  Column _detailColumn(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          'COMPLETED !!!',
          style: textTheme.headlineLarge!.copyWith(
            fontSize: 35.0,
            color: colorScheme.secondaryContainer,
            letterSpacing: 0.4,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 0.5),
              ),
            ],
          ),
        ),
        Container(
          color: colorScheme.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  StarsRow(
                    textColor: colorScheme.secondary,
                    size: 27,
                    starBoder: colorScheme.outlineVariant,
                    amount: 18,
                  ),
                  Text(
                    '+${2}',
                    style: textTheme.displayLarge!.copyWith(
                      fontSize: 27,
                      letterSpacing: -1,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  style: textTheme.headlineSmall!.copyWith(
                    fontSize: 20,
                    color: colorScheme.secondary,
                  ),
                  children: [
                    TextSpan(
                      text: '1.75',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                    ),
                    const TextSpan(text: '/3'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            LinearPercentIndicator(
              percent: 0.5,
              lineHeight: 12.0,
              barRadius: const Radius.circular(6.0),
              padding: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
              backgroundColor: colorScheme.onBackground,
              progressColor: appBarTheme.backgroundColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Opacity(
                    opacity: 0.0,
                    child: Star(
                      size: 20,
                    ),
                  ),
                  Star(
                    boderColor: colorScheme.outlineVariant,
                    size: 30,
                  ),
                  Star(
                    boderColor: colorScheme.outlineVariant,
                    size: 20,
                  ),
                  Star(
                    boderColor: colorScheme.outlineVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: _data(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            print(snapshot.data);
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Text('done'),
              ],
            );
          },
        ),
      ],
    );
  }
}

class RewardArguments {
  final int stage;
  final int level;
  RewardArguments(this.stage, this.level);
}
