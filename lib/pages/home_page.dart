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
                image: AssetImage('images/background.png'), // Sesuaikan dengan path gambar background kamu
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
                    'images/logo.png',
                    height: 125, // Ukuran logo lebih besar
                    width: 125,
                  ),
                  // Teks Utama dan Deskripsi
                  Text(
                    'Frame Fit',
                    style: TextStyle(
                      fontSize: 26, // Ukuran teks lebih besar
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Bringing our users\nthe best eyewear,\npersonalized fit, and\ninspiring stories in style.',
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
                          // Navigasi atau aksi saat Sign Up ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, 
                          foregroundColor: Colors.black, 
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 15),
                      OutlinedButton(
                        onPressed: () {
                          // Navigasi atau aksi saat Sign In ditekan
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          side: BorderSide(color: Colors.white), 
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                          backgroundColor: Colors.blue, // Warna latar belakang tombol
                          foregroundColor: Colors.white, // Warna teks tombol
                          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20), // Ukuran tombol lebih besar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Ke Camera Page', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
