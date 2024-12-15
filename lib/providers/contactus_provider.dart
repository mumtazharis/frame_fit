import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart'; // Ganti dengan path yang sesuai
import 'package:shared_preferences/shared_preferences.dart';

class ContactUsState {
  final String? errorMessage;
  final String? message;
  final bool isLoading;

  ContactUsState({
    this.errorMessage,
    this.message,
    this.isLoading = false,
  });

  ContactUsState copyWith({
    String? errorMessage,
    String? message,
    bool? isLoading,
  }) {
    return ContactUsState(
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ContactUsNotifier extends StateNotifier<ContactUsState> {
  ContactUsNotifier() : super(ContactUsState());
  void resetState() {
    state = state.copyWith(errorMessage: null);
    state = state.copyWith(message: null);
    state = state.copyWith(isLoading: false);
  }
  Future<void> sendMessage(String message) async {
    state = state.copyWith(isLoading: true, errorMessage: null, message: null);

    final String apiUrl = "${ApiConfig.baseUrl}/api/contact";

    try {
      // Ambil token JWT sebelum melakukan permintaan
      final token = await _getToken();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "message": message,
        }),
      );

      if (response.statusCode != 201) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final String errorMessage = responseJson['message'] ?? 'Gagal mengirim pesan.';
        state = state.copyWith(errorMessage: errorMessage);
      } else {
        // Jika berhasil, ambil pesan dari respons
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final String successMessage = responseJson['message'] ?? 'Pesan berhasil dikirim!';
        state = state.copyWith(message: successMessage);

        // Jeda sebelum mereset state
        await Future.delayed(Duration(seconds: 2));
        resetState();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Terjadi Kesalahan');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}

// Provider untuk ContactUsNotifier
final contactUsProvider = StateNotifierProvider<ContactUsNotifier, ContactUsState>((ref) {
  return ContactUsNotifier();
});
