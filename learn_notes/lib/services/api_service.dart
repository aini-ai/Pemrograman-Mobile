import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.quotable.io';

  static Future<List<Map<String, dynamic>>> getLearningQuotes() async {
    try {
      // Gunakan random page untuk mendapatkan quote berbeda
      final randomPage = DateTime.now().millisecond % 5 + 1;

      final response = await http.get(
        Uri.parse('$baseUrl/quotes?tags=education&page=$randomPage&limit=1'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final quote = data['results'][0];
          return [
            {
              'quote': quote['content'] ?? 'Tetap semangat belajar!',
              'author': quote['author'] ?? 'Unknown'
            }
          ];
        } else {
          return _getFallbackData();
        }
      } else {
        return _getFallbackData();
      }
    } catch (e) {
      return _getFallbackData();
    }
  }

  static List<Map<String, dynamic>> _getFallbackData() {
    final quotes = getLocalQuotes();
    final randomIndex = DateTime.now().millisecond % quotes.length;

    return [
      {'quote': quotes[randomIndex], 'author': 'Inspirasi Lokal'}
    ];
  }

  static List<String> getLocalQuotes() {
    return [
      'Belajar adalah investasi terbaik untuk masa depan.',
      'Konsisten adalah kunci keberhasilan dalam belajar.',
      'Setiap ahli pernah menjadi pemula, jangan menyerah!',
      'Ilmu yang bermanfaat adalah yang diamalkan.',
      'Waktu terbaik untuk belajar adalah sekarang.',
      'Jangan hanya membaca, tapi pahami dan praktikkan.',
      'Membuat catatan membantu mengingat lebih lama.',
      'Belajar kelompok bisa saling melengkapi pemahaman.',
      'Istirahat yang cukup meningkatkan konsentrasi belajar.',
      'Review materi sebelum tidur meningkatkan retensi memori.',
      'Ajarkan orang lain untuk memperdalam pemahamanmu.',
      'Fokus pada proses, bukan hanya hasil akhir.',
      'Belajar dari kesalahan adalah cara terbaik berkembang.',
      'Tetap penasaran dan selalu bertanya.',
      'Kembangkan pola pikir bertumbuh (growth mindset).',
      'Mulai dari yang kecil, konsistenlah setiap hari.',
      'Jangan takut bertanya jika tidak paham.',
      'Belajar dengan bahagia akan lebih efektif.',
      'Atur target yang realistis dan terukur.',
      'Rayakan setiap pencapaian kecil dalam belajar.',
    ];
  }
}
