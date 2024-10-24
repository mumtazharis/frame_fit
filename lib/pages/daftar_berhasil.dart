import 'package:flutter/material.dart';
import 'package:frame_fit/pages/masuk_akun.dart';

class DaftarBerhasil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Posisikan konten di tengah
          children: [
            // Menampilkan Icon Logo
            Image.asset(
              'assets/icon/alert_icon.png', // Path ke icon logo
              width: 100, // Atur ukuran sesuai kebutuhan
              height: 100,
            ),
            SizedBox(height: 30), // Spasi antar elemen
            // Menampilkan Pesan
            Text(
              'Akun FrameFit Anda berhasil dibuat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Sesuaikan teks ke tengah
            ),
            SizedBox(height: 30), // Spasi antar elemen
            // Tombol Lanjutkan
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MasukAkunPage(),
                    )
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
