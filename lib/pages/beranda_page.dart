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
  String searchQuery = '';

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

  void _showGlassesDetailPopup(Glasses glasses) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool isFavorite = glasses.isFavorite; // Awal status favorit adalah false

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 300,
              height: 280,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris atas dengan judul dan tombol close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Detail Produk",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  Row(
                    children: [
                      // Gambar di sebelah kiri
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(glasses.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              glasses.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kategori: ${glasses.category}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  // Row untuk tombol "Coba" dan tombol "Love"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol "Coba"
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Menutup dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Coba',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Tombol "Love"
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              glasses.isFavorite = !isFavorite; // Toggle status favorit
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );}

  @override
  Widget build(BuildContext context) {
    List<Glasses> displayedGlassesList = glassesList
        .where((glasses) =>
            glasses.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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
            // Pencarian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
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
    return GestureDetector(
      onTap: () {
        _showGlassesDetailPopup(glasses); // Memanggil pop-up saat produk diklik
      },
      child: Container(
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
      ),
    );
  }
}

class Glasses {
  final String name;
  final String category;
  final String imagePath;
  bool isFavorite;

  Glasses({
    required this.name,
    required this.category,
    required this.imagePath,
    this.isFavorite = false,
  });

  factory Glasses.fromJson(Map<String, dynamic> json) {
    return Glasses(
      name: json['model'], // Ganti ke 'model' sesuai respons API
      category: json['bentuk'], // Ganti ke 'bentuk' sesuai respons API
      imagePath: json['foto'], // Properti untuk URL gambar
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
