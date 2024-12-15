import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/glasses_model.dart';
import '../config/api_config.dart';

final glassesProvider = StateNotifierProvider<GlassesNotifier, List<Glasses>>((ref) {
  return GlassesNotifier();
});

class GlassesNotifier extends StateNotifier<List<Glasses>> {
  GlassesNotifier() : super([]);

  Future<void> fetchGlasses({String gender = ''}) async {
    String url = '${ApiConfig.baseUrl}/api/kacamata';

    if (gender == 'male') {
      url += '?gender=male';
    } else if (gender == 'female') {
      url += '?gender=female';
    }

    try {
      final token = await _getToken();

      if (token == null) {
        print('Token tidak ditemukan');
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        state = data.map((item) => Glasses.fromJson(item)).toList();
      } else {
        print('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  void toggleFavorite(Glasses glasses) {
    state = state.map((item) {
      if (item == glasses) {
        return item.copyWith(isFavorite: !item.isFavorite);
      }
      return item;
    }).toList();
  }
}
