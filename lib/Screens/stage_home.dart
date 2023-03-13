import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/Widgets/common_appbar.dart';
import 'package:number_crush/Screens/question_screen.dart';

import 'Widgets/Stars/star.dart';

class StageHome extends StatelessWidget {
  static const String route = 'stage-home';
  const StageHome({super.key});

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as StageHomeArguments;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: colorScheme.background,
      appBar: CommonAppBar(
        stageNo: args.stage,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          width * 0.05,
          width * 0.05,
          width * 0.05,
          0.0,
        ),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: width * 0.05,
          crossAxisSpacing: width * 0.05,
          childAspectRatio: 0.75,
          physics: const BouncingScrollPhysics(),
          children: List.generate(50, (index) {
            const int unlockedCount = 7;
            return InkWell(
              highlightColor: Theme.of(context).splashColor,
              splashColor: Theme.of(context).splashColor,
              onTap: () {
                if (index + 1 <= unlockedCount) {
                  Navigator.pushNamed(context, QuestionScreen.route);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('You Need ${8 + 3} Stars to Unlock This Level'),
                    ),
                  );
                }
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: appBarTheme.backgroundColor!,
                    width: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: tileContent(context, index, index + 1 <= unlockedCount),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget tileContent(BuildContext context, int index, bool unlocked) {
    var args = ModalRoute.of(context)?.settings.arguments as StageHomeArguments;
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Column(
          children: [
            if (unlocked)
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Star(
                        size: 20,
                        borderSize: 5.0,
                        boderColor: colorScheme.outlineVariant,
                        // color: colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Star(
                        size: 30,
                        borderSize: 5.0,
                        boderColor: colorScheme.outlineVariant,
                        // color: colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Star(
                        size: 20,
                        borderSize: 5.0,
                        boderColor: colorScheme.outlineVariant,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: appBarTheme.backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: const Center(
                    child: StarsRow(
                      amount: 18,
                      size: 20,
                      starBoder: Colors.transparent,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: colorScheme.secondary,
                child: Container(
                  color: colorScheme.onBackground,
                  margin: const EdgeInsets.symmetric(vertical: 7.0),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        '${(args.stage - 1) * 50 + (index + 1)}',
                        style: textTheme.headlineSmall?.copyWith(
                          color: appBarTheme.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (unlocked)
                    const Icon(
                      Icons.lock_open,
                      size: 18,
                    )
                  else
                    const SizedBox.shrink(),
                  RichText(
                    text: TextSpan(
                      style: textTheme.labelMedium,
                      children: const [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(text: '/3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!unlocked)
          Container(
            decoration: BoxDecoration(
              color: appBarTheme.backgroundColor?.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        if (!unlocked)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appBarTheme.backgroundColor,
            ),
            padding: const EdgeInsets.all(6.0),
            margin: const EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Icon(
              Icons.lock,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
      ],
    );
  }
}

class StageHomeArguments {
  final int stage;
  final int ongoingProblem;
  StageHomeArguments(this.stage, this.ongoingProblem);
}
