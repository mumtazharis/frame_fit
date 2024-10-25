import 'package:flutter/material.dart';
import 'edit_profil.dart';

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
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
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
                title: const Text('Reset Password'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.subscriptions),
                title: const Text('Subscription'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.support_agent),
                title: const Text('Support'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About us'),
                onTap: () {},
              ),

              // Spacer untuk mendorong konten agar tidak terlalu atas
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/beranda');
              break;
            case 1:
              Navigator.pushNamed(context, '/cari');
              break;
            case 2:
              Navigator.pushNamed(context, '/camera');
              break;
            case 3:
              Navigator.pushNamed(context, '/profil');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan Wajah'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
