import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gambar Latar Belakang
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Sesuaikan dengan path gambar background kamu
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten di bagian kiri bawah layar
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 80.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Menyusun konten ke kiri
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 125, // Ukuran logo lebih besar
                    width: 125,
                  ),
                  // Teks Utama dan Deskripsi
                  Text(
                    'FrameFit',
                    style: TextStyle(
                      fontSize: 26, // Ukuran teks lebih besar
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Menghadirkan\nbingkai kacamata terbaik,\nsesuai dengan kebutuhan pengguna, dan\nkisah inspiratif dalam gaya.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18, // Ukuran teks deskripsi lebih besar
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Tombol Sign Up dan Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                            Navigator.pushNamed(context, '/daftar');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, 
                          foregroundColor: Colors.black, 
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 15),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/masuk_akun');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          side: BorderSide(color: Colors.white), 
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/camera');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                          foregroundColor: Colors.white, // Warna teks tombol
                          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20), // Ukuran tombol lebih besar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Pindai Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
