import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import '../widgets/camera_preview_widget.dart';
import '../widgets/camera_control_widget.dart';
import 'preview_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    // Mendapatkan daftar kamera yang tersedia
    _cameras = await availableCameras();
    
    // Mencari kamera depan
    _selectedCameraIndex = _cameras!.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    // Jika tidak ada kamera depan, ambil kamera pertama
    if (_selectedCameraIndex == -1) {
      _selectedCameraIndex = 0; // Kamera default ke kamera pertama
    }

    // Inisialisasi kamera
    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      print('Error: Kamera belum terinisialisasi.');
      return;
    }

    final image = await _cameraController!.takePicture();
    if (mounted) {
      setState(() {
        _imagePath = image.path;
      });
    }

    if (_cameras![_selectedCameraIndex].lensDirection == CameraLensDirection.front) {
      await _mirrorImage(_imagePath!);
    }

    await _goToPreviewPage(); 
  }

  Future<void> _mirrorImage(String imagePath) async {
    final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());

    if (originalImage != null) {
      final mirroredImage = img.flipHorizontal(originalImage);
      final mirroredImagePath = imagePath.replaceFirst('.jpg', '_mirrored.jpg');
      File(mirroredImagePath).writeAsBytesSync(img.encodeJpg(mirroredImage));

      if (mounted) {
        setState(() {
          _imagePath = mirroredImagePath;
        });
      }
    }
  }

  Future<void> _goToPreviewPage() async {
    if (_imagePath != null) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.blue,
                size: 70.0,
              ),
            );
          },
        );
      }

      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ImagePreviewPage(imagePath: _imagePath!),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      }
    }
  }

  void _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) {
      return;
    }
    
    await _cameraController?.dispose();
    
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    });

    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Page'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _cameraController == null || !_cameraController!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : SizedBox.expand(
                    child: CameraPreviewWidget(cameraController: _cameraController!),
                  ),
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
