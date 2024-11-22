import 'package:flutter/material.dart';
import 'package:frame_fit/pages/loading_screen.dart';

class DaftarBerhasil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/alert_icon.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 30),
            Text(
              'Akun FrameFit Anda berhasil dibuat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingScreen(nextPage: 'MasukAkunPage'),  // Mengirimkan nextPage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
              child: Text(
                'Lanjutkan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
