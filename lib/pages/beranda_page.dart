import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/glasses_provider.dart';
import '../providers/glasses_detail_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/selectedCategoryProvider.dart';
import '../widgets/category_tab.dart';
import '../widgets/product_card.dart';
import '../models/glasses_model.dart';

class BerandaPage extends ConsumerWidget {
  const BerandaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glassesList = ref.watch(glassesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

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
                  CategoryTab(
                    label: 'Semua',
                    isSelected: selectedCategory == 'Semua',
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).updateCategory('Semua');
                      ref.read(glassesProvider.notifier).fetchGlasses(gender: '');
                    },
                  ),
                  CategoryTab(
                    label: 'Koleksi Pria',
                    isSelected: selectedCategory == 'Koleksi Pria',
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).updateCategory('Koleksi Pria');
                      ref.read(glassesProvider.notifier).fetchGlasses(gender: 'male');
                    },
                  ),
                  CategoryTab(
                    label: 'Koleksi Wanita',
                    isSelected: selectedCategory == 'Koleksi Wanita',
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).updateCategory('Koleksi Wanita');
                      ref.read(glassesProvider.notifier).fetchGlasses(gender: 'female');
                    },
                  ),
                ],
              ),
            ),

            // GridView produk kacamata
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: glassesList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
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
                          return ProductCard(
                            glasses: glasses,
                            onTap: () {
                              _showGlassesDetailPopup(context, glasses, ref);
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menampilkan detail produk dalam pop-up
  void _showGlassesDetailPopup(BuildContext context, Glasses glasses, WidgetRef ref) {
    // Set detail produk yang dipilih
    ref.read(glassesDetailProvider.notifier).setGlassesDetail(glasses);
    ref.read(favoriteProvider.notifier).setFavoriteStatus(glasses.isFavorite);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            // Mendapatkan status favorit dari provider
            bool isFavorite = ref.watch(favoriteProvider);

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
                        const Text(
                          "Detail Produk",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                        const SizedBox(width: 16),
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
                    const Spacer(),
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
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            child: const Center(
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
                        const SizedBox(width: 16),
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
                              ref.read(favoriteProvider.notifier).toggleFavorite();
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
    );
  }
}
