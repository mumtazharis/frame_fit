import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import '../widgets/camera_preview_widget.dart';
import '../widgets/image_preview_widget.dart';
import '../widgets/camera_control_widget.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      print('Error: Kamera belum terinisialisasi.');
      return;
    }

    final image = await _cameraController!.takePicture();
    setState(() {
      _imagePath = image.path;
    });

    // Proses gambar (misalnya, mirroring)
    if (_cameras![_selectedCameraIndex].lensDirection == CameraLensDirection.front) {
      _mirrorImage(_imagePath!);
    }

    print('Gambar disimpan di: $_imagePath');
  }

  Future<void> _mirrorImage(String imagePath) async {
    // Membaca gambar dari file
    final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());

    if (originalImage != null) {
      // Melakukan flip horizontal pada gambar
      final mirroredImage = img.flipHorizontal(originalImage);

      // Menyimpan gambar yang telah dimirror
      final mirroredImagePath = imagePath.replaceFirst('.jpg', '_mirrored.jpg');
      File(mirroredImagePath).writeAsBytesSync(img.encodeJpg(mirroredImage));

      // Mengupdate path gambar yang ditampilkan
      setState(() {
        _imagePath = mirroredImagePath;
      });
    }
  }

  void _switchCamera() {
    if (_cameras == null || _cameras!.isEmpty) {
      return;
    }
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      _initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _cameraController == null || !_cameraController!.value.isInitialized
                ? Center(child: CircularProgressIndicator())
                : CameraPreviewWidget(cameraController: _cameraController!),
          ),
          if (_imagePath != null)
            Expanded(
              flex: 1,
              child: ImagePreviewWidget(imagePath: _imagePath!),
            ),
          Expanded(
            flex: 1,
            child: CameraControlWidget(
              onSwitchCamera: _switchCamera,
              onTakePicture: _takePicture,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
