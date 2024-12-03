import 'package:flutter/material.dart';
import 'package:frame_fit/pages/beranda_page.dart';

class FavoritePage extends StatelessWidget {
  final List<Glasses> favoriteGlassesList;

  FavoritePage({required this.favoriteGlassesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Produk Favorit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: favoriteGlassesList.isEmpty
          ? Center(child: Text("Tidak ada produk favorit"))
          : ListView.builder(
              itemCount: favoriteGlassesList.length,
              itemBuilder: (context, index) {
                final glasses = favoriteGlassesList[index];
                return ListTile(
                  title: Text(glasses.name),
                  subtitle: Text('Kategori: ${glasses.category}'),
                  leading: Image.asset(glasses.imagePath),
                );
              },
            ),
    );
  }
}
