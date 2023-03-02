import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_crush/Screens/Widgets/Stars/stars_row.dart';
import 'package:number_crush/Screens/settings.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? stageNo;
  final int? level;
  const CommonAppBar({super.key, this.stageNo = 5, this.level = 23});

  @override
  Widget build(BuildContext context) {
    final String? route = ModalRoute.of(context)?.settings.name;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    Color? backgroundColor = appBarTheme.backgroundColor;
    Widget title = const SizedBox.shrink();
    Brightness iconBrightness = Brightness.light;
    bool buttonSettings = false;
    bool buttonHome = false;
    bool buttonRefresh = false;
    switch (route) {
      case '/':
        buttonSettings = true;
        backgroundColor = Colors.transparent;
        iconBrightness = Brightness.dark;
        break;
      case 'settings':
        buttonHome = true;
        backgroundColor = Colors.transparent;
        iconBrightness = Brightness.dark;
        break;
      case 'stages':
        buttonHome = true;
        title = Text(
          'STAGES',
          style: textTheme.headlineLarge,
        );
        break;
      case 'stage-in':
        buttonHome = true;
        title = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'STAGE $stageNo',
              style: textTheme.headlineLarge,
            ),
            const StarsRow(
              amount: 10,
            ),
          ],
        );
        break;
      case 'question':
        buttonRefresh = true;
        title = Text(
          'LEVEL $level',
          style: textTheme.headlineLarge,
        );
        break;
      case 'reward':
        buttonHome = true;
        buttonRefresh = true;
        buttonRefresh = true;
        title = Text(
          'LEVEL $level',
          style: textTheme.headlineLarge,
        );
        break;
      case 'background':
        buttonHome = true;
        title = Text(
          'BACKGROUNDS',
          style: textTheme.headlineLarge,
        );
        break;
    }
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.0,
      toolbarHeight: 70,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: iconBrightness),
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
        ),
      ),
      title: title,
      actions: [
        if (buttonSettings) actionButton(context, Icons.settings),
        if (buttonHome) actionButton(context, Icons.home),
        if (buttonRefresh) actionButton(context, Icons.refresh),
      ],
    );
  }

  Container actionButton(BuildContext context, IconData icon) {
    return Container(
      width: 45,
      height: 45,
      margin: const EdgeInsets.only(right: 15.0),
      child: ElevatedButton(
        onPressed: () {
          if (icon == Icons.settings) {
            Navigator.pushNamed(context, Settings.route);
          } else if (icon == Icons.home) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        child: Icon(
          icon,
          size: 27,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
