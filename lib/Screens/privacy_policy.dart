import 'package:flutter/material.dart';
import 'package:number_crush/Screens/Widgets/common_appbar.dart';

class PrivacyPolicy extends StatelessWidget {
  static const String route = 'privacy-policy';
  const PrivacyPolicy({super.key});

  static const Map<String, dynamic> content = {
    'heading': 'Privacy Policy for Number Crush',
    'description': 'This Privacy Policy governs the manner in which Number '
        'Crush, a mobile puzzle game application, collects, uses, maintains, '
        'and discloses information collected from users (each, a "User") '
        'of the app.',
    'headlines': [
      'Personal identification information',
      'Non-personal identification information',
      'How we use collected information',
      'Sharing your personal information',
      'Third-party services',
      'How we protect your information',
      'Children\'s Privacy',
      'Changes to this privacy policy',
      'Contacting us',
    ],
    'contents': [
      'We do not knowingly collect any personal identification '
          'information from children under the age of 13. If you are a parent or '
          'guardian and believe that your child has provided us with personal '
          'information, please contact us immediately at the email address listed '
          'below. We will delete the personal identification information of any '
          'child under the age of 13 as soon as possible.',
      'We do not collect any non-personal identification information from '
          'users of the app.',
      'We do not collect any personal identification or non-personal '
          'identification information from users of the app. Therefore, we '
          'do not use any collected information from users of the app.',
      'We do not collect any personal identification information from '
          'users of the app, and therefore we do not share any personal '
          'identification information with any third parties.',
      'We do not use any third-party services that may collect personal '
          'identification information from users of the app.',
      'We do not collect any personal identification information from '
          'users of the app, and therefore we do not have to protect any '
          'personal identification information.',
      'We do not knowingly collect personal identification information '
          'from children under the age of 13. However, our app can be used by '
          'anyone who knows mathematical operators and numbers, including '
          'children under the age of 13. We encourage parents and guardians '
          'to monitor their children\'s use of the app and to help us protect '
          'their children\'s privacy online.\n\n'
          'If you are a parent or guardian and believe that your child has '
          'provided us with personal information, please contact us immediately '
          'at the email address listed below. We will delete the personal '
          'identification information of any child under the age of 13 as '
          'soon as possible.',
      'We reserve the right to update this privacy policy at any time. '
          'We encourage Users to frequently check this page for any changes '
          'to stay informed about how we are protecting the privacy of users '
          'of the app.',
      'If you have any questions about this Privacy Policy, the practices '
          'of this app, or your dealings with this app, please contact us at:\n'
          '\nMHDEVELOPER\n'
          '\nSakuntha Hansaka - sakunthasugathadasa@gmail.com\n'
          '\nThamindu Manodya - thamindumanodya285@gmail.com\n'
          '\nCompany Mail - magichackers0101@gmail.com\n'
          '\nThis document was last updated on 16/03/2023.',
    ],
  };
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CommonAppBar(),
      backgroundColor: colorScheme.background,
      body: ListView.builder(
        padding: EdgeInsets.all(width * 0.05),
        itemCount: content['headlines'].length + content['contents'].length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Text(
                    content['heading'],
                    style: textTheme.headlineSmall,
                  ),
                ),
              ),
            );
          } else if (index == 1) {
            return Text(
              content['description'],
              style: textTheme.titleMedium!.copyWith(fontSize: 15.0),
            );
          }
          if (index % 2 == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Text(
                content['headlines'][((index - 2) / 2).round()],
                style: textTheme.titleMedium!.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return Text(
            content['contents'][((index - 3) / 2).round()],
            style: textTheme.titleMedium!.copyWith(
              fontSize: 14,
            ),
          );
        },
      ),
    );
  }
}
