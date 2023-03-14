import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/Widgets/common_appbar.dart';
import 'package:number_crush/Screens/question_screen.dart';
import 'package:number_crush/Screens/stage_home.dart';
import 'package:number_crush/Services/databaseFunctions.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'Widgets/Stars/star.dart';

class Reward extends StatefulWidget {
  static const String route = 'reward';
  final RewardArguments args;
  const Reward(this.args, {super.key});

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> with TickerProviderStateMixin {
  Future<int> _stars() async {
    DatabaseFunctions db = DatabaseFunctions();
    return await db.getStars();
  }

  late Animation<double> _firstStarAnim;
  late AnimationController _firstStarController;
  late Animation<double> _secondStarAnim;
  late AnimationController _secondStarController;
  late Animation<double> _thirdStarAnim;
  late AnimationController _thirdStarController;
  final ConfettiController _finalAnimationController = ConfettiController();

  @override
  void initState() {
    super.initState();
    _firstStarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _firstStarAnim = Tween(begin: 20 / 30, end: 1.0).animate(
      CurvedAnimation(
        parent: _firstStarController,
        curve: Curves.elasticOut,
      ),
    );
    _secondStarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _secondStarAnim = Tween(begin: 20 / 30, end: 1.0).animate(
      CurvedAnimation(
        parent: _secondStarController,
        curve: Curves.elasticOut,
      ),
    );
    _thirdStarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _thirdStarAnim = Tween(begin: 20 / 30, end: 1.0).animate(
      CurvedAnimation(
        parent: _thirdStarController,
        curve: Curves.elasticOut,
      ),
    );
    _finalAnimationController.play();
  }

  @override
  void dispose() {
    super.dispose();
    _firstStarController.dispose();
    _secondStarController.dispose();
    _thirdStarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
        backgroundColor: colorScheme.primary,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: const Alignment(0, 1),
              child: Image.asset('images/Reward_Back.jpg'),
            ),
            ConfettiWidget(
              confettiController: _finalAnimationController,
              shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: -pi / 2,
              numberOfParticles: 120,
              createParticlePath: (size) {
                final Path path = Path();
                path.addRRect(RRect.fromLTRBAndCorners(0, 0, 4, 6));
                return path;
              },
            ),
            Center(
              child: _detailColumn(context),
            ),
          ],
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
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
        ),
        FutureBuilder(
          future: _stars(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final int totalStars = snapshot.data!;
            final int previousStars = widget.args.previousStars.floor();
            final int curruntStars = widget.args.stars.floor();
            return Container(
              color: colorScheme.background,
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Builder(builder: (context) {
                    int total;
                    int increment;
                    if (previousStars < curruntStars) {
                      total = totalStars - (curruntStars - previousStars);
                      increment = curruntStars - previousStars;
                    } else {
                      total = totalStars;
                      increment = 0;
                    }
                    return Row(
                      children: [
                        StarsRow(
                          textColor: colorScheme.secondary,
                          size: 27,
                          starBoder: colorScheme.outlineVariant,
                          amount: total,
                        ),
                        Text(
                          '+$increment',
                          style: textTheme.displayLarge!.copyWith(
                            fontSize: 27,
                            letterSpacing: -1,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ],
                    );
                  }),
                  TweenAnimationBuilder(
                    duration: const Duration(seconds: 4),
                    tween: Tween(
                      begin: 0.0,
                      end: widget.args.stars > 3 ? 3.0 : widget.args.stars,
                    ),
                    builder: (context, progress, _) {
                      return RichText(
                        text: TextSpan(
                          style: textTheme.headlineSmall!.copyWith(
                            fontSize: 20,
                            color: colorScheme.secondary,
                          ),
                          children: [
                            TextSpan(
                              text: progress.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                              ),
                            ),
                            const TextSpan(text: '/3'),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        Container(
          color: colorScheme.primary,
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          margin: const EdgeInsets.only(top: 15.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.args.result.length, (index) {
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
                  child: Icon(
                    widget.args.result[index] ? Icons.done : Icons.close,
                    size: 15,
                    color: widget.args.result[index]
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.error,
                  ),
                );
              }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: TweenAnimationBuilder(
            duration: const Duration(seconds: 4),
            tween: Tween(
              begin: 0.0,
              end: (1 / 3) * (widget.args.stars > 3 ? 3.0 : widget.args.stars),
            ),
            curve:
                widget.args.stars < 3.15 ? Curves.easeOut : Curves.easeOutExpo,
            builder: (context, progress, _) {
              if (progress > 1 / 3) {
                _firstStarController.forward();
              }
              if (progress > 2 / 3) {
                _secondStarController.forward();
              }
              if (progress > 0.999) {
                _thirdStarController.forward();
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  LinearPercentIndicator(
                    percent: progress,
                    lineHeight: 12.0,
                    barRadius: const Radius.circular(6.0),
                    padding: EdgeInsets.only(
                      right: width * 0.05,
                      left: width * 0.05,
                    ),
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
                        ScaleTransition(
                          scale: _firstStarAnim,
                          child: Star(
                            boderColor: colorScheme.outlineVariant,
                            size: 30,
                          ),
                        ),
                        ScaleTransition(
                          scale: _secondStarAnim,
                          child: Star(
                            boderColor: colorScheme.outlineVariant,
                            size: 30,
                          ),
                        ),
                        ScaleTransition(
                          scale: _thirdStarAnim,
                          child: Star(
                            boderColor: colorScheme.outlineVariant,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          width: 130,
          height: 45,
          margin: const EdgeInsets.only(top: 5.0),
          child: ElevatedButton(
            onPressed: () async {
              DatabaseFunctions db = DatabaseFunctions();
              final bool unlocked = await db.isUnlock(widget.args.level + 1);
              if (unlocked) {
                if (widget.args.level % 50 != 0) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(
                    context,
                    QuestionScreen.route,
                    arguments: QuestionScreenArguments(
                      widget.args.stage,
                      widget.args.level + 1,
                    ),
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(StageHome.route),
                  );
                }
              } else {
                // ignore: use_build_context_synchronously
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(StageHome.route),
                );
              }
            },
            child: Text(
              'NEXT',
              style: textTheme.headlineLarge!.copyWith(
                fontSize: 24,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RewardArguments {
  final int stage;
  final int level;
  final double stars;
  final double previousStars;
  final List<bool> result;
  RewardArguments(
    this.stage,
    this.level,
    this.stars,
    this.previousStars,
    this.result,
  );
}
