import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  List<Glasses> glassesList = [];
  String selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    fetchGlasses(); // Ambil semua data kacamata di awal
  }

  Future<void> fetchGlasses({String gender = ''}) async {
    String url = '${ApiConfig.baseUrl}/api/kacamata'; // URL backend

    // Tambahkan filter gender jika kategori selain 'Semua' dipilih
    if (gender == 'male') {
      url += '?gender=male';
    } else if (gender == 'female') {
      url += '?gender=female';
    }

    try {
      final token = await getToken();

      if (token == null) {
        print('Token tidak ditemukan');
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Kirim token JWT dalam header
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          glassesList = data.map((item) => Glasses.fromJson(item)).toList();
        });
      } else {
        print('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;

      if (category == 'Koleksi Pria') {
        fetchGlasses(gender: 'male'); // Filter untuk pria
      } else if (category == 'Koleksi Wanita') {
        fetchGlasses(gender: 'female'); // Filter untuk wanita
      } else {
        fetchGlasses(gender: ''); // Ambil semua data
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header kategori
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => onCategorySelected('Semua'),
                    child: _buildCategoryTab('Semua', isSelected: selectedCategory == 'Semua'),
                  ),
                  GestureDetector(
                    onTap: () => onCategorySelected('Koleksi Pria'),
                    child: _buildCategoryTab('Koleksi Pria', isSelected: selectedCategory == 'Koleksi Pria'),
                  ),
                  GestureDetector(
                    onTap: () => onCategorySelected('Koleksi Wanita'),
                    child: _buildCategoryTab('Koleksi Wanita', isSelected: selectedCategory == 'Koleksi Wanita'),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),

            // GridView produk kacamata
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: glassesList.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
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
        currentIndex: 0,
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

  Widget _buildProductCard(Glasses glasses) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(glasses.imagePath),
                    fit: BoxFit.contain,
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
        ),
      ),
    );
  }
}

class Glasses {
  final String name;
  final String category;
  final String imagePath;

  Glasses({
    required this.name,
    required this.category,
    required this.imagePath,
  });

  factory Glasses.fromJson(Map<String, dynamic> json) {
    return Glasses(
      name: json['model'], // Ganti ke 'model' sesuai respons API
      category: json['bentuk'], // Ganti ke 'bentuk' sesuai respons API
      imagePath: json['foto'], // Properti untuk URL gambar
    );
  }
}
