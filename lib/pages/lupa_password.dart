import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lupaPassword_provider.dart';
import 'masuk_akun.dart';

class LupaPasswordPage extends ConsumerStatefulWidget {
  @override
  _LupaPasswordPageState createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends ConsumerState<LupaPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String? _errorText;
  String? _message;
  bool _isOtpSent = false;
  bool _isLoading = false;

  Future<void> _sendOtpRequest() async {
    final email = _emailController.text;

    setState(() {
      _isLoading = true;
      _errorText = null;
      _message = null;
    });

    final provider = ref.read(lupaPasswordProvider);
    final result = await provider.sendOtp(email);

    setState(() {
      _message = result;
      _isOtpSent = result == 'OTP telah dikirim ke email Anda.';
      _isLoading = false;
    });
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text;
    final otp = _otpController.text;
    final newPassword = _newPasswordController.text;

    setState(() {
      _isLoading = true;
      _errorText = null;
      _message = null;
    });

    final provider = ref.read(lupaPasswordProvider);
    final result = await provider.resetPassword(email, otp, newPassword);

    setState(() {
      _message = result;
      _isLoading = false;
    });

    if (result == 'Password berhasil diperbarui') {
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MasukAkunPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 72, 243),
        title: Text('Lupa Kata Sandi', style: TextStyle(fontSize: 18, color: Colors.white)),
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

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Masukkan email Anda',
                      labelStyle: TextStyle(color: Colors.black54),
                      errorText: _errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color.fromARGB(255, 33, 72, 243)),
                      ),
                      prefixIcon: Icon(Icons.email, color: const Color.fromARGB(255, 33, 72, 243)),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtpRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Kirim OTP',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                  SizedBox(height: 20),

                  if (_isOtpSent) ...[
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Masukkan OTP',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: const Color.fromARGB(255, 33, 72, 243)),
                        ),
                        prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 33, 72, 243)),
                      ),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Masukkan kata sandi baru',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: const Color.fromARGB(255, 33, 72, 243)),
                        ),
                        prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 33, 72, 243)),
                      ),
                    ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Reset Kata Sandi',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ],

                  if (_message != null) ...[
                    SizedBox(height: 20),
                    Text(
                      _message!,
                      style: TextStyle(
                        color: _message!.contains('berhasil') ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
