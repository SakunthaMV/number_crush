import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:number_crush/Screens/about_us.dart';
import 'package:number_crush/Screens/privacy_policy.dart';
import 'package:number_crush/Services/database_functions.dart';
import 'package:number_crush/controllers/vibration_controller.dart';
import 'package:share_plus/share_plus.dart';

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
        child: SingleChildScrollView(
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
                  return settingsRow(context, Icons.done, 'Sound',
                      _soundStatus ? 'On' : 'Off');
                },
              ),
              settingsRow(context, Icons.star, 'Rate Us', 'Your Experience'),
              settingsRow(context, Icons.share, 'Share', 'With Friends'),
              settingsRow(
                context,
                Icons.policy_outlined,
                'Privacy Policy',
                'About Your Privacy',
              ),
              settingsRow(
                context,
                Icons.question_mark,
                'About Us',
                'Application Info',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsRow(
    BuildContext context,
    IconData icon,
    String topic,
    String subTopic,
  ) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
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
                const String url = 'https://play.google.com/store/apps/'
                    'details?id=com.mhdeveloper.number_crush';
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
                } else if (topic == 'Rate Us') {
                  final int level = await db.lastUnlockLevel();
                  if (level <= 50) {
                    final InAppReview inAppReview = InAppReview.instance;
                    final SnackBar show = SnackBar(
                      backgroundColor: appBarTheme.backgroundColor,
                      content: const Center(
                        child: Text(
                          'In app review not available at the moment. You '
                          'can come later or rate us using Google Play '
                          'Store page.',
                        ),
                      ),
                    );
                    if (await inAppReview.isAvailable()) {
                      await inAppReview.requestReview().catchError((error) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          show,
                        );
                      });
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        show,
                      );
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: appBarTheme.backgroundColor,
                        content: const Center(
                          child: Text(
                            'You must be at least 50th level to rate this game.',
                          ),
                        ),
                      ),
                    );
                  }
                } else if (topic == 'Share') {
                  const String massage = 'Hey there! If you love math and '
                      'solving number puzzles, check out Number Crush. It\'s '
                      'an addictive and fun game that challenges your skills '
                      'and rewards your performance. Download now and start '
                      'crushing those numbers! \n\n $url';
                  await Share.share(massage);
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
