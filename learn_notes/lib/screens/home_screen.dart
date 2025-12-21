import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note_model.dart';
import 'note_list_screen.dart';
import 'settings_screen.dart';
import 'favorite_notes_screen.dart';
import 'add_edit_note_screen.dart';
import 'note_detail_screen.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dailyQuote = '';
  bool _isRefreshingQuote = false;

  @override
  void initState() {
    super.initState();
    _loadDailyQuote();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
  }

  void _loadDailyQuote() {
    final quotes = [
      'Ilmu tanpa amal seperti pohon tanpa buah.',
      'Belajarlah dari kesalahan, tapi jangan terpuruk karenanya.',
      'Kesuksesan dimulai dari kemauan untuk belajar.',
      'Jangan takut gagal, takutlah tidak mencoba.',
      'Setiap ahli pernah menjadi pemula.',
      'Belajar hari ini, sukses esok hari.',
      'Konsisten adalah kunci keberhasilan.',
      'Pahami konsep, bukan hafalan.',
      'Belajar dengan praktik lebih efektif.',
      'Review materi secara berkala.',
      'Jadikan belajar sebagai kebiasaan.',
      'Mulailah dari yang mudah, naikkan level secara bertahap.',
    ];

    final now = DateTime.now();
    final seed = now.millisecondsSinceEpoch ~/ 1000;
    final index = seed % quotes.length;

    setState(() {
      _dailyQuote = quotes[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 LearnNotes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).loadNotes();
            },
            tooltip: 'Refresh data',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            tooltip: 'Pengaturan',
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.notes.isEmpty) {
            return const LoadingIndicator();
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      provider.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: provider.loadNotes,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final totalNotes = provider.notes.length;
          final favoriteNotes = provider.favoriteNotes.length;
          final recentNotes = provider.notes.take(3).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadNotes();
              _loadDailyQuote();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER GREETING
                  _buildGreetingCard(),
                  const SizedBox(height: 20),

                  // INSPIRASI BELAJAR HARIAN
                  _buildInspirationCard(context),
                  const SizedBox(height: 20),

                  // STATISTIK
                  _buildStatsCard(
                      totalNotes, favoriteNotes, provider.categories.length),
                  const SizedBox(height: 20),

                  // CATATAN TERBARU
                  _buildRecentNotesCard(recentNotes, context, provider),
                  const SizedBox(height: 20),

                  // AKSI CEPAT
                  _buildQuickActionsCard(context, provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGreetingCard() {
    final hour = DateTime.now().hour;
    String greeting = 'Selamat Siang';

    if (hour < 12) greeting = 'Selamat Pagi';
    if (hour > 17) greeting = 'Selamat Malam';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school, color: Colors.blue, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Siap belajar hari ini?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.waving_hand, color: Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _buildInspirationCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.lightbulb,
                        color: Colors.amber, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '💡 Inspirasi Belajar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  if (_isRefreshingQuote)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: () async {
                        setState(() => _isRefreshingQuote = true);
                        await Future.delayed(const Duration(milliseconds: 500));
                        _loadDailyQuote();
                        setState(() => _isRefreshingQuote = false);
                      },
                      tooltip: 'Ganti inspirasi',
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _dailyQuote,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    final quote =
                        await Provider.of<NoteProvider>(context, listen: false)
                            .loadFromAPI();
                    if (!mounted) return;
                    if (quote != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.amber),
                              SizedBox(width: 10),
                              Text('Inspirasi Belajar Baru'),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                quote,
                                style:
                                    const TextStyle(fontSize: 16, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 10),
                              const Text(
                                'Apa yang ingin Anda lakukan?',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hanya Baca'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final newNote = Note(
                                  title: 'Inspirasi Belajar',
                                  content: quote,
                                  category: 'Motivasi',
                                  createdAt: DateTime.now(),
                                  isFavorite: true,
                                );
                                await Provider.of<NoteProvider>(context,
                                        listen: false)
                                    .addNote(newNote);
                                if (!mounted) return;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                            'Inspirasi disimpan sebagai catatan favorit'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text('Simpan sebagai Catatan'),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(Provider.of<NoteProvider>(context,
                                        listen: false)
                                    .error
                                    .isEmpty
                                ? 'Gagal mengambil data dari API'
                                : Provider.of<NoteProvider>(context,
                                        listen: false)
                                    .error)),
                      );
                    }
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Ambil dari API'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(
      int totalNotes, int favoriteNotes, int totalCategories) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Statistik Belajar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  totalNotes.toString(),
                  Icons.note,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Favorit',
                  favoriteNotes.toString(),
                  Icons.favorite,
                  Colors.red,
                ),
                _buildStatItem(
                  'Kategori',
                  totalCategories.toString(),
                  Icons.category,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentNotesCard(
      List<Note> recentNotes, BuildContext context, NoteProvider provider) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '📝 Catatan Terbaru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoteListScreen()),
                    );
                  },
                  child: const Row(
                    children: [
                      Text('Lihat Semua'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (recentNotes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.note_add, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Belum ada catatan',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tambahkan catatan pertamamu!',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: recentNotes.map((note) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(note.category),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            note.category[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            note.content.length > 60
                                ? '${note.content.substring(0, 60)}...'
                                : note.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              if (note.isFavorite)
                                const Icon(Icons.favorite,
                                    color: Colors.red, size: 14),
                            ],
                          ),
                        ],
                      ),
                      trailing:
                          const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(note: note),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context, NoteProvider provider) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚡ Aksi Cepat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickActionButton(
                  'Tambah Catatan',
                  Icons.add_circle,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditNoteScreen(),
                      ),
                    );
                  },
                ),
                _buildQuickActionButton(
                  'Semua Catatan',
                  Icons.list_alt,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoteListScreen()),
                    );
                  },
                ),
                _buildQuickActionButton(
                  'Catatan Favorit',
                  Icons.favorite,
                  Colors.red,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteNotesScreen(),
                      ),
                    );
                  },
                ),
                _buildQuickActionButton(
                  'Ambil Inspirasi',
                  Icons.auto_awesome,
                  Colors.orange,
                  () async {
                    final quote = await provider.loadFromAPI();
                    if (!mounted) return;
                    if (quote != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.amber),
                              SizedBox(width: 10),
                              Text('Inspirasi Belajar Baru'),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                quote,
                                style:
                                    const TextStyle(fontSize: 16, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 10),
                              const Text(
                                'Apa yang ingin Anda lakukan?',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hanya Baca'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final newNote = Note(
                                  title: 'Inspirasi Belajar',
                                  content: quote,
                                  category: 'Motivasi',
                                  createdAt: DateTime.now(),
                                  isFavorite: true,
                                );
                                await Provider.of<NoteProvider>(context,
                                        listen: false)
                                    .addNote(newNote);
                                if (!mounted) return;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                            'Inspirasi disimpan sebagai catatan favorit'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text('Simpan sebagai Catatan'),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(provider.error.isEmpty
                                ? 'Gagal mengambil data dari API'
                                : provider.error)),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Pemrograman Mobile': Colors.blue,
      'Rekayasa Perangkat Lunak': Colors.green,
      'Multimedia': Colors.orange,
      'Implementasi Testing Dan Sistem': Colors.purple,
      'Technopreneuship': Colors.red,
      'Manajemen Risiko': Colors.teal,
      'Tips': Colors.pink,
      'Pengenalan': Colors.indigo,
    };
    return colors[category] ?? Colors.grey;
  }
}
