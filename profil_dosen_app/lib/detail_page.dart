import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DetailPage extends StatefulWidget {
  final Map<String, String> dosen;
  const DetailPage({super.key, required this.dosen});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Map<String, String> _dosen;
  bool _isBookmarked = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _dosen = Map.from(widget.dosen);
    _isBookmarked = _dosen['bookmarked'] == 'true';
  }

  // Fungsi untuk membuka aplikasi email
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull('subject=Halo ${_dosen['nama']}'),
    );

    try {
      bool launched = await launchUrl(emailUri);
      if (!launched) {
        throw Exception('Tidak dapat membuka aplikasi email.');
      }
    } catch (e) {
      debugPrint('Error saat membuka email: $e');
    }
  }

  // Fungsi untuk membuka WhatsApp
  Future<void> _launchWhatsApp(String phone) async {
    final String cleanPhone = phone.replaceFirst('+', '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');

    try {
      bool launched = await launchUrl(whatsappUri);
      if (!launched) {
        throw Exception('Tidak dapat membuka WhatsApp.');
      }
    } catch (e) {
      debugPrint('Error saat membuka WhatsApp: $e');
    }
  }

  // Fungsi untuk toggle bookmark
  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
      _dosen['bookmarked'] = _isBookmarked.toString();
    });
    // Di sini Anda bisa menyimpan ke penyimpanan lokal atau database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Ditambahkan ke bookmark' : 'Dihapus dari bookmark',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _dosen['nama']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 109, 155, 240),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? const Color.fromARGB(255, 93, 147, 228) : Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              // Foto Dosen
              Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage(_dosen['foto']!) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromARGB(255, 88, 156, 235),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Nama Dosen
              Text(
                _dosen['nama']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 89, 168, 252),
                ),
              ),
              const SizedBox(height: 8),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    _dosen['rating']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Bidang Keahlian
              Text(
                'Bidang Keahlian: ${_dosen['keahlian']}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Email Dosen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 96, 149, 242),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _dosen['email']!,
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Telepon Dosen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone,
                    color: Color.fromARGB(255, 84, 145, 219),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _dosen['telepon']!,
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Tombol Hubungi via Email
              ElevatedButton.icon(
                onPressed: () => _launchEmail(_dosen['email']!),
                icon: const Icon(Icons.mail_outline),
                label: const Text(
                  'Hubungi via Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 104, 151, 252),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Tombol Hubungi via WhatsApp
              ElevatedButton.icon(
                onPressed: () => _launchWhatsApp(_dosen['telepon']!),
                icon: const Icon(Icons.message),
                label: const Text(
                  'Hubungi via WhatsApp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 39, 133, 239),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}