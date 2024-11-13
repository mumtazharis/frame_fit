import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/camera_page.dart';
import 'pages/daftar.dart';
import 'pages/masuk_akun.dart';
import 'pages/profil.dart';
import 'pages/beranda.dart';
import 'pages/cari.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

void main() async {
  // Memastikan bahwa WidgetsFlutterBinding sudah terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Memeriksa token di SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  // Cek jika token ada, dan valid
  bool isTokenValid = token != null && await isValidToken(token);

  // Menjalankan aplikasi dengan halaman yang sesuai
  runApp(MyApp(isTokenValid: isTokenValid));
}

class MyApp extends StatelessWidget {
  final bool isTokenValid;

  MyApp({required this.isTokenValid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isTokenValid ? '/beranda' : '/', // Jika token valid, arahkan ke beranda, jika tidak ke login
      routes: {
        '/': (context) => HomePage(),
        '/camera': (context) => CameraPage(),
        '/daftar': (context) => DaftarPage(),
        '/masuk_akun': (context) => MasukAkunPage(),
        '/profil': (context) => ProfilePage(),
        '/beranda': (context) => BerandaPage(),
        '/cari': (context) => CariPage(),
      },
    );
  }
}

Future<bool> isValidToken(String token) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/verify_token'), // Ganti dengan endpoint verifikasi token di server Anda
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Jika server merespon 200 OK, anggap token valid
    return true;
  } else {
    // Jika server merespon dengan error, anggap token tidak valid
    return false;
  }
}
