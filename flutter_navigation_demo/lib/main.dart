import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo - Blue Theme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 110, 255),
        colorScheme: const ColorScheme.light(
          primary: const Color.fromARGB(255, 0, 110, 255),
          secondary:Color.fromARGB(255, 163, 203, 255),
          background:  Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:const Color.fromARGB(255, 0, 110, 255),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor:const Color.fromARGB(255, 0, 110, 255),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}