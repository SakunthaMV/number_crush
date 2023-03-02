import 'package:flutter/material.dart';

import 'Widgets/common_background.dart';


class Settings extends StatefulWidget {
  static String route = 'settings';
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _vibrationStatus;
  late bool _soundStatus;

  @override
  void initState() {
    super.initState();
    _vibrationStatus = true;
    _soundStatus = false;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CommonBackground(
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.2 + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            settingsRow(context, Icons.done, 'Vibration', _vibrationStatus ? 'On' : 'Off'),
            settingsRow(context, Icons.done, 'Sound', _soundStatus ? 'On' : 'Off'),
            settingsRow(context, Icons.star, 'Rate Us', 'Your Experience'),
            settingsRow(context, Icons.question_mark, 'About Us', 'Application Info'),
          ],
        ),
      ),
    );
  }

  Widget settingsRow(BuildContext context, IconData icon, String topic, String subTopic) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color? backgroundColor;
    IconData changeIcon = icon;
    switch (topic) {
      case 'Vibration':
        if (_vibrationStatus) {
          backgroundColor = colorScheme.secondary;
          changeIcon = Icons.done;
        } else {
          backgroundColor = colorScheme.error;
          changeIcon = Icons.close;
        }
        break;
      case 'Sound':
        if (_soundStatus) {
          backgroundColor = colorScheme.secondary;
          changeIcon = Icons.done;
        } else {
          backgroundColor = colorScheme.error;
          changeIcon = Icons.close;
        }
        break;
      default:
        backgroundColor = colorScheme.secondary;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (topic == 'Vibration') {
                    _vibrationStatus = !_vibrationStatus;
                  } else if (topic == 'Sound') {
                    _soundStatus = !_soundStatus;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
              ),
              child: Icon(
                changeIcon,
                size: 35,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.05),
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 25.0),
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
        ],
      ),
    );
  }
}
