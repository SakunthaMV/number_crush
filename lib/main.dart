import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          background: Color(0xFFF1F2EB),
          onBackground: Color(0xFFD8DAD3),
        ),
        splashColor: Colors.transparent,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF4A4A48)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: const Color(0xFFA4C2A5),
            padding: const EdgeInsets.all(0.0),
            elevation: 1.0,
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.ubuntu(
            fontSize: 30.0,
            letterSpacing: 2,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.lato(
            color: const Color(0xFFA4C2A5),
          ),
        ),
        // colorScheme: const ColorScheme(
        //   brightness: Brightness.light,
        //   primary: Colors.white,
        //   onPrimary: Colors.black,
        //   secondary: Colors.transparent,
        //   onSecondary: Colors.transparent,
        //   error: Colors.red,
        //   onError: Colors.transparent,
        //   background: Color(0xFFF1F2EB),
        //   onBackground: Color(0xFFD8DAD3),
        //   surface: Colors.transparent,
        //   onSurface: Colors.transparent,
        // ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const Home(),
      },
    );
  }
}
