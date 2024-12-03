import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Hilangkan bayangan
        leadingWidth: 80, 
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          // Tombol Simpan diaktifkan
          TextButton(
            onPressed: null,
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.grey), // Ubah warna teks menjadi biru
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.camera_alt, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              
              // Tombol untuk mengganti foto profil
              Center(
                child: TextButton(
                  onPressed: () {
                    // Tambahkan aksi untuk mengganti foto profil
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Kotak untuk First Name dan Last Name
              Row(
                children: [
                  Expanded(
                    child: _buildTextFieldContainer('Nama Awal', 'Joko'),
                  ),
                  const SizedBox(width: 16), // Beri jarak antara kedua kotak
                  Expanded(
                    child: _buildTextFieldContainer('Nama Akhir', 'Tingkir'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Kotak untuk Email
              _buildTextFieldContainer('Email', 'Baputritaz@polinema.ac.id'),
              const SizedBox(height: 8),
              // Kotak untuk Phone Number
              _buildTextFieldContainer('Nomor HP', '+62 822 2899 8041'),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun kotak dengan TextField
  Widget _buildTextFieldContainer(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // Border kotak
            borderRadius: BorderRadius.circular(8.0), // Sudut kotak
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: placeholder, // Tampilkan placeholder
              border: InputBorder.none, // Hilangkan border default TextField
              contentPadding: const EdgeInsets.all(8.0), // Padding dalam kotak
            ),
          ),
        ),
        const SizedBox(height: 16), // Beri jarak antar field
      ],
    );
  }
}
