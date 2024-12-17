import 'dart:async';
import 'package:flutter/material.dart';
import 'daftar_berhasil.dart'; 
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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

  // Tambahkan method hash password
  String _hashPassword(String password) {
    // Gunakan SHA-256 untuk hash password
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;  // Menampilkan indikator loading saat request sedang berlangsung
    });

    // Menyiapkan data yang akan dikirim ke server
    final String email = widget.email;
    final String otp = _codeController.text;
    final String password = _passwordController.text;
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    // Hash password sebelum dikirim
    final String hashedPassword = _hashPassword(password);

    final Map<String, dynamic> data = {
      'email': email,
      'otp': otp,
      'password': hashedPassword,
      'first_name': firstName,
      'last_name': lastName,
    };

    final Uri url = Uri.parse('${ApiConfig.baseUrl}/api/users/register'); // Ganti dengan URL API Anda

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // Jika registrasi berhasil, arahkan ke halaman berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DaftarBerhasil(),
          ),
        );
      } else {
        // Jika terjadi kesalahan, tampilkan pesan kesalahan
        final Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Terjadi kesalahan')),
        );
      }
    } catch (error) {
      // Menangani kesalahan saat mengirim request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;  // Menyembunyikan indikator loading setelah request selesai
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true; // Menampilkan indikator loading
    });

    final String email = widget.email;

    final Map<String, dynamic> data = {
      'email': email,
    };

    final Uri url = Uri.parse('${ApiConfig.baseUrl}/api/users/sendotp'); // Ganti dengan URL API Anda

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Jika permintaan berhasil, mulai ulang timer
        setState(() {
          _resendTimer = 30;
          _startResendTimer();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP berhasil dikirim ulang')),
        );
      } else {
        // Jika terjadi kesalahan
        final Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Terjadi kesalahan saat mengirim ulang OTP')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Menyembunyikan indikator loading setelah request selesai
      });
    }
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
      _isCodeValid = _codeController.text.length == 6;
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
                  // keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) => _validateForm(),
                  decoration: InputDecoration(
                    labelText: 'Kode',
                    border: OutlineInputBorder(),
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
                              // Kirim ulang OTP
                              _resendOtp(); // Memanggil fungsi resend OTP
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
                            // Panggil fungsi untuk registrasi user
                            _registerUser();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 135, vertical: 20),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)  // Menampilkan loading jika sedang request
                        : Text(
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
