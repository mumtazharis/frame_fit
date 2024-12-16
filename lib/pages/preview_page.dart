import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';
import '../providers/AR_provider.dart';
import 'preview_AR.dart';
import 'dart:io';

class ImagePreviewPage extends ConsumerWidget {
  const ImagePreviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cameraProvider);
    final arNotifier = ref.watch(ARProvider.notifier);
    
    void _showGenderSelectionDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Jenis Kelamin'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Laki-laki'),
                  leading: const Icon(Icons.male),
                  onTap: () {
                    Navigator.pop(context, 'male');
                  },
                ),
                ListTile(
                  title: const Text('Perempuan'),
                  leading: const Icon(Icons.female),
                  onTap: () {
                    Navigator.pop(context, 'female');
                  },
                ),
              ],
            ),
          );
        },
      ).then((selectedGender) {
        if (selectedGender != null) {
          // Simpan gender ke dalam predictionResult
          state.predictionResult!['gender'] = selectedGender;

          // arNotifier.setSelectedCameraIndex(state.selectedCameraIndex);
          arNotifier.initializeCamera();
          arNotifier.initializeFaceDetector();
          arNotifier.toggleSwiperAndSheet(true);
          arNotifier.updateInformasiRekomendasi(state.predictionResult!['predicted_label'], selectedGender);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ARPreviewPage(
          
              ),
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: state.imagePath != null
                  ? Image.file(File(state.imagePath!))
                  : const Text('No Image Selected'),
            ),
          ),
          if (state.predictionResult != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: state.predictionResult!.containsKey('error')
                  ? Text(
                      'Error: ${state.predictionResult!['error']}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          'Prediction: ${state.predictionResult!['predicted_label']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Confidence: ${state.predictionResult!['confidence']}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (state.predictionResult != null &&
                    state.predictionResult!.containsKey('predicted_label')) {
                  _showGenderSelectionDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 33, 72, 243), // Warna latar belakang tombol
                foregroundColor: Colors.white, // Warna teks tombol
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20), // Ukuran tombol lebih besar
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Sudut tombol melengkung
                ),
              ),
              child: const Text('Lihat Rekomendasi'),
            ),
          ),

        ],
      ),
    );
  }
}
