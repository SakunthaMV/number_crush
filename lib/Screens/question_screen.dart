import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'Widgets/common_appbar.dart';

class QuestionScreen extends StatefulWidget {
  static const String route = 'question_screen';
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final List<bool?> dummy = [true, true, false, null];

  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)?.settings.arguments as QuestionScreenArguments;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CommonAppBar(
        stageNo: args.stage,
        level: args.level,
      ),
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          TweenAnimationBuilder(
            duration: const Duration(seconds: 25),
            tween: Tween(begin: 1.0, end: 0.0),
            builder: (context, time, _) {
              return LinearPercentIndicator(
                percent: time,
                lineHeight: 20.0,
                barRadius: const Radius.circular(10.0),
                padding: EdgeInsets.only(right: width * 0.05, left: 5.0),
                leading: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(7.0),
                  margin: EdgeInsets.only(
                    left: width * 0.05,
                    top: 15.0,
                    bottom: 15.0,
                  ),
                  child: Icon(
                    Icons.hourglass_bottom,
                    color: colorScheme.primary,
                    size: 25,
                  ),
                ),
                center: FittedBox(
                  child: Text(
                    (time * 25).toStringAsFixed(0),
                    style: textTheme.headlineLarge!.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                backgroundColor: colorScheme.primary,
                progressColor: colorScheme.onBackground,
              );
            },
          ),
          Container(
            color: colorScheme.primary,
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (index) {
                  return Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.onPrimary,
                        width: 1.5,
                      ),
                    ),
                    child: Builder(builder: (context) {
                      if (dummy[index] == null) {
                        return const SizedBox.shrink();
                      } else {
                        return Icon(
                          dummy[index]! ? Icons.done : Icons.close,
                          size: 15,
                          color: dummy[index]!
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.error,
                        );
                      }
                    }),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                questionPage(context, '7 + 2'),
                questionPage(context, '17 + 22'),
                questionPage(context, '47 x 2'),
                questionPage(context, '74 + 26'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget questionPage(BuildContext context, String question) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: width * 0.9,
          height: 200,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Center(
            child: FittedBox(
              child: Text(
                question,
                style: textTheme.headlineLarge!.copyWith(
                  fontSize: 80,
                  color: appBarTheme.backgroundColor,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Table(
            children: [
              TableRow(
                children: [
                  answerTile(context, 10),
                  answerTile(context, 12),
                ],
              ),
              TableRow(
                children: [
                  answerTile(context, 14),
                  answerTile(context, 23),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container answerTile(BuildContext context, int answer) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 100,
      margin: EdgeInsets.all(width * 0.025),
      child: BouncingWidget(
        onPressed: () {
          if (_currentIndex < 3) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            setState(() {
              _currentIndex++;
            });
          }
        },
        scaleFactor: 1.5,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 3.0,
          color: colorScheme.onBackground,
          child: Center(
            child: FittedBox(
              child: Text(
                '$answer',
                style: textTheme.headlineLarge!.copyWith(
                  fontSize: 40,
                  color: colorScheme.secondaryContainer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionScreenArguments {
  final int stage;
  final int level;
  QuestionScreenArguments(this.stage, this.level);
}
