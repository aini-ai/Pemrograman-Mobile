import 'package:flutter/material.dart';
// 'foundation.dart' not required here
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'providers/theme_provider.dart'; // <-- FILE BARU
import 'screens/home_screen.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 LearnNotes App Starting...');

  try {
    await LocalStorageService.init();
    print('✅ App initialized successfully');
  } catch (e) {
    print('⚠️ Initialization warning: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // <-- TAMBAH INI
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'LearnNotes',
            theme: themeProvider.currentTheme, // <-- PAKAI THEME DARI PROVIDER
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
