import 'package:flutter/material.dart';
import 'package:frame_fit/pages/aboutUs_page.dart';
import 'package:frame_fit/pages/contactUs_page.dart';
import 'package:frame_fit/pages/ubahPassword_page.dart';
import 'editProfil_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  // Agar konten bisa di-scroll jika layar kecil
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Konten di tengah vertikal
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Memberi jarak dari atas layar
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.camera_alt, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Joko Tingkir',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Baputritaz@polinema.ac.id',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Tombol Edit yang lebih besar dan memenuhi layar
              SizedBox(
                width: double.infinity, // Tombol memenuhi lebar layar
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              // Garis pemisah
              const SizedBox(height: 16),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),

              const SizedBox(height: 16),

              // List Menu
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Ubah Password'),
                onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UbahPasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.support_agent),
                title: const Text('Kontak Kami'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang Kami'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),

              // Spacer untuk mendorong konten agar tidak terlalu atas
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
