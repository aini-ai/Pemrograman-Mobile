import 'package:flutter/material.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _allDosen = [
    {
      'nama': 'Hery Afriadi, SE, S.Kom, M.Si',
      'foto': 'assets/images/dosen1.jpg',
      'keahlian': 'Testing dan Implementasi',
      'email': 'hery.afriadi@university.ac.id',
      'telepon': '+6281234567890',
      'rating': '4.5',
      'bookmarked': 'false',
    },
    {
      'nama': 'Pol Metra, M.Kom',
      'foto': 'assets/images/dosen2.jpg',
      'keahlian': 'Basis Data',
      'email': 'pol.metra@university.ac.id',
      'telepon': '+6281234567891',
      'rating': '4.7',
      'bookmarked': 'false',
    },
    {
      'nama': 'Ahmad Nasukha, S.Hum, M.Si',
      'foto': 'assets/images/dosen3.jpg',
      'keahlian': 'Human Computer Interaction',
      'email': 'ahmad.nasukha@university.ac.id',
      'telepon': '+6281234567892',
      'rating': '4.3',
      'bookmarked': 'false',
    },
    {
      'nama': 'Dila Nurlaila, M.Kom',
      'foto': 'assets/images/dosen4.jpg',
      'keahlian': 'Software Engineering',
      'email': 'dila.nurlaila@university.ac.id',
      'telepon': '+6281234567893',
      'rating': '4.6',
      'bookmarked': 'false',
    },
    {
      'nama': 'M. Yusuf, S.Kom, M.Si',
      'foto': 'assets/images/dosen5.jpg',
      'keahlian': 'Cyber Security',
      'email': 'm.yusuf@university.ac.id',
      'telepon': '+6281234567894',
      'rating': '4.8',
      'bookmarked': 'false',
    },
    {
      'nama': 'Wahyu Anggoro, M.Kom',
      'foto': 'assets/images/dosen6.jpg',
      'keahlian': 'Machine Learning',
      'email': 'wahyu.anggoro@university.ac.id',
      'telepon': '+6281234567895',
      'rating': '4.4',
      'bookmarked': 'false',
    },
  ];

  List<Map<String, String>> _filteredDosen = [];

  @override
  void initState() {
    super.initState();
    _filteredDosen = _allDosen;
  }

  void _searchDosen(String query) {
    setState(() {
      _filteredDosen = _allDosen
          .where(
            (dosen) =>
                dosen['nama']!.toLowerCase().contains(query.toLowerCase()) ||
                dosen['keahlian']!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Daftar Dosen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔍 Kotak pencarian
            TextField(
              onChanged: _searchDosen,
              decoration: InputDecoration(
                hintText: 'Cari nama atau keahlian dosen...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            // 🧑‍🏫 Daftar dosen
            Expanded(
              child: _filteredDosen.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredDosen.length,
                      itemBuilder: (context, index) {
                        final dosen = _filteredDosen[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 5,
                            ),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(dosen['foto']!),
                                radius: 30,
                              ),
                              title: Text(
                                dosen['nama']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                dosen['keahlian']!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, _) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: DetailPage(dosen: dosen),
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Dosen tidak ditemukan.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}