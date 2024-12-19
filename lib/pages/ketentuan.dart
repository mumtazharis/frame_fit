import 'package:flutter/material.dart';

class KetentuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ketentuan Penggunaan',
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
              _buildKetentuanItem(
                '1.',
                'Penggunaan aplikasi FrameFit hanya untuk membantu pengguna memilih bingkai kacamata yang sesuai berdasarkan bentuk wajah mereka.',
              ),
              // Poin 2
              _buildKetentuanItem(
                '2.',
                'Aplikasi ini tidak menjamin bahwa bingkai yang direkomendasikan akan sepenuhnya sesuai atau memuaskan pengguna. Keputusan akhir tetap berada di pihak pengguna.',
              ),
              // Poin 3
              _buildKetentuanItem(
                '3.',
                'Dilarang menggunakan aplikasi ini untuk tujuan komersial tanpa izin tertulis dari pengembang.',
              ),
              // Poin 4
              _buildKetentuanItem(
                '4.',
                'Pengguna bertanggung jawab penuh atas penggunaan aplikasi dan hasil yang diperoleh.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat item ketentuan
  Widget _buildKetentuanItem(String number, String description) {
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
