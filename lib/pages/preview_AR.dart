import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../widgets/camera_preview_widget.dart';
import 'dart:math';
import 'package:flutter/services.dart'; // Impor yang diperlukan

class ARPreviewPage extends StatefulWidget {
  final int selectedCameraIndex;

  ARPreviewPage({Key? key, required this.selectedCameraIndex}) : super(key: key);

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
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    
    // Memilih kamera berdasarkan index yang dipilih
    _cameraController = CameraController(
      cameras[widget.selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      // Menginisialisasi kamera
      await _cameraController!.initialize();

      // Mengatur tampilan agar selalu portrait
      // _setPortraitOrientation();

      _startFaceDetection();
    } catch (e) {
      print('Error initializing camera: $e');
      _showErrorDialog('Error initializing camera: $e');
    }
  }

  // Fungsi untuk mengunci orientasi tampilan ke portrait
  void _setPortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

    // Dapatkan orientasi sensor dari CameraController.description
    int rotation = _cameraController!.description.sensorOrientation;

    InputImageFormat format = InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotationValue.fromRawValue(rotation)!,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  double statusBarHeight = MediaQuery.of(context).padding.top;
  Size screenSize = MediaQuery.of(context).size;

  return Scaffold(
    body: _cameraController != null && _cameraController!.value.isInitialized
        ? Column(
            children: [
              // Video dengan rasio 3:4 di bagian atas
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Container(
                  width: screenSize.width,
                  height: screenSize.width * 4 / 3, // Rasio 3:4
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: (_cameraController!.value.previewSize != null)
                            ? SizedBox(
                                width: _cameraController!.value.previewSize!.height,
                                height: _cameraController!.value.previewSize!.width,
                                child: Stack(
                                  children: [
                                 

                             Transform(
  alignment: Alignment.center,
  transform: (_cameraController!.description.lensDirection == CameraLensDirection.front
      ? (Matrix4.identity()..scale(-1.0, 1.0)) // Membalik secara horizontal untuk kamera depan
      : Matrix4.identity()), // Tidak ada transformasi untuk kamera belakang
  child: CameraPreviewWidget(
    cameraController: _cameraController!,
    showCircleOverlay: false,
  ),
),

                                                                        // Kacamata
..._faces.map((face) {
  final leftEye = face.landmarks[FaceLandmarkType.leftEye];
  final rightEye = face.landmarks[FaceLandmarkType.rightEye];

  if (leftEye != null && rightEye != null) {
    final previewWidth = MediaQuery.of(context).size.width;

    final eyeLeftPosition = Point<double>(
      leftEye.position.x.toDouble(),
      leftEye.position.y.toDouble(),
    );
    final eyeRightPosition = Point<double>(
      rightEye.position.x.toDouble(),
      rightEye.position.y.toDouble(),
    );

    // Hitung posisi rata-rata antara kedua mata
    var centerX = (eyeLeftPosition.x + eyeRightPosition.x) / 2;
    var centerY = (eyeLeftPosition.y + eyeRightPosition.y) / 2;

    // Hitung jarak antara kedua mata
    double eyeDistance = (eyeRightPosition.x - eyeLeftPosition.x).abs();
    
    // Tentukan ukuran kacamata dengan penyesuaian
    double width = eyeDistance * 2 ; // Lebar kacamata
    double height = eyeDistance ; // Tinggi kacamata

    // Hitung sudut rotasi kacamata berdasarkan posisi kedua mata
    double dx = eyeRightPosition.x - eyeLeftPosition.x;
    double dy = eyeRightPosition.y - eyeLeftPosition.y;
    double angle = atan2(dy, dx);

    return Stack(
      children: [
        Positioned(
          left: centerX - (width / 2), // Posisi horizontal disesuaikan
          top: centerY - (height / 2), // Posisi vertikal
          child: Transform.rotate(
            angle: angle, // Rotasi sesuai sudut antara kedua mata
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
          ),
        ),
      ],
    );
  } else {
    return SizedBox();
  }
}).toList()

                                  ],
                                ),
                              )
                            : Center(child: Text('Preview tidak tersedia')),
                      ),
                    ),
                  ),
                ),
              ),
              // Area kosong di bawah video untuk menampilkan koordinat
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: _faces.map((face) {
                    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
                    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

                    if (leftEye != null && rightEye != null) {
                      final eyeLeftPosition = Point<double>(
                        leftEye.position.x.toDouble(),
                        leftEye.position.y.toDouble(),
                      );
                      final eyeRightPosition = Point<double>(
                        rightEye.position.x.toDouble(),
                        rightEye.position.y.toDouble(),
                      );

                      // Hitung informasi tambahan
                      var centerX = (eyeLeftPosition.x + eyeRightPosition.x) / 2;
                      var centerY = (eyeLeftPosition.y + eyeRightPosition.y) / 2;

                      double eyeDistance = sqrt(
                        pow(eyeRightPosition.x - eyeLeftPosition.x, 2) +
                        pow(eyeRightPosition.y - eyeLeftPosition.y, 2),
                      );

                      double width = eyeDistance + eyeDistance; // Panjang kacamata
                      double height = eyeDistance; // Tinggi kacamata

                      double dx = eyeRightPosition.x - eyeLeftPosition.x;
                      double dy = eyeRightPosition.y - eyeLeftPosition.y;
                      double angle = atan2(dy, dx) * (180 / pi); // Sudut dalam derajat

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Deteksi:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Mata Kiri: (${eyeLeftPosition.x.toStringAsFixed(2)}, ${eyeLeftPosition.y.toStringAsFixed(2)})',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          Text(
                            'Mata Kanan: (${eyeRightPosition.x.toStringAsFixed(2)}, ${eyeRightPosition.y.toStringAsFixed(2)})',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          Text(
                            'Titik Tengah Kacamata: (${centerX.toStringAsFixed(2)}, ${centerY.toStringAsFixed(2)})',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                          Text(
                            'Panjang Kacamata: ${width.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, color: Colors.purple),
                          ),
                          Text(
                            'Tinggi Kacamata: ${height.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, color: Colors.orange),
                          ),
                          Text(
                            'Sudut Rotasi: ${angle.toStringAsFixed(2)}°',
                            style: TextStyle(fontSize: 16, color: Colors.brown),
                          ),
                          Divider(),
                        ],
                      );
                    } else {
                      return Text(
                        'Landmark mata tidak terdeteksi.',
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                  }).toList(),
                ),
              ),
            ),

          ],
        )
      : const Center(child: CircularProgressIndicator()),
    );
  }



  @override
  void dispose() {
    _faceDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }
}
