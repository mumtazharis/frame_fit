import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/glasses_provider.dart';
import '../widgets/glasses_card.dart';

class BerandaPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glassesList = ref.watch(glassesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header kategori
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (query) {
                  // Implementasi pencarian lokal jika perlu
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
            Expanded(
              child: glassesList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: glassesList.length,
                      itemBuilder: (context, index) {
                        final glasses = glassesList[index];
                        return GlassesCard(
                          glasses: glasses,
                          onTap: () {
                            // Tampilkan detail popup
                          },
                          onFavoriteToggle: () {
                            ref.read(glassesProvider.notifier).toggleFavorite(glasses);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
