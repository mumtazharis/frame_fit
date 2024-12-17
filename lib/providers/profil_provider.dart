import 'dart:convert';
import 'package:frame_fit/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State untuk Profile
class ProfileState {
  final Map<String, dynamic>? profile;
  final String? error;

  ProfileState({this.profile, this.error});

  ProfileState copyWith({Map<String, dynamic>? profile, String? error}) {
    return ProfileState(
      profile: profile ?? this.profile,
      error: error ?? this.error,
    );
  }
}

// Notifier untuk Profile
class ProfileNotifier extends AsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() async {
    return await _fetchProfile();
  }

  // Memuat profil dari API
  Future<ProfileState> _fetchProfile() async {
    final token = await _getToken();
    if (token == null) {
      return ProfileState(error: 'Token tidak ditemukan');
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProfileState(profile: data);
      } else {
        return ProfileState(error: 'Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      return ProfileState(error: 'Error: $e');
    }
  }

  // Memperbarui profil secara manual
  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchProfile());
  }
}

// Provider untuk Profile
final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, ProfileState>(() => ProfileNotifier());

// Fungsi untuk mendapatkan token
Future<String?> _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}
