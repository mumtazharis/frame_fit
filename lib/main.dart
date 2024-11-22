import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pages/home_page.dart';
import 'pages/camera_page.dart';
import 'pages/daftar.dart';
import 'pages/masuk_akun.dart';
import 'pages/profil.dart';
import 'pages/beranda.dart';
import 'pages/cari.dart';
import '../config/api_config.dart';

void main() async {
  // Memastikan WidgetsFlutterBinding diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Memeriksa token di SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  String? refreshToken = prefs.getString('refresh_token');

  // Cek validitas token
  bool isTokenValid = false;
  if (accessToken != null) {
    isTokenValid = await isValidToken(accessToken);
    if (!isTokenValid && refreshToken != null) {
      // Coba refresh token jika access token tidak valid
      accessToken = await refreshAccessToken(refreshToken);
      if (accessToken != null) {
        isTokenValid = true;
        await prefs.setString('access_token', accessToken);
      }
    }
  }

  // Jalankan aplikasi
  runApp(MyApp(isTokenValid: isTokenValid));
}

class MyApp extends StatelessWidget {
  final bool isTokenValid;

  MyApp({required this.isTokenValid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isTokenValid ? '/beranda' : '/masuk_akun', // Sesuaikan rute awal
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

// Fungsi untuk memeriksa validitas token
Future<bool> isValidToken(String token) async {
  try {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/verify_token'), // Endpoint server Anda
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200; // Anggap token valid jika status 200
  } catch (e) {
    print('Error saat memverifikasi token: $e');
    return false;
  }
}

// Fungsi untuk merefresh token
Future<String?> refreshAccessToken(String refreshToken) async {
  try {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/refresh_token'), // Endpoint refresh token server Anda
      headers: {
        'Authorization': 'Bearer $refreshToken',  // Kirimkan refresh token sebagai Bearer token
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody['access_token']; // Ambil token baru
    } else {
      print('Gagal merefresh token: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error saat merefresh token: $e');
    return null;
  }
}
