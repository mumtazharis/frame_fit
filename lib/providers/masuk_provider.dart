import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class MasukState {
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;

  MasukState({this.accessToken, this.refreshToken, this.errorMessage});
}

class MasukNotifier extends StateNotifier<MasukState> {
  MasukNotifier() : super(MasukState());

  Future<void> login(String email, String password) async {
    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      state = MasukState(errorMessage: 'Email dan password tidak boleh kosong.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': email,
          'password': password,
        }),
      );

      // Cek status response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String accessToken = responseBody['access_token'];
        final String refreshToken = responseBody['refresh_token'];

        // Simpan token ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        // Update state dengan token baru
        state = MasukState(accessToken: accessToken, refreshToken: refreshToken);

        
      } else {
        state = MasukState(errorMessage: 'Email atau password salah.');
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau lainnya
      state = MasukState(errorMessage: 'Terjadi kesalahan');
    }
  }
}

// Provider untuk MasukNotifier
final authProvider = StateNotifierProvider<MasukNotifier, MasukState>((ref) {
  return MasukNotifier();
});
