import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/local_storage_service.dart';
import '../services/api_service.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  String _error = '';
  List<String> _categories = [
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi',
    'Programming',
    'Motivasi',
    'Tips'
  ];

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String get error => _error;
  List<String> get categories => _categories;

  // Filter
  List<Note> get favoriteNotes =>
      _notes.where((note) => note.isFavorite).toList();

  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  // Load notes dari storage
  Future<void> loadNotes() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final loadedNotes = await LocalStorageService.getNotes();

      // Hapus duplikat berdasarkan ID dan timestamp
      final uniqueNotes = <Note>[];
      final seenIds = <int>{};

      for (final note in loadedNotes) {
        if (note.id != null && !seenIds.contains(note.id)) {
          seenIds.add(note.id!);
          uniqueNotes.add(note);
        }
      }

      // Urutkan berdasarkan tanggal terbaru
      uniqueNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _notes = uniqueNotes;
      _error = '';
    } catch (e) {
      _error = 'Gagal memuat catatan: $e';
      print('Error loading notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tambah note
  Future<void> addNote(Note note) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id = await LocalStorageService.insertNote(note);
      note.id = id;
      _notes.insert(0, note);
      _error = '';

      // Sort ulang setelah tambah
      _notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = 'Gagal menambah catatan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update note
  Future<void> updateNote(Note updatedNote) async {
    _isLoading = true;
    notifyListeners();

    try {
      await LocalStorageService.updateNote(updatedNote);
      final index = _notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        _notes[index] = updatedNote;
        _notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      _error = '';
    } catch (e) {
      _error = 'Gagal mengupdate catatan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hapus note
  Future<void> deleteNote(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await LocalStorageService.deleteNote(id);
      _notes.removeWhere((note) => note.id == id);
      _error = '';
    } catch (e) {
      _error = 'Gagal menghapus catatan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(int id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index].isFavorite = !_notes[index].isFavorite;
      await LocalStorageService.updateNote(_notes[index]);
      notifyListeners();
    }
  }

  // Load data dari API (mengembalikan quote string; UI bertanggung jawab menampilkannya)
  Future<String?> loadFromAPI() async {
    if (_isLoading) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.getLearningQuotes();

      if (data.isNotEmpty && data[0]['quote'] != null) {
        _error = '';
        return data[0]['quote']!;
      }

      _error = '';
      return null;
    } catch (e) {
      _error = 'Gagal mengambil data dari API: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
