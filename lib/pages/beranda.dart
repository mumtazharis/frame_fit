import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menambahkan SizedBox untuk memberi jarak di bagian atas
          SizedBox(height: 20), // Sesuaikan nilai height untuk jarak yang diinginkan

          // Bagian tab pilihan koleksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryTab('Semua', isSelected: true),
                _buildCategoryTab('Koleksi Pria'),
                _buildCategoryTab('Koleksi Wanita'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(thickness: 1),

          // Bagian daftar produk kacamata
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Menampilkan 2 kolom
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75, // Memperbaiki proporsi item
                ),
                itemCount: glassesList.length,
                itemBuilder: (context, index) {
                  final glasses = glassesList[index];
                  return _buildProductCard(glasses);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        currentIndex: 0, // Home sebagai tab aktif
        onTap: (index) {
          // Navigasi berdasarkan index yang dipilih
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'Scan Wajah'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Widget untuk tab kategori koleksi
  Widget _buildCategoryTab(String label, {bool isSelected = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            height: 2,
            width: 20,
            color: Colors.blue,
          ),
      ],
    );
  }

  // Widget untuk kartu produk kacamata
  Widget _buildProductCard(Glasses glasses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            glasses.imagePath,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5),
        Text(
          glasses.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3),
        Text(
          glasses.category,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

// Model produk kacamata
class Glasses {
  final String name;
  final String category;
  final String imagePath;

  Glasses({required this.name, required this.category, required this.imagePath});
}

// Daftar produk kacamata
final List<Glasses> glassesList = [
  Glasses(
      name: 'Aviator Glasses',
      category: 'Pria',
      imagePath: 'assets/images/aviator.jpg'),
  Glasses(
      name: 'Ray-Ban Wayfarer Glasses',
      category: 'Pria',
      imagePath: 'assets/images/wayfarer.jpg'),
  Glasses(
      name: 'Hexagonal Pink Glasses',
      category: 'Wanita',
      imagePath: 'assets/images/hexagonal.jpg'),
  Glasses(
      name: 'Black Bold Square Glasses',
      category: 'Wanita',
      imagePath: 'assets/images/square.jpg'),
];
