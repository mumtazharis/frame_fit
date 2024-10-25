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

                  // Bagian kode di dalam map loop untuk widget kacamata
                  ..._faces.map((face) {
                    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
                    final rightEye = face.landmarks[FaceLandmarkType.rightEye];
                    final noseBase = face.landmarks[FaceLandmarkType.noseBase];

                    if (leftEye != null && rightEye != null && noseBase != null) {
                      final eyeLeftPosition = leftEye.position;
                      final eyeRightPosition = rightEye.position;
                      final nosePosition = noseBase.position;

                      // Hitung titik tengah antara kedua mata
                      var centerX = (eyeLeftPosition.x + eyeRightPosition.x) / 2;
                      var centerY = (eyeLeftPosition.y + eyeRightPosition.y) / 2;

                      // Hitung lebar kacamata berdasarkan jarak antara kedua mata
                      double width = (eyeRightPosition.x - eyeLeftPosition.x) * 1.5;
                      double height = width * 0.5;

                      // Perhitungan sudut rotasi
                      double dx = eyeRightPosition.x - eyeLeftPosition.x;
                      double dy = eyeRightPosition.y - eyeLeftPosition.y;
                      double rotationAngle = math.atan2(dy, dx);

                      // Sesuaikan posisi Y kacamata agar lebih pas di atas mata
                      double adjustedY = centerY - (height * 0.6);
                      adjustedY = adjustedY < 0 ? 0 : adjustedY;

                      // Batasi agar kacamata tidak keluar layar
                      if (centerX - (width / 2) < 0) {
                        centerX = width / 2;
                      }
                      if (centerX + (width / 2) > screenSize.width) {
                        centerX = screenSize.width - (width / 2);
                      }

                      // Balikkan posisi X agar kacamata sesuai arah wajah
                      centerX = screenSize.width - centerX;

                      return Positioned(
                        left: centerX - (width / 2),
                        top: adjustedY - (height / 2),
                        child: Transform.rotate(
                          angle: rotationAngle, // Rotasi kacamata berdasarkan sudut mata
                          child: Image.asset(
                            'assets/kacamata/square.png',
                            width: width,
                            height: height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
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
