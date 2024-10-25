import 'package:flutter/material.dart';

class CariPage extends StatefulWidget {
  @override
  _CariPageState createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  final TextEditingController _CariController = TextEditingController();
  List<String> _CariResults = [];

  // Daftar contoh data produk untuk pencarian
  List<String> _products = [
    'Kacamata Bulat',
    'Kacamata Bulat Cowok',
    'Kacamata Bulat Cewek',
    'Kacamata Bulat Pink',
    'Kacamata Olahraga Bulat',
    'Kacamata Aviator',
    'Kacamata Aviator Bulat',
  ];

  void _onCariChanged(String query) {
    setState(() {
      // Filter produk berdasarkan query pencarian
      _CariResults = _products
          .where((product) => product.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tanda panah kembali
        backgroundColor: Colors.white,
        title: TextField(
          controller: _CariController,
          decoration: InputDecoration(
            hintText: 'Cari Product',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.black),
            suffixIcon: _CariController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _CariController.clear();
                        _CariResults.clear();
                      });
                    },
                  )
                : null,
          ),
          onChanged: _onCariChanged,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Membatalkan pencarian dan kembali ke halaman sebelumnya
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: _CariResults.isEmpty
          ? Center(child: Text('No results found', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: _CariResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_CariResults[index]),
                  onTap: () {
                    // Implementasi logika saat produk dipilih
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        currentIndex: 1,
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
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan Wajah'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
