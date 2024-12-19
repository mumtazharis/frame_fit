import 'package:flutter/material.dart';

class KebijakanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kebijakan Privasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 72, 243),
        iconTheme: IconThemeData(color: Colors.white), // Mengubah warna icon back menjadi putih
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poin 1
              _buildKebijakanItem(
                '1.',
                'Aplikasi ini mengumpulkan data berupa gambar wajah untuk analisis bentuk wajah. Data ini tidak akan dibagikan kepada pihak ketiga tanpa persetujuan pengguna.',
              ),
              // Poin 2
              _buildKebijakanItem(
                '2.',
                'Semua gambar yang diunggah akan dienkripsi dan hanya digunakan untuk memberikan rekomendasi bingkai kacamata.',
              ),
              // Poin 3
              _buildKebijakanItem(
                '3.',
                'Data pengguna disimpan dengan aman sesuai standar keamanan terkini. Namun, pengembang tidak bertanggung jawab atas kerugian akibat serangan pihak ketiga.',
              ),
              // Poin 4
              _buildKebijakanItem(
                '4.',
                'Pengguna dapat menghubungi layanan dukungan untuk meminta penghapusan data mereka kapan saja.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat item kebijakan
  Widget _buildKebijakanItem(String number, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
