import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_crush/Screens/question_screen.dart';
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
          error: Colors.red,
          background: Color(0xFFF6F7FC),
          onBackground: Color(0xFFC9D6FB),
          outline: Color(0xFF1F3C88),
          outlineVariant: Color(0xFFB3B334),
          secondary: Color(0xFF324D94),
          onSecondary: Color(0xFF041D63),
          primaryContainer: Color(0xFFA8BDF4),
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
      initialRoute: "/",
      routes: {
        "/": (context) => const Home(),
        Settings.route: (context) => const Settings(),
        Stages.route: (context) => const Stages(),
        StageHome.route: (context) => const StageHome(),
        QuestionScreen.route: (context) => const QuestionScreen(),
      },
    );
  }
}
