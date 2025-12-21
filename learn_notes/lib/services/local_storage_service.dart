import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class LocalStorageService {
  static sql.Database? _database;
  static SharedPreferences? _prefs;
  static List<Note> _webNotes = [];
  static bool _isInitialized = false;

  // ==================== INITIALIZATION ====================
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();

      if (!kIsWeb) {
        await _initSQLiteDatabase();
      } else {
        await _initWebStorage();
      }

      _isInitialized = true;
      print('✅ Storage initialized successfully');
    } catch (e) {
      print('❌ Error initializing storage: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  // ==================== SQLITE DATABASE (MOBILE) ====================
  static Future<void> _initSQLiteDatabase() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = path.join(dbPath, 'learnnotes_final.db');

      print('📁 Database path: $db');

      _database = await sql.openDatabase(
        db,
        version: 1,
        onCreate: (sql.Database db, int version) async {
          print('🆕 Creating database tables...');

          // Create notes table
          await db.execute('''
            CREATE TABLE notes(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              category TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              isFavorite INTEGER DEFAULT 0
            )
          ''');

          print('✅ Notes table created');

          // Insert sample data
          await _addSampleData(db);
        },
      );

      // Verify table exists
      final tables = await _database!.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='notes'");

      if (tables.isNotEmpty) {
        print('✅ SQLite database ready with notes table');
      } else {
        print('⚠️ Notes table not found, creating...');
        await _database!.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            category TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            isFavorite INTEGER DEFAULT 0
          )
        ''');
        await _addSampleData(_database!);
      }
    } catch (e) {
      print('❌ SQLite initialization error: $e');
      rethrow;
    }
  }

  static Future<void> _addSampleData(sql.Database db) async {
    try {
      // Insert welcome note
      await db.insert('notes', {
        'title': 'Selamat Datang di LearnNotes!',
        'content':
            'Aplikasi catatan belajar untuk UAS Pemrograman Mobile 5C.\n\nFitur:\n• Buat, Edit, Hapus Catatan\n• Kategori Belajar\n• Favorit\n• Penyimpanan Lokal\n• API Quotes Inspirasi',
        'category': 'Pengenalan',
        'createdAt': DateTime.now().toIso8601String(),
        'isFavorite': 1,
      });

      // Insert sample study tips
      await db.insert('notes', {
        'title': 'Tips Belajar Efektif',
        'content':
            '1. Buat jadwal belajar rutin\n2. Fokus 25 menit, istirahat 5 menit\n3. Review materi sebelum tidur\n4. Praktik langsung dengan contoh\n5. Ajarkan orang lain untuk lebih paham',
        'category': 'Tips',
        'createdAt':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'isFavorite': 0,
      });

      print('✅ Sample data inserted');
    } catch (e) {
      print('⚠️ Error inserting sample data: $e');
    }
  }

  // ==================== WEB STORAGE ====================
  static Future<void> _initWebStorage() async {
    try {
      // For web, we use SharedPreferences and in-memory list
      _webNotes = [];

      // Load existing notes from SharedPreferences
      final notesData = _prefs?.getStringList('web_notes_data');
      if (notesData != null && notesData.isNotEmpty) {
        for (final noteStr in notesData) {
          try {
            final parts = noteStr.split('|');
            if (parts.length >= 6) {
              _webNotes.add(Note(
                id: int.tryParse(parts[0]) ??
                    DateTime.now().millisecondsSinceEpoch,
                title: parts[1],
                content: parts[2],
                category: parts[3],
                createdAt: DateTime.tryParse(parts[4]) ?? DateTime.now(),
                isFavorite: parts[5] == '1',
              ));
            }
          } catch (e) {
            print('⚠️ Error parsing web note: $e');
          }
        }
      }

      // If no notes exist, add sample data
      if (_webNotes.isEmpty) {
        await _addWebSampleData();
      }

      print('✅ Web storage initialized with ${_webNotes.length} notes');
    } catch (e) {
      print('❌ Web storage initialization error: $e');
    }
  }

  static Future<void> _addWebSampleData() async {
    _webNotes = [
      Note(
        id: 1,
        title: 'Selamat Datang di LearnNotes!',
        content:
            'Aplikasi catatan belajar untuk UAS Pemrograman Mobile 5C. Fitur lengkap dengan Provider, API, dan Local Storage.',
        category: 'Pengenalan',
        createdAt: DateTime.now(),
        isFavorite: true,
      ),
      Note(
        id: 2,
        title: 'Tips Belajar Efektif',
        content:
            '1. Buat jadwal rutin\n2. Fokus dan istirahat seimbang\n3. Review materi berkala\n4. Praktik langsung',
        category: 'Tips',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
    await _saveWebNotes();
  }

  static Future<void> _saveWebNotes() async {
    try {
      final notesData = _webNotes.map((note) {
        return '${note.id}|${note.title}|${note.content}|${note.category}|${note.createdAt.toIso8601String()}|${note.isFavorite ? 1 : 0}';
      }).toList();

      await _prefs?.setStringList('web_notes_data', notesData);
    } catch (e) {
      print('❌ Error saving web notes: $e');
    }
  }

  // ==================== CRUD OPERATIONS ====================
  static Future<int> insertNote(Note note) async {
    try {
      if (kIsWeb) {
        note.id = DateTime.now().millisecondsSinceEpoch;
        _webNotes.insert(0, note);
        await _saveWebNotes();
        return note.id!;
      } else {
        // Ensure database is initialized
        if (_database == null || !_database!.isOpen) {
          await _initSQLiteDatabase();
        }

        final id = await _database!.insert('notes', note.toMap());
        return id;
      }
    } catch (e) {
      print('❌ Error inserting note: $e');
      rethrow;
    }
  }

  static Future<List<Note>> getNotes() async {
    try {
      if (kIsWeb) {
        return List.from(_webNotes); // Return copy
      } else {
        // Ensure database is initialized
        if (_database == null || !_database!.isOpen) {
          await _initSQLiteDatabase();
        }

        final data = await _database!.query('notes', orderBy: 'createdAt DESC');

        return data.map((map) => Note.fromMap(map)).toList();
      }
    } catch (e) {
      print('❌ Error getting notes: $e');
      return [];
    }
  }

  static Future<int> updateNote(Note note) async {
    try {
      if (kIsWeb) {
        final index = _webNotes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _webNotes[index] = note;
          await _saveWebNotes();
          return 1;
        }
        return 0;
      } else {
        // Ensure database is initialized
        if (_database == null || !_database!.isOpen) {
          await _initSQLiteDatabase();
        }

        return await _database!.update(
          'notes',
          note.toMap(),
          where: 'id = ?',
          whereArgs: [note.id],
        );
      }
    } catch (e) {
      print('❌ Error updating note: $e');
      rethrow;
    }
  }

  static Future<int> deleteNote(int id) async {
    try {
      if (kIsWeb) {
        _webNotes.removeWhere((note) => note.id == id);
        await _saveWebNotes();
        return 1;
      } else {
        // Ensure database is initialized
        if (_database == null || !_database!.isOpen) {
          await _initSQLiteDatabase();
        }

        return await _database!.delete(
          'notes',
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    } catch (e) {
      print('❌ Error deleting note: $e');
      rethrow;
    }
  }

  // ==================== UTILITY METHODS ====================
  static Future<int> getNoteCount() async {
    try {
      if (kIsWeb) {
        return _webNotes.length;
      } else {
        if (_database == null || !_database!.isOpen) {
          await _initSQLiteDatabase();
        }

        final result =
            await _database!.rawQuery('SELECT COUNT(*) as count FROM notes');
        return (result.first['count'] ?? 0) as int;
      }
    } catch (e) {
      print('❌ Error getting note count: $e');
      return 0;
    }
  }

  static Future<List<Note>> getFavoriteNotes() async {
    try {
      final allNotes = await getNotes();
      return allNotes.where((note) => note.isFavorite).toList();
    } catch (e) {
      print('❌ Error getting favorite notes: $e');
      return [];
    }
  }

  static Future<List<Note>> getNotesByCategory(String category) async {
    try {
      final allNotes = await getNotes();
      return allNotes.where((note) => note.category == category).toList();
    } catch (e) {
      print('❌ Error getting notes by category: $e');
      return [];
    }
  }

  // ==================== DEBUG & MAINTENANCE ====================
  static Future<void> debugDatabase() async {
    if (kIsWeb) {
      print('🌐 WEB MODE: ${_webNotes.length} notes in memory');
      for (final note in _webNotes) {
        print('   📍 ${note.id}: ${note.title} (${note.category})');
      }
    } else {
      try {
        if (_database == null || !_database!.isOpen) {
          print('⚠️ Database not initialized');
          return;
        }

        // Show all tables
        final tables = await _database!
            .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

        print('📊 DATABASE TABLES:');
        for (final table in tables) {
          final tableName = table['name'] as String;
          print('   - $tableName');

          // Show row count for each table
          if (tableName == 'notes') {
            final count = await getNoteCount();
            print('     Rows: $count');
          }
        }

        // Show all notes
        final notes = await getNotes();
        print('📝 NOTES IN DATABASE:');
        for (final note in notes) {
          print('   ${note.id}: ${note.title} - ${note.category}');
        }
      } catch (e) {
        print('❌ Debug error: $e');
      }
    }
  }

  static Future<void> clearDatabase() async {
    try {
      if (kIsWeb) {
        _webNotes.clear();
        await _prefs?.remove('web_notes_data');
        print('✅ Web database cleared');
      } else {
        if (_database != null && _database!.isOpen) {
          await _database!.delete('notes');
          await _addSampleData(_database!);
          print('✅ SQLite database cleared and reset');
        }
      }
    } catch (e) {
      print('❌ Error clearing database: $e');
    }
  }

  // ==================== SHARED PREFERENCES ====================
  // Note: Dark mode methods removed - now handled by ThemeProvider

  static String getUsername() {
    return _prefs?.getString('username') ?? 'Mahasiswa';
  }

  static Future<void> setUsername(String value) async {
    await _prefs?.setString('username', value);
  }

  static Future<void> clearPreferences() async {
    await _prefs?.clear();
  }
}
