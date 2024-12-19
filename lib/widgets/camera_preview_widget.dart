import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool showCircleOverlay;

  const CameraPreviewWidget({
    Key? key,
    this.cameraController,
    this.showCircleOverlay = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tampilkan preview kamera
        _buildCameraPreview(),
        // Tampilkan lingkaran panduan jika showCircleOverlay adalah true
        if (showCircleOverlay) _buildCircleOverlay(),
      ],
    );
  }

  Widget _buildCameraPreview() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Positioned.fill(
      child: AspectRatio(
        aspectRatio: cameraController!.value.aspectRatio,
        child: cameraController!.description.lensDirection == CameraLensDirection.front
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0), // Flip horizontal
                child: CameraPreview(cameraController!),
              )
            : CameraPreview(cameraController!),
      ),
    );
  }

  Widget _buildCircleOverlay() {
    return Center(
      child: Container(
        width: 400, // Diameter lingkaran
        height: 400, // Diameter lingkaran
        child: Image.asset(
          'assets/images/lingkaran.png',
        ),
      ),
    );
  }
}
