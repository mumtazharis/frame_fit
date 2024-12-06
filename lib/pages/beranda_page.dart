import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/glasses_model.dart';
import '../providers/glasses_provider.dart';

class BerandaPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final glassesAsyncValue = ref.watch(glassesProvider(selectedCategory == 'Semua'
        ? ''
        : (selectedCategory == 'Koleksi Pria' ? 'male' : 'female')));

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
                  _buildCategoryTab(context, ref, 'Semua'),
                  _buildCategoryTab(context, ref, 'Koleksi Pria'),
                  _buildCategoryTab(context, ref, 'Koleksi Wanita'),
                ],
              ),
            ),
            // Pencarian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
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
            // GridView produk
            Expanded(
              child: glassesAsyncValue.when(
                data: (glassesList) {
                  final filteredList = glassesList
                      .where((glasses) => glasses.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  if (filteredList.isEmpty) {
                    return Center(child: Text('Tidak ada produk ditemukan'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final glasses = filteredList[index];
                      return _buildProductCard(glasses);
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(BuildContext context, WidgetRef ref, String label) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = label;
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: selectedCategory == label ? FontWeight.bold : FontWeight.normal,
              color: selectedCategory == label ? Colors.blue : Colors.black,
            ),
          ),
          if (selectedCategory == label)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2,
              width: 20,
              color: Colors.blue,
            ),
        ],
      ),
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
