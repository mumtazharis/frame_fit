import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/password_validation_state.dart';
import '../config/api_config.dart';

class PasswordChangeNotifier extends StateNotifier<PasswordValidationState> {
  PasswordChangeNotifier() : super(const PasswordValidationState());

  void validatePassword(String password) {
    state = PasswordValidationState(
      hasMinLength: password.length >= 8,
      hasUppercase: password.contains(RegExp(r'[A-Z]')),
      hasLowercase: password.contains(RegExp(r'[a-z]')),
      hasDigits: password.contains(RegExp(r'\d')),
      hasSpecialChar: password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_]')),
    );
  }

  Future<Result<void>> changePassword({
    required String oldPassword, 
    required String newPassword, 
    required String confirmPassword
  }) async {
    // Input validation
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      return Result.error('Semua kolom harus diisi');
    }

    if (newPassword != confirmPassword) {
      return Result.error('Kata sandi baru dan konfirmasi password tidak cocok');
    }

    if (!state.isPasswordValid) {
      return Result.error('Kata sandi baru tidak memenuhi persyaratan');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        return Result.error('Sesi telah berakhir. Silakan login ulang.');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/users/ubah_password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'password_lama': oldPassword,
          'password_baru': newPassword,
          'konfirmasi_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        final responseBody = json.decode(response.body);
        return Result.error(responseBody['message'] ?? 'Gagal mengubah kata sandi');
      }
    } catch (e) {
      return Result.error('Terjadi kesalahan: ${e.toString()}');
    }
  }
}

// Result class for handling success and error states
class Result<T> {
  final T? _value;
  final String? _error;
  final bool _isSuccess;

  Result.success(T value) 
    : _value = value, 
      _error = null, 
      _isSuccess = true;

  Result.error(String error) 
    : _value = null, 
      _error = error, 
      _isSuccess = false;

  bool get isSuccess => _isSuccess;
  T get value => _value as T;
  String get error => _error!;
}

// Provider for password change state management
final passwordChangeProvider = StateNotifierProvider<PasswordChangeNotifier, PasswordValidationState>((ref) {
  return PasswordChangeNotifier();
});