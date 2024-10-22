import 'dart:ui';
import 'package:flutter/material.dart';

class DaftarPage extends StatefulWidget {
  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  bool _isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Mencegah overflow saat keyboard muncul
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Menyesuaikan tinggi tampilan
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Logo dari assets
                          Image.asset(
                            'assets/images/logo_pt.png',
                            width: 175,
                            height: 175,
                          ),
                          SizedBox(height: 70),
                          // Input Username atau Email dengan ukuran yang lebih kecil
                          Container(
                            width: 350, // Lebar kotak input yang lebih kecil
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress, 
                              onChanged: (value) {
                                setState(() {
                                  // Memeriksa apakah email berakhiran @gmail.com
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
                                errorText: _errorMessage, // Tampilkan pesan error jika tidak sesuai
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Checkbox untuk persetujuan Terms of use dan Privacy Policy
                          Container(
                            width: 350,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value ?? false;
                                    });
                                  },
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
                          // Tombol Next
                          ElevatedButton(
                            onPressed: (_isChecked && _errorMessage == null && _emailController.text.endsWith('@gmail.com'))
                                ? () {
                                    // Aksi jika checkbox sudah dicentang dan email valid
                                    print("Lanjut ke halaman berikutnya");
                                  }
                                : null, // Tombol akan disable jika checkbox belum dicentang atau email tidak valid
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 150, vertical: 25),
                            ),
                            child: Text(
                              'Lanjut',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 30),
                          // Garis pemisah
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
