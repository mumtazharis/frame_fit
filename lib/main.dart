import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/camera_page.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomeScreen(), // Halaman pertama yang ditampilkan adalah HomeScreen
      '/camera': (context) => CameraPage(),
    },
  ));
}
