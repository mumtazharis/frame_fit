import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'daftar.dart';
import 'beranda.dart';
import '../config/api_config.dart';

class MasukAkunPage extends StatefulWidget {
  @override
  _MasukAkunPageState createState() => _MasukAkunPageState();
}

class _MasukAkunPageState extends State<MasukAkunPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  // Fungsi untuk mengirimkan request login ke API
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
      Uri.parse('${ApiConfig.baseUrl}/api/users/login'), // Ganti dengan endpoint login Anda
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Jika login berhasil, simpan token
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String accessToken = responseBody['access_token'];
      final String refreshToken = responseBody['refresh_token']; // Tambahkan refresh token

      // Simpan token di SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);

      // Arahkan ke halaman beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BerandaPage()),
      );
    } else {
      // Jika login gagal, tampilkan pesan error
      setState(() {
        _errorMessage = 'Email atau password salah.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent overflow when the keyboard appears
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Match height to fit content
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Logo
                          Image.asset(
                            'assets/images/logo_pt.png',
                            width: 175,
                            height: 175,
                          ),
                          SizedBox(height: 40),
                          SizedBox(height: 50),
                          // Input Email
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
                          SizedBox(height: 16),
                          // Input Password
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
                          SizedBox(height: 30),
                          // Tombol Sign In
                          ElevatedButton(
                            onPressed: _login, // Panggil fungsi login
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  const Color.fromARGB(255, 33, 72, 243),
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
                          if (_errorMessage != null) // Menampilkan pesan error
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ),
                          SizedBox(height: 30),
                          // Tombol sosial media
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  thickness: 2, 
                                  color: Colors.black, 
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text('atau masuk dengan'),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 2, 
                                  color: Colors.black, 
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Tombol sosial media
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Image.asset('assets/icon/gmail.png', width: 36, height: 36),
                              ),
                              SizedBox(width: 16),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.facebook, size: 36, color: Colors.blue),
                              ),
                              SizedBox(width: 16),
                              IconButton(
                                onPressed: () {},
                                icon: Image.asset('assets/icon/x.png', width: 36, height: 36),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // Link to Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Belum punya akun? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DaftarPage(), // Navigate to DaftarPage
                                    ),
                                  );
                                },
                                child: Text(
                                  "Daftar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
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
