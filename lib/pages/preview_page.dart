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
                        arNotifier.setSelectedCameraIndex(state.selectedCameraIndex);
                        arNotifier.updateBentukWajah(state.predictionResult!['predicted_label']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ARPreviewPage(
                        // selectedCameraIndex: state.selectedCameraIndex,
                        // bentuk_wajah: state.predictionResult!['predicted_label'],
                      ),
                    ),
                  );
                }
              },
              child: const Text('Preview AR'),
            ),
          ),
        ],
      ),
    );
  }
}