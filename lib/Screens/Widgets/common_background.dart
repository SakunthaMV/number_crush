import 'package:flutter/material.dart';

import 'common_appbar.dart';

class CommonBackground extends StatelessWidget {
  final Widget content;
  final bool extend;
  const CommonBackground({
    super.key,
    this.content = const SizedBox.shrink(),
    this.extend = true,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: extend,
      appBar: const CommonAppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              color: colorScheme.onBackground,
              width: width * 0.2,
            ),
          ),
          content,
        ],
      ),
    );
  }
}
