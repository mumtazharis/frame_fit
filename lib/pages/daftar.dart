import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/daftar_provider.dart';
import 'daftar_verifikasi.dart';
import 'ketentuan.dart';
import 'kebijakan.dart';

class DaftarPage extends ConsumerStatefulWidget {
  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends ConsumerState<DaftarPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isCheckboxChecked = false;
  String? _errorText;

  void _validateEmail(String value) {
    if (!value.endsWith('@gmail.com')) {
      setState(() {
        _errorText = 'Email harus diakhiri dengan @gmail.com';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

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
                        mainAxisAlignment: MainAxisAlignment.start, // Elemen mulai dari atas
                        children: <Widget>[
                          SizedBox(height: 150),
                          Image.asset(
                            'assets/images/logo_pt.png',
                            width: 175,
                            height: 175,
                          ),
                          SizedBox(height: 80),
                          Container(
                            width: 350,
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Masukkan email Anda untuk daftar atau masuk',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.person),
                                errorText: _errorText,
                              ),
                              onChanged: _validateEmail,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: 350,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isCheckboxChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckboxChecked = value!;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Dengan membuat akun, Anda menyetujui ',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: 'Ketentuan Penggunaan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => KetentuanPage(),
                                                  ),
                                                );
                                              },
                                          ),
                                          TextSpan(
                                            text: ' dan ',
                                          ),
                                          TextSpan(
                                            text: 'Kebijakan Privasi',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => KebijakanPage(),
                                                  ),
                                                );
                                              },
                                          ),
                                          TextSpan(
                                            text: '.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          authState.isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: (_isCheckboxChecked && _errorText == null)
                                      ? () async {
                                          await authNotifier.sendOtp(_emailController.text);
                                          if (authState.errorMessage == null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DaftarVerifikasi(
                                                  email: _emailController.text,
                                                ),
                                              ),
                                            );
                                          }
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
