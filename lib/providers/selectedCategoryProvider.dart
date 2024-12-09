import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedCategoryNotifier extends StateNotifier<String> {
  SelectedCategoryNotifier() : super('Semua');

  void updateCategory(String category) {
    state = category;
  }
}

final selectedCategoryProvider =
    StateNotifierProvider<SelectedCategoryNotifier, String>(
  (ref) => SelectedCategoryNotifier(),
);
