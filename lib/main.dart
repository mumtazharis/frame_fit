import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/camera_page.dart';
import 'pages/daftar.dart';
import 'pages/masuk_akun.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(), // Halaman pertama yang ditampilkan adalah HomeScreen
      '/camera': (context) => CameraPage(),
      '/daftar': (context) => DaftarPage(),
      '/masuk_akun': (context) => MasukAkunPage(),
    },
  ));
}
