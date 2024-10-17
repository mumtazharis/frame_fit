import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/camera_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/camera': (context) => CameraPage(),
    },
  ));
}
