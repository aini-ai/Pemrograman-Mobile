import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'theme.dart';

void main() {
  // Contoh: ubah warna sebelum run app
  AppTheme.setColors(
    primary: const Color.fromARGB(255, 37, 97, 255),
    background: const Color.fromARGB(255, 37, 97, 255),
    inputFill: Colors.white,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Update Form',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: const ProfilePage(),
    );
  }
}
