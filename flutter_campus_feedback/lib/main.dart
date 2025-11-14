import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const CampusFeedbackApp());
}

class CampusFeedbackApp extends StatefulWidget {
  const CampusFeedbackApp({super.key});

  @override
  State<CampusFeedbackApp> createState() => _CampusFeedbackAppState();
}

class _CampusFeedbackAppState extends State<CampusFeedbackApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Feedback',
      theme: isDarkMode
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.blueAccent),
            ),
      debugShowCheckedModeBanner: false,
      home: HomePageWrapper(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
    );
  }
}

class HomePageWrapper extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomePageWrapper(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return HomePage(
      isDarkMode: isDarkMode,
      toggleTheme: toggleTheme,
    );
  }
}
