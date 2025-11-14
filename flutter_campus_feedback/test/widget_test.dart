import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_campus_feedback/main.dart';

void main() {
  testWidgets('Smoke test aplikasi Campus Feedback', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusFeedbackApp());

    // Cek tampilan awal
    expect(find.text('Selamat Datang di Aplikasi Kuesioner Kampus!'), findsOneWidget);
    expect(find.text('Isi Kuesioner'), findsOneWidget);
    expect(find.text('Lihat Feedback'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });
}
