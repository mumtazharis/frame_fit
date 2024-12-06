import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class LupaPasswordPage extends StatefulWidget {
  @override
  _LupaPasswordPageState createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String? _errorText;
  String? _message;
  bool _isOtpSent = false;

  // Fungsi untuk mengirim permintaan OTP ke email
  Future<void> _sendOtpRequest() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _errorText = 'Email diperlukan';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/users/send_otp_email'),  // Endpoint untuk mengirim OTP lupa password
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _message = 'OTP telah dikirim ke email Anda.';
        _isOtpSent = true;
      });
    } else {
      final responseData = json.decode(response.body);
      setState(() {
        _message = responseData['message'] ?? 'Terjadi kesalahan atau email tidak ditemukan';
      });
    }
  }

  // Fungsi untuk mereset password menggunakan OTP
  Future<void> _resetPassword() async {
    final email = _emailController.text;
    final otp = _otpController.text;
    final newPassword = _newPasswordController.text;

    if (otp.isEmpty || newPassword.isEmpty) {
      setState(() {
        _errorText = 'OTP dan password baru diperlukan';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/users/reset_password'),  // Endpoint untuk mereset password
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _message = 'Password berhasil diperbarui';
      });
    } else {
      final responseData = json.decode(response.body);
      setState(() {
        _message = responseData['message'] ?? 'OTP salah atau kadaluarsa';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Lupa Password', style: TextStyle(fontSize: 18, color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Image.asset('assets/images/logo_pt.png', width: 175, height: 175),
                  SizedBox(height: 40),

                  // Input email untuk meminta OTP
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Masukkan email Anda',
                      labelStyle: TextStyle(color: Colors.black54),
                      errorText: _errorText,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Tombol untuk mengirim OTP
                  ElevatedButton(
                    onPressed: _sendOtpRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Kirim OTP',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Tampilkan pesan jika OTP sudah dikirim
                  if (_isOtpSent) ...[
                    Text('OTP telah dikirim ke email Anda', style: TextStyle(color: Colors.green)),
                    SizedBox(height: 20),
                    
                    // Input OTP
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Masukkan OTP',
                        labelStyle: TextStyle(color: Colors.black54),
                        errorStyle: TextStyle(color: Colors.red, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Input password baru
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Masukkan password baru',
                        labelStyle: TextStyle(color: Colors.black54),
                        errorStyle: TextStyle(color: Colors.red, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Tombol untuk mereset password
                    ElevatedButton(
                      onPressed: _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],

                  // Tampilkan pesan sukses atau error
                  if (_message != null) ...[
                    SizedBox(height: 20),
                    Text(_message!, style: TextStyle(color: _message!.contains('berhasil') ? Colors.green : Colors.red, fontSize: 16)),
                  ],

                  SizedBox(height: 20),

                  // Tombol kembali ke login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);  // Kembali ke halaman login
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Kembali ke Masuk',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
