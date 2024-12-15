import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier() : super('');

  void updateSearchQuery(String query) {
    state = query;
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, String>((ref) => SearchNotifier());
