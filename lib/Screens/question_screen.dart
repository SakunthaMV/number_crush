import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:number_crush/Models/Question.dart';
import 'package:number_crush/Screens/reward.dart';
import 'package:number_crush/Screens/stage_home.dart';
import 'package:number_crush/Services/databaseFunctions.dart';
import 'package:number_crush/controllers/algorithm.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../controllers/audio_controller.dart';
import 'Widgets/common_appbar.dart';

class QuestionScreen extends StatefulWidget {
  static const String route = 'question_screen';
  final QuestionScreenArguments args;
  const QuestionScreen(this.args, {super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // ignore: prefer_final_fields
  List<bool?> _questionStatus = [null, null, null, null, null, null];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  double _totalTime = 0.0;
  late List<Question> _questions;
  final Stopwatch _stopwatch = Stopwatch();

  Future<List<Question>> _generatedQuestion() async {
    DatabaseFunctions db = DatabaseFunctions();
    final bool exist = await db.ifExist(widget.args.level);
    if (exist) {
      _questions = await db.getQuestions(widget.args.level);
    } else {
      _questions = Algorithm().questionList(widget.args.level);
      for (int i = 0; i < _questions.length; i++) {
        await db.storeQuestion(_questions[i]);
      }
    }
    if (_totalTime <= 0.1) {
      for (int i = 0; i < _questions.length; i++) {
        _totalTime += _questions[i].time;
      }
    }
    return _questions;
  }

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(
          context,
          ModalRoute.withName(StageHome.route),
        );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: CommonAppBar(
          stageNo: widget.args.stage,
          level: widget.args.level,
        ),
        backgroundColor: colorScheme.background,
        body: FutureBuilder(
          future: _generatedQuestion(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    color: colorScheme.onBackground,
                  ),
                ),
              );
            }
            _questions = snapshot.data!;
            return Column(
              children: [
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: (_totalTime * 1000).toInt()),
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
                          (time * _totalTime).toStringAsFixed(0),
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
                      children: List.generate(_questions.length, (index) {
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
                            if (_questionStatus[index] == null) {
                              return const SizedBox.shrink();
                            } else {
                              return Icon(
                                _questionStatus[index]!
                                    ? Icons.done
                                    : Icons.close,
                                size: 15,
                                color: _questionStatus[index]!
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
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: List.generate(_questions.length, (index) {
                      final List<int> answers = [
                        _questions[index].ans_1,
                        _questions[index].ans_2,
                        _questions[index].ans_3,
                        _questions[index].correctAns,
                      ];
                      return questionPage(
                        context,
                        _questions[index].operand_1,
                        _questions[index].operand_2,
                        _questions[index].operator,
                        answers,
                      );
                    }),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget questionPage(
    BuildContext context,
    int op1,
    int op2,
    String op,
    List<int> answers,
  ) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    answers.shuffle();
    String mathText = '';
    if (op == '+' || op == '-') {
      mathText = op1.toString() + op + op2.toString();
    } else if (op == '*') {
      mathText = op1.toString() + r'\times' + op2.toString();
    } else if (op == '/') {
      mathText = op1.toString() + r'\div' + op2.toString();
    } else if (op == 'squre') {
      mathText = op1.toString() + r'^2';
    } else if (op == 'squreRoot') {
      // ignore: prefer_interpolation_to_compose_strings
      mathText = r'\sqrt {' + op1.toString() + '}';
    } else if (op == 'log') {
      // ignore: prefer_interpolation_to_compose_strings
      mathText = r'\log_{' + op1.toString() + '}' + op2.toString();
    }
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
              child: Math.tex(
                mathText,
                textStyle: textTheme.headlineLarge!.copyWith(
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
                  answerTile(context, answers[0]),
                  answerTile(context, answers[1]),
                ],
              ),
              TableRow(
                children: [
                  answerTile(context, answers[2]),
                  answerTile(context, answers[3]),
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
        onPressed: () async {
          await AudioController().play('Answer_Buttons.mp3');
          if (answer == _questions[_currentIndex].correctAns) {
            _questionStatus[_currentIndex] = true;
          } else {
            _questionStatus[_currentIndex] = false;
          }
          if (_currentIndex < _questions.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            setState(() {
              _currentIndex++;
            });
          } else {
            _stopwatch.stop();
            _questionStatus.removeWhere((item) => item == null);
            List<bool> result = [];
            for (var element in _questionStatus) {
              result.add(element ?? true);
            }
            final double stars = await Algorithm().calculateStars(
              result,
              widget.args.level,
              _stopwatch.elapsedMilliseconds / 1000,
            );
            DatabaseFunctions db = DatabaseFunctions();
            final double previousStars =
                await db.getDoubleStar(widget.args.level);
            if (previousStars < stars) {
              await db.updateLevel(
                stars.floor(),
                widget.args.level,
                _stopwatch.elapsedMilliseconds / 1000,
                stars,
              );
            }
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(
              context,
              'reward',
              arguments: RewardArguments(
                widget.args.stage,
                widget.args.level,
                stars,
                previousStars,
                result,
              ),
            );
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
