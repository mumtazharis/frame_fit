import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController cameraController;

  const CameraPreviewWidget({Key? key, required this.cameraController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tampilkan preview kamera
        _buildCameraPreview(),
        // Tambahkan lingkaran panduan
        _buildCircleOverlay(),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return Positioned.fill(
      child: AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: cameraController.description.lensDirection == CameraLensDirection.front
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0), // Flip horizontal
                child: CameraPreview(cameraController),
              )
            : CameraPreview(cameraController),
      ),
    );
  }

  Widget _buildCircleOverlay() {
    return Center(
      child: Container(
        width: 300, // Diameter lingkaran
        height: 300, // Diameter lingkaran
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3), // Warna dan ketebalan garis lingkaran
        ),
      ),
    );
  }
}
