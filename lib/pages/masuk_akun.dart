import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frame_fit/pages/loading_screen.dart';
import 'package:frame_fit/providers/masuk_provider.dart'; // Import provider

class MasukAkunPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MasukAkunPage> createState() => _MasukAkunPageState();
}

class _MasukAkunPageState extends ConsumerState<MasukAkunPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    // Panggil fungsi login dari AuthNotifier
    await ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );

    // Ambil state terbaru setelah login
    final updatedAuthState = ref.read(authProvider);

    // Lakukan navigasi jika token berhasil diperoleh
    if (updatedAuthState.accessToken != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(nextPage: 'BerandaPage'),
        ),
      );
    } else if (updatedAuthState.errorMessage != null) {
      // Jika ada error, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updatedAuthState.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 90),
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
                                labelText: 'Masukkan email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
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
                          if (authState.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                authState.errorMessage!,
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
