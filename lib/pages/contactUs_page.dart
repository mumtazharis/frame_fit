import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
              'Kontak Kami',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              // Name Input
              Container(
                width: double.infinity,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email Input
              Container(
                width: double.infinity,
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Message Input
              Container(
                width: double.infinity,
                child: TextField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Apa yang ingin Anda katakan?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika untuk mengirim data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message sent!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Send',
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
}
