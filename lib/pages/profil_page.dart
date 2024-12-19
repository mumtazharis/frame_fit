import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frame_fit/pages/aboutUs_page.dart';
import 'package:frame_fit/pages/contactUs_page.dart';
import 'package:frame_fit/pages/ubahPassword_page.dart';
import 'package:frame_fit/pages/editProfil_page.dart';
import 'package:frame_fit/providers/profil_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Refresh data profil saat halaman dimuat
    Future.microtask(() => ref.read(profileProvider.notifier).refreshProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: profileState.when(
        data: (state) {
          if (state.profile != null) {
            final profile = state.profile!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profile['foto_profil'] != null
                          ? NetworkImage(profile['foto_profil'])
                          : null,
                      child: profile['foto_profil'] == null
                          ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${profile['first_name']} ${profile['last_name']}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile['email'] ?? 'Email tidak tersedia',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfilePage()),
                          );
                          if (result == true) {
                            ref.read(profileProvider.notifier).refreshProfile();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 33, 72, 243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Ubah Kata Sandi'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UbahPasswordPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.support_agent),
                      title: const Text('Kontak Kami'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactUsPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Tentang Kami'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutUsPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Keluar',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Konfirmasi Keluar'),
                            content: const Text('Apakah Anda yakin ingin keluar?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('access_token');
                                  await prefs.remove('refresh_token');

                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                child: const Text('Keluar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(profileProvider.notifier).refreshProfile();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
