import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'My Blue Todo';
  static const String storageKey = 'todos';
  
  // Filter types
  static const String filterAll = 'all';
  static const String filterDone = 'done';
  static const String filterNotDone = 'notyet';
  
  // Messages
  static const String emptyTodoMessage = 'Yay! Tidak ada tugas~';
  static const String addTodoTitle = 'Buat Tugas Baru ✨';
  static const String editTodoTitle = 'Edit Tugas ✏️';
  static const String cancelText = 'Batal';
  static const String saveText = 'Simpan';
  static const String deleteText = 'Hapus';
  static const String confirmDeleteTitle = 'Hapus Tugas?';
  static const String confirmDeleteMessage = 'Tugas ini akan dihapus permanen!';
}

class AppColors {
  static const primaryColor = const Color.fromARGB(255, 82, 122, 255);
  static const primaryLight = const Color.fromARGB(255, 82, 122, 255);
  static const primaryDark = const Color.fromARGB(255, 37, 97, 255);
  static const accentColor = const Color.fromARGB(255, 82, 122, 255);
  static const dangerColor = Color(0xFFFF5252);
  static const successColor = Color(0xFF69F0AE);
  static const backgroundColor = Color(0xFFFFF0F5);
  static const cardColor = Colors.white;
  static const textColor = const Color.fromARGB(255, 37, 97, 255);
}

class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [const Color.fromARGB(255, 82, 122, 255), const Color.fromARGB(255, 82, 122, 255)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const appBarGradient = LinearGradient(
    colors: [const Color.fromARGB(255, 82, 122, 255), const Color.fromARGB(255, 82, 122, 255)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}