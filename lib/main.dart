import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/camera_page.dart';
import 'pages/daftar.dart';
import 'pages/masuk_akun.dart';
import 'pages/profil.dart';
import 'pages/beranda.dart';
import 'pages/cari.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(), // Halaman pertama yang ditampilkan adalah HomeScreen
      '/camera': (context) => CameraPage(),
      '/daftar': (context) => DaftarPage(),
      '/masuk_akun': (context) => MasukAkunPage(),
      '/profil': (context) => ProfilePage(),
      '/beranda': (context) => BerandaPage(),
      '/cari': (context) => CariPage(),
    },
  ));
}
