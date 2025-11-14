// Flutter widget test untuk aplikasi Profil Dosen
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profil_dosen_app/main.dart';

void main() {
  // Pasang HttpClient palsu supaya Image.network tidak error saat testing
  late HttpOverrides? _previousOverrides;
  setUpAll(() {
    _previousOverrides = HttpOverrides.current;
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = _previousOverrides;
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfilDosenApp());

    // Pastikan halaman utama muncul
    expect(find.text('Daftar Dosen'), findsOneWidget);

    // Pastikan kolom pencarian ada
    expect(find.byType(TextField), findsOneWidget);

    // Pastikan daftar dosen tampil
    expect(find.byType(ListView), findsOneWidget);

    // Pastikan ada kartu dosen
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Search functionality test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfilDosenApp());
    await tester.pumpAndSettle();

    // Masukkan teks pencarian
    await tester.enterText(find.byType(TextField), 'Hery Afriadi');
    await tester.pumpAndSettle();

    // Perbaikan: gunakan findsWidgets karena teks bisa muncul lebih dari satu kali
    expect(find.text('Hery Afriadi, SE, S.Kom, M.Si'), findsWidgets);

    // Pastikan dosen lain tidak muncul
    expect(find.text('Pol Metra, M.Kom'), findsNothing);
  });

  testWidgets('Navigation to detail page test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfilDosenApp());
    await tester.pumpAndSettle();

    // Tap pada kartu dosen pertama
    await tester.tap(find.byType(Card).first);
    await tester.pumpAndSettle();

    // Cek apakah halaman detail tampil
    // Gunakan findsWidgets karena teks bisa muncul di AppBar dan isi halaman
    expect(find.text('Hery Afriadi, SE, S.Kom, M.Si'), findsWidgets);

    // Pastikan bidang keahlian muncul
    expect(find.text('Bidang Keahlian: Manajemen Informatika'), findsOneWidget);
  });
}

/// HttpOverrides palsu supaya Image.network tidak error saat test
class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient();
  }
}

class _FakeHttpClient implements HttpClient {
  static final List<int> _pngBytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=');

  @override
  Future<HttpClientRequest> getUrl(Uri url) async =>
      _FakeHttpClientRequest(_pngBytes);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _FakeHttpClientRequest(_pngBytes);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientRequest implements HttpClientRequest {
  final List<int> _responseBytes;
  _FakeHttpClientRequest(this._responseBytes);

  @override
  Future<HttpClientResponse> close() async =>
      _FakeHttpClientResponse(_responseBytes);

  // ✅ Diperbaiki agar tidak merah — tulis getter & setter berpasangan tanpa override di salah satu saja
  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {}

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  final List<int> _bytes;
  _FakeHttpClientResponse(this._bytes);

  @override
  int get statusCode => 200;
  @override
  int get contentLength => _bytes.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final controller = StreamController<List<int>>();
    controller.add(_bytes);
    controller.close();
    return controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _map = {};

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _map.putIfAbsent(name, () => []).add(value.toString());
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _map[name] = [value.toString()];
  }

  @override
  List<String>? operator [](String name) => _map[name];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}