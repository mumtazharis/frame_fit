import 'dart:async';
import 'package:flutter/material.dart';

class DaftarVerifikasi extends StatefulWidget {
  final String email;

  DaftarVerifikasi({required this.email});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<DaftarVerifikasi> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isCodeValid = false;
  bool _isPasswordValid = false;
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;
  
  // Variabel untuk mengatur visibilitas kata sandi
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isCodeValid = _codeController.text.length == 5;
      _isFirstNameValid = _firstNameController.text.isNotEmpty;
      _isLastNameValid = _lastNameController.text.isNotEmpty;
      _isPasswordValid = _passwordController.text.length >= 8 &&
          _passwordController.text.contains(RegExp(r'[A-Z]')) &&
          _passwordController.text.contains(RegExp(r'[a-z]')) &&
          _passwordController.text.contains(RegExp(r'[0-9]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo_pt.png', // Path ke logo
                    width: 175, // Sesuaikan ukuran logo
                    height: 175,
                  ),
                ),
                SizedBox(height: 50),
                // Teks informasi pengiriman kode
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(
                    "Kami telah mengirimkan kode ke",
                    style: TextStyle(fontSize: 16),
                  ),],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.email,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // Aksi untuk mengedit email
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Input Kode Verifikasi
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  onChanged: (value) => _validateForm(),
                  decoration: InputDecoration(
                    labelText: 'Kode',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _resendTimer == 0
                          ? () {
                              setState(() {
                                _resendTimer = 30;
                                _startResendTimer();
                              });
                            }
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 1),
                _resendTimer > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text('Kirim ulang dalam $_resendTimer detik')]
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Aksi kirim ulang kode jika waktunya habis
                              setState(() {
                                _resendTimer = 30;
                                _startResendTimer();
                              });
                            },
                            child: Text('Kirim Ulang Sekarang'),
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                // Input Nama Depan dan Nama Belakang dalam satu baris
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _firstNameController,
                        onChanged: (value) => _validateForm(),
                        decoration: InputDecoration(
                          labelText: 'Nama Depan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _lastNameController,
                        onChanged: (value) => _validateForm(),
                        decoration: InputDecoration(
                          labelText: 'Nama Belakang',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Input Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (value) => _validateForm(),
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Pesan validasi di bawah kolom password
                    Row(
                      children: [
                        Icon(
                          _passwordController.text.length >= 8
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _passwordController.text.length >= 8
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Minimal 8 karakter',
                          style: TextStyle(
                            color: _passwordController.text.length >= 8
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _passwordController.text.contains(RegExp(r'[A-Z]')) &&
                                  _passwordController.text.contains(RegExp(r'[a-z]')) &&
                                  _passwordController.text.contains(RegExp(r'[0-9]'))
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _passwordController.text.contains(RegExp(r'[A-Z]')) &&
                                  _passwordController.text.contains(RegExp(r'[a-z]')) &&
                                  _passwordController.text.contains(RegExp(r'[0-9]'))
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Terdiri dari huruf besar, huruf kecil, dan satu angka',
                          style: TextStyle(
                            color: _passwordController.text.contains(RegExp(r'[A-Z]')) &&
                                    _passwordController.text.contains(RegExp(r'[a-z]')) &&
                                    _passwordController.text.contains(RegExp(r'[0-9]'))
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Tombol Daftar
                Center(
                  child: ElevatedButton(
                    onPressed: (_isCodeValid && _isPasswordValid && _isFirstNameValid && _isLastNameValid)
                        ? () {
                            // Aksi jika semua validasi terpenuhi
                            print("Akun berhasil dibuat!");
                          }
                        : null, // Disable jika tidak valid
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 135, vertical: 20),
                    ),
                    child: Text(
                      'Buat Akun',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
