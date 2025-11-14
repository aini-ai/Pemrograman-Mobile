import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomePage from home_page.dart

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Dosen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 114, 155, 237),
          primary: const Color.fromARGB(255, 102, 174, 255),
          secondary: const Color.fromARGB(255, 91, 143, 247),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomePage(), // Use HomePage from home_page.dart
    );
  }
}