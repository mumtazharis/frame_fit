import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model untuk kacamata favorit
class Glasses {
  final String id;
  final String name;

  Glasses({required this.id, required this.name});
}

// StateNotifier untuk mengelola daftar favorit
class FavoriteNotifier extends StateNotifier<List<Glasses>> {
  FavoriteNotifier() : super([]);

  void toggleFavorite(Glasses glasses) {
    if (state.contains(glasses)) {
      state = state.where((item) => item.id != glasses.id).toList();
    } else {
      state = [...state, glasses];
    }
  }
}

// Provider untuk daftar favorit
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Glasses>>(
  (ref) => FavoriteNotifier(),
);
