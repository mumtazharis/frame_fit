import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frame_fit/pages/masuk_akun.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk beralih ke halaman MasukAkunPage setelah 2 detik
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MasukAkunPage()),
      );
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
            // CircularProgressIndicator mengelilingi logo
            SizedBox(
              width: 150, 
              height: 150,
              child: CircularProgressIndicator(
                strokeWidth: 6.0, // Lebar dari lingkaran
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Warna lingkaran
              ),
            ),
            // Logo di tengah lingkaran
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
