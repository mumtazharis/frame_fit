import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frame_fit/providers/ubahPassword_provider.dart';

class UbahPasswordPage extends ConsumerStatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  _UbahPasswordPageState createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends ConsumerState<UbahPasswordPage> {
  final TextEditingController _passwordLamaController = TextEditingController();
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController = TextEditingController();

  bool _isPasswordLamaVisible = false;
  bool _isPasswordBaruVisible = false;
  bool _isKonfirmasiPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(passwordChangeProvider.notifier).resetValidation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordState = ref.watch(passwordChangeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],      
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah Kata Sandi',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Kata Sandi Lama
              _buildPasswordTextField(
                controller: _passwordLamaController,
                labelText: 'Kata Sandi Lama',
                isVisible: _isPasswordLamaVisible,
                onVisibilityToggle: () => setState(() {
                  _isPasswordLamaVisible = !_isPasswordLamaVisible;
                }),
              ),
              const SizedBox(height: 24),

              // Kata Sandi Baru
              _buildPasswordTextField(
                controller: _passwordBaruController,
                labelText: 'Kata Sandi Baru',
                isVisible: _isPasswordBaruVisible,
                onChanged: (password) {
                  ref.read(passwordChangeProvider.notifier).validatePassword(password);
                },
                onVisibilityToggle: () => setState(() {
                  _isPasswordBaruVisible = !_isPasswordBaruVisible;
                }),
              ),
              const SizedBox(height: 8),
              
              // Password Requirement Rows
              _buildPasswordRequirementRow('Minimum 8 karakter', passwordState.hasMinLength),
              _buildPasswordRequirementRow('Mengandung huruf besar', passwordState.hasUppercase),
              _buildPasswordRequirementRow('Mengandung huruf kecil', passwordState.hasLowercase),
              _buildPasswordRequirementRow('Mengandung angka', passwordState.hasDigits),
              const SizedBox(height: 16),

              // Konfirmasi Kata Sandi Baru
              _buildPasswordTextField(
                controller: _konfirmasiPasswordController,
                labelText: 'Konfirmasi Kata Sandi Baru',
                isVisible: _isKonfirmasiPasswordVisible,
                onVisibilityToggle: () => setState(() {
                  _isKonfirmasiPasswordVisible = !_isKonfirmasiPasswordVisible;
                }),
              ),
              const SizedBox(height: 24),
              
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handlePasswordChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    Function(String)? onChanged,
  }) {
    return Container(
      width: 350,
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onVisibilityToggle,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirementRow(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined, 
          color: isValid ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text, 
          style: TextStyle(
            color: isValid ? Colors.green : Colors.grey, 
            fontSize: 12
          ),
        ),
      ],
    );
  }

  void _handlePasswordChange() async {
    setState(() { _isLoading = true; });

    final result = await ref.read(passwordChangeProvider.notifier).changePassword(
      oldPassword: _passwordLamaController.text, 
      newPassword: _passwordBaruController.text, 
      confirmPassword: _konfirmasiPasswordController.text,
    );

    setState(() { _isLoading = false; });

    if (result.isSuccess) {
      _showSuccessDialog('Kata sandi berhasil diubah');
    } else {
      _showErrorDialog(result.error);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Berhasil'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }
}