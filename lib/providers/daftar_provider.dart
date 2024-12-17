import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class DaftarState {
  final bool isLoading;
  final String? errorMessage;

  DaftarState({this.isLoading = false, this.errorMessage});

  DaftarState copyWith({bool? isLoading, String? errorMessage}) {
    return DaftarState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DaftarNotifier extends StateNotifier<DaftarState> {
  DaftarNotifier() : super(DaftarState());

  Future<void> sendOtp(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final String apiUrl = "${ApiConfig.baseUrl}/api/users/sendotp";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode != 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final String errorMessage = responseJson['message'] ?? 'Gagal mengirim OTP.';
        state = state.copyWith(errorMessage: errorMessage);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Terjadi Kesalahan');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final authProvider = StateNotifierProvider<DaftarNotifier, DaftarState>((ref) {
  return DaftarNotifier();
});
