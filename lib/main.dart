import 'package:flutter/material.dart';
import './homepage/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
          primaryColorDark: Colors.purple,
        ),
        textTheme: GoogleFonts.firaCodeTextTheme(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: Colors.black54,
          elevation: 20.0,
        ),
      ),
      title: 'Flutter Midi Demo',
      home: Homepage(),
    );
  }
}
