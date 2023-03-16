import 'package:flutter/material.dart';
import 'package:number_crush/Screens/about_us.dart';
import 'package:number_crush/Screens/privacy_policy.dart';
import 'package:number_crush/Services/database_functions.dart';
import 'package:number_crush/controllers/vibration_controller.dart';

import 'Widgets/common_background.dart';

class Settings extends StatefulWidget {
  static const String route = 'settings';
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _soundStatus;
  late bool _vibrationStatus;

  Future<bool> _vibration() async {
    final DatabaseFunctions db = DatabaseFunctions();
    return await db.getSettingStatus('vibration');
  }

  Future<bool> _sound() async {
    final DatabaseFunctions db = DatabaseFunctions();
    return await db.getSettingStatus('sound');
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CommonBackground(
      content: Padding(
        padding: EdgeInsets.only(left: width * 0.2 + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: _vibration(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                _vibrationStatus = snapshot.data!;
                return settingsRow(context, Icons.done, 'Vibration',
                    _vibrationStatus ? 'On' : 'Off');
              },
            ),
            FutureBuilder(
              future: _sound(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                _soundStatus = snapshot.data!;
                return settingsRow(
                    context, Icons.done, 'Sound', _soundStatus ? 'On' : 'Off');
              },
            ),
            settingsRow(context, Icons.star, 'Rate Us', 'Your Experience'),
            settingsRow(
              context,
              Icons.question_mark,
              'About Us',
              'Application Info',
            ),
            settingsRow(
              context,
              Icons.policy_outlined,
              'Privacy Policy',
              'About Your Privacy',
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsRow(
      BuildContext context, IconData icon, String topic, String subTopic) {
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
              onPressed: () async {
                final DatabaseFunctions db = DatabaseFunctions();
                if (topic == 'Vibration') {
                  setState(() {
                    _vibrationStatus = !_vibrationStatus;
                  });
                  db.setSettingStatus('vibration', _vibrationStatus);
                  VibrationController().vibrate();
                } else if (topic == 'Sound') {
                  setState(() {
                    _soundStatus = !_soundStatus;
                  });
                  db.setSettingStatus('sound', _soundStatus);
                } else if (topic == 'About Us') {
                  Navigator.pushNamed(context, AboutUs.route);
                } else if (topic == 'Privacy Policy') {
                  Navigator.pushNamed(context, PrivacyPolicy.route);
                }
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
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 25.0),
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
