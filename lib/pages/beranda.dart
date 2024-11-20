import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Mencegah konten tertutup status bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan padding lebih baik
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryTab('Semua', isSelected: true),
                  _buildCategoryTab('Koleksi Pria'),
                  _buildCategoryTab('Koleksi Wanita'),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),

            // Daftar produk kacamata
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Menampilkan 2 kolom
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75, // Proporsi elemen dalam grid
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: 0, // Tab aktif
        onTap: (index) {
          // Navigasi ke tab berdasarkan index
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade200,
              image: DecorationImage(
                image: AssetImage(glasses.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          glasses.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        Text(
          glasses.category,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
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

  Glasses({
    required this.name,
    required this.category,
    required this.imagePath,
  });
}

// Daftar produk kacamata
final List<Glasses> glassesList = [
  Glasses(
    name: 'Aviator Glasses',
    category: 'Pria',
    imagePath: 'assets/images/aviator.jpg',
  ),
  Glasses(
    name: 'Ray-Ban Wayfarer Glasses',
    category: 'Pria',
    imagePath: 'assets/images/wayfarer.jpg',
  ),
  Glasses(
    name: 'Hexagonal Pink Glasses',
    category: 'Wanita',
    imagePath: 'assets/images/hexagonal.jpg',
  ),
  Glasses(
    name: 'Black Bold Square Glasses',
    category: 'Wanita',
    imagePath: 'assets/images/square.jpg',
  ),
];
