import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNotifier extends StateNotifier<bool> {
  FavoriteNotifier() : super(false);

  void toggleFavorite() {
    state = !state;
  }

  void setFavoriteStatus(bool isFavorite) {
    state = isFavorite;
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, bool>(
  (ref) => FavoriteNotifier(),
);
