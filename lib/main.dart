import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_crush/Screens/about_us.dart';
import 'package:number_crush/Screens/open_splash.dart';
import 'package:number_crush/Screens/privacy_policy.dart';
import 'package:number_crush/Screens/question_screen.dart';
import 'package:number_crush/Screens/reward.dart';
import 'package:number_crush/Screens/settings.dart';
import 'package:number_crush/Screens/stage_home.dart';
import 'package:number_crush/Screens/stages.dart';

import 'Screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Crush',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
          primaryContainer: Color(0xFFA8BDF4),
          onPrimaryContainer: Colors.green,
          error: Colors.red,
          background: Color(0xFFF6F7FC),
          onBackground: Color(0xFFC9D6FB),
          outline: Color(0xFF1F3C88),
          outlineVariant: Color(0xFFB3B334),
          secondary: Color(0xFF324D94),
          onSecondary: Color(0xFF041D63),
          secondaryContainer: Color(0xFF8A2626),
          onSecondaryContainer: Color(0xFF488BDF),
          tertiary: Color(0xFFFFFF00),
        ),
        splashColor: Colors.transparent,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF112049)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: const Color(0xFF324D94),
            padding: const EdgeInsets.all(0.0),
            elevation: 1.0,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.robotoMono(
            fontSize: 150.0,
          ),
          displayMedium: const TextStyle(
            fontFamily: 'Pony Maker',
            fontSize: 100,
          ),
          displaySmall: const TextStyle(fontFamily: 'Snack', fontSize: 60),
          headlineLarge: GoogleFonts.ubuntu(
            fontSize: 30.0,
            letterSpacing: 2,
            color: Colors.white,
          ),
          headlineSmall: GoogleFonts.openSans(fontWeight: FontWeight.w600),
          titleLarge: GoogleFonts.lato(color: const Color(0xFF324D94)),
          titleMedium: GoogleFonts.roboto(fontWeight: FontWeight.w400),
          labelMedium: GoogleFonts.encodeSans(
            color: const Color(0xFF1F3C88),
            fontSize: 13,
            letterSpacing: 1.5,
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == QuestionScreen.route) {
          final args = settings.arguments as QuestionScreenArguments;
          return MaterialPageRoute(
            builder: (_) => QuestionScreen(args),
            settings: settings,
          );
        } else if (settings.name == Reward.route) {
          final args = settings.arguments as RewardArguments;
          return MaterialPageRoute(
            builder: (_) => Reward(args),
            settings: settings,
          );
        } else if (settings.name == StageHome.route) {
          final args = settings.arguments as StageHomeArguments;
          return MaterialPageRoute(
            builder: (_) => StageHome(args),
            settings: settings,
          );
        }
        return null;
      },
      initialRoute: OpenSplash.route,
      routes: {
        "/": (context) => const Home(),
        Settings.route: (context) => const Settings(),
        Stages.route: (context) => const Stages(),
        OpenSplash.route: (context) => const OpenSplash(),
        AboutUs.route: (context) => const AboutUs(),
        PrivacyPolicy.route: (context) => const PrivacyPolicy(),
      },
    );
  }
}
