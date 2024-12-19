import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

final lupaPasswordProvider = Provider<LupaPasswordProvider>((ref) {
  return LupaPasswordProvider();
});

class LupaPasswordProvider {
  Future<String> sendOtp(String email) async {
    if (email.isEmpty) {
      return 'Email diperlukan';
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/users/sendotp_sandi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return 'OTP telah dikirim ke email Anda.';
      } else {
        final responseData = json.decode(response.body);
        return responseData['message'] ?? 'Terjadi kesalahan';
      }
    } catch (e) {
      return 'Tidak dapat terhubung ke server.';
    }
  }

  Future<String> resetPassword(String email, String otp, String newPassword) async {
    if (otp.isEmpty || newPassword.isEmpty) {
      return 'OTP dan password baru diperlukan';
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/users/reset_password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return 'Password berhasil diperbarui';
      } else {
        final responseData = json.decode(response.body);
        return responseData['message'] ?? 'OTP salah atau kadaluarsa';
      }
    } catch (e) {
      return 'Tidak dapat terhubung ke server.';
    }
  }
}
