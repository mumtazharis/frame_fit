import 'package:flutter/material.dart';

class KebijakanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kebijakan Privasi', style: TextStyle(
                    color: Colors.white,),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Text(
                '1.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                'Aplikasi ini mengumpulkan data berupa gambar wajah untuk analisis bentuk wajah. Data ini tidak akan dibagikan kepada pihak ketiga tanpa persetujuan pengguna.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Text(
                '2.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                'Semua gambar yang diunggah akan dienkripsi dan hanya digunakan untuk memberikan rekomendasi bingkai kacamata.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Text(
                '3.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                'Data pengguna disimpan dengan aman sesuai standar keamanan terkini. Namun, pengembang tidak bertanggung jawab atas kerugian akibat serangan pihak ketiga.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Text(
                '4.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                'Pengguna dapat menghubungi layanan dukungan untuk meminta penghapusan data mereka kapan saja.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
