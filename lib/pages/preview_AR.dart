import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../widgets/camera_preview_widget.dart';

class ARPreviewPage extends StatefulWidget {
  final int selectedCameraIndex;

  ARPreviewPage({
    Key? key,
    required this.selectedCameraIndex,
  }) : super(key: key);

  @override
  _ARPreviewPageState createState() => _ARPreviewPageState();
}

class _ARPreviewPageState extends State<ARPreviewPage> {
  late FaceDetector _faceDetector;
  CameraController? _cameraController;
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: false,
        enableTracking: false,
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[widget.selectedCameraIndex],
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      _startFaceDetection();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _startFaceDetection() async {
    _cameraController!.startImageStream((CameraImage image) async {
      try {
        final inputImage = _convertCameraImage(image);
        final faces = await _faceDetector.processImage(inputImage);

        if (mounted) {
          setState(() {
            _faces = faces;
          });
        }
      } catch (e) {
        print('Error processing image: $e');
      }
    });
  }

  InputImage _convertCameraImage(CameraImage image) {
    final BytesBuilder bytesBuilder = BytesBuilder();
    for (var plane in image.planes) {
      bytesBuilder.add(plane.bytes);
    }
    final bytes = bytesBuilder.toBytes();

    InputImageFormat format = InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation0deg,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Stack(
                children: [
                  CameraPreviewWidget(
                    cameraController: _cameraController!,
                    showCircleOverlay: false,
                  ),
                  ..._faces.map((face) {
                    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
                    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

                   if (leftEye != null && rightEye != null) {
                    final eyeLeftPosition = leftEye.position;
                    final eyeRightPosition = rightEye.position;

                    // Hitung titik tengah antara kedua mata
                    var centerX = (eyeLeftPosition.x + eyeRightPosition.x) / 2;
                    var centerY = (eyeLeftPosition.y + eyeRightPosition.y) / 2;

                    // Ukuran kacamata berdasarkan jarak antara kedua mata
                    double width = (eyeRightPosition.x - eyeLeftPosition.x) * 1.5; // Lebar kacamata
                    double height = width * 0.5; // Tinggi kacamata, misalnya setengah dari lebar

                    // Sesuaikan posisi Y kacamata agar lebih pas di atas mata
                    double adjustedY = centerY - (height * 0.6); // Ubah faktor ini sesuai kebutuhan

                    // Jangan biarkan kacamata berada di luar layar (di atas layar)
                    adjustedY = adjustedY < 0 ? 0 : adjustedY;

                    // Jangan biarkan kacamata berada di luar batas layar
                    if (centerX - (width / 2) < 0) {
                      centerX = width / 2; // Atur centerX agar tidak keluar layar kiri
                    }
                    if (centerX + (width / 2) > screenSize.width) {
                      centerX = screenSize.width - (width / 2); // Atur centerX agar tidak keluar layar kanan
                    }

                    // Balikkan posisi X untuk mencocokkan arah mata
                    centerX = screenSize.width - centerX;

                    print('Kacamata - Posisi X: $centerX, Posisi Y: $adjustedY, Width: $width, Height: $height');

                    return Positioned(
                      left: centerX, // Tempatkan kacamata di tengah
                      top: adjustedY - (height / 2), // Tempatkan kacamata di posisi yang disesuaikan
                      child: Image.asset(
                        'assets/kacamata/square.png',
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Text('Error loading image');
                        },
                      ),
                    );
                  } else {
                    return SizedBox(); // Kembali dengan ukuran kosong jika tidak ada mata
                  }


                  }).toList(),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }
}
