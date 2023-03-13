import 'package:flutter/material.dart';

import 'Widgets/common_appbar.dart';

class QuestionScreen extends StatefulWidget {
  static const String route = 'question_screen';
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const CommonAppBar(),
      backgroundColor: colorScheme.background,
      body: SizedBox(),
    );
  }
}
