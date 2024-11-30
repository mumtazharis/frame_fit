import 'package:flutter/material.dart';
import 'preview_AR.dart';
import 'dart:io';

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;
  final int selectedCameraIndex;
  // final CameraController cameraController;
  final Map<String, dynamic>? predictionResult;

  const ImagePreviewPage({
    Key? key,
    required this.imagePath,
    required this.selectedCameraIndex,
    // required this.cameraController,
    required this.predictionResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(File(imagePath)),
            ),
          ),
          if (predictionResult != null) 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: predictionResult!.containsKey('error')
                  // Tampilkan pesan error jika terdapat kunci 'error' dalam predictionResult
                  ? Text(
                      'Error: ${predictionResult!['error']}',
                      style: const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  // Jika tidak ada error, tampilkan hasil prediksi dan confidence
                  : Column(
                      children: [
                        Text(
                          'Prediction: ${predictionResult!['predicted_label']}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Confidence: ${predictionResult!['confidence']}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ARPreviewPage(
                      selectedCameraIndex: selectedCameraIndex,
                      
                      bentuk_wajah: predictionResult!['predicted_label'],
                    ),
                  ),
                );
              },
              child: const Text('Preview AR'),
            ),
          ),
        ],
      ),
    );
  }
  
}
