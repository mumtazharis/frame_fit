import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/glasses_model.dart';
import '../config/api_config.dart';

// Provider untuk kategori terpilih
final selectedCategoryProvider = StateProvider<String>((ref) => 'Semua');

// Provider untuk query pencarian
final searchQueryProvider = StateProvider<String>((ref) => '');

// FutureProvider untuk daftar kacamata
final glassesProvider = FutureProvider.family<List<Glasses>, String>((ref, gender) async {
  String url = '${ApiConfig.baseUrl}/api/kacamata';
  
  // Tambahkan filter gender jika kategori selain 'Semua' dipilih
  if (gender == 'male') {
    url += '?gender=male';
  } else if (gender == 'female') {
    url += '?gender=female';
  }

  try {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Kirim token JWT dalam header
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Glasses.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
});

// Fungsi untuk mendapatkan token
Future<String?> _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}
