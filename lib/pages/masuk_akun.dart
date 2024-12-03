import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:frame_fit/pages/navbar.dart';

class MasukAkunPage extends StatefulWidget {
  @override
  _MasukAkunPageState createState() => _MasukAkunPageState();
}

class _MasukAkunPageState extends State<MasukAkunPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password tidak boleh kosong.';
      });
      return;
    }

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

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String accessToken = responseBody['access_token'];
      final String refreshToken = responseBody['refresh_token']; // Tambahkan refresh token

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavbarPage(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Email atau password salah.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, // Posisi elemen ke atas
                        children: <Widget>[
                          // Menggeser logo lebih kebawah
                          SizedBox(height: 90), // Menambah jarak lebih besar dari atas
                          Image.asset(
                            'assets/images/logo_pt.png',
                            width: 175,
                            height: 175,
                          ),
                          // Menambah jarak setelah logo
                          SizedBox(height: 80), // Jarak lebih besar setelah logo
                          Container(
                            width: 350,
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Masukkan email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                          ),
                          SizedBox(height: 16), // Jarak antar input
                          Container(
                            width: 350,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Masukkan password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30), // Jarak sebelum tombol
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                            ),
                            child: Text(
                              'Masuk',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
