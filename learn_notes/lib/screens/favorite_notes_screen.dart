import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';
import 'note_detail_screen.dart';

class FavoriteNotesScreen extends StatelessWidget {
  const FavoriteNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Favorit'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.notes.isEmpty) {
            return const LoadingIndicator();
          }

          final favoriteNotes = provider.favoriteNotes;

          return favoriteNotes.isEmpty
              ? const EmptyState(
                  icon: Icons.favorite_border,
                  message:
                      'Belum ada catatan favorit\nTambahkan favorit pada catatan!',
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadNotes();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteNotes.length,
                    itemBuilder: (context, index) {
                      final note = favoriteNotes[index];
                      return NoteCard(
                        note: note,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailScreen(note: note),
                            ),
                          );
                        },
                        onDelete: () {
                          _showDeleteDialog(context, provider, note.id!);
                        },
                        onToggleFavorite: () {
                          provider.toggleFavorite(note.id!);
                        },
                      );
                    },
                  ),
                );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, NoteProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteNote(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
