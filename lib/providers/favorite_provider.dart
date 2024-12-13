import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/glasses_model.dart';
import '../config/api_config.dart';

class FavoriteNotifier extends StateNotifier<List<Glasses>> {
  FavoriteNotifier() : super([]);

  Future<bool> toggleFavorite(Glasses glasses) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final isFavorite = state.any((item) => item.kacamata_id == glasses.kacamata_id);
      final endpoint = isFavorite
          ? '${ApiConfig.baseUrl}/api/bookmark/${glasses.kacamata_id}'
          : '${ApiConfig.baseUrl}/api/bookmark';

      final response = isFavorite
          ? await http.delete(
              Uri.parse(endpoint),
              headers: {
                'Authorization': 'Bearer $token',
              },
            )
          : await http.post(
              Uri.parse(endpoint),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: json.encode({'kacamata_id': glasses.kacamata_id}),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isFavorite) {
          state = state.where((item) => item.kacamata_id != glasses.kacamata_id).toList();
        } else {
          state = [...state, glasses];
        }
        return true;
      } else {
        print('Failed to update favorites: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error updating favorites: $e');
    }
    return false;
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Glasses>>(
  (ref) => FavoriteNotifier(),
);
