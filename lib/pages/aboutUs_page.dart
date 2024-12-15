import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Tentang Kami'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              Text(
                'FrameFit',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),

              // Deskripsi tentang aplikasi
              Text(
                'FrameFit adalah aplikasi mobile inovatif yang dirancang untuk membantu Anda menemukan bingkai kacamata yang tepat dengan cara yang mudah dan menyenangkan. '
                'Dengan teknologi deteksi wajah yang canggih, aplikasi kami menganalisis bentuk wajah Anda untuk memberikan rekomendasi bingkai kacamata yang paling cocok dan sesuai dengan gaya pribadi Anda.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 32),

              // Fitur Utama
              Text(
                'Fitur Utama FrameFit:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),

              // Daftar fitur
              _buildFeatureItem('Deteksi Wajah Akurat', 'FrameFit menggunakan teknologi pengenalan wajah yang akurat untuk menganalisis bentuk wajah Anda, sehingga dapat memberikan rekomendasi bingkai kacamata yang pas.'),
              _buildFeatureItem('Ragam Pilihan Bingkai', 'Kami menyediakan berbagai pilihan bingkai kacamata dari berbagai model dan bahan yang dapat Anda coba melalui aplikasi ini.'),
              _buildFeatureItem('Coba Sebelum Membeli', 'Cobalah berbagai bingkai secara virtual tanpa harus pergi ke toko fisik, cukup dengan menggunakan foto atau kamera depan.'),
              _buildFeatureItem('Rekomendasi yang Tepat', 'Aplikasi kami memberikan rekomendasi bingkai yang sesuai berdasarkan deteksi bentuk wajah Anda, membuat proses berbelanja lebih mudah dan cepat.'),

              SizedBox(height: 32),

              // Misi
              Text(
                'Misi Kami:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Misi kami adalah untuk menyederhanakan cara orang memilih kacamata dengan menggabungkan teknologi dan fashion. Kami percaya bahwa kacamata bukan hanya alat bantu penglihatan, tetapi juga bagian dari ekspresi gaya pribadi Anda. '
                'Dengan FrameFit, kami ingin membantu setiap pengguna menemukan bingkai yang tidak hanya nyaman, tetapi juga menambah kepercayaan diri.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 32),

              // Kenapa Memilih FrameFit
              Text(
                'Kenapa Memilih FrameFit?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              _buildFeatureItem('Personalisasi', 'Rekomendasi kami disesuaikan dengan bentuk wajah Anda, memastikan Anda mendapatkan pilihan terbaik.'),
              _buildFeatureItem('Kemudahan', 'Cobalah berbagai model kacamata langsung dari smartphone Anda, kapan saja dan di mana saja.'),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan item fitur
  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blue, size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: $description',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
