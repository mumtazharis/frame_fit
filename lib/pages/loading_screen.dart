import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frame_fit/pages/masuk_akun.dart';
import 'package:frame_fit/pages/beranda.dart';

class LoadingScreen extends StatefulWidget {
  final String nextPage;  // pastikan ada deklarasi parameter nextPage di sini

  // Constructor untuk menerima parameter nextPage
  LoadingScreen({required this.nextPage});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      // Navigasi berdasarkan nextPage
      if (widget.nextPage == 'MasukAkunPage') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MasukAkunPage()),
        );
      } else if (widget.nextPage == 'BerandaPage') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BerandaPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 72, 243),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
