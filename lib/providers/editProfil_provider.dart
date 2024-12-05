import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frame_fit/config/api_config.dart';

// Model untuk menyimpan data profil
class EditProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImageUrl;

  EditProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImageUrl,
  });

  factory EditProfile.fromJson(Map<String, dynamic> json) {
    return EditProfile(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      profileImageUrl: json['foto_profil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}

// Provider untuk menyimpan data pengguna
final editProfileProvider = StateNotifierProvider<EditProfileNotifier, EditProfile?>((ref) {
  return EditProfileNotifier();
});

// StateNotifier untuk mengelola status profile
class EditProfileNotifier extends StateNotifier<EditProfile?> {
  EditProfileNotifier() : super(null);

  Future<void> fetchProfile() async {
    final token = await _getToken();
    if (token == null) return;

    final url = '${ApiConfig.baseUrl}/api/profile';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      state = EditProfile.fromJson(data);
    } else {
      print('Failed to fetch profile: ${response.statusCode}');
    }
  }

  Future<void> updateProfile(EditProfile profile) async {
    final token = await _getToken();
    if (token == null) return;

    final url = '${ApiConfig.baseUrl}/api/profile/edit';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      state = profile;
    } else {
      print('Failed to update profile: ${response.statusCode}');
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
