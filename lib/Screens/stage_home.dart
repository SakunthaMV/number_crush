import 'package:flutter/material.dart';
import 'package:number_crush/Models/level.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/Widgets/common_appbar.dart';
import 'package:number_crush/Screens/question_screen.dart';
import 'package:number_crush/Services/database_functions.dart';
import 'package:number_crush/controllers/algorithm.dart';
import 'package:number_crush/controllers/vibration_controller.dart';

import '../controllers/audio_controller.dart';
import 'Widgets/Stars/star.dart';

class StageHome extends StatefulWidget {
  static const String route = 'stage-home';
  final StageHomeArguments args;
  const StageHome(this.args, {super.key});

  @override
  State<StageHome> createState() => _StageHomeState();
}

class _StageHomeState extends State<StageHome> {
  final ScrollController _controller = ScrollController();
  Future<List<Level>> _levelDetails(int stage) async {
    DatabaseFunctions db = DatabaseFunctions();
    return await db.getLevels(stage);
  }

  void _toItem(int item) {
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final double appBarHeight = AppBar().preferredSize.height;
    final int pos = ((item - 1) / 3).floor();
    final double height = _controller.position.maxScrollExtent +
        context.size!.height -
        appBarHeight -
        statusBarHeight;
    final double scrollValue = (pos / 17) * height;
    final double reduceValue = context.size!.height / 2 -
        appBarHeight -
        statusBarHeight -
        ((1 / 17) * height) / 2;
    final double value =
        scrollValue > reduceValue ? scrollValue - reduceValue : 0.0;
    final double newValue = value > _controller.position.maxScrollExtent
        ? _controller.position.maxScrollExtent
        : value;
    _controller.animateTo(
      newValue,
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.args.currantLevel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) {
          _toItem(widget.args.currantLevel!);
        } else {
          Future.delayed(const Duration(milliseconds: 400)).then((value) {
            _toItem(widget.args.currantLevel!);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as StageHomeArguments;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final double width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      backgroundColor: colorScheme.primary,
      color: colorScheme.secondary,
      displacement: 100.0,
      child: Scaffold(
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
          child: FutureBuilder(
              future: _levelDetails(args.stage),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                    ),
                  );
                }
                final List<Level> details = snapshot.data!;
                return GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: width * 0.05,
                  crossAxisSpacing: width * 0.05,
                  childAspectRatio: 0.75,
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  children: List.generate(50, (index) {
                    return InkWell(
                      highlightColor: Theme.of(context).splashColor,
                      splashColor: Theme.of(context).splashColor,
                      onTap: () async {
                        if (details.length >= index + 1) {
                          await AudioController().play('Normal_Buttons.mp3');
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(
                            context,
                            QuestionScreen.route,
                            arguments: QuestionScreenArguments(
                              args.stage,
                              (args.stage - 1) * 50 + (index + 1),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        } else {
                          VibrationController().vibrate(amplitude: 50);
                          final int unlockStars = Algorithm().toUnlockStar(
                              (args.stage - 1) * 50 + (index + 1));
                          final int totalStars =
                              await DatabaseFunctions().getStars();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: appBarTheme.backgroundColor,
                              content: Center(
                                child: Text(
                                  'You Need ${unlockStars - totalStars} More '
                                  'Stars to Unlock This Level',
                                ),
                              ),
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
                        child: tileContent(
                          context,
                          index,
                          details.length >= index + 1,
                          level: details.length >= index + 1
                              ? details[index]
                              : null,
                        ),
                      ),
                    );
                  }),
                );
              }),
        ),
      ),
    );
  }

  Widget tileContent(
    BuildContext context,
    int index,
    bool unlocked, {
    Level? level,
  }) {
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
                        color: level!.stars >= 1
                            ? colorScheme.tertiary
                            : colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Star(
                        size: 30,
                        borderSize: 5.0,
                        boderColor: colorScheme.outlineVariant,
                        color: level.stars >= 2
                            ? colorScheme.tertiary
                            : colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Star(
                        size: 20,
                        borderSize: 5.0,
                        boderColor: colorScheme.outlineVariant,
                        color: level.stars >= 3
                            ? colorScheme.tertiary
                            : colorScheme.primary,
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
                  child: Center(
                    child: StarsRow(
                      amount: Algorithm()
                          .toUnlockStar((args.stage - 1) * 50 + (index + 1)),
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
                horizontal: width * 0.015,
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (unlocked)
                    if (level!.times < 0.1)
                      const Icon(
                        Icons.lock_open,
                        size: 18,
                      )
                    else
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Icon(
                              Icons.timer_sharp,
                              size: 15,
                              color: colorScheme.onPrimary.withOpacity(0.2),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              level.times.toStringAsFixed(1),
                              style: textTheme.labelMedium!.copyWith(
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ],
                      )
                  else
                    const SizedBox.shrink(),
                  RichText(
                    text: TextSpan(
                      style: textTheme.labelMedium,
                      children: [
                        TextSpan(
                          text: '${level != null ? level.stars : 0}',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const TextSpan(text: '/3'),
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
  final int? currantLevel;
  StageHomeArguments(this.stage, {this.currantLevel});
}
