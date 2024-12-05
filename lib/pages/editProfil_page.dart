import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frame_fit/providers/editProfil_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    await ref.read(editProfileProvider.notifier).fetchProfile();
  }

  Future<void> _updateProfile() async {
    final profile = EditProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
    );

    await ref.read(editProfileProvider.notifier).updateProfile(profile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    // Memanfaatkan Riverpod untuk mendengarkan perubahan state
    final profile = ref.watch(editProfileProvider);

    // Jika profil belum ada (loading), tampilkan CircularProgressIndicator
    if (profile == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
            TextButton(
              onPressed: null, // Tidak aktifkan Simpan selama loading
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Jika data profil sudah ada, tampilkan form
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          TextButton(
            onPressed: _updateProfile,
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.blue),
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
                  backgroundImage: profile.profileImageUrl != null
                      ? NetworkImage(profile.profileImageUrl!)
                      : null,
                  child: profile.profileImageUrl == null
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Aksi untuk mengganti foto profil
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildTextFieldContainer('Nama Awal', firstNameController, profile.firstName),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextFieldContainer('Nama Akhir', lastNameController, profile.lastName),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextFieldContainer('Email', emailController, profile.email),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer(String label, TextEditingController controller, String initialValue) {
    controller.text = initialValue; // Menetapkan nilai awal dari provider
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
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
