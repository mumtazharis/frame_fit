import 'dart:convert'; // Untuk jsonEncode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'daftar_verifikasi.dart'; // Pastikan path file benar

class DaftarPage extends StatefulWidget {
  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  bool _isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false; // Tambahkan ini untuk status loading

  // Fungsi untuk mengirim permintaan OTP
  Future<void> sendOtp(String email) async {
    setState(() {
      _isLoading = true; // Set status loading ke true
    });

    final String apiUrl = "${ApiConfig.baseUrl}/api/users/sendotp";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP telah dikirim ke $email')),
        );

        // Navigasi ke halaman verifikasi
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DaftarVerifikasi(email: email),
          ),
        );
      } else {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String errorMessage = responseJson['message'] ?? 'Gagal mengirim OTP. Coba lagi nanti.';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      String errorMessage = 'Kesalahan terjadi saat mengirim OTP: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set status loading kembali ke false
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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logo_pt.png',
                            width: 175,
                            height: 175,
                          ),
                          SizedBox(height: 70),
                          Container(
                            width: 350,
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {
                                  if (!value.endsWith('@gmail.com')) {
                                    _errorMessage = 'Email harus diakhiri dengan @gmail.com';
                                  } else {
                                    _errorMessage = null;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Masukkan email Anda untuk daftar atau masuk',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.person),
                                errorText: _errorMessage,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: 360,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value ?? false;
                                    });
                                  },
                                  activeColor: Color.fromARGB(255, 33, 72, 243),
                                ),
                                Expanded(
                                  child: Text(
                                    'Dengan membuat akun, Anda menyetujui Ketentuan Penggunaan dan Kebijakan Privasi.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          _isLoading
                              ? CircularProgressIndicator() // Tampilkan loading jika sedang memproses
                              : ElevatedButton(
                                  onPressed: (_isChecked &&
                                          _errorMessage == null &&
                                          _emailController.text.endsWith('@gmail.com'))
                                      ? () {
                                          sendOtp(_emailController.text); // Panggil fungsi sendOtp
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                                  ),
                                  child: Text(
                                    'Lanjut',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                          SizedBox(height: 30),
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
                                child: Text('atau lanjutkan dengan'),
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
