import 'package:flutter/material.dart';
import 'preview_AR.dart';
import 'dart:io';
import 'package:camera/camera.dart'; // Import package camera

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;
  final int selectedCameraIndex;
  final CameraController cameraController; // Tambahkan CameraController

  const ImagePreviewPage({
    Key? key, 
    required this.imagePath,
    required this.selectedCameraIndex,
    required this.cameraController, // Tambahkan parameter ini
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Arahkan ke halaman AR di sini
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ARPreviewPage(
                      selectedCameraIndex: selectedCameraIndex,
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
